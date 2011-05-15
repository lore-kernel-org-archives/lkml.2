Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231Ab1EOXhu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 19:37:50 -0400
Received: from mail.df.lth.se ([194.47.250.12]:22991 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755119Ab1EOXhs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 19:37:48 -0400
From: Linus Walleij <linus.walleij@linaro.org>
To: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/13] mach-ux500: update ASIC version detection
Date: Mon, 16 May 2011 01:37:45 +0200
Message-Id: <1305502665-32549-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This makes the core detect the DB8500 V2.0 and V2.1 ASICs, and
add a convenience macro for "V2 or later".

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/include/mach/id.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/id.h b/arch/arm/mach-ux500/include/mach/id.h
index f1288d1..02b541a 100644
--- a/arch/arm/mach-ux500/include/mach/id.h
+++ b/arch/arm/mach-ux500/include/mach/id.h
@@ -75,6 +75,26 @@ static inline bool __attribute_const__ cpu_is_u8500v2(void)
 	return cpu_is_u8500() && ((dbx500_revision() & 0xf0) == 0xB0);
 }
 
+static inline bool cpu_is_u8500v20(void)
+{
+	return cpu_is_u8500() && (dbx500_revision() == 0xB0);
+}
+
+static inline bool cpu_is_u8500v21(void)
+{
+	return cpu_is_u8500() && (dbx500_revision() == 0xB1);
+}
+
+static inline bool cpu_is_u8500v20_or_later(void)
+{
+	return cpu_is_u8500() && !cpu_is_u8500v10() && !cpu_is_u8500v11();
+}
+
+static inline bool ux500_is_svp(void)
+{
+	return false;
+}
+
 #define ux500_unknown_soc()	BUG()
 
 #endif
-- 
1.7.4.4

