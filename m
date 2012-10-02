Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755200Ab2JBQqT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 12:46:19 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:6383 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755165Ab2JBQqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 12:46:18 -0400
X-IronPort-AV: E=Sophos;i="4.80,524,1344211200"; 
   d="scan'208";a="14899812"
Date: Tue, 2 Oct 2012 17:45:17 +0100
From: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "sfr@canb.auug.org.au" <sfr@canb.auug.org.au>,
        "JBeulich@suse.com" <JBeulich@suse.com>
Subject: [PATCH v2] xen/Makefile: resolve merge conflict with 9fa5780beea1
Message-ID: <alpine.DEB.2.02.1210021737000.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is actually a merge conflict resolution between Konrad's Xen
tree and the following commit:

commit 9fa5780beea1274d498a224822397100022da7d4
Author: Jan Beulich <JBeulich@suse.com>
Date:   Tue Sep 18 12:23:02 2012 +0100

    USB EHCI/Xen: propagate controller reset information to hypervisor


Compile dbgp.o only if CONFIG_USB_SUPPORT is defined.
After all xen_dbgp_op relies on hcd_to_bus.

This patch should be applied on top of 

http://marc.info/?l=linux-kernel&m=134919011231980&w=2


Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Suggested-by: Jan Beulich <JBeulich@suse.com>
Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --cc drivers/xen/Makefile
index a4a3cab,275abfc..33711ad
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@@ -4,8 -8,11 +8,12 @@@ obj-y	+= xenbus
  nostackp := $(call cc-option, -fno-stack-protector)
  CFLAGS_features.o			:= $(nostackp)
  
+ dom0-$(CONFIG_PCI) += pci.o
+ dom0-$(CONFIG_ACPI) += acpi.o
+ dom0-$(CONFIG_X86) += pcpu.o
++dom0-$(CONFIG_USB_SUPPORT) += dbgp.o
+ obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
  obj-$(CONFIG_BLOCK)			+= biomerge.o
- obj-$(CONFIG_HOTPLUG_CPU)		+= cpu_hotplug.o
  obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
  obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
  obj-$(CONFIG_XEN_SELFBALLOONING)	+= xen-selfballoon.o
