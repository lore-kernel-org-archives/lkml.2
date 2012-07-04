Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab2GDLQV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 07:16:21 -0400
Received: from smtp.citrix.com ([66.165.176.89]:41382 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933604Ab2GDLPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 07:15:40 -0400
X-IronPort-AV: E=Sophos;i="4.77,522,1336363200"; 
   d="scan'208";a="30393585"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: xen-devel@lists.xensource.com
CC: linux-kernel@vger.kernel.org, stefano.stabellini@eu.citrix.com,
        Ian.Campbell@citrix.com, david.vrabel@citrix.com
Subject: [PATCH WIP 2/5] xen/arm: set xen_platform_pci_unplug to XEN_UNPLUG_ALL
Date: Wed, 4 Jul 2012 12:15:17 +0100
Message-ID: <1341400520-31770-2-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207041207050.13581@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Set xen_platform_pci_unplug to XEN_UNPLUG_ALL by default to make
blkfront happy. The parameter doesn't make sense on ARM and should be
removed.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 arch/arm/xen/enlighten.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
index 6901e37..a6dc9eb 100644
--- a/arch/arm/xen/enlighten.c
+++ b/arch/arm/xen/enlighten.c
@@ -8,6 +8,7 @@
 #include <xen/grant_table.h>
 #include <xen/hvm.h>
 #include <xen/xenbus.h>
+#include <xen/platform_pci.h>
 
 #include <linux/module.h>
 
@@ -33,7 +34,7 @@ __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 
 /* XXX: to be removed */
-int xen_platform_pci_unplug;
+int xen_platform_pci_unplug = XEN_UNPLUG_ALL;
 EXPORT_SYMBOL_GPL(xen_platform_pci_unplug);
 
 #define FOREIGN_MAP_BUFFER 0x90000000UL
-- 
1.7.2.5

