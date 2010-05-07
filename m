Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab0EGRsf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 13:48:35 -0400
Received: from mga10.intel.com ([192.55.52.92]:58103 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756919Ab0EGRrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 13:47:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,349,1270450800"; 
   d="scan'208";a="796418391"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Ingo Molnar <mingo@elte.hu>, Alek Du <alek.du@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 2/8] x86/mrst/pci: return 0 for non-present pci bars
Date: Fri,  7 May 2010 10:41:42 -0700
Message-Id: <1273254108-3234-3-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
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

