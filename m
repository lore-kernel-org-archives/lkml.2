Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754709Ab2GROoC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 10:44:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31653 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab2GROn7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 10:43:59 -0400
Message-ID: <5006CC26.20203@redhat.com>
Date: Wed, 18 Jul 2012 22:45:58 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-kernel@vger.kernel.org, "Michael S. Tsirkin" <mst@redhat.com>,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <1342169711-12386-6-git-send-email-asias@redhat.com> <x49mx2yyzi5.fsf@segfault.boston.devel.redhat.com> <50060FE8.4040607@redhat.com> <x49fw8pb0ov.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49fw8pb0ov.fsf@segfault.boston.devel.redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2012 10:31 PM, Jeff Moyer wrote:
> Asias He <asias@redhat.com> writes:
>
>> On 07/18/2012 03:10 AM, Jeff Moyer wrote:
>>> Asias He <asias@redhat.com> writes:
>>>
>>>> vhost-blk is a in kernel virito-blk device accelerator.
>>>>
>>>> This patch is based on Liu Yuan's implementation with various
>>>> improvements and bug fixes. Notably, this patch makes guest notify and
>>>> host completion processing in parallel which gives about 60% performance
>>>> improvement compared to Liu Yuan's implementation.
>>>
>>> So, first off, some basic questions.  Is it correct to assume that you
>>> tested this with buffered I/O (files opened *without* O_DIRECT)?
>>>   I'm pretty sure that if you used O_DIRECT, you'd run into problems (which
>>> are solved by the patch set posted by Shaggy, based on Zach Brown's work
>>> of many moons ago).  Note that, with buffered I/O, the submission path
>>> is NOT asynchronous.  So, any speedups you've reported are extremely
>>> suspect.  ;-)
>>
>> I always used O_DIRECT to test this patchset. And I mostly used raw
>> block device as guest image. Is this the reason why I did not hit the
>> problem you mentioned. Btw, I do have run this patchset on image based
>> file. I still do not see problems like IO hangs.
>
> Hmm, so do the iovec's passed in point to buffers in userspace?  I
> thought they were kernel buffers, which would have blown up in
> get_user_pages_fast.

Yes. The iovec's passed in point to userspace buffers. ;-)

-- 
Asias


