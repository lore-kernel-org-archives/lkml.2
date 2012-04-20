Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2DTRhm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:37:42 -0400
Received: from relay.parallels.com ([195.214.232.42]:57814 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753310Ab2DTRhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:37:40 -0400
Message-ID: <4F919EEB.8020807@parallels.com>
Date: Fri, 20 Apr 2012 21:37:47 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com> <4F91862F.2030502@zabbo.net> <4F918758.8020001@oracle.com> <4F918B64.5030602@parallels.com> <4F919AA5.2030402@oracle.com>
In-Reply-To: <4F919AA5.2030402@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 09:19 PM, Dave Kleikamp wrote:
>> 1. Could we use fdatasync there? (otherwise it can hurt performance very
>> badly)
> I don't see why not.
Great.

>> 2. vfs_sync() is synchronous. loop_thread() will be blocked till it's
>> completed. Would it be better to perform vfs_sync in another thread (to
>> allow other bio-s in loop queue proceed)? Also, if there are more than
>> one REQ_FLUSH bio in lo->lo_bio_list, we could call vfs_sync() only
>> once. Make sense?
> If more than one REQ_FLUSH bio is in the list, they should be performed
> in order. We must call vfs_fsync() between each of them to guarantee that.
yes, my bad

> A less complex tradeoff would be to move the vfs_fsync() call to
> loop_make_request() so it is called in the context of the thread making
> the request. That would make those threads requesting ordered IO to pay
> the price while others would be able to proceed.
>
> This is something I can re-visit. I don't want to hold up progress on
> the patchset for something that can be improved later.
Completely agree, it can be done later.

Thanks,
Maxim

