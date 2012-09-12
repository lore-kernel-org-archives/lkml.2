Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760645Ab2ILRU6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 13:20:58 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53872 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754175Ab2ILRU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 13:20:56 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Subject: Re: [PATCH 13/16] ARM: omap: move platform_data definitions
Date: Wed, 12 Sep 2012 17:20:33 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        =?utf-8?q?Beno=C3=AEt_Cousson?= <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "Ohad Ben-Cohen" <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, J Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-13-git-send-email-arnd@arndb.de> <504F4227.4080206@ti.com>
In-Reply-To: <504F4227.4080206@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201209121720.33822.arnd@arndb.de>
X-Provags-ID: V02:K0:oRHlkV6Qis2id7miW49/cv6pxlaNFCMrImw5rtXJQfn
 SDCK7siqHJHXG45Us3ySGfLzv/pCIdbEM4bbsifXnZOd8RMnYY
 eIAQ32dJPS8TP6hYHJvEz7+KvqwQJAajGzwy9yx0EGn2a4fT0T
 gO5ATMTIV8cczTh8awUkyAL9Qm+D4saghaEW29H3vZ1/JzG0dp
 qY9zPBhMOPO8ZW8lbfWmSFUEUGua1OvE9j181u0Fj9il99AMYA
 X0Mjvwq+P4zp0c6yEc0RUtcZ63lMyGMkkK4LIdDA0KUNvIYbR0
 TbM7ef4/CkCAKWvJ0rwiBw+DegWfZp38PDMGcMrP1HZUJmWfXS
 toBlUtf3pvGDWTb4Lgmc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, Peter Ujfalusi wrote:
> OMAP McBSP has nothing to do with a dsp.
> A better name would be: ti-mcbsp.h (or leave it as mcbsp.h)
> McBSP stands for: Multichannel Buffered Serial Port and it is used for audio
> connection (I2S, TDM, etc).

changed to asoc-ti-mcbsp.h to, as discussed.

> >  .../include/plat/dsp.h => include/linux/platform_data/dsp-omap.h   |    0
> >  .../plat/keypad.h => include/linux/platform_data/keypad-omap.h     |    0
> >  .../plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h    |    0
> >  .../plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h    |    0
> >  .../onenand.h => include/linux/platform_data/mtd-onenand-omap2.h   |    0
> >  .../remoteproc.h => include/linux/platform_data/remoteproc-omap.h  |    0
> >  .../voltage.h => include/linux/platform_data/smartreflex-omap.h    |    0
> >  .../plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h  |    0
> >  include/linux/power/smartreflex.h                                  |    2 +-
> 
> Let me see these:
> 
> This four drivers are going to be removed via sound tree.
> >  sound/soc/omap/igep0020.c                                          |    2 +-
> >  sound/soc/omap/omap3beagle.c                                       |    2 +-
> >  sound/soc/omap/omap3evm.c                                          |    2 +-
> >  sound/soc/omap/overo.c                                             |    2 +-
> 
> The new driver which replaces these (omap-twl4030.c) does not include
> plat/mcbsp.h

For the sake of bisection, I think we should leave the patch as is.
When merging the two branches, we will get a small conflict that
is trivial to resolve.

> From these ASoC machine drivers you can just remove the <plat/mcbsp.h>
> include since they should not include them (I have pending patch for this to
> be sent):
> >  sound/soc/omap/am3517evm.c                                         |    2 +-
> >  sound/soc/omap/ams-delta.c                                         |    2 +-
> >  sound/soc/omap/n810.c                                              |    2 +-
> >  sound/soc/omap/omap3pandora.c                                      |    2 +-
> >  sound/soc/omap/osk5912.c                                           |    2 +-
> >  sound/soc/omap/rx51.c                                              |    2 +-
> >  sound/soc/omap/sdp3430.c                                           |    2 +-
> >  sound/soc/omap/zoom2.c                                             |    2 +-
> 
> >  sound/soc/omap/omap-mcbsp.c                                        |    2 +-
> >  sound/soc/omap/mcbsp.c                                             |    2 +-

Can you do that change on top of mine? I would prefer to leave it as is
because I could create this version with a script.

The alternative is that I leave the mcbsp.h file alone entirely and you
submit a patch to fix all instances where it's used, either rename or
remove them.

	Arnd
