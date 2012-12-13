Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab2LMNXI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 08:23:08 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:33644 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755619Ab2LMNWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 08:22:33 -0500
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com, ulf.hansson@linaro.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 6/8] ARM: ux500: Setup correct settling time for the MMCI regulator
Date: Thu, 13 Dec 2012 13:22:08 +0000
Message-Id: <1355404930-5691-7-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
References: <1355404930-5691-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The GPIO controlled MMCI regulator used on the ux5x0 boards takes
100us to settle. There's already a binding to provide such
information. Let's make use of it.

Acked-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/arm/boot/dts/dbx5x0.dtsi |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/boot/dts/dbx5x0.dtsi b/arch/arm/boot/dts/dbx5x0.dtsi
index 88f90217..208fe8b 100644
--- a/arch/arm/boot/dts/dbx5x0.dtsi
+++ b/arch/arm/boot/dts/dbx5x0.dtsi
@@ -638,6 +638,7 @@
 			regulator-name = "mmci-reg";
 			regulator-type = "voltage";
 
+			startup-delay-us = <100>;
 			enable-active-high;
 
 			states = <1800000 0x1
-- 
1.7.9.5

