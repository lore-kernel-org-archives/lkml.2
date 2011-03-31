Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab1CaR4Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 13:56:16 -0400
Received: from relais.videotron.ca ([24.201.245.36]:56193 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab1CaR4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 13:56:15 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Thu, 31 Mar 2011 13:56:12 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: david@lang.hm
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-omap@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
In-reply-to: <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
Message-id: <alpine.LFD.2.00.1103311218240.28032@xanadu.home>
References: <201103301906.42429.arnd@arndb.de>
 <AANLkTim578-kwM14SJd06RW_QiC4WVCmFuG+ASgGC4sq@mail.gmail.com>
 <alpine.LFD.2.00.1103301531420.28032@xanadu.home>
 <AANLkTim6zg-U6HtAQbqnENqoK7x8erXSqOuTFVC0YE5r@mail.gmail.com>
 <alpine.LFD.2.00.1103301814250.28032@xanadu.home>
 <alpine.DEB.2.00.1103301728000.15330@asgard.lang.hm>
 <alpine.LFD.2.00.1103302255280.28032@xanadu.home>
 <alpine.DEB.2.00.1103302130500.29543@asgard.lang.hm>
 <alpine.LFD.2.00.1103310145390.28032@xanadu.home>
 <20110331080634.GA18022@elte.hu>
 <20110331083044.GB14323@n2100.arm.linux.org.uk>
 <alpine.DEB.2.00.1103310855450.29543@asgard.lang.hm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 31 Mar 2011, david@lang.hm wrote:

> I think that part of the issue is that when Linus points out a problem, the
> response isn't "we agree and are working on it, here's what we are doing",
> instead it seems to be mostly "there is no problem, this is just because there
> is so much variation in ARM"

The problem is two-fold:

1) - "ARM hardware manufacturers are morons"... 
   - ARM vendors "do things differently just to be difficult"...
   - "the crazy arm fragmentation"...
   Translate this into whatever ways you like.  The fact is that ARM
   is quite popular as a CPU core but there is very little in terms of 
   standardization around that CPU core.  *OBVIOUSLY* this is a problem.
   But there is _nothing_ we can do about that besides the current 
   moaning and the hope that those vendors will hear us and stop trying 
   to be different from their competitors.  Apparently that won't happen 
   in the near future, so we can either sit on our arses proclaiming 
   repeatedly that this is a problem until those hardware vendors put 
   their acts together, or we find ways to deal with it somehow.

2) Because of (1) we do end up being floded by SOC specific support code
   with an unprecedented scale.  Here's the stat:

   $ git diff --shortstat v2.6.38..v2.6.39-rc1 arch/arm/
    1319 files changed, 61303 insertions(+), 33780 deletions(-)
   $ git diff --shortstat v2.6.38..v2.6.39-rc1 arch/x86/
    241 files changed, 6508 insertions(+), 4326 deletions(-)

   That's ten (10) times more lines added in the ARM directory than in 
   the X86 directory.  Is this a sudden burst or a tendency?

   $ git diff --shortstat v2.6.37..v2.6.38 arch/arm/
    1257 files changed, 72412 insertions(+), 29361 deletions(-)
   $ git diff --shortstat v2.6.37..v2.6.38 arch/x86/
    216 files changed, 10021 insertions(+), 5016 deletions(-)

   $ git diff --shortstat v2.6.36..v2.6.37 arch/arm/
    1314 files changed, 55072 insertions(+), 17620 deletions(-)
   $ git diff --shortstat v2.6.36..v2.6.37 arch/x86/
    299 files changed, 16130 insertions(+), 12800 deletions(-)

   $ git diff --shortstat v2.6.35..v2.6.36 arch/arm
    1041 files changed, 53428 insertions(+), 25722 deletions(-)
   $ git diff --shortstat v2.6.35..v2.6.36 arch/x86/
    231 files changed, 7216 insertions(+), 8028 deletions(-)

   So that appears to be quite "normal" to see ARM vendors together 
   producing many times the level of activities compared to X86.

So... Is there missed opportunity for better code reuse here?  Most 
probably.  Is all that code the result of misabstracted and duplicated 
code?  Certainly not.  Let's just presume that half of that code is 
genuine crap and the other half is simply the result of new hardware for 
which there is no existing model to fit it in.  Even then, do we have 5 
times the reviewer bandwidth to properly review all that code compared 
to X86?  Absolutely not, not even close.

If prominent people looking at this from the side line continue bashing 
at those who are both feet in the mud trying to contain the flood rather 
than actually helping then nothing will change.  Instead this only 
creates despair and the splashed people may simply decide to throw in 
the towel, at which point things will collapse for real.  In reality, 
the system has been going as it is for quite a while and with more or 
less the same level of intensity.  And the fact is that _users_ of the 
ARM kernel are not complaining.  Things are far from being perfect, but 
so far things have been "good enough" for the majority of the people 
involved, and improvements are constantly being worked on with the men 
power available.


Nicolas

