Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2BFOIo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:08:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1977 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750970Ab2BFOIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:08:43 -0500
Message-ID: <4F2FDEE5.9010302@redhat.com>
Date: Mon, 06 Feb 2012 16:08:37 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Anthony Liguori <anthony@codemonkey.ws>
CC: KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>,
        Gleb Natapov <gleb@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
References: <4F2AB552.2070909@redhat.com>	<20120205093723.GQ23536@redhat.com>	<4F2E4F8B.8090504@redhat.com>	<20120205095153.GA29265@redhat.com>	<4F2EAFF6.7030006@codemonkey.ws>	<4F2F9E89.7090607@redhat.com> <4F2FD692.5060708@codemonkey.ws> <4F2FDB91.80200@redhat.com> <4F2FDCFB.3010408@codemonkey.ws>
In-Reply-To: <4F2FDCFB.3010408@codemonkey.ws>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/06/2012 04:00 PM, Anthony Liguori wrote:
>> Do guests always read an unlatched counter?  Doesn't seem reasonable
>> since they can't get a stable count this way.
>
>
> Perhaps.  You could have the latching done by writing to persisted
> scratch memory but then locking becomes an issue.

Oh, you'd certainly serialize the entire device.

>
>>> The idea would be to allow the filter to not handle an I/O request
>>> depending on existing state.  Anything that's modifies state (like
>>> reading the latch counter) would drop to userspace.
>>
>> This restricts us to a subset of the device which is at the mercy of the
>> guest.
>
> Yes, but it provides an elegant solution to having a flexible way to
> do things in the fast path in a generic way without presenting
> additional security concerns.
>
> A similar, albeit more complex and less elegant, approach would be to
> make use of something like the vtpm optimization to reflect certain
> exits back into injected code into the guest.  But this has the
> disadvantage of being very x86-centric and it's not clear if you can
> avoid double exits which would hurt the slow paths.

It's also hard to communicate with the rest of the host kernel (say for
timers).  You can't ensure that any piece of memory will be virtually
mapped, and with the correct permissions too.

>
>> We could define mmio registers for muldiv64, and for communicating over
>> the APIC bus.  But then the device model for BPF ends up more
>> complicated than the kernel devices we have put together.
>
> Maybe what we really need is NaCL for kernel space :-D

NaCl or bytecode, doesn't matter.  But we do need bindings to other
kernel and kvm services.

-- 
error compiling committee.c: too many arguments to function

