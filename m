Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756886Ab2KZRoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:44:13 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933455Ab2KZRJ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:09:59 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Pavel Machek <pavel@suse.cz>, linux-pcmcia@lists.infradead.org,
        Jochen Friedrich <jochen@scram.de>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 160/270] pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
Date: Mon, 26 Nov 2012 14:57:30 -0200
Message-Id: <1353949160-26803-161-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/pcmcia/pxa2xx_sharpsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pcmcia/pxa2xx_sharpsl.c b/drivers/pcmcia/pxa2xx_sharpsl.c
index b066273..7dd879c 100644
--- a/drivers/pcmcia/pxa2xx_sharpsl.c
+++ b/drivers/pcmcia/pxa2xx_sharpsl.c
@@ -194,7 +194,7 @@ static void sharpsl_pcmcia_socket_suspend(struct soc_pcmcia_socket *skt)
 	sharpsl_pcmcia_init_reset(skt);
 }
 
-static struct pcmcia_low_level sharpsl_pcmcia_ops __initdata = {
+static struct pcmcia_low_level sharpsl_pcmcia_ops = {
 	.owner                  = THIS_MODULE,
 	.hw_init                = sharpsl_pcmcia_hw_init,
 	.socket_state           = sharpsl_pcmcia_socket_state,
-- 
1.7.9.5

