Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758680Ab0LMSDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:03:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:47550 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754458Ab0LMSCJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 8/9] xen/pciback: Fix checkpatch warnings and errors.
Date: Mon, 13 Dec 2010 13:01:42 -0500
Message-Id: <1292263303-31680-9-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checkpatch found some extra warnings and errors. This mega
patch fixes all of them in one swoop.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/pci.h                  |    2 +-
 drivers/xen/events.c                            |   38 ++++++++++----------
 drivers/xen/pciback/conf_space.c                |    4 +-
 drivers/xen/pciback/conf_space_capability_msi.c |   11 +++---
 drivers/xen/pciback/conf_space_header.c         |   42 +++++++++++-----------
 drivers/xen/pciback/controller.c                |    2 +-
 drivers/xen/pciback/pci_stub.c                  |    7 ++--
 drivers/xen/pciback/pciback.h                   |   16 ++++----
 drivers/xen/pciback/pciback_ops.c               |    9 ++---
 drivers/xen/pciback/xenbus.c                    |   14 ++++----
 10 files changed, 73 insertions(+), 72 deletions(-)

diff --git a/arch/x86/include/asm/xen/pci.h b/arch/x86/include/asm/xen/pci.h
index 8474b4b..7e61d78 100644
--- a/arch/x86/include/asm/xen/pci.h
+++ b/arch/x86/include/asm/xen/pci.h
@@ -27,7 +27,7 @@ static inline int xen_find_device_domain_owner(struct pci_dev *dev)
 	return -1;
 }
 static inline int xen_register_device_domain_owner(struct pci_dev *dev,
- 						   uint16_t domain)
+						   uint16_t domain)
 {
 	return -1;
 }
diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 95eea13..3929c20 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -698,7 +698,7 @@ int xen_create_msi_irq(struct pci_dev *dev, struct msi_desc *msidesc, int type)
 	domid = rc = xen_find_device_domain_owner(dev);
 	if (rc < 0)
 		domid = DOMID_SELF;
-	
+
 	memset(&map_irq, 0, sizeof(map_irq));
 	map_irq.domid = domid;
 	map_irq.type = MAP_PIRQ_TYPE_MSI;
@@ -850,18 +850,18 @@ static int bind_ipi_to_irq(unsigned int ipi, unsigned int cpu)
 }
 
 static int bind_interdomain_evtchn_to_irq(unsigned int remote_domain,
-                                          unsigned int remote_port)
+					  unsigned int remote_port)
 {
-        struct evtchn_bind_interdomain bind_interdomain;
-        int err;
+	struct evtchn_bind_interdomain bind_interdomain;
+	int err;
 
-        bind_interdomain.remote_dom  = remote_domain;
-        bind_interdomain.remote_port = remote_port;
+	bind_interdomain.remote_dom  = remote_domain;
+	bind_interdomain.remote_port = remote_port;
 
-        err = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
-                                          &bind_interdomain);
+	err = HYPERVISOR_event_channel_op(EVTCHNOP_bind_interdomain,
+					  &bind_interdomain);
 
-        return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
+	return err ? : bind_evtchn_to_irq(bind_interdomain.local_port);
 }
 
 
@@ -966,19 +966,19 @@ int bind_interdomain_evtchn_to_irqhandler(unsigned int remote_domain,
 					  const char *devname,
 					  void *dev_id)
 {
-        int irq, retval;
+	int irq, retval;
 
-        irq = bind_interdomain_evtchn_to_irq(remote_domain, remote_port);
-        if (irq < 0)
-                return irq;
+	irq = bind_interdomain_evtchn_to_irq(remote_domain, remote_port);
+	if (irq < 0)
+		return irq;
 
-        retval = request_irq(irq, handler, irqflags, devname, dev_id);
-        if (retval != 0) {
-                unbind_from_irq(irq);
-                return retval;
-        }
+	retval = request_irq(irq, handler, irqflags, devname, dev_id);
+	if (retval != 0) {
+		unbind_from_irq(irq);
+		return retval;
+	}
 
-        return irq;
+	return irq;
 }
 EXPORT_SYMBOL_GPL(bind_interdomain_evtchn_to_irqhandler);
 
