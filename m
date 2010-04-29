Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757331Ab0D2AbF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 20:31:05 -0400
Received: from mail.gmx.net ([213.165.64.20]:46797 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1755637Ab0D2AbC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 20:31:02 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+rpo9k83arqubyJ3KMStEDY/IRggYwZXClnWvZIZ
	HhEBjx9321ssfD
From: Peter Huewe <PeterHuewe@gmx.de>
To: Russell King <linux@arm.linux.org.uk>
Subject: [PATCH] arch/arm: Fix missing define for ARM_PMU_DEVICE_CPU
Date: Thu, 29 Apr 2010 02:31:03 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.33.2; KDE/4.3.5; x86_64; ; )
Cc: Jamie Iles <jamie.iles@picochip.com>, linux-arm-kernel@lists.infradead.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201004290231.03440.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.53000000000000003
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch adds a define for ARM_PMU_DEVICE_CPU which seemed to be
missing/undefined and caused some build failures [1-4].

I defined ARM_PMU_DEVICE_CPU = -1 as stated in
Documentation/driver_model/platform.txt to indicate there is only one.
I'm _not_ sure if this is correct, but due to the static nature of the
define I assume it is.


References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/2535843/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/2535842/
[3] http://kisskb.ellerman.id.au/kisskb/buildresult/2535820/
[4] http://kisskb.ellerman.id.au/kisskb/buildresult/2535819/

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
KernelVersion: linux-next-20100429

 arch/arm/include/asm/pmu.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/arm/include/asm/pmu.h b/arch/arm/include/asm/pmu.h
index 2829b9f..9b186e2 100644
--- a/arch/arm/include/asm/pmu.h
+++ b/arch/arm/include/asm/pmu.h
@@ -13,6 +13,7 @@
 #define __ARM_PMU_H__
 
 #ifdef CONFIG_CPU_HAS_PMU
+#define ARM_PMU_DEVICE_CPU -1
 
 struct pmu_irqs {
 	const int   *irqs;
-- 
1.6.4.4

