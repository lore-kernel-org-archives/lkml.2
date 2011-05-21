Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab1EUImu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:42:50 -0400
Received: from eu1sys200aog116.obsmtp.com ([207.126.144.141]:36337 "EHLO
	eu1sys200aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751748Ab1EUImV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:42:21 -0400
From: Linus Walleij <linus.walleij@stericsson.com>
To: Samuel Ortiz <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>
Cc: Lee Jones <lee.jones@linaro.org>, Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 04/13] mach-ux500: update ASIC version detection
Date: Sat, 21 May 2011 10:42:12 +0200
Message-ID: <1305967332-16478-1-git-send-email-linus.walleij@stericsson.com>
X-Mailer: git-send-email 1.7.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

This makes the core detect the DB8500 V2.0 and V2.1 ASICs, and
add a convenience macro for "V2 or later".

Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
 arch/arm/mach-ux500/include/mach/id.h |   20 ++++++++++++++++++++
 1 files changed, 20 insertions(+), 0 deletions(-)

diff --git a/arch/arm/mach-ux500/include/mach/id.h b/arch/arm/mach-ux500/include/mach/id.h
index f1288d1..02b541a3 100644
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
1.7.3.2

