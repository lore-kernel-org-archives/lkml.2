Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2KCWE6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:04:58 -0400
Received: from mail-ea0-f174.google.com ([209.85.215.174]:36338 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab2KCWCu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:02:50 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Lee Jones <lee.jones@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        x86@kernel.org
Subject: [PATCH 3/9] x86: Suppress build warnings in quirks
Date: Sat,  3 Nov 2012 23:02:24 +0100
Message-Id: <1351980150-24145-4-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

arch/x86/kernel/quirks.c: In function ‘ati_force_enable_hpet’:
arch/x86/kernel/quirks.c:364:4: warning: ‘d’ may be used uninitialised in this function [-Wuninitialized]
arch/x86/kernel/quirks.c:357:6: note: ‘d’ was declared here
arch/x86/kernel/quirks.c:407:21: warning: ‘val’ may be used uninitialised in this function [-Wuninitialized]

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86@kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 arch/x86/kernel/quirks.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/quirks.c b/arch/x86/kernel/quirks.c
index 1b27de5..d280b70 100644
--- a/arch/x86/kernel/quirks.c
+++ b/arch/x86/kernel/quirks.c
@@ -354,7 +354,7 @@ static void ati_force_hpet_resume(void)
 
 static u32 ati_ixp4x0_rev(struct pci_dev *dev)
 {
-	u32 d;
+	u32 d = 0;
 	u8  b;
 
 	pci_read_config_byte(dev, 0xac, &b);
@@ -371,7 +371,7 @@ static u32 ati_ixp4x0_rev(struct pci_dev *dev)
 
 static void ati_force_enable_hpet(struct pci_dev *dev)
 {
-	u32 d, val;
+	u32 d, val = 0;
 	u8  b;
 
 	if (hpet_address || force_hpet_address)
-- 
1.7.9.5

