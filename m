Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756574Ab2APSzD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 13:55:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756317Ab2APStR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 13:49:17 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 16 10:45:18 2012
Message-Id: <20120116184518.771490983@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Mon, 16 Jan 2012 10:45:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [36/48] x86/PCI: build amd_bus.o only when CONFIG_AMD_NB=y
In-Reply-To: <20120116184527.GA11972@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjorn Helgaas <bhelgaas@google.com>

commit 5cf9a4e69c1ff0ccdd1d2b7404f95c0531355274 upstream.

We only need amd_bus.o for AMD systems with PCI.  arch/x86/pci/Makefile
already depends on CONFIG_PCI=y, so this patch just adds the dependency
on CONFIG_AMD_NB.

Cc: Yinghai Lu <yinghai@kernel.org>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/pci/Makefile |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/pci/Makefile
+++ b/arch/x86/pci/Makefile
@@ -18,8 +18,9 @@ obj-$(CONFIG_X86_NUMAQ)		+= numaq_32.o
 obj-$(CONFIG_X86_MRST)		+= mrst.o
 
 obj-y				+= common.o early.o
-obj-y				+= amd_bus.o bus_numa.o
+obj-y				+= bus_numa.o
 
+obj-$(CONFIG_AMD_NB)		+= amd_bus.o
 obj-$(CONFIG_PCI_CNB20LE_QUIRK)	+= broadcom_bus.o
 
 ifeq ($(CONFIG_PCI_DEBUG),y)


