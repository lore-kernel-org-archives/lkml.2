Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab1JATX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 15:23:29 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50633 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756695Ab1JATXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 15:23:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH 10/11] ARM: OC_ETM should not select ARM_AMBA
Date: Sat,  1 Oct 2011 21:21:59 +0200
Message-Id: <1317496920-7764-11-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1317496920-7764-1-git-send-email-arnd@arndb.de>
References: <1317496920-7764-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V02:K0:TJ517U9iUhpS6oN7lOqOGwrRog3KILQ1K1Cy90oWQVm
 6FVC3EcqNDAu8IJmNqyY5h4sBdTNGeQBfp6PHC4FEMAydQCbRq
 EaEVFJ0LZcHeZZMP75QXjXpV1DvxqA7p61LfAuxhlHG12CQLB+
 u42/tFwZKvKsP34ItskUqi17eIsFc1Dp0Utuq9Ms9Gl1StG2kF
 LY9g+AcMA3VoEmRvpMSch8X7S8e17jYBKiDMZmbzgVqcYvNQ0j
 qzlST8bXJp4frXPVWx9a+/ta/Ecg9IpiFuF7TYjZiKquszYPHg
 oVq4rL5nyLCX0mM0Jc7YQwYd5u66lqbC7R91NEYnBa9aJZ7oOe
 RdATfX9dhIgpcGT3dvcKuxH/hTSDB05SzsjECFvKhxekEvECJz
 MPpJwmEcXTFXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CONFIG_ARM_AMBA symbol is selected by the platforms that support
AMBA, and the other platforms (e.g. orion) might not be able to
build that code at all when they do not support the clk API.

Instead, make sure that OC_ETM is only built on platforms that
do support the amba subsystem already.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 arch/arm/Kconfig.debug |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/arm/Kconfig.debug b/arch/arm/Kconfig.debug
index 81cbe40..0c7a4f5 100644
--- a/arch/arm/Kconfig.debug
+++ b/arch/arm/Kconfig.debug
@@ -94,7 +94,7 @@ config DEBUG_ICEDCC
 
 config OC_ETM
 	bool "On-chip ETM and ETB"
-	select ARM_AMBA
+	depends on ARM_AMBA
 	help
 	  Enables the on-chip embedded trace macrocell and embedded trace
 	  buffer driver that will allow you to collect traces of the
-- 
1.7.5.4

