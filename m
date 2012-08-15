Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab2HORJ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:09:57 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56023 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755194Ab2HORIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:08:40 -0400
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King <linux@arm.linux.org.uk>, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rabeeh Khoury <rabeeh@solid-run.com>,
        Ian Molton <ian.molton@codethink.co.uk>,
        Maen Suleiman <maen@marvell.com>, Olof Johansson <olof@lixom.net>
Subject: [PATCH v3 3/6] ARM: dove: add crypto engine
Date: Wed, 15 Aug 2012 19:07:32 +0200
Message-Id: <1345050455-32643-4-git-send-email-sebastian.hesselbarth@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1345050455-32643-1-git-send-email-sebastian.hesselbarth@gmail.com>
References: <1344681326-17946-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1345050455-32643-1-git-send-email-sebastian.hesselbarth@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a dove specific setup function for the Marvell CESA
crypto engine available on orion based SoCs. Dove setup was just
missing a function to call orion_crypto_init with dove specific
setup.

Signed-off-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
---
Cc: Russell King <linux@arm.linux.org.uk>
Cc: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Cc: Rabeeh Khoury <rabeeh@solid-run.com>
Cc: Ian Molton <ian.molton@codethink.co.uk>
Cc: Maen Suleiman <maen@marvell.com>
Cc: Olof Johansson <olof@lixom.net>
---
 arch/arm/mach-dove/common.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/arch/arm/mach-dove/common.c b/arch/arm/mach-dove/common.c
index 9b2f961..66689ce 100644
--- a/arch/arm/mach-dove/common.c
+++ b/arch/arm/mach-dove/common.c
@@ -258,6 +258,15 @@ struct sys_timer dove_timer = {
 };
 
 /*****************************************************************************
+ * Cryptographic Engines and Security Accelerator (CESA)
+ ****************************************************************************/
+void __init dove_crypto_init(void)
+{
+	orion_crypto_init(DOVE_CRYPT_PHYS_BASE, DOVE_CESA_PHYS_BASE,
+			  DOVE_CESA_SIZE, IRQ_DOVE_CRYPTO);
+}
+
+/*****************************************************************************
  * XOR 0
  ****************************************************************************/
 void __init dove_xor0_init(void)
-- 
1.7.10.4

