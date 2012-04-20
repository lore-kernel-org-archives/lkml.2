Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932758Ab2DTPUd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 11:20:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932512Ab2DTPUc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 11:20:32 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [RFC PATCH v2 15/21] loop: use aio to perform io on the underlying file
References: <1333122228-13633-1-git-send-email-dave.kleikamp@oracle.com>
	<1333122228-13633-16-git-send-email-dave.kleikamp@oracle.com>
	<4F917751.9040600@parallels.com> <4F917C2F.4020805@oracle.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 20 Apr 2012 11:20:25 -0400
In-Reply-To: <4F917C2F.4020805@oracle.com> (Dave Kleikamp's message of "Fri,
	20 Apr 2012 10:09:35 -0500")
Message-ID: <x49mx66whty.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Kleikamp <dave.kleikamp@oracle.com> writes:

> On 04/20/2012 09:48 AM, Maxim V. Patlasov wrote:
>> On 03/30/2012 07:43 PM, Dave Kleikamp wrote:
>>> From: Zach Brown<zab@zabbo.net>
>>>
>>> This uses the new kernel aio interface to process loopback IO by
>>> submitting concurrent direct aio.  Previously loop's IO was serialized
>>> by synchronous processing in a thread.
>>>
>> 
>> The patch ignores REQ_FLUSH bit of bi_rw. Is it simply overlook?
>
> Good question. Since the loop device is sending only direct IO requests,
> it shouldn't be necessary to explicitly flush page cache, but REQ_FLUSH

REQ_FLUSH isn't about the page cache, it's about flushing the volatile
disk write cache.  You need to handle that.

Cheers,
Jeff
