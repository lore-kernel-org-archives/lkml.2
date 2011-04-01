Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab1DAVcs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 17:32:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:59766 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756758Ab1DAVcr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:32:47 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [GIT PULL] omap changes for v2.6.39 merge window
Date: Fri, 1 Apr 2011 23:32:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Kevin Hilman <khilman@ti.com>, david@lang.hm,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Tony Lindgren <tony@atomide.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@elte.hu>, linux-omap@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Brown <davidb@codeaurora.org>, Detlef Vollmann <dv@vollmann.ch>
References: <alpine.LFD.2.00.1103310145390.28032@xanadu.home> <201104011659.40443.arnd@arndb.de> <87vcyxllub.fsf@ti.com>
In-Reply-To: <87vcyxllub.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104012332.24319.arnd@arndb.de>
X-Provags-ID: V02:K0:h3Amf2pEDgkSOUlne8Uh6BG4qXy+Eiq++ootRn05Zjf
 Kctjm4ggHpvtsTQZWeSoMUXOzQP6xvSxFc4GqTr+Lb70VkWOES
 QlC1hAdwip8m0jTZgHZu+o8dLnP9/O6JhqfugWdhqMj179lSF4
 bTdyg+yYFWwKkMfjw9D1LTwKNPlMYkT00H7MSU2oG5YbPOkKMv
 2QF+D9ztGgAJ090RxdIAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 01 April 2011 23:10:04 Kevin Hilman wrote:
> Arnd Bergmann <arnd@arndb.de> writes:
> 
> > On Friday 01 April 2011, Detlef Vollmann wrote:
> >> On 04/01/11 15:54, Arnd Bergmann wrote:
> >
> >> > 9. All interesting work is going into a handful of platforms, all of which
> >> >     are ARMv7 based.
> >> Define interesting.
> >
> > The ones that are causing the churn that we're talking about.
> > Platforms that have been working forever and only need to get
> > the occasional bug fix are boring, i.e. not the problem.
> 
> I'm not sure I follow the ARMv7-only thinking either.  
> 
> Picking ARMv7 only would be a good way to avoid part of the problem, but
> IMO, it doesn't really address the root causes.  Part of the ugliness of
> the platform-specific hackery (and the "churn" to clean some of it up)
> is precisely due to support for multiple ARM architecture versions, and
> the various SoCs in a family that use them.  For example, linux-omap
> supports OMAP1 (ARMv5), OMAP2 (ARMv6), OMAP3 (ARMv7) and OMAP4 (ARMv7
> SMP), and OMAP2/3/4 in a single binary.
> 
> Also, since we've only very recently got to the point of being able to
> support ARMv6 + ARMv7 UP & SMP in the same kernel, making a decision now
> that only ARMv7 is important seems like a step backwards.  If the
> ultimate goal is getting to a point where we have infrastrucure that can
> be cross-SoC, surely this same infrastrucure should support multiple ARM
> architecture revisions.

Yes, forget about the ARMv7 part of my proposal, that was not a main point.

If we decide to have a new clean platform variant the way I suggested,
it would be nice to support all machines in a single kernel binary,
and at least v6+v7 is a solved problem.

Supporting a second kernel binary up to v5 with the same source is also
simple, as would be big-endian/little-endian variants, or thumb2/arm variants.
We might not want to do all combinations from the start though, and I would
choose ARMv6/v7-thumb2-le simply because that's what Linaro is focusing
on. The idea is to start with a clearly defined set, but write the code
in a way that makes it possible to extend in other directions.

	Arnd
