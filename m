Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756917Ab2DTQOX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 12:14:23 -0400
Received: from relay.parallels.com ([195.214.232.42]:42586 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab2DTQOW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 12:14:22 -0400
Message-ID: <4F918B64.5030602@parallels.com>
Date: Fri, 20 Apr 2012 20:14:28 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Dave Kleikamp <dave.kleikamp@oracle.com>
CC: Zach Brown <zab@zabbo.net>, Jeff Moyer <jmoyer@redhat.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying
 file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com> <1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com> <4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com> <x49mx66whty.fsf@segfault.boston.devel.redhat.com> <4F91862F.2030502@zabbo.net> <4F918758.8020001@oracle.com>
In-Reply-To: <4F918758.8020001@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/20/2012 07:57 PM, Dave Kleikamp wrote:
>> So yeah, I'd agree that the loop code should be reworked a bit so that
>> both the filebacked and aio methods call vfs_sync() when they see
>> REQ_FLUSH.
> It's an easy fix. I don't anticipate that it will hurt performance too
> badly.

Two questions:

1. Could we use fdatasync there? (otherwise it can hurt performance very 
badly)

2. vfs_sync() is synchronous. loop_thread() will be blocked till it's 
completed. Would it be better to perform vfs_sync in another thread (to 
allow other bio-s in loop queue proceed)? Also, if there are more than 
one REQ_FLUSH bio in lo->lo_bio_list, we could call vfs_sync() only 
once. Make sense?

Thanks,
Maxim
