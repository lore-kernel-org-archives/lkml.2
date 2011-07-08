Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1GHIhe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jul 2011 04:37:34 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34308 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753936Ab1GHIhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jul 2011 04:37:31 -0400
Subject: [RFC][PATCH] cpufreq: e_powersaver: Fix checking brand for
 EPS_BRAND_C3
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Rafal Bilski <rafalbilski@interia.pl>, Dave Jones <davej@redhat.com>,
        cpufreq@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 16:37:23 +0800
Message-ID: <1310114243.2940.3.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do not return -ENODEV for EPS_BRAND_C3.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
I just found the code is suspect. 
I don't have this hardware handy.
Anyone can help to confirm and test if this patch works?
Axel

 drivers/cpufreq/e_powersaver.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/cpufreq/e_powersaver.c b/drivers/cpufreq/e_powersaver.c
index 35a257d..637f055 100644
--- a/drivers/cpufreq/e_powersaver.c
+++ b/drivers/cpufreq/e_powersaver.c
@@ -199,8 +199,9 @@ static int eps_cpu_init(struct cpufreq_policy *policy)
 		break;
 	case EPS_BRAND_C3:
 		printk(KERN_CONT "C3\n");
-		return -ENODEV;
 		break;
+	default:
+		return -ENODEV;
 	}
 	/* Enable Enhanced PowerSaver */
 	rdmsrl(MSR_IA32_MISC_ENABLE, val);
-- 
1.7.4.1



