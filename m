Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290Ab2IGQpq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 12:45:46 -0400
Received: from fiji.vyatta.com ([76.74.103.50]:35651 "EHLO fiji.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2IGQpo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 12:45:44 -0400
Message-Id: <20120907163438.085433610@vyatta.com>
User-Agent: quilt/0.60-1
Date: Fri, 07 Sep 2012 09:33:17 -0700
From: Stephen Hemminger <shemminger@vyatta.com>
To: Linas Vepstas <linasvepstas@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] make drivers with pci error handlers const
References: <20120907163313.614852012@vyatta.com>
Content-Disposition: inline; filename=pci-errhandle-other.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Covers the rest of the uses of pci error handler.

Signed-off-by: Stephen Hemminger <shemminger@vyatta.com>


---
Depends on first patch that changes PCI core.

 drivers/block/nvme.c                  |    2 +-
 drivers/infiniband/hw/qib/qib.h       |    2 +-
 drivers/infiniband/hw/qib/qib_pcie.c  |    2 +-
 drivers/media/dvb/ngene/ngene-cards.c |    2 +-
 drivers/tty/serial/8250/8250_pci.c    |    2 +-
 drivers/tty/serial/jsm/jsm_driver.c   |    2 +-
 drivers/xen/xen-pciback/pci_stub.c    |    2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/block/nvme.c	2012-09-07 09:29:55.901548765 -0700
+++ b/drivers/block/nvme.c	2012-09-07 09:31:23.240671617 -0700
@@ -1675,7 +1675,7 @@ static void __devexit nvme_remove(struct
 #define nvme_suspend NULL
 #define nvme_resume NULL
 
-static struct pci_error_handlers nvme_err_handler = {
+static const struct pci_error_handlers nvme_err_handler = {
 	.error_detected	= nvme_error_detected,
 	.mmio_enabled	= nvme_dump_registers,
 	.link_reset	= nvme_link_reset,
--- a/drivers/media/dvb/ngene/ngene-cards.c	2012-09-07 09:29:55.901548765 -0700
+++ b/drivers/media/dvb/ngene/ngene-cards.c	2012-09-07 09:31:23.240671617 -0700
@@ -524,7 +524,7 @@ static void ngene_resume(struct pci_dev
 	printk(KERN_INFO DEVICE_NAME ": resume\n");
 }
 
-static struct pci_error_handlers ngene_errors = {
+static const struct pci_error_handlers ngene_errors = {
 	.error_detected = ngene_error_detected,
 	.link_reset = ngene_link_reset,
 	.slot_reset = ngene_slot_reset,
--- a/drivers/tty/serial/8250/8250_pci.c	2012-09-07 09:29:55.901548765 -0700
+++ b/drivers/tty/serial/8250/8250_pci.c	2012-09-07 09:31:23.240671617 -0700
@@ -4236,7 +4236,7 @@ static void serial8250_io_resume(struct
 		pciserial_resume_ports(priv);
 }
 
-static struct pci_error_handlers serial8250_err_handler = {
+static const struct pci_error_handlers serial8250_err_handler = {
 	.error_detected = serial8250_io_error_detected,
 	.slot_reset = serial8250_io_slot_reset,
 	.resume = serial8250_io_resume,
--- a/drivers/tty/serial/jsm/jsm_driver.c	2012-09-07 09:29:55.901548765 -0700
+++ b/drivers/tty/serial/jsm/jsm_driver.c	2012-09-07 09:31:23.240671617 -0700
@@ -54,7 +54,7 @@ static pci_ers_result_t jsm_io_error_det
 static pci_ers_result_t jsm_io_slot_reset(struct pci_dev *pdev);
 static void jsm_io_resume(struct pci_dev *pdev);
 
-static struct pci_error_handlers jsm_err_handler = {
+static const struct pci_error_handlers jsm_err_handler = {
 	.error_detected = jsm_io_error_detected,
 	.slot_reset = jsm_io_slot_reset,
 	.resume = jsm_io_resume,
--- a/drivers/xen/xen-pciback/pci_stub.c	2012-09-07 09:29:55.901548765 -0700
+++ b/drivers/xen/xen-pciback/pci_stub.c	2012-09-07 09:31:23.240671617 -0700
@@ -871,7 +871,7 @@ end:
 }
 
 /*add xen_pcibk AER handling*/
-static struct pci_error_handlers xen_pcibk_error_handler = {
+static const struct pci_error_handlers xen_pcibk_error_handler = {
 	.error_detected = xen_pcibk_error_detected,
 	.mmio_enabled = xen_pcibk_mmio_enabled,
 	.slot_reset = xen_pcibk_slot_reset,
--- a/drivers/infiniband/hw/qib/qib.h	2012-09-07 09:29:56.901538722 -0700
+++ b/drivers/infiniband/hw/qib/qib.h	2012-09-07 09:31:23.244671576 -0700
@@ -87,7 +87,7 @@ struct qlogic_ib_stats {
 };
 
 extern struct qlogic_ib_stats qib_stats;
-extern struct pci_error_handlers qib_pci_err_handler;
+extern const struct pci_error_handlers qib_pci_err_handler;
 extern struct pci_driver qib_driver;
 
 #define QIB_CHIP_SWVERSION QIB_CHIP_VERS_MAJ
--- a/drivers/infiniband/hw/qib/qib_pcie.c	2012-09-07 09:29:56.901538722 -0700
+++ b/drivers/infiniband/hw/qib/qib_pcie.c	2012-09-07 09:31:23.244671576 -0700
@@ -753,7 +753,7 @@ qib_pci_resume(struct pci_dev *pdev)
 	qib_init(dd, 1); /* same as re-init after reset */
 }
 
-struct pci_error_handlers qib_pci_err_handler = {
+const struct pci_error_handlers qib_pci_err_handler = {
 	.error_detected = qib_pci_error_detected,
 	.mmio_enabled = qib_pci_mmio_enabled,
 	.link_reset = qib_pci_link_reset,


