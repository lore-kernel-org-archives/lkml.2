Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2EETDR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 15:03:17 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:55290 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755012Ab2EETDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 15:03:15 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 00/02] mach-shmobile: Emma Mobile EV2 - first shot
Date: Sat, 5 May 2012 21:08:02 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Magnus Damm <magnus.damm@gmail.com>, linux-arm-kernel@lists.infradead.org,
        horms@verge.net.au, linux@arm.linux.org.uk, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, lethal@linux-sh.org, olof@lixom.net
References: <20120503144645.6390.62303.sendpatchset@w520> <201205042316.55593.rjw@sisk.pl> <201205050722.45500.arnd@arndb.de>
In-Reply-To: <201205050722.45500.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201205052108.03001.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, May 05, 2012, Arnd Bergmann wrote:
> On Friday 04 May 2012, Rafael J. Wysocki wrote:
> > I'm not sure if I understand your point correctly, so please let me clarify.
> > 
> > Do you think it's better to have a separate mach-emma directory for the
> > new hardware because technically it is a different platform and the fact
> > that it was developed by the same manufacturer as the mach-shmobile hardware
> > is less important?
> 
> Yes, that was my point. Compare this to how we have omap and davinci for TI,
> orion and pxa for Marvell, or mxs and imx for Freescale. These are all
> for the most part independent developments that happened to end up being
> owned by the same company.
> 
> We try to group code based on technical similarities, not on who makes them.
> If you are able to share code between multiple completely independent socs
> you work on, the result shouldn't be to put them into a directory you "own",
> but to generalize the common parts so they can be shared with everyone else,
> too.

This works a slightly different way for the Renesas SoCs, though.  The
mach-shmobile code is (almost) entirely specific to the SoCs and boards and
everything else is already under drivers/ and elsewhere.  That's because
much of that code is shared between the ARM and SH architectures (since there
are SH CPU core in many of those systems along with the ARM CPU cores).
So we generalize the common parts by putting them out of arch/arm rather
than by putting them into a common place in there.

Now, if you insist on us having a separate mach- directory for every platform
(SoC), we can do that I think, but then we should start with splitting up the
existing mach-shmobile into a number of SoC-specific directories rather than
adding new mach- directories for random new parts, because that goes against
our development history to date, which is important too IMHO.

Thanks,
Rafael
