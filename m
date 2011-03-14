Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755649Ab1CNNR6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 09:17:58 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:52559 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467Ab1CNNR4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 09:17:56 -0400
Date: Mon, 14 Mar 2011 14:17:29 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Andreas Schwab <schwab@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Jan Beulich <JBeulich@novell.com>,
        "H.J. Lu" <hjl.tools@gmail.com>, binutils@sourceware.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Alan Modra <amodra@gmail.com>
Subject: Re: PATCH: Add --size-check=[error|warning]
Message-ID: <20110314131729.GB28851@elte.hu>
References: <AANLkTikG8wa1Em0bEUddbYpYs2TzFFTDb95qWFJ3xSbv@mail.gmail.com>
 <4D7DE39302000078000362E6@vpn.id2.novell.com>
 <20110314095534.GB18058@elte.hu>
 <20110314104131.GG6275@bubble.grove.modra.org>
 <AANLkTi=3AiLaw5Gnis8Ha4eRXirk0s-Cnk2zzN12YDpH__45869.1711457961$1300099861$gmane$org@mail.gmail.com>
 <m3oc5eufrk.fsf@redhat.com>
 <AANLkTikOX_9G-kFEOCHJbnTootY4n4EPSounwjDjPiZc@mail.gmail.com>
 <m3fwqpvrjy.fsf@redhat.com>
 <20110314121321.GE23257@elte.hu>
 <m3bp1dvp3l.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m3bp1dvp3l.fsf@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Andreas Schwab <schwab@redhat.com> wrote:

> Ingo Molnar <mingo@elte.hu> writes:
> 
> > * Andreas Schwab <schwab@redhat.com> wrote:
> >
> >> Pekka Enberg <penberg@kernel.org> writes:
> >> 
> >> > Hi Andreas,
> >> >
> >> > Pekka Enberg <penberg@kernel.org> writes:
> >> >>> So what do you suggest that testers who want to, say, build old Linux
> >> >>> kernel versions with new binutils do?
> >> >
> >> > On Mon, Mar 14, 2011 at 1:02 PM, Andreas Schwab <schwab@redhat.com> wrote:
> >> >> The same that testers have to do in order to build old Linux kernel
> >> >> versions with current versions of make.
> >> >
> >> > Are you saying it's OK to screw over binutils users because GNU Make
> >> > did that too?
> >> 
> >> I'm just telling you the facts.
> >
> > And you are wrong - latest Make does not break reasonably old kernel builds such 
> > as v2.6.30.
> 
> This is just ridiculous.
> You are defining away facts just because they don't fit your view.

No, i actually tried out the latest released Make version (3.82) and it still builds 
v2.6.30 fine:

    LD      arch/x86/boot/setup.elf
    OBJCOPY arch/x86/boot/setup.bin
    BUILD   arch/x86/boot/bzImage
  Root device is (8, 1)
  Setup is 12364 bytes (padded to 12800 bytes). 
  System is 3730 kB
  CRC 77bb7f2d
  Kernel: arch/x86/boot/bzImage is ready  (#105830)

The kernel build count is at 105830 because i build and test a lot of kernels on 
this box.

And the resulting kernel boots fine on a testbox:

  mercury:~> uname -a
  Linux mercury 2.6.30 #105830 SMP Mon Mar 14 12:29:06 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

I have built and booted over half a million Linux kernels in the past 3-4 years so i 
generally have quite a bit of experience when it comes to build environment bugs and 
workflow problems. Breaking the build retroactively and unnecessarily like here is 
one of the worst things that can be done to testing quality and efficiency.

Thanks,

	Ingo
