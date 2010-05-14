Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932094Ab0ENVsj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:48:39 -0400
Received: from mga09.intel.com ([134.134.136.24]:47140 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759993Ab0ENVsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:48:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="621797676"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 7/8] x86/mrst: add nop functions to x86_init mpparse functions
Date: Fri, 14 May 2010 14:41:20 -0700
Message-Id: <1273873281-17489-8-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown does not have BIOS provided MP tables, we can save some time
by avoiding scaning of these tables. e.g.
[    0.000000] Scan SMP from c0000000 for 1024 bytes.
[    0.000000] Scan SMP from c009fc00 for 1024 bytes.
[    0.000000] Scan SMP from c00f0000 for 65536 bytes.
[    0.000000] Scan SMP from c00bfff0 for 1024 bytes.

Searching EBDA with the base at 0x40E will also result in random pointer
deferencing within 1MB. This can be a problem in Lincroft if the pointer
hits VGA area and VGA mode is not enabled.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 arch/x86/kernel/mrst.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/mrst.c b/arch/x86/kernel/mrst.c
index 83c23d6..9b62d32 100644
--- a/arch/x86/kernel/mrst.c
+++ b/arch/x86/kernel/mrst.c
@@ -311,4 +311,9 @@ void __init x86_mrst_early_setup(void)
 	x86_init.pci.fixup_irqs = x86_init_noop;
 
 	legacy_pic = &null_legacy_pic;
+
+	/* Avoid searching for BIOS MP tables */
+	x86_init.mpparse.find_smp_config = x86_init_noop;
+	x86_init.mpparse.get_smp_config = x86_init_uint_noop;
+
 }
-- 
1.6.3.3

