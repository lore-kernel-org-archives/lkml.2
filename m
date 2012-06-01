Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759319Ab2FAUD2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 16:03:28 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:27715 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759236Ab2FAUD1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 16:03:27 -0400
Date: Fri, 1 Jun 2012 22:03:15 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Meelis Roos <mroos@linux.ee>, Dean Nelson <dnelson@redhat.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: f71805f arch dependencies?
Message-ID: <20120601220315.246ba5a5@endymion.delvare>
In-Reply-To: <CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
References: <alpine.SOC.1.00.1206011559370.10517@math.ut.ee>
	<CAMuHMdXtZg7JJ18Ao+yLJ5s-vHt38Omgp=b4vOOFet870Buuzw@mail.gmail.com>
	<alpine.SOC.1.00.1206011610060.10517@math.ut.ee>
	<CAMuHMdVLkueZdpjht9kL9s9qKv=YT18AVTCoYDmJyKLD=KQ4dg@mail.gmail.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi there,

On Fri, 1 Jun 2012 15:23:04 +0200, Geert Uytterhoeven wrote:
> On Fri, Jun 1, 2012 at 3:12 PM, Meelis Roos <mroos@linux.ee> wrote:
> >> > Loading f71805f on sparc64 causes hard reboot beacuse on invalid
> >> > hardware access. Should this driver be restricted to PC, or some wider
> >> > subset of platforms where this LPC SUper-IO chip is present?
> >>
> >> Which tree is f71805f in? Not in Linus'.
> >
> > Running upstream 3.4.0-09547-gfb21aff and it is there as
> > SENSORS_F71805F.
> >
> > In fact, there are more LPC hwmon drivers that people can use to "shoot
> > themselves in the leg" - SMSC LPC*, SMSC SCH*, SMSC DME1737 (partly I2C,
> > partly ISA IO), and Fintek F71882FG and compatibles. Maybe more.
> 
> Sorry, I thought it was a git SHA1 commit ID.
> Didn't know hardware manufacturers christen their chips to the abbreviated
> commit ID in their VHDL repository ;-)
> 
> Indeed, it seems commit 746cdfbf01c0a30d59f6e1b6942d432658d7c7cd
> ("hwmon: Avoid building drivers for powerpc that read/write ISA addresses")
> was a bit too limited...

I am fine extending that commit to other architectures. Now the
question is, do we just add SPARC64 to the exception list, or do we
restrict these drivers to X86? I know they are mostly used on X86, but
I have no proof they aren't used on other architectures. That's why
Dean and myself decided to play it safe at first and only exclude PPC.

Apparently other drivers (e.g. watchdog drivers) for similar chips are
limited to X86 so we might as well do the same here. And see if anybody
complains...

Meelis, do you feel like sending a patch, or do you prefer if I take
care of it?

-- 
Jean Delvare
