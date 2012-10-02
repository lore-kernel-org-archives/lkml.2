Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab2JBPBt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 11:01:49 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:43120 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753530Ab2JBPBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 11:01:46 -0400
X-IronPort-AV: E=Sophos;i="4.80,523,1344211200"; 
   d="scan'208";a="14897169"
Date: Tue, 2 Oct 2012 16:00:43 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: [PATCH] xen/Makefile: fix dom-y build
Message-ID: <alpine.DEB.2.02.1210021558260.29232@kaball.uk.xensource.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to add $(dom0-y) to obj-$(CONFIG_XEN_DOM0) after dom0-y is
defined otherwise we end up adding nothing.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index cd28aae..275abfc 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -8,10 +8,10 @@ obj-y	+= xenbus/
 nostackp := $(call cc-option, -fno-stack-protector)
 CFLAGS_features.o			:= $(nostackp)
 
-obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
 dom0-$(CONFIG_PCI) += pci.o
 dom0-$(CONFIG_ACPI) += acpi.o
 dom0-$(CONFIG_X86) += pcpu.o
+obj-$(CONFIG_XEN_DOM0)			+= $(dom0-y)
 obj-$(CONFIG_BLOCK)			+= biomerge.o
 obj-$(CONFIG_XEN_XENCOMM)		+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)		+= xen-balloon.o
