Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131Ab1DHCOK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 22:14:10 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62662 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757369Ab1DHCOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 22:14:08 -0400
Message-ID: <4D9E6F6E.9050709@codemonkey.ws>
Date: Thu, 07 Apr 2011 21:14:06 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Avi Kivity <avi@redhat.com>, Pekka Enberg <penberg@kernel.org>,
        linux-kernel@vger.kernel.org, aarcange@redhat.com, mtosatti@redhat.com,
        kvm@vger.kernel.org, joro@8bytes.org, penberg@cs.helsinki.fi,
        asias.hejun@gmail.com, gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar> <4D982E89.8070502@redhat.com> <BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com> <4D9847BC.9060906@redhat.com> <4D98716D.9040307@codemonkey.ws> <4D9873CD.3080207@redhat.com> <20110406093333.GB6465@elte.hu>
In-Reply-To: <20110406093333.GB6465@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/06/2011 04:33 AM, Ingo Molnar wrote:
> * Avi Kivity<avi@redhat.com>  wrote:
>
>> Sure, any succcesful project becomes an ugly gooball.  It's almost a
>> compliment.
> I disagree strongly with that sentiment and there's several good counter
> examples:
>
>   - the Git project is also highly successful and is kept very clean (and has a
>     project size comparable to Qemu)
>
>   - the Linux kernel is also very clean in all areas i care about and has most
>     of its ugliness stuffed into drivers/staging/ (and has a project size more
>     than an order of magnitude larger than Qemu).
>
> In fact i claim the exact opposite: certain types of projects can only grow
> beyond a certain size and stay healthy if they are *not* ugly gooballs.
>
> Examples: X11 and GCC - both were struggling for years to break through magic
> invisible barriers of growth and IMHO a lot of it had to do with the lack of
> code (and development model) cleanliness.

So what makes Native Linux KVM tool so much cleaner?

As far as I can tell, it's architecturally identical to QEMU.  In fact, 
it's reminiscent of QEMU from about 5 years ago.  It makes the same 
mistakes of having a linear I/O dispatch model, makes no attempt to 
enable a threaded execution model, ignores thing like migration and 
manageability.

> So no, your kind of cynical, defeatist sentiment about code quality is by no
> means true in my experience. Projects become ugly gooballs once maintainers
> stop caring enough.

It think sweeping generalizations are always wrong :-)

I struggle with a lot of things in QEMU.  Compatibility is just a 
nightmare to maintain because so many of the previous interfaces and 
functionality were so poorly thought through.

If someone was going to seriously go about doing something like this, a 
better approach would be to start with QEMU and remove anything non-x86 
and all of the UI/command line/management bits and start there.

There's nothing more I'd like to see than a viable alternative to QEMU 
but ignoring any of the architectural mistakes in QEMU and repeating 
them in a new project isn't going to get there.

Too much effort in QEMU goes into working around previous mistakes.  
That doesn't mean that QEMU doesn't have a lot of useful bits in it and 
hasn't figured out a lot of good ways to do things.

Regards,

Anthony Liguori

> Thanks,
>
> 	Ingo

