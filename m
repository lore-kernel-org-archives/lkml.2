Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005Ab1GGVMG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:12:06 -0400
Received: from mga11.intel.com ([192.55.52.93]:44187 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750932Ab1GGVME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:12:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,495,1304319600"; 
   d="scan'208";a="25127841"
From: james_p_freyensee@linux.intel.com
To: linux-next@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, randy.dunlap@oracle.com,
        sfr@canb.auug.org.au, christophe.guerard@intel.com,
        pranav.k.sanghadia@intel.com, james_p_freyensee@linux.intel.com
Subject: [PATCH] Add PCI config dependency for PTI.
Date: Thu,  7 Jul 2011 14:12:25 -0700
Message-Id: <1310073145-18328-1-git-send-email-james_p_freyensee@linux.intel.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <james_p_freyensee@linux.intel.com>
References: <james_p_freyensee@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: J Freyensee <james_p_freyensee@linux.intel.com>

Intel-Atom implementation of PTI will not work with PCI
configured off, so the pti driver should not be compiled
in the event someone does not enable PCI in the linux kernel.

Reported-by: Randy Dunlap <randy.dunlap@oracle.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: J Freyensee <james_p_freyensee@linux.intel.com>
---
 drivers/misc/Kconfig |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
index 4e349cd..7fd32a6 100644
--- a/drivers/misc/Kconfig
+++ b/drivers/misc/Kconfig
@@ -146,6 +146,7 @@ config PHANTOM
 
 config INTEL_MID_PTI
 	tristate "Parallel Trace Interface for MIPI P1149.7 cJTAG standard"
+	depends on PCI
 	default n
 	help
 	  The PTI (Parallel Trace Interface) driver directs
-- 
1.7.0.4

