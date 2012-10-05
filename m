Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab2JEO65 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 10:58:57 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61424 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756220Ab2JEO4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 10:56:07 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org, arm@kernel.org,
        Arnd Bergmann <arnd@arndb.de>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Pavel Machek <pavel@suse.cz>, linux-pcmcia@lists.infradead.org,
        Jochen Friedrich <jochen@scram.de>, stable@vger.kernel.org
Subject: [PATCH 11/16] pcmcia: sharpsl: don't discard sharpsl_pcmcia_ops
Date: Fri,  5 Oct 2012 16:55:25 +0200
Message-Id: <1349448930-23976-12-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1349448930-23976-1-git-send-email-arnd@arndb.de>
References: <1349448930-23976-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:nn8BWbPO460Y2W01upUc5AGLGbxLrVGDwBGKkgYjjp3
 FnZwlHTwnwXvEw1O/XVunK+GyOXI/arIZztHiT0phOdY6lKAgz
 ylBHEJaW5ycKzT2Wm1HHnxy6RV0o6yi7hn5eXjbR/XL7ekgbZW
 82Fyn5J9h3xSvVc2zBWySavYALbLHSymdCDFevrCze8PTkdksx
 1TAEY/cb+WbtWyDH2rkPKcpCqfGFyyqtt5Z6j0ZPb/eMpj1/JW
 MTEfmq1wK1HwUjnS8jb9qq3eUMFA14uT+1yP0DusHVw084HCOW
 mvNZ3tIPocrrmHJqwQ17kMWd+wGwFWOrwkhBx8bg7+BdrLST+S
 k1/AF1p1z9/MtGmZdrv666N811RHO5P3I3CcNqaTLrzZnUuMSM
 OtNn2k1xBymH02uetIJcVSgh1o757m+W+8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The sharpsl_pcmcia_ops structure gets passed into
sa11xx_drv_pcmcia_probe, where it gets accessed at run-time,
unlike all other pcmcia drivers that pass their structures
into platform_device_add_data, which makes a copy.

This means the gcc warning is valid and the structure
must not be marked as __initdata.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King <rmk+kernel@arm.linux.org.uk>
Cc: Pavel Machek <pavel@suse.cz>
Cc: linux-pcmcia@lists.infradead.org
Cc: Jochen Friedrich <jochen@scram.de>
Cc: stable@vger.kernel.org
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
1.7.10

