Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab0G0Xvy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:51:54 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:44560 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753924Ab0G0Xvt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:51:49 -0400
From: dann frazier <dannf@hp.com>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-kernel@vger.kernel.org, Thomas Mingarelli <thomas.mingarelli@hp.com>,
        dann frazier <dannf@hp.com>
Subject: [PATCH 01/15] hpwdt_pretimeout reorganization
Date: Tue, 27 Jul 2010 17:50:49 -0600
Message-Id: <1280274663-9160-2-git-send-email-dannf@hp.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1280274663-9160-1-git-send-email-dannf@hp.com>
References: <1280274663-9160-1-git-send-email-dannf@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorganize this function to remove excess indentation and highlight
the single return code.

No functional change.

Signed-off-by: dann frazier <dannf@hp.com>
---
 drivers/watchdog/hpwdt.c |   36 +++++++++++++++++++-----------------
 1 files changed, 19 insertions(+), 17 deletions(-)

diff --git a/drivers/watchdog/hpwdt.c b/drivers/watchdog/hpwdt.c
index dbe650e..64ea6fc 100644
--- a/drivers/watchdog/hpwdt.c
+++ b/drivers/watchdog/hpwdt.c
@@ -476,24 +476,26 @@ static int hpwdt_pretimeout(struct notifier_block *nb, unsigned long ulReason,
 	static int die_nmi_called;
 
 	if (ulReason != DIE_NMI && ulReason != DIE_NMI_IPI)
-		return NOTIFY_OK;
-
-	if (hpwdt_nmi_sourcing) {
-		spin_lock_irqsave(&rom_lock, rom_pl);
-		if (!die_nmi_called)
-			asminline_call(&cmn_regs, cru_rom_addr);
-		die_nmi_called = 1;
-		spin_unlock_irqrestore(&rom_lock, rom_pl);
-		if (cmn_regs.u1.ral == 0) {
-			printk(KERN_WARNING "hpwdt: An NMI occurred, "
-				"but unable to determine source.\n");
-		} else {
-			if (allow_kdump)
-				hpwdt_stop();
-			panic("An NMI occurred, please see the Integrated "
-				"Management Log for details.\n");
-		}
+		goto out;
+
+	if (!hpwdt_nmi_sourcing)
+		goto out;
+
+	spin_lock_irqsave(&rom_lock, rom_pl);
+	if (!die_nmi_called)
+		asminline_call(&cmn_regs, cru_rom_addr);
+	die_nmi_called = 1;
+	spin_unlock_irqrestore(&rom_lock, rom_pl);
+	if (cmn_regs.u1.ral == 0) {
+		printk(KERN_WARNING "hpwdt: An NMI occurred, "
+			"but unable to determine source.\n");
+	} else {
+		if (allow_kdump)
+			hpwdt_stop();
+		panic("An NMI occurred, please see the Integrated "
+			"Management Log for details.\n");
 	}
+out:
 	return NOTIFY_OK;
 }
 
-- 
1.7.1

