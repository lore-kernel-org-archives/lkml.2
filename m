Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757750Ab2HVS5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 14:57:45 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:58310 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab2HVS5m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 14:57:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH] media/radio/shark2: Fix build error caused by missing dependencies
Date: Wed, 22 Aug 2012 18:57:01 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Hans de Goede <hdegoede@redhat.com>, linux-media@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
References: <1345648585-5176-1-git-send-email-linux@roeck-us.net> <5034F932.4000405@redhat.com> <20120822152922.GA6177@roeck-us.net>
In-Reply-To: <20120822152922.GA6177@roeck-us.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221857.01527.arnd@arndb.de>
X-Provags-ID: V02:K0:8lz5/FkHE5hp65xaTknWaYyetUBue8PQMSkxGPL+aAP
 Hzk8jwINnnzd4IM85TMYBPa4SRE4IPc6KccUH+t634/l3PV0Z9
 PQR+gp9sl5yq9IJ4BpJdufn5uEVsLApKyGYWV4aq4STjE20YwN
 gOPD5Y96GHHx7HOK4VuJZu0z1mBiGiVNmxY7Z7uOAZCLEh+Kyw
 OlUcJ5YNkVBCNiZinXXTo6ra+3uB8DxG36rqQsXxvoCf7JsHXO
 6l+ta9ihCXQH0HKVv9ql66cdy9i5nocfEq8AiklnmNM6+svOmJ
 9/oWsB72uf5QGaRf033gDHFdgn1tY8OPUuF7ApuJH3FB/JcbMd
 7YYTysK3QGrs0+ZiHRaU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Guenter Roeck wrote:
> On Wed, Aug 22, 2012 at 05:22:26PM +0200, Hans de Goede wrote:
> > Hi,
> > 
> > I've a better fix for this here:
> > http://git.linuxtv.org/hgoede/gspca.git/shortlog/refs/heads/media-for_v3.6
> > 
> > I already send a pull-req for this to Mauro a while ago, Mauro?
> > 
> Looks like it found its way into mainline in the last couple of days.
> Should have updated my tree first. Sorry for the noise.
> 

I found another issue with the shark driver while doing randconfig tests.
Here is my semi-automated log file for the problem. Has this also made
it in already?

	Arnd

---
Without this patch, building rand-0y2jSKT results in:

WARNING: drivers/usb/musb/musb_hdrc.o(.devinit.text+0x9b8): Section mismatch in reference from the function musb_init_controller() to the function .init.text:dma_controller_create()
The function __devinit musb_init_controller() references
a function __init dma_controller_create().
If dma_controller_create is only used by musb_init_controller then
annotate dma_controller_create with a matching annotation.

ERROR: "snd_tea575x_init" [drivers/media/radio/radio-shark.ko] undefined!
ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-shark.ko] undefined!
make[2]: *** [__modpost] Error 1
make[1]: *** [modules] Error 2
make: *** [sub-make] Error 2

---
 sound/pci/Kconfig |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/pci/Kconfig b/sound/pci/Kconfig
index ff3af6e..f99fa25 100644
--- a/sound/pci/Kconfig
+++ b/sound/pci/Kconfig
@@ -2,8 +2,8 @@
 
 config SND_TEA575X
 	tristate
-	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO
-	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO
+	depends on SND_FM801_TEA575X_BOOL || SND_ES1968_RADIO || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
+	default SND_FM801 || SND_ES1968 || RADIO_SF16FMR2 || RADIO_MAXIRADIO || RADIO_SHARK
 
 menuconfig SND_PCI
 	bool "PCI sound devices"
-- 
1.7.10

