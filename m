Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754840Ab1IFPMT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:12:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58411 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754821Ab1IFPMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:12:14 -0400
From: Thomas Weber <weber@corscience.de>
To: linux-omap@vger.kernel.org
Cc: Thomas Weber <weber@corscience.de>,
        Tony Lindgren <tony@atomide.com> (maintainer:OMAP SUPPORT),
        Russell King <linux@arm.linux.org.uk> (maintainer:ARM PORT),
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] OMAP2: Devkit8000: Remove double omap_mux_init_gpio
Date: Tue,  6 Sep 2011 17:11:49 +0200
Message-Id: <1315321909-5593-1-git-send-email-weber@corscience.de>
X-Mailer: git-send-email 1.7.6.1
X-Provags-ID: V02:K0:W4GLDas8UJtlY/oqzX5LyNHRvW9YNPeALw6ttOBODms
 3Co0HWz2KmRI9vV9veSzuuZ9n22K34ANT/TBQ74OTCm7556jqD
 Z0r+U1muIW//hbxhkjilssk9FMrzvMiv0vNBOctzFLHvJng9SM
 1x7IYolPcLFS4KEI8ijLccnP2vR8kyCoPxxjb0LYka2DlZM0RX
 +1E1Vv5hnRiUmVquvJO1mHwwrOUa55dK6e3CZNBomfK/zW6ZdU
 /yljVvHWFYlO0GFjdXvM5aeV7+gW+VUXASTfFQBSiooA/h3QCA
 ZYOZipGS3Ppa6SO6mHiQVeoFD8jk18xi4JVWDJYW1h2Y9X/HAG
 bUNUDfYqs0eb/7KRT+d5syTL3g06QbnLDbNmR03XJQuHPmoepC
 O5kKzVMyoDL6w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove the init of card detect pin because
omap_mux_init_gpio() is called during hsmmc initialization
for the write protect and card detect pin.

Signed-off-by: Thomas Weber <weber@corscience.de>
---
 arch/arm/mach-omap2/board-devkit8000.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/arch/arm/mach-omap2/board-devkit8000.c b/arch/arm/mach-omap2/board-devkit8000.c
index f15f2a2..029c08a 100644
--- a/arch/arm/mach-omap2/board-devkit8000.c
+++ b/arch/arm/mach-omap2/board-devkit8000.c
@@ -226,7 +226,6 @@ static int devkit8000_twl_gpio_setup(struct device *dev,
 {
 	int ret;
 
-	omap_mux_init_gpio(29, OMAP_PIN_INPUT);
 	/* gpio + 0 is "mmc0_cd" (input/IRQ) */
 	mmc[0].gpio_cd = gpio + 0;
 	omap2_hsmmc_init(mmc);
-- 
1.7.6.1

