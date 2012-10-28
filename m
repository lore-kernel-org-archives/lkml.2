Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757058Ab2J1X2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:28:30 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42173 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756978Ab2J1X2X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:28:23 -0400
Message-Id: <20121028231550.941789248@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:21 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Pavel Machek <pavel@suse.cz>, Jochen Friedrich <jochen@scram.de>
Subject: [ 045/105] pcmcia: sharpsl: dont discard sharpsl_pcmcia_ops
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit fdc858a466b738d35d3492bc7cf77b1dac98bf7c upstream.

The sharpsl_pcmcia_ops structure gets passed into
sa11xx_drv_pcmcia_probe, where it gets accessed at run-time,
unlike all other pcmcia drivers that pass their structures
into platform_device_add_data, which makes a copy.

This means the gcc warning is valid and the structure
must not be marked as __initdata.

Without this patch, building collie_defconfig results in:

drivers/pcmcia/pxa2xx_sharpsl.c:22:31: fatal error: mach-pxa/hardware.h: No such file or directory
compilation terminated.
make[3]: *** [drivers/pcmcia/pxa2xx_sharpsl.o] Error 1
make[2]: *** [drivers/pcmcia] Error 2
make[1]: *** [drivers] Error 2
make: *** [sub-make] Error 2

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Pavel Machek <pavel@suse.cz>
Cc: linux-pcmcia@lists.infradead.org
Cc: Jochen Friedrich <jochen@scram.de>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/pcmcia/pxa2xx_sharpsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -219,7 +219,7 @@ static void sharpsl_pcmcia_socket_suspen
 	sharpsl_pcmcia_init_reset(skt);
 }
 
-static struct pcmcia_low_level sharpsl_pcmcia_ops __initdata = {
+static struct pcmcia_low_level sharpsl_pcmcia_ops = {
 	.owner                  = THIS_MODULE,
 	.hw_init                = sharpsl_pcmcia_hw_init,
 	.hw_shutdown            = sharpsl_pcmcia_hw_shutdown,


