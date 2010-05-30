Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753707Ab0E3TkD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 15:40:03 -0400
Received: from mail.skyhub.de ([78.46.96.112]:51936 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753185Ab0E3TkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 15:40:01 -0400
Date: Sun, 30 May 2010 21:39:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
       Borislav Petkov <borislav.petkov@amd.com>,
       Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
       user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86, hweight: Fix UML boot crash
Message-ID: <20100530193956.GA2498@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Geert Uytterhoeven <geert@linux-m68k.org>,
	Borislav Petkov <borislav.petkov@amd.com>,
	Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
	user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org
References: <201005271944.09541.toralf.foerster@gmx.de>
 <AANLkTimKwxYxM_PExplIDK1WPTQ9e_-CHn5SnIvfjfUg@mail.gmail.com>
 <20100530150214.GA1565@liondog.tnic>
 <201005301728.25976.toralf.foerster@gmx.de>
 <20100530170346.GC1565@liondog.tnic>
 <4C02B020.2040103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4C02B020.2040103@zytor.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "H. Peter Anvin" <hpa@zytor.com>
Date: Sun, May 30, 2010 at 11:36:16AM -0700

> On 05/30/2010 10:03 AM, Borislav Petkov wrote:
> > Obviously UML cannot stomach callee reg-saving trickery
> > introduced with d61931d89be506372d01a90d1755f6d0a9fafe2d (x86:
> > Add optimized popcnt variants) and oopses during boot:
> > http://marc.info/?l=linux-kernel&m=127522065202435&w=2
> > 
> > Go ahead and fall back to the software hweight* routines on UML.
> 
> I actually don't understand why UML can't stomach that... it would work
> exactly the same in userspace as in kernel space.  The only thing that I
> can think of is if UML overrides the CFLAGS including the per-file
> CFLAGS, but that would seem to cause all kinds of other issues.
> 
> I would also be a lot happier if this was handled in
> <asm/arch_hweight.h> than in <asm/bitops.h>.  Finally, if UML really
> can't handle this, then ARCH_HWEIGHT_CFLAGS should be disabled on UML.
> 
> This bothers me, because it really feels like something is fundamentally
> broken in UML tryingto track the upstream architecture, and this is just
> a bandage.

First of all, scratch that patch. It is indeed dumb idea to sprinkle UML
special cases in x86 just because they include it.

Which begs the question why _is_ UML sucking in x86 stuff and can anyone
provide us with some sensible reasons? Because if there aren't any, it
is their includes that should be fixed. Let me see what I can do to
redirect hweight stuff properly...

-- 
Regards/Gruss,
    Boris.
