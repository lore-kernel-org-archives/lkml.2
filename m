Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2FZDc2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 23:32:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45608 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756907Ab2FZDcZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 23:32:25 -0400
From: Myron Stowe <myron.stowe@redhat.com>
Subject: [PATCH 01/16] PCI: Pull 'pcibios_setup' up into PCI's core
To: bhelgaas@google.com
Cc: linux-pci@vger.kernel.org, rth@twiddle.net, ink@jurassic.park.msu.ru,
        mattst88@gmail.com, linux@arm.linux.org.uk, starvik@axis.com,
        jesper.nilsson@axis.com, tony.luck@intel.com, fenghua.yu@intel.com,
        monstr@monstr.eu, ralf@linux-mips.org,
        yasutake.koichi@jp.panasonic.com, jejb@parisc-linux.org, deller@gmx.de,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        chris@zankel.net, linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 21:30:57 -0600
Message-ID: <20120626033057.16434.48634.stgit@amt.stowe>
In-Reply-To: <20120626033045.16434.17412.stgit@amt.stowe>
References: <20120626033045.16434.17412.stgit@amt.stowe>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, all of the architectures implement their own 'pcibios_setup()'
routine.  Most of the implementations do nothing so this patch introduces
a generic (__weak) routine into PCI's core that can be used by all
architectures as a default.  If necessary, it can be over-ridden by
architecture-specific code.

No functional change.

Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
---

 drivers/pci/pci.c   |   12 ++++++++++++
 include/linux/pci.h |    1 +
 2 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/drivers/pci/pci.c b/drivers/pci/pci.c
index 77cb54a..0f6d472 100644
--- a/drivers/pci/pci.c
+++ b/drivers/pci/pci.c
@@ -2671,6 +2671,18 @@ static void __pci_set_master(struct pci_dev *dev, bool enable)
 }
 
 /**
+ * pcibios_setup - process "pci=" kernel boot arguments
+ * @str: string used to pass in "pci=" kernel boot arguments
+ *
+ * Process kernel boot arguments.  This is the default implementation.
+ * Architecture specific implementations can override this as necessary.
+ */
+char * __weak __init pcibios_setup(char *str)
+{
+	return str;
+}
+
+/**
  * pcibios_set_master - enable PCI bus-mastering for device dev
  * @dev: the PCI device to enable
  *
diff --git a/include/linux/pci.h b/include/linux/pci.h
index fefb4e1..fdcff0e 100644
--- a/include/linux/pci.h
+++ b/include/linux/pci.h
@@ -644,6 +644,7 @@ extern int no_pci_devices(void);
 
 void pcibios_fixup_bus(struct pci_bus *);
 int __must_check pcibios_enable_device(struct pci_dev *, int mask);
+/* Architecture specific versions may override this (weak) */
 char *pcibios_setup(char *str);
 
 /* Used only when drivers/pci/setup.c is used */