diff --git a/drivers/xen/pciback/conf_space.c b/drivers/xen/pciback/conf_space.c
index 370c18e..eb6bba0 100644
--- a/drivers/xen/pciback/conf_space.c
+++ b/drivers/xen/pciback/conf_space.c
@@ -18,8 +18,8 @@
 static int permissive;
 module_param(permissive, bool, 0644);
 
-#define DEFINE_PCI_CONFIG(op, size, type) 			\
-int pciback_##op##_config_##size 				\
+#define DEFINE_PCI_CONFIG(op, size, type)			\
+int pciback_##op##_config_##size				\
 (struct pci_dev *dev, int offset, type value, void *data)	\
 {								\
 	return pci_##op##_config_##size(dev, offset, value);	\
diff --git a/drivers/xen/pciback/conf_space_capability_msi.c b/drivers/xen/pciback/conf_space_capability_msi.c
index b15131e..3acda69 100644
--- a/drivers/xen/pciback/conf_space_capability_msi.c
+++ b/drivers/xen/pciback/conf_space_capability_msi.c
@@ -16,7 +16,7 @@ int pciback_enable_msi(struct pciback_device *pdev,
 	int otherend = pdev->xdev->otherend_id;
 	int status;
 
- 	if (unlikely(verbose_request))
+	if (unlikely(verbose_request))
 		printk(KERN_DEBUG "pciback: %s: enable MSI\n", pci_name(dev));
 
 	status = pci_enable_msi(dev);
@@ -43,7 +43,7 @@ int pciback_disable_msi(struct pciback_device *pdev,
 {
 	struct pciback_dev_data *dev_data;
 
- 	if (unlikely(verbose_request))
+	if (unlikely(verbose_request))
 		printk(KERN_DEBUG "pciback: %s: disable MSI\n", pci_name(dev));
 	pci_disable_msi(dev);
 
@@ -61,7 +61,7 @@ int pciback_enable_msix(struct pciback_device *pdev,
 	int i, result;
 	struct msix_entry *entries;
 
- 	if (unlikely(verbose_request))
+	if (unlikely(verbose_request))
 		printk(KERN_DEBUG "pciback: %s: enable MSI-X\n", pci_name(dev));
 	if (op->value > SH_INFO_MAX_VEC)
 		return -EINVAL;
@@ -97,8 +97,9 @@ int pciback_disable_msix(struct pciback_device *pdev,
 		struct pci_dev *dev, struct xen_pci_op *op)
 {
 	struct pciback_dev_data *dev_data;
- 	if (unlikely(verbose_request))
-		printk(KERN_DEBUG "pciback: %s: disable MSI-X\n", pci_name(dev));
+	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: disable MSI-X\n",
+			pci_name(dev));
 	pci_disable_msix(dev);
 
 	op->value = xen_gsi_from_irq(dev->irq);
diff --git a/drivers/xen/pciback/conf_space_header.c b/drivers/xen/pciback/conf_space_header.c
index cb450f4..22ad0f5 100644
--- a/drivers/xen/pciback/conf_space_header.c
+++ b/drivers/xen/pciback/conf_space_header.c
@@ -316,27 +316,27 @@ static const struct config_field header_common[] = {
 	{}
 };
 
-#define CFG_FIELD_BAR(reg_offset) 			\
-	{ 						\
-	 .offset     = reg_offset, 			\
-	 .size       = 4, 				\
-	 .init       = bar_init, 			\
-	 .reset      = bar_reset, 			\
-	 .release    = bar_release, 			\
-	 .u.dw.read  = bar_read, 			\
-	 .u.dw.write = bar_write, 			\
-	 }
-
-#define CFG_FIELD_ROM(reg_offset) 			\
-	{ 						\
-	 .offset     = reg_offset, 			\
-	 .size       = 4, 				\
-	 .init       = rom_init, 			\
-	 .reset      = bar_reset, 			\
-	 .release    = bar_release, 			\
-	 .u.dw.read  = bar_read, 			\
-	 .u.dw.write = rom_write, 			\
-	 }
+#define CFG_FIELD_BAR(reg_offset)			\
+	{						\
+	.offset     = reg_offset,			\
+	.size       = 4,				\
+	.init       = bar_init,				\
+	.reset      = bar_reset,			\
+	.release    = bar_release,			\
+	.u.dw.read  = bar_read,				\
+	.u.dw.write = bar_write,			\
+	}
+
+#define CFG_FIELD_ROM(reg_offset)			\
+	{						\
+	.offset     = reg_offset,			\
+	.size       = 4,				\
+	.init       = rom_init,				\
+	.reset      = bar_reset,			\
+	.release    = bar_release,			\
+	.u.dw.read  = bar_read,				\
+	.u.dw.write = rom_write,			\
+	}
 
 static const struct config_field header_0[] = {
 	CFG_FIELD_BAR(PCI_BASE_ADDRESS_0),
diff --git a/drivers/xen/pciback/controller.c b/drivers/xen/pciback/controller.c
index 7f04f11..5a7e4cc 100644
--- a/drivers/xen/pciback/controller.c
+++ b/drivers/xen/pciback/controller.c
@@ -378,7 +378,7 @@ int pciback_publish_pci_roots(struct pciback_device *pdev,
 	}
 
 	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
-			    "%lx", (sizeof(struct acpi_resource) * 2) + 1);
+			    "%lx", (sizeof(struct acpi_resource) *2) + 1);
 
 out:
 	spin_unlock(&dev_data->lock);
diff --git a/drivers/xen/pciback/pci_stub.c b/drivers/xen/pciback/pci_stub.c
index 88c7ca1..c8f6f29 100644
--- a/drivers/xen/pciback/pci_stub.c
+++ b/drivers/xen/pciback/pci_stub.c
@@ -13,7 +13,7 @@
 #include <linux/pci.h>
 #include <linux/wait.h>
 #include <linux/sched.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <xen/events.h>
 #include <asm/xen/pci.h>
 #include <asm/xen/hypervisor.h>
@@ -603,7 +603,7 @@ static pci_ers_result_t common_process(struct pcistub_device *psdev,
 	if (test_bit(_XEN_PCIF_active,
 		(unsigned long *)&psdev->pdev->sh_info->flags)) {
 		dev_dbg(&psdev->dev->dev,
-			"schedule pci_conf service in pciback \n");
+			"schedule pci_conf service in pciback\n");
 		test_and_schedule_op(psdev->pdev);
 	}
 
@@ -1055,7 +1055,8 @@ static ssize_t pcistub_irq_handler_show(struct device_driver *drv, char *buf)
 		if (!dev_data)
 			continue;
 		count +=
-		    scnprintf(buf + count, PAGE_SIZE - count, "%s:%s:%sing:%ld\n",
+		    scnprintf(buf + count, PAGE_SIZE - count,
+			      "%s:%s:%sing:%ld\n",
 			      pci_name(psdev->dev),
 			      dev_data->isr_on ? "on" : "off",
 			      dev_data->ack_intr ? "ack" : "not ack",
diff --git a/drivers/xen/pciback/pciback.h b/drivers/xen/pciback/pciback.h
index fc31052..5c14020 100644
--- a/drivers/xen/pciback/pciback.h
+++ b/drivers/xen/pciback/pciback.h
@@ -12,7 +12,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/workqueue.h>
-#include <asm/atomic.h>
+#include <linux/atomic.h>
 #include <xen/interface/io/pciif.h>
 
 struct pci_dev_entry {
@@ -20,8 +20,8 @@ struct pci_dev_entry {
 	struct pci_dev *dev;
 };
 
-#define _PDEVF_op_active 	(0)
-#define PDEVF_op_active 	(1<<(_PDEVF_op_active))
+#define _PDEVF_op_active	(0)
+#define PDEVF_op_active		(1<<(_PDEVF_op_active))
 #define _PCIB_op_pending	(1)
 #define PCIB_op_pending		(1<<(_PCIB_op_pending))
 
@@ -45,11 +45,11 @@ struct pciback_device {
 
 struct pciback_dev_data {
 	struct list_head config_fields;
-	unsigned int permissive : 1;
-	unsigned int warned_on_write : 1;
-	unsigned int enable_intx : 1;
-	unsigned int isr_on : 1; /* Whether the IRQ handler is installed. */ 
-	unsigned int ack_intr : 1; /* .. and ACK-ing */
+	unsigned int permissive:1;
+	unsigned int warned_on_write:1;
+	unsigned int enable_intx:1;
+	unsigned int isr_on:1; /* Whether the IRQ handler is installed. */
+	unsigned int ack_intr:1; /* .. and ACK-ing */
 	unsigned long handled;
 	unsigned int irq; /* Saved in case device transitions to MSI/MSI-X */
 	char irq_name[0]; /* pciback[000:04:00.0] */
diff --git a/drivers/xen/pciback/pciback_ops.c b/drivers/xen/pciback/pciback_ops.c
index 5543881..9a465e9 100644
--- a/drivers/xen/pciback/pciback_ops.c
+++ b/drivers/xen/pciback/pciback_ops.c
@@ -63,12 +63,11 @@ void pciback_control_isr(struct pci_dev *dev, int reset)
 				dev_data->irq_name, dev);
 		if (rc) {
 			dev_err(&dev->dev, "%s: failed to install fake IRQ " \
-				"handler for IRQ %d! (rc:%d)\n", dev_data->irq_name,
-				dev_data->irq, rc);
+				"handler for IRQ %d! (rc:%d)\n",
+				dev_data->irq_name, dev_data->irq, rc);
 			goto out;
 		}
-	}
-	else {
+	} else {
 		free_irq(dev_data->irq, dev);
 		dev_data->irq = 0;
 	}
@@ -188,7 +187,7 @@ void pciback_do_op(struct work_struct *data)
 			break;
 #endif
 		default:
-			op->err = XEN_PCI_ERR_not_implemented;	
+			op->err = XEN_PCI_ERR_not_implemented;
 			break;
 		}
 	}
diff --git a/drivers/xen/pciback/xenbus.c b/drivers/xen/pciback/xenbus.c
index 993b659..70030c4 100644
--- a/drivers/xen/pciback/xenbus.c
+++ b/drivers/xen/pciback/xenbus.c
@@ -700,12 +700,12 @@ static const struct xenbus_device_id xenpci_ids[] = {
 };
 
 static struct xenbus_driver xenbus_pciback_driver = {
-	.name 			= "pciback",
-	.owner 			= THIS_MODULE,
-	.ids 			= xenpci_ids,
-	.probe 			= pciback_xenbus_probe,
-	.remove 		= pciback_xenbus_remove,
-	.otherend_changed 	= pciback_frontend_changed,
+	.name			= "pciback",
+	.owner			= THIS_MODULE,
+	.ids			= xenpci_ids,
+	.probe			= pciback_xenbus_probe,
+	.remove			= pciback_xenbus_remove,
+	.otherend_changed	= pciback_frontend_changed,
 };
 
 int __init pciback_xenbus_register(void)
@@ -713,7 +713,7 @@ int __init pciback_xenbus_register(void)
 	pciback_wq = create_workqueue("pciback_workqueue");
 	if (!pciback_wq) {
 		printk(KERN_ERR "%s: create"
-			"pciback_workqueue failed\n",__FUNCTION__);
+			"pciback_workqueue failed\n", __func__);
 		return -EFAULT;
 	}
 	return xenbus_register_backend(&xenbus_pciback_driver);
-- 
1.7.1

