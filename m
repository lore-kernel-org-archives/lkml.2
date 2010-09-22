Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0IVQnN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 12:43:13 -0400
Received: from mtaout01-winn.ispmail.ntl.com ([81.103.221.47]:33055 "EHLO
	mtaout01-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751868Ab0IVQnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 12:43:12 -0400
From: Daniel Drake <dsd@laptop.org>
To: tglx@linutronix.de
Cc: x86@kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: dilinger@queued.net
Subject: [PATCH 1/3] OLPC: extended board revision detection
Message-Id: <20100922164307.8D7F09D401B@zog.reactivated.net>
Date: Wed, 22 Sep 2010 17:43:07 +0100 (BST)
X-Cloudmark-Analysis: v=1.1 cv=3ENABmdyEd/Fm7fR7+mZIuMDn6+IErAeEhlfWBImZFk= c=1 sm=0 a=iJWZOT5mzuEA:10 a=Op-mwl0xAAAA:8 a=AGgCn4eQgtZ7TJQTVoEA:9 a=oAIC01FxrKkWChBc78DiC1kwmNYA:4 a=d4CUUju0HPYA:10 a=o98uK1cdWnhKTUMc:21 a=OfbMJ7nQnDu_sdXD:21 a=HpAAvcLHHh0Zw7uRqdWCyQ==:117
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add some functions to easily detect which version of the laptop we are
running on, and document the board IDs which are accepted by olpc_board().

Signed-off-by: Daniel Drake <dsd@laptop.org>
---
 arch/x86/include/asm/olpc.h |   37 +++++++++++++++++++++++++++++++++++++
 1 files changed, 37 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/olpc.h b/arch/x86/include/asm/olpc.h
index 101229b..9f3219b 100644
--- a/arch/x86/include/asm/olpc.h
+++ b/arch/x86/include/asm/olpc.h
@@ -23,6 +23,21 @@ extern struct olpc_platform_t olpc_platform_info;
  * and the minor build number withing 0x000f.  Pre-builds have a minor
  * number less than 8, and normal builds start at 8.  For example, 0x0B10
  * is a PreB1, and 0x0C18 is a C1.
+ *
+ * History of board IDs that you can pass into this function:
+ *  0xb1 - XO-1 B1
+ *  0xb2 - XO-1 B2
+ *  0xb3 - XO-1 B3
+ *  0xc1 - XO-1 C1
+ *  0xc2 - XO-1 C2
+ *  0xd0 - XO-1.5 A0 and A1 test
+ *  0xd1 - XO-1.5 B1 and B2 test
+ *  0xd2 - XO-1.5 B3 test
+ *  0xd3 - XO-1.5 C1 initial factory build (12/2009)
+ *  0xd4 - XO-1.5 C2 ramp build (02/2010)
+ *  0xd3 - XO-1.5 mass production
+ *  0xd4 - XO-1.5
+ *  0xd5 - XO-1.5
  */
 
 static inline uint32_t olpc_board(uint8_t id)
@@ -40,6 +55,18 @@ static inline int machine_is_olpc(void)
 	return (olpc_platform_info.flags & OLPC_F_PRESENT) ? 1 : 0;
 }
 
+static inline int machine_is_olpc_xo_1(void)
+{
+	return machine_is_olpc() &&
+		olpc_platform_info.boardrev < olpc_board_pre(0xd0);
+}
+
+static inline int machine_is_olpc_xo_1_5(void)
+{
+	return machine_is_olpc() &&
+		olpc_platform_info.boardrev >= olpc_board_pre(0xd0);
+}
+
 /*
  * The DCON is OLPC's Display Controller.  It has a number of unique
  * features that we might want to take advantage of..
@@ -69,6 +96,16 @@ static inline int machine_is_olpc(void)
 	return 0;
 }
 
+static inline int machine_is_olpc_xo_1(void)
+{
+	return 0;
+}
+
+static inline int machine_is_olpc_xo_1_5(void)
+{
+	return 0;
+}
+
 static inline int olpc_has_dcon(void)
 {
 	return 0;
-- 
1.7.2.2

