Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812Ab1BBSF3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 13:05:29 -0500
Received: from claw.goop.org ([74.207.240.146]:38512 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754547Ab1BBSF2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 13:05:28 -0500
Message-ID: <4D499CE3.9070401@goop.org>
Date: Wed, 02 Feb 2011 10:05:23 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, the arch/x86 maintainers <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen Devel <Xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 0/2] x86/microcode: support for microcode update in Xen
 dom0
References: <cover.1296259339.git.jeremy.fitzhardinge@citrix.com> <20110130113356.GA27967@liondog.tnic> <4D461FB9.5050807@goop.org> <20110131070241.GA22071@liondog.tnic> <4D46FC9F.6090309@goop.org> <20110131234131.GA16095@liondog.tnic> <4D475099.1080004@goop.org> <20110201110026.GA4739@liondog.tnic> <4D489348.90701@goop.org> <20110202095445.GA4761@liondog.tnic>
In-Reply-To: <20110202095445.GA4761@liondog.tnic>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2011 01:54 AM, Borislav Petkov wrote:
> Ok, I'm reading your answers but I keep getting the impression that this
> discussion is not moving anywhere. You keep finding reasons why it can't
> be done and trying to persuade me that your way is the only way. Why is
> that?

I agree that this conversation has got bogged down.  I'm getting the
impression that you're not really understanding my answers within the
context of how Xen works, and so things are going in circles.  I'm happy
to go into more detail if you're interested.

I'm not trying to be obstructionist here.  We've often changed the way
things work on the Xen side to smooth the path into the kernel, and I'm
perfectly willing to do it again for the microcode driver if it makes
sense to do so.

> And I'm telling you microcode_xen has nothing to do among
> vendor-specific code. Since when is xen a hw vendor and deserves special
> attention? And don't tell me because people use it.

Who's asking for special attention?  I'm just trying to use the existing
microcode infrastructure for handling different methods of microcode
update to add one more.  Why is "because people use it" not a useful
thing to say?  If I said "but nobody uses it", then that would be a
strong argument for not including it.

>  It is absolutely
> inacceptable to add a bunch of code to arch/x86 just because you're
> telling me it can't be done differently, not intermixed with hw vendor
> code and just because a hypervisor vendor needs it.
You seem to have staked out a very... specific... position here, but I
don't agree with your premise that microcode_foo is specifically
microcode_<cpu-vendor>.  If you view it as microcode_<method of loading
microcode> then adding microcode_xen makes perfect sense.  Since it is a
small, self-contained piece of code that doesn't have any effects on any
other code, nor any dependencies aside from the microcode driver's
internal interface, I think it is a clean way to approach the problem.

Or to turn it around, what specific problems do you see arising from
implementing the Xen microcode loader in this way?  Why is adding a
third microcode_foo.c a problem?

>  Does that mean that
> if every other virtualization booth wants to add their special code to
> arch/x86, we just go and slap it in without questioning its design?

Of course not; the whole point of posting code for review is to get
feedback on both general and specific issues, and I appreciate the time
you've spent on this.  But I have to say I don't really understand what
your objections are.  Are you objecting to the very principle of adding
a new microcode driver, or is there something specific about the code I
posted that you have issues with?

Thanks,
    J
