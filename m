Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab2ICAir (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 20:38:47 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53953 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab2ICAip (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 20:38:45 -0400
From: Joe Millenbach <jmillenbach@gmail.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Cc: team-fjord@googlegroups.com, Joe Millenbach <jmillenbach@gmail.com>
Subject: [PATCHv2] x86: Removing invalid reference to Intel CPUs in CONFIG_SWIOTLB
Date: Sun,  2 Sep 2012 17:38:20 -0700
Message-Id: <1346632700-29113-1-git-send-email-jmillenbach@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Deleted the no longer valid example of which x86 CPUs lack a hardware
IOMMU, and moved the "If unsure..." statement to a new line to follow
the style of surrounding options.

Signed-off-by: Joe Millenbach <jmillenbach@gmail.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
v2: Incorporated feedback from Konrad Rzeszutek Wilk that no mention of
    Intel CPUs was needed.

 arch/x86/Kconfig |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 5bed94e..c5b08e3 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -755,10 +755,10 @@ config SWIOTLB
 	def_bool y if X86_64
 	---help---
 	  Support for software bounce buffers used on x86-64 systems
-	  which don't have a hardware IOMMU (e.g. the current generation
-	  of Intel's x86-64 CPUs). Using this PCI devices which can only
-	  access 32-bits of memory can be used on systems with more than
-	  3 GB of memory. If unsure, say Y.
+	  which don't have a hardware IOMMU. Using this PCI devices
+	  which can only access 32-bits of memory can be used on systems
+	  with more than 3 GB of memory.
+	  If unsure, say Y.
 
 config IOMMU_HELPER
 	def_bool (CALGARY_IOMMU || GART_IOMMU || SWIOTLB || AMD_IOMMU)
-- 
1.7.9.5

