Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934199Ab0GOSoI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 14:44:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:39095 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S934152Ab0GOSoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 14:44:05 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX182s0xgLEU2L4Ufyy290z3YD/yxgzy+EInN5CAthi
	yMkTdhrO17rvMW
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: [PATCH 02/25] cpufreq: Convert pci_table entries to PCI_VDEVICE (if PCI_ANY_ID is used)
Date: Thu, 15 Jul 2010 20:36:41 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34; KDE/4.3.5; x86_64; ; )
Cc: Dave Jones <davej@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Tejun Heo <tj@kernel.org>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201007152036.41768.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Huewe <peterhuewe@gmx.de>

This patch converts pci_table entries, where .subvendor=PCI_ANY_ID and
.subdevice=PCI_ANY_ID, .class=0 and .class_mask=0, to use the
PCI_VDEVICE macro, and thus improves readability.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
 arch/x86/kernel/cpu/cpufreq/gx-suspmod.c |    9 +++------
 1 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
index 16e3483..a7867ee 100644
--- a/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
+++ b/arch/x86/kernel/cpu/cpufreq/gx-suspmod.c
@@ -169,12 +169,9 @@ static int gx_freq_mult[16] = {
  *	Low Level chipset interface				*
  ****************************************************************/
 static struct pci_device_id gx_chipset_tbl[] __initdata = {
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5520,
-		PCI_ANY_ID, PCI_ANY_ID },
-	{ PCI_VENDOR_ID_CYRIX, PCI_DEVICE_ID_CYRIX_5510,
-		PCI_ANY_ID, PCI_ANY_ID },
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5530_LEGACY), },
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5520), },
+	{ PCI_VDEVICE(CYRIX, PCI_DEVICE_ID_CYRIX_5510), },
 	{ 0, },
 };
 
-- 
1.7.1

