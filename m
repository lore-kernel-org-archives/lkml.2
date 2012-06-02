Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965121Ab2FBG1z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Jun 2012 02:27:55 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:46460 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965105Ab2FBG1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Jun 2012 02:27:54 -0400
Date: Sat, 2 Jun 2012 09:27:51 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: Jean Delvare <khali@linux-fr.org>
cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Dean Nelson <dnelson@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: f71805f arch dependencies?
In-Reply-To: <20120601220315.246ba5a5@endymion.delvare>
Message-ID: <alpine.SOC.1.00.1206020925060.2992@math.ut.ee>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee> <CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com> <alpine.SOC.1.00.1206011610060.10517@math.ut.ee> <CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
 <20120601220315.246ba5a5@endymion.delvare>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >> > Loading f71805f on sparc64 causes hard reboot beacuse on invalid
> > >> > hardware access. Should this driver be restricted to PC, or some wider
> > >> > subset of platforms where this LPC SUper-IO chip is present?
> > >>
> > >> Which tree is f71805f in? Not in Linus'.
> > >
> > > Running upstream 3.4.0-09547-gfb21aff and it is there as
> > > SENSORS_F71805F.
> > >
> > > In fact, there are more LPC hwmon drivers that people can use to "shoot
> > > themselves in the leg" - SMSC LPC*, SMSC SCH*, SMSC DME1737 (partly I2C,
> > > partly ISA IO), and Fintek F71882FG and compatibles. Maybe more.
> > 
> > Sorry, I thought it was a git SHA1 commit ID.
> > Didn't know hardware manufacturers christen their chips to the abbreviated
> > commit ID in their VHDL repository ;-)
> > 
> > Indeed, it seems commit 746cdfbf01c0a30d59f6e1b6942d432658d7c7cd
> > ("hwmon: Avoid building drivers for powerpc that read/write ISA addresses")
> > was a bit too limited...
> 
> I am fine extending that commit to other architectures. Now the
> question is, do we just add SPARC64 to the exception list, or do we
> restrict these drivers to X86? I know they are mostly used on X86, but
> I have no proof they aren't used on other architectures. That's why
> Dean and myself decided to play it safe at first and only exclude PPC.
> 
> Apparently other drivers (e.g. watchdog drivers) for similar chips are
> limited to X86 so we might as well do the same here. And see if anybody
> complains...
> 
> Meelis, do you feel like sending a patch, or do you prefer if I take
> care of it?

I can send a patch in a couple of days, but I do not know either wihich 
way is better.

What other architectures can use the ISA-IO style LPC - probably quite 
several if hardware has been made (but it probably hasn't)?

-- 
Meelis Roos (mroos@ut.ee)      http://www.cs.ut.ee/~mroos/
