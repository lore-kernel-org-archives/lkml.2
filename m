Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422750Ab2LNXDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:03:32 -0500
Received: from mail.kernel.org ([198.145.19.201]:40723 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422734Ab2LNXD3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:03:29 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Jan Beulich <jbeulich@suse.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [ 16/37] x86: hpet: Fix masking of MSI interrupts
Date: Fri, 14 Dec 2012 15:00:53 -0800
Message-Id: <20121214222256.300455321@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20121214222252.781413287@linuxfoundation.org>
References: <20121214222252.781413287@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Beulich <JBeulich@suse.com>

commit 6acf5a8c931da9d26c8dd77d784daaf07fa2bff0 upstream.

HPET_TN_FSB is not a proper mask bit; it merely toggles between MSI and
legacy interrupt delivery. The proper mask bit is HPET_TN_ENABLE, so
use both bits when (un)masking the interrupt.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Link: http://lkml.kernel.org/r/5093E09002000078000A60E6@nat28.tlf.novell.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/hpet.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/hpet.c
+++ b/arch/x86/kernel/hpet.c
@@ -434,7 +434,7 @@ void hpet_msi_unmask(struct irq_data *da
 
 	/* unmask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg |= HPET_TN_FSB;
+	cfg |= HPET_TN_ENABLE | HPET_TN_FSB;
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 
@@ -445,7 +445,7 @@ void hpet_msi_mask(struct irq_data *data
 
 	/* mask it */
 	cfg = hpet_readl(HPET_Tn_CFG(hdev->num));
-	cfg &= ~HPET_TN_FSB;
+	cfg &= ~(HPET_TN_ENABLE | HPET_TN_FSB);
 	hpet_writel(cfg, HPET_Tn_CFG(hdev->num));
 }
 


