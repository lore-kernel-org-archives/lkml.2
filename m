Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751866Ab1GUWuB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 18:50:01 -0400
Received: from smtpo.poczta.interia.pl ([217.74.65.205]:30468 "EHLO
	smtpo.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1GUWt6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 18:49:58 -0400
From: =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?b?UmFmYcWC?= Bilski <rafalbilski@interia.pl>
Subject: [PATCH] e_powersaver: This is C7 driver only
Date: Thu, 21 Jul 2011 23:52:44 +0100
Message-Id: <1311288764-1089-1-git-send-email-rafalbilski@interia.pl>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
X-Interia-Antivirus: OK
X-EMID: a0771958
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enhanced Powersaver has been replaced by Adaptive Powersaver technology. Flag
"est" on VIA/Centaur Nano processors means that processor supports Adaptive
Powersaver.

Signed-off-by: Rafał Bilski <rafalbilski@interia.pl>
---
 drivers/cpufreq/e_powersaver.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 7638f5d..28600ae 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -237,10 +237,6 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		brand = (((lo >> 4) ^ (lo >> 2))) & 0xff;
 		printk(KERN_CONT "Model D ");
 		break;
-	default:
-		printk(KERN_CONT "unknown processor\n");
-		return -ENODEV;
-		break;
 	}
 
 	switch (brand) {
@@ -437,7 +433,8 @@ static int __init eps_init(void)
 	/* This driver will work only on Centaur C7 processors with
 	 * Enhanced SpeedStep/PowerSaver registers */
 	if (c->x86_vendor != X86_VENDOR_CENTAUR
-	    || c->x86 != 6 || c->x86_model < 10)
+	    || c->x86 != 6
+	    || !(c->x86_model == 10 || c->x86_model == 13))
 		return -ENODEV;
 	if (!cpu_has(c, X86_FEATURE_EST))
 		return -ENODEV;
-- 
1.7.6


----------------------------------------------------------------
Znajdz samochod idealny dla siebie!
Szukaj >> http://linkint.pl/f29e2
