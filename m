Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753919Ab0GASg5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 14:36:57 -0400
Received: from kroah.org ([198.145.64.141]:40646 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758016Ab0GASXx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 14:23:53 -0400
X-Mailbox-Line: From gregkh@clark.site Thu Jul  1 10:32:14 2010
Message-Id: <20100701173214.824349240@clark.site>
User-Agent: quilt/0.48-10.1
Date: Thu, 01 Jul 2010 10:32:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Tejun Heo <tj@kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: [patch 095/149] ahci: add pci quirk for JMB362
In-Reply-To: <20100701175144.GA2116@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 4daedcfe8c6851aa01cc1997220f2577f4039c13 upstream.

JMB362 is a new variant of jmicron controller which is similar to
JMB360 but has two SATA ports instead of one.  As there is no PATA
port, single function AHCI mode can be used as in JMB360.  Add pci
quirk for JMB362.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Aries Lee <arieslee@jmicron.com>
Signed-off-by: Jeff Garzik <jgarzik@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/quirks.c    |    5 ++++-
 include/linux/pci_ids.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -1444,7 +1444,8 @@ static void quirk_jmicron_ata(struct pci
 	conf5 &= ~(1 << 24);  /* Clear bit 24 */
 
 	switch (pdev->device) {
-	case PCI_DEVICE_ID_JMICRON_JMB360:
+	case PCI_DEVICE_ID_JMICRON_JMB360: /* SATA single port */
+	case PCI_DEVICE_ID_JMICRON_JMB362: /* SATA dual ports */
 		/* The controller should be in single function ahci mode */
 		conf1 |= 0x0002A100; /* Set 8, 13, 15, 17 */
 		break;
@@ -1480,12 +1481,14 @@ static void quirk_jmicron_ata(struct pci
 }
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB368, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB360, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB361, quirk_jmicron_ata);
+DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB362, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB363, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB365, quirk_jmicron_ata);
 DECLARE_PCI_FIXUP_RESUME_EARLY(PCI_VENDOR_ID_JMICRON, PCI_DEVICE_ID_JMICRON_JMB366, quirk_jmicron_ata);
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2317,6 +2317,7 @@
 #define PCI_VENDOR_ID_JMICRON		0x197B
 #define PCI_DEVICE_ID_JMICRON_JMB360	0x2360
 #define PCI_DEVICE_ID_JMICRON_JMB361	0x2361
+#define PCI_DEVICE_ID_JMICRON_JMB362	0x2362
 #define PCI_DEVICE_ID_JMICRON_JMB363	0x2363
 #define PCI_DEVICE_ID_JMICRON_JMB365	0x2365
 #define PCI_DEVICE_ID_JMICRON_JMB366	0x2366


