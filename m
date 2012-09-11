Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759699Ab2IKRQz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:16:55 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:60800 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282Ab2IKRQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:16:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Subject: Re: [PATCH 03/16] ARM: ep93xx: move platform_data definitions
Date: Tue, 11 Sep 2012 17:16:27 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ryan Mallon <rmallon@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Axel Lin <axel.lin@gmail.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-3-git-send-email-arnd@arndb.de> <ADE657CA350FB648AAC2C43247A983F00206B1EB884D@AUSP01VMBX24.collaborationhost.net>
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F00206B1EB884D@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209111716.27848.arnd@arndb.de>
X-Provags-ID: V02:K0:NKA6FH5F+UOL0PXJpvjFfcGhfeg0eGX3tmaXJlt3vhs
 RW17e20Oatfz2TtOUNpi8klsCIVEMr08u20IkokIKoesN6436o
 AWHs7TVczCd64JRUKk6nf14c/Va1FAiv3/4y278RjTQAwXFQaK
 X1LI9tGFnnxMWLXdo7woEL7Y3/JgHJ+sWlphEZklBzexkmVgqa
 EfSlnY5tA0dxBSSt6Av/KJIpkkZ0IcPEUv69Tsx1fG4HDGO+Dr
 OD7T7oz9g1Qlg+s6Q/1BqO/6JvEZyrcJv0w13FMb5hDuIbO5Wh
 SHc+Wx/tTQoHAiiXuQfXgkpXlGc5FDmMgF3FuSwnK1LFsY3FdY
 FXlcFyEArv+SYaa9k7dw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 September 2012, H Hartley Sweeten wrote:
> Arnd,
> 
> What about gpio-ep93xx.h? It does not have any platform_data in
> it but the gpio driver (driver/gpio/gpio-ep93xx.c) does include it
> from the mach-* directory.

There are actually four such headers for ep93xx:

* mach/ep93xx-regs.h
  sound/soc/ep93xx/ep93xx-i2s.c
  sound/soc/ep93xx/ep93xx-pcm.c

* mach/gpio-ep93xx.h
  drivers/gpio/gpio-ep93xx.c

* mach/hardware.h
  drivers/gpio/gpio-ep93xx.c
  drivers/input/keyboard/ep93xx_keypad.c
  drivers/net/ethernet/cirrus/ep93xx_eth.c
  sound/soc/ep93xx/edb93xx.c
  sound/soc/ep93xx/ep93xx-i2s.c
  sound/soc/ep93xx/ep93xx-pcm.c
  sound/soc/ep93xx/simone.c
  sound/soc/ep93xx/snappercl15.c

* mach/platform.h
  drivers/ata/pata_ep93xx.c
  drivers/misc/ep93xx_pwm.c

If you are planning to allow building a combined kernel for ep93xx and
another ARMv4/v5 platform, all of these inclusions need to be removed
and done differently, plus you also need to start using the common clock
subsystem and sparse-irq. 

Any of those things would be greatly appreciated as a cleanup, but we're
not going to require them any time soon.

	Arnd
