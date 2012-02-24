Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757071Ab2BXPUe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 10:20:34 -0500
Received: from va3ehsobe001.messaging.microsoft.com ([216.32.180.11]:29860
	"EHLO VA3EHSOBE009.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754588Ab2BXPUd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 10:20:33 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZWLA0-02-H4U-02
X-M-MSG: 
Date: Fri, 24 Feb 2012 16:20:25 +0100
From: Andreas Herrmann <andreas.herrmann3@amd.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/2] x86/amd: Enable early_fill_mp_bus_to_node on AMD family
 15h models 0-0xf
Message-ID: <20120224152025.GB28921@alberich.amd.com>
References: <20120224151912.GA28921@alberich.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20120224151912.GA28921@alberich.amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


While at it avoid calling this function on family 11h (aka Griffin)
which was a mobile part and doesn't support NUMA.

Signed-off-by: Andreas Herrmann <andreas.herrmann3@amd.com>
---
 arch/x86/pci/amd_bus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/amd_bus.c b/arch/x86/pci/amd_bus.c
index 0384e69..d552b29 100644
--- a/arch/x86/pci/amd_bus.c
+++ b/arch/x86/pci/amd_bus.c
@@ -27,7 +27,7 @@ static struct pci_hostbridge_probe pci_probes[] __initdata = {
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1100 },
 	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1200 },
 	{ 0xff, 0, PCI_VENDOR_ID_AMD, 0x1200 },
-	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1300 },
+	{ 0, 0x18, PCI_VENDOR_ID_AMD, 0x1600 },
 };
 
 /**
-- 
1.7.8.4



