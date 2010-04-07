Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756837Ab0DGXNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 19:13:16 -0400
Received: from mail.df.lth.se ([194.47.250.12]:65432 "EHLO df.lth.se"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756355Ab0DGXNI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 19:13:08 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: akpm@linux-foundation.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Grant Likely <grant.likely@secretlab.ca>,
       Dan Williams <dan.j.williams@intel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       STEricsson_nomadik_linux@list.st.com, linux-kernel@vger.kernel.org,
       Linus Walleij <linus.walleij@stericsson.com>
Subject: [PATCH 03/11] ARM: U300: set f_max to 24 MHz for MMCI
Date: Thu,  8 Apr 2010 01:12:33 +0200
Message-Id: <1270681953-5244-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.6.2.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This employs the frequency setting mechanism introduced to the
MMCI to specify that this system can actually be clocked at 24 MHz.

Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
---
 arch/arm/mach-u300/mmc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-u300/mmc.c b/arch/arm/mach-u300/mmc.c
index c2549b8..88506d0 100644
--- a/arch/arm/mach-u300/mmc.c
+++ b/arch/arm/mach-u300/mmc.c
@@ -102,6 +102,7 @@ int __devinit mmc_init(struct amba_device *adev)
 	 * we have a regulator we can control instead.
 	 */
 	/* Nominally 2.85V on our platform */
+	mmci_card->mmc0_plat_data.f_max = 24000000;
 	mmci_card->mmc0_plat_data.status = mmc_status;
 	mmci_card->mmc0_plat_data.gpio_wp = -1;
 	mmci_card->mmc0_plat_data.gpio_cd = -1;
-- 
1.6.3.3

