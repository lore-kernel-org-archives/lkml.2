Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab1KLTvN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 14:51:13 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:32936 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752042Ab1KLTvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 14:51:12 -0500
Subject: [PATCH] ia64: change "select DMAR" to "select INTEL_IOMMU"
From: Paul Bolle <pebolle@tiscali.nl>
To: Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>
Cc: linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 12 Nov 2011 20:51:01 +0100
Message-ID: <1321127461.27598.102.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d3f138106b ("iommu: Rename the DMAR and INTR_REMAP config
options") changed all references to DMAR in Kconfig files to INTEL_IOMMU
(and, likewise, changed the references to CONFIG_DMAR everywhere else
to CONFIG_INTEL_IOMMU). That commit missed one "select DMAR" statement
in ia64's Kconfig file. Change that one too.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) Tested with "make ARCH=ia64 menuconfig" only.

1) Everything suggests this was simply an oversight. Otherwise that
select line would have been dropped, wouldn't it?

 arch/ia64/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/Kconfig b/arch/ia64/Kconfig
index 552cbe9..c7bf0ea 100644
--- a/arch/ia64/Kconfig
+++ b/arch/ia64/Kconfig
@@ -185,7 +185,7 @@ config IA64_DIG
 
 config IA64_DIG_VTD
 	bool "DIG+Intel+IOMMU"
-	select DMAR
+	select INTEL_IOMMU
 	select PCI_MSI
 
 config IA64_HP_ZX1
-- 
1.7.4.4

