Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753169Ab2GUBGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 21:06:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58081 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752178Ab2GUBGM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 21:06:12 -0400
Message-ID: <500A00ED.9090508@redhat.com>
Date: Sat, 21 Jul 2012 09:07:57 +0800
From: Asias He <asias@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH RESEND 5/5] vhost-blk: Add vhost-blk support
References: <1342169711-12386-1-git-send-email-asias@redhat.com> <1342169711-12386-6-git-send-email-asias@redhat.com> <87mx2vrjdl.fsf@codemonkey.ws> <20120719130957.GD9303@redhat.com> <87obnaup70.fsf@codemonkey.ws>
In-Reply-To: <87obnaup70.fsf@codemonkey.ws>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2012 04:56 AM, Anthony Liguori wrote:
> "Michael S. Tsirkin" <mst@redhat.com> writes:
>
>> On Thu, Jul 19, 2012 at 08:05:42AM -0500, Anthony Liguori wrote:
>>> Of course, the million dollar question is why would using AIO in the
>>> kernel be faster than using AIO in userspace?
>>
>> Actually for me a more important question is how does it compare
>> with virtio-blk dataplane?
>
> I'm not even asking for a benchmark comparision.  It's the same API
> being called from a kernel thread vs. a userspace thread.  Why would
> there be a 60% performance difference between the two?  That doesn't
> make any sense.

Please read the commit log again. I am not saying vhost-blk v.s 
userspace implementation gives 60% improvement. I am saying the 
vhost-blk v.s original vhost-blk gives 60% improvement.


"""
This patch is based on Liu Yuan's implementation with various
improvements and bug fixes. Notably, this patch makes guest notify and
host completion processing in parallel which gives about 60% performance
improvement compared to Liu Yuan's implementation.
"""

>
> There's got to be a better justification for putting this in the kernel
> than just that we can.
>
> I completely understand why Christoph's suggestion of submitting BIOs
> directly would be faster.  There's no way to do that in userspace.

Well. With Zach and Dave's new in-kernel aio API, the aio usage in 
kernel is much simpler than in userspace. This a potential reason that 
in kernel one is better than userspace one. I am working on it right 
now. And for block based image, as suggested by Christoph, we can submit 
bio directly. This is another potential reason.

Why can't we just go further to see if we can improve the IO stack from 
guest kernel side all the way down to host kernel side. We can not do 
that if we stick to doing everything in userspace (qemu).

-- 
Asias


