Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759987Ab0ENVsG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 17:48:06 -0400
Received: from mga06.intel.com ([134.134.136.21]:49795 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1759661Ab0ENVr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 17:47:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,233,1272870000"; 
   d="scan'208";a="621797623"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Alan Cox <alan@linux.intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/8] x86/mrst/pci: return 0 for non-present pci bars
Date: Fri, 14 May 2010 14:41:14 -0700
Message-Id: <1273873281-17489-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273873281-17489-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Moorestown PCI code has special handling of devices with fixed BARs. In
case of BAR sizing writes, we need to update the fake PCI MMCFG space with real
size decode value.

When a BAR is not present, we need to return 0 instead of ~0. ~0 will be
treated as device error per bugzilla 12006.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/pci/mrst.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/mrst.c b/arch/x86/pci/mrst.c
index 8bf2fcb..d5c7aef 100644
--- a/arch/x86/pci/mrst.c
+++ b/arch/x86/pci/mrst.c
@@ -109,7 +109,7 @@ static int pci_device_update_fixed(struct pci_bus *bus, unsigned int devfn,
 			decode++;
 			decode = ~(decode - 1);
 		} else {
-			decode = ~0;
+			decode = 0;
 		}
 
 		/*
-- 
1.6.3.3

