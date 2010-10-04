Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755485Ab0JDLaZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 07:30:25 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:45605 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755350Ab0JDL3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 07:29:39 -0400
X-IronPort-AV: E=Sophos;i="4.57,278,1283745600"; 
   d="scan'208";a="116520288"
From: stefano.stabellini@eu.citrix.com
To: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH v2 07/10] xen: introduce XEN_DOM0 as a silent option
Date: Mon,  4 Oct 2010 12:28:47 +0100
Message-Id: <1286191730-3188-7-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop>
References: <alpine.DEB.2.00.1009301536300.2864@kaball-desktop>
X-OriginalArrivalTime: 04 Oct 2010 11:29:20.0539 (UTC) FILETIME=[633E66B0:01CB63B7]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

Add XEN_DOM0 to arch/x86/xen/Kconfig as a silent compile time option
that gets enabled when xen and basic x86, acpi and pci support are
selected.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/x86/xen/Kconfig |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
index 68128a1..9bbb06b 100644
--- a/arch/x86/xen/Kconfig
+++ b/arch/x86/xen/Kconfig
@@ -13,6 +13,11 @@ config XEN
 	  kernel to boot in a paravirtualized environment under the
 	  Xen hypervisor.
 
+config XEN_DOM0
+	def_bool y
+	depends on XEN && PCI_XEN && SWIOTLB_XEN
+	depends on X86_LOCAL_APIC && X86_IO_APIC && ACPI && PCI
+
 config XEN_PVHVM
 	def_bool y
 	depends on XEN
-- 
1.5.6.5

