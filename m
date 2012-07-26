Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2GZPfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:35:44 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7440 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752210Ab2GZPe7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:34:59 -0400
X-IronPort-AV: E=Sophos;i="4.77,659,1336363200"; 
   d="scan'208";a="203308474"
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
To: <linux-kernel@vger.kernel.org>
CC: <xen-devel@lists.xensource.com>, <Stefano.Stabellini@eu.citrix.com>,
        <konrad.wilk@oracle.com>, <Ian.Campbell@citrix.com>, <tim@xen.org>,
        <linux-arm-kernel@lists.infradead.org>, <linaro-dev@lists.linaro.org>,
        <catalin.marinas@arm.com>, <arnd@arndb.de>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Subject: [PATCH 10/24] xen: do not compile manage, balloon, pci, acpi and cpu_hotplug on ARM
Date: Thu, 26 Jul 2012 16:33:52 +0100
Message-ID: <1343316846-25860-10-git-send-email-stefano.stabellini@eu.citrix.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
---
 drivers/xen/Makefile |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index fc34886..0cfa6c47 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -1,11 +1,15 @@
-obj-y	+= grant-table.o features.o events.o manage.o balloon.o
+ifneq ($(CONFIG_ARM),y)
+obj-y	+= manage.o balloon.o
+obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
+obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
+endif
+obj-y	+= grant-table.o features.o events.o
 obj-y	+= xenbus/
 
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
 obj-$(CONFIG_BLOCK)			+= biomerge.o
-obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
 obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o
@@ -17,7 +21,6 @@ obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
 obj-$(CONFIG_XEN_PVHVM)			+= platform-pci.o
 obj-$(CONFIG_XEN_TMEM)			+= tmem.o
 obj-$(CONFIG_SWIOTLB_XEN)		+= swiotlb-xen.o
-obj-$(CONFIG_XEN_DOM0)			+= pci.o acpi.o
 obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= xen-pciback/
 obj-$(CONFIG_XEN_PRIVCMD)		+= xen-privcmd.o
 obj-$(CONFIG_XEN_ACPI_PROCESSOR)	+= xen-acpi-processor.o
-- 
1.7.2.5

