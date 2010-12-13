Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758656Ab0LMSCz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 13:02:55 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24573 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758482Ab0LMSCu (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 13 Dec 2010 13:02:50 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com
Cc: Jan Beulich <JBeulich@novell.com>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 7/9] xen-pciback: Backend driver for Xen pci-front.
Date: Mon, 13 Dec 2010 13:01:41 -0500
Message-Id: <1292263303-31680-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
References: <1292263303-31680-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch contains the backend driver for Xen PCI-front
all squashed in one easy patch for review. The individual commits
are available at

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/xen-pciback-0.2

The authorship got squished in here, but when I ask Linus
to pull this, it will be the above mentioned git tree which has
all of the patches separated with authorship.

If you think it would be easier to break out certain patches, please let
me know so I can do that.

This particular patch contains the following patches rolled in one:
 Initial copy from linux-2.6.18.hg off pciback driver.
 xen-pciback: Fix include header name change (evtchn.h is now events.h)
 xen-pciback: Use pci_is_enabled() instead of is_enabled.
 xen-pciback: Fix usage of INIT_WORK.
 xen-pciback: Update the calling mechanism for xenbus_[map|unmap]_ring_valloc functions.
 xen-pciback: Add check to load only under priviliged domain.
 xen-pciback: Remove usage of pci_restore_bars() as Linux handles the power-up states correctly now.
 xen-pciback: Enable Xen-PCI-back to be compiled.
 xen-pciback: Return the physical IRQ number instead of the allocated IRQ number to pcifront.
 xen-pciback: Fix checkpatch warnings and errors for pciback/ directory.
 xen-pciback: Fix compile error: 'TASK_NORMAL' undeclared.
 xen-pciback: Remove the vestiges of CONFIG_PCI_GUESTDEV.
 xen-pciback: Remove deprecated routine to find domain owner of PCI device.
 xen-pciback: Fix compiler warning in pci_stub.c.
 xen-pciback: Fix compile warning in vpci.c
 xen: rename pciback module to xen-pciback.
 xen-pciback: Register the owner (domain) of the PCI device.
 xen-pciback: guest SR-IOV support for PV guest
 xen-pciback: Disable MSI/MSI-X when reseting device
 xen-pciback: Allocate IRQ handler for device that is shared with guest.
 xen-pciback: Add SysFS instrumentation for the fake IRQ handler.
 xen-pciback: When device transitions to MSI/MSI-X stop ACK-ing on the legacy interrupt.
 xen-pciback: Enable interrupt handler when device is enabled.
 xen-pciback: Probe the IRQ line to check if it is not shared.
 xen-pciback: Add debug statements for the MSI/MSI-X configuration module.
 xen-pciback: Redo spinlock usage.
 xen-pciback: Remove spinlock for be->watching state.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/xen/Kconfig                             |   65 ++
 drivers/xen/Makefile                            |    1 +
 drivers/xen/pciback/Makefile                    |   17 +
 drivers/xen/pciback/conf_space.c                |  435 +++++++
 drivers/xen/pciback/conf_space.h                |  126 +++
 drivers/xen/pciback/conf_space_capability.c     |   66 ++
 drivers/xen/pciback/conf_space_capability.h     |   26 +
 drivers/xen/pciback/conf_space_capability_msi.c |  110 ++
 drivers/xen/pciback/conf_space_capability_pm.c  |  113 ++
 drivers/xen/pciback/conf_space_capability_vpd.c |   40 +
 drivers/xen/pciback/conf_space_header.c         |  385 +++++++
 drivers/xen/pciback/conf_space_quirks.c         |  140 +++
 drivers/xen/pciback/conf_space_quirks.h         |   35 +
 drivers/xen/pciback/controller.c                |  442 ++++++++
 drivers/xen/pciback/passthrough.c               |  178 +++
 drivers/xen/pciback/pci_stub.c                  | 1370 +++++++++++++++++++++++
 drivers/xen/pciback/pciback.h                   |  142 +++
 drivers/xen/pciback/pciback_ops.c               |  242 ++++
 drivers/xen/pciback/slot.c                      |  191 ++++
 drivers/xen/pciback/vpci.c                      |  244 ++++
 drivers/xen/pciback/xenbus.c                    |  726 ++++++++++++
 21 files changed, 5094 insertions(+), 0 deletions(-)
 create mode 100644 drivers/xen/pciback/Makefile
 create mode 100644 drivers/xen/pciback/conf_space.c
 create mode 100644 drivers/xen/pciback/conf_space.h
 create mode 100644 drivers/xen/pciback/conf_space_capability.c
 create mode 100644 drivers/xen/pciback/conf_space_capability.h
 create mode 100644 drivers/xen/pciback/conf_space_capability_msi.c
 create mode 100644 drivers/xen/pciback/conf_space_capability_pm.c
 create mode 100644 drivers/xen/pciback/conf_space_capability_vpd.c
 create mode 100644 drivers/xen/pciback/conf_space_header.c
 create mode 100644 drivers/xen/pciback/conf_space_quirks.c
 create mode 100644 drivers/xen/pciback/conf_space_quirks.h
 create mode 100644 drivers/xen/pciback/controller.c
 create mode 100644 drivers/xen/pciback/passthrough.c
 create mode 100644 drivers/xen/pciback/pci_stub.c
 create mode 100644 drivers/xen/pciback/pciback.h
 create mode 100644 drivers/xen/pciback/pciback_ops.c
 create mode 100644 drivers/xen/pciback/slot.c
 create mode 100644 drivers/xen/pciback/vpci.c
 create mode 100644 drivers/xen/pciback/xenbus.c

diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
index 6e6180c..d874453 100644
--- a/drivers/xen/Kconfig
+++ b/drivers/xen/Kconfig
@@ -29,6 +29,71 @@ config XEN_DEV_EVTCHN
 	  firing.
 	  If in doubt, say yes.
 
+config XEN_PCIDEV_BACKEND
+	tristate "PCI-device backend driver"
+	depends on PCI
+	depends on XEN_BACKEND
+	help
+	  The PCI device backend driver allows the kernel to export arbitrary
+	  PCI devices to other guests. If you select this to be a module, you
+	  will need to make sure no other driver has bound to the device(s)
+	  you want to make visible to other guests.
+
+choice
+	prompt "PCI Backend Mode"
+	depends on XEN_PCIDEV_BACKEND
+	default XEN_PCIDEV_BACKEND_VPCI if !IA64
+	default XEN_PCIDEV_BACKEND_CONTROLLER if IA64
+
+config XEN_PCIDEV_BACKEND_VPCI
+	bool "Virtual PCI"
+	---help---
+	  This PCI Backend hides the true PCI topology and makes the frontend
+	  think there is a single PCI bus with only the exported devices on it.
+	  For example, a device at 03:05.0 will be re-assigned to 00:00.0. A
+	  second device at 02:1a.1 will be re-assigned to 00:01.1.
+
+config XEN_PCIDEV_BACKEND_PASS
+	bool "Passthrough"
+	---help---
+	  This PCI Backend provides a real view of the PCI topology to the
+	  frontend (for example, a device at 06:01.b will still appear at
+	  06:01.b to the frontend). This is similar to how Xen 2.0.x exposed
+	  PCI devices to its driver domains. This may be required for drivers
+	  which depend on finding their hardward in certain bus/slot
+	  locations.
+
+config XEN_PCIDEV_BACKEND_SLOT
+	bool "Slot"
+	---help---
+	  This PCI Backend hides the true PCI topology and makes the frontend
+	  think there is a single PCI bus with only the exported devices on it.
+	  Contrary to the virtual PCI backend, a function becomes a new slot.
+	  For example, a device at 03:05.2 will be re-assigned to 00:00.0. A
+	  second device at 02:1a.1 will be re-assigned to 00:01.0.
+
+config XEN_PCIDEV_BACKEND_CONTROLLER
+	bool "Controller"
+	depends on IA64
+	---help---
+	  This PCI backend virtualizes the PCI bus topology by providing a
+	  virtual bus per PCI root device.  Devices which are physically under
+	  the same root bus will appear on the same virtual bus.  For systems
+	  with complex I/O addressing, this is the only backend which supports
+	  extended I/O port spaces and MMIO translation offsets.  This backend
+	  also supports slot virtualization.  For example, a device at
+	  0000:01:02.1 will be re-assigned to 0000:00:00.0.  A second device
+	  at 0000:02:05.0 (behind a P2P bridge on bus 0000:01) will be
+	  re-assigned to 0000:00:01.0.  A third device at 0000:16:05.0 (under
+	  a different PCI root bus) will be re-assigned to 0000:01:00.0.
+
+endchoice
+
+config XEN_PCIDEV_BE_DEBUG
+	bool "PCI Backend Debugging"
+	depends on XEN_PCIDEV_BACKEND
+
+
 config XENFS
 	tristate "Xen filesystem"
 	default y
diff --git a/drivers/xen/Makefile b/drivers/xen/Makefile
index eb8a78d..3737dee 100644
--- a/drivers/xen/Makefile
+++ b/drivers/xen/Makefile
@@ -9,6 +9,7 @@ obj-$(CONFIG_HOTPLUG_CPU)	+= cpu_hotplug.o
 obj-$(CONFIG_XEN_XENCOMM)	+= xencomm.o
 obj-$(CONFIG_XEN_BALLOON)	+= balloon.o
 obj-$(CONFIG_XEN_DEV_EVTCHN)	+= evtchn.o
+obj-$(CONFIG_XEN_PCIDEV_BACKEND)	+= pciback/
 obj-$(CONFIG_XENFS)		+= xenfs/
 obj-$(CONFIG_XEN_SYS_HYPERVISOR)	+= sys-hypervisor.o
 obj-$(CONFIG_XEN_PLATFORM_PCI)	+= platform-pci.o
diff --git a/drivers/xen/pciback/Makefile b/drivers/xen/pciback/Makefile
new file mode 100644
index 0000000..38bc123
--- /dev/null
+++ b/drivers/xen/pciback/Makefile
@@ -0,0 +1,17 @@
+obj-$(CONFIG_XEN_PCIDEV_BACKEND) += xen-pciback.o
+
+xen-pciback-y := pci_stub.o pciback_ops.o xenbus.o
+xen-pciback-y += conf_space.o conf_space_header.o \
+		 conf_space_capability.o \
+		 conf_space_capability_vpd.o \
+		 conf_space_capability_pm.o \
+		 conf_space_quirks.o
+xen-pciback-$(CONFIG_PCI_MSI) += conf_space_capability_msi.o
+xen-pciback-$(CONFIG_XEN_PCIDEV_BACKEND_VPCI) += vpci.o
+xen-pciback-$(CONFIG_XEN_PCIDEV_BACKEND_SLOT) += slot.o
+xen-pciback-$(CONFIG_XEN_PCIDEV_BACKEND_PASS) += passthrough.o
+xen-pciback-$(CONFIG_XEN_PCIDEV_BACKEND_CONTROLLER) += controller.o
+
+ifeq ($(CONFIG_XEN_PCIDEV_BE_DEBUG),y)
+EXTRA_CFLAGS += -DDEBUG
+endif
diff --git a/drivers/xen/pciback/conf_space.c b/drivers/xen/pciback/conf_space.c
new file mode 100644
index 0000000..370c18e
--- /dev/null
+++ b/drivers/xen/pciback/conf_space.c
@@ -0,0 +1,435 @@
+/*
+ * PCI Backend - Functions for creating a virtual configuration space for
+ *               exported PCI Devices.
+ *               It's dangerous to allow PCI Driver Domains to change their
+ *               device's resources (memory, i/o ports, interrupts). We need to
+ *               restrict changes to certain PCI Configuration registers:
+ *               BARs, INTERRUPT_PIN, most registers in the header...
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "pciback.h"
+#include "conf_space.h"
+#include "conf_space_quirks.h"
+
+static int permissive;
+module_param(permissive, bool, 0644);
+
+#define DEFINE_PCI_CONFIG(op, size, type) 			\
+int pciback_##op##_config_##size 				\
+(struct pci_dev *dev, int offset, type value, void *data)	\
+{								\
+	return pci_##op##_config_##size(dev, offset, value);	\
+}
+
+DEFINE_PCI_CONFIG(read, byte, u8 *)
+DEFINE_PCI_CONFIG(read, word, u16 *)
+DEFINE_PCI_CONFIG(read, dword, u32 *)
+
+DEFINE_PCI_CONFIG(write, byte, u8)
+DEFINE_PCI_CONFIG(write, word, u16)
+DEFINE_PCI_CONFIG(write, dword, u32)
+
+static int conf_space_read(struct pci_dev *dev,
+			   const struct config_field_entry *entry,
+			   int offset, u32 *value)
+{
+	int ret = 0;
+	const struct config_field *field = entry->field;
+
+	*value = 0;
+
+	switch (field->size) {
+	case 1:
+		if (field->u.b.read)
+			ret = field->u.b.read(dev, offset, (u8 *) value,
+					      entry->data);
+		break;
+	case 2:
+		if (field->u.w.read)
+			ret = field->u.w.read(dev, offset, (u16 *) value,
+					      entry->data);
+		break;
+	case 4:
+		if (field->u.dw.read)
+			ret = field->u.dw.read(dev, offset, value, entry->data);
+		break;
+	}
+	return ret;
+}
+
+static int conf_space_write(struct pci_dev *dev,
+			    const struct config_field_entry *entry,
+			    int offset, u32 value)
+{
+	int ret = 0;
+	const struct config_field *field = entry->field;
+
+	switch (field->size) {
+	case 1:
+		if (field->u.b.write)
+			ret = field->u.b.write(dev, offset, (u8) value,
+					       entry->data);
+		break;
+	case 2:
+		if (field->u.w.write)
+			ret = field->u.w.write(dev, offset, (u16) value,
+					       entry->data);
+		break;
+	case 4:
+		if (field->u.dw.write)
+			ret = field->u.dw.write(dev, offset, value,
+						entry->data);
+		break;
+	}
+	return ret;
+}
+
+static inline u32 get_mask(int size)
+{
+	if (size == 1)
+		return 0xff;
+	else if (size == 2)
+		return 0xffff;
+	else
+		return 0xffffffff;
+}
+
+static inline int valid_request(int offset, int size)
+{
+	/* Validate request (no un-aligned requests) */
+	if ((size == 1 || size == 2 || size == 4) && (offset % size) == 0)
+		return 1;
+	return 0;
+}
+
+static inline u32 merge_value(u32 val, u32 new_val, u32 new_val_mask,
+			      int offset)
+{
+	if (offset >= 0) {
+		new_val_mask <<= (offset * 8);
+		new_val <<= (offset * 8);
+	} else {
+		new_val_mask >>= (offset * -8);
+		new_val >>= (offset * -8);
+	}
+	val = (val & ~new_val_mask) | (new_val & new_val_mask);
+
+	return val;
+}
+
+static int pcibios_err_to_errno(int err)
+{
+	switch (err) {
+	case PCIBIOS_SUCCESSFUL:
+		return XEN_PCI_ERR_success;
+	case PCIBIOS_DEVICE_NOT_FOUND:
+		return XEN_PCI_ERR_dev_not_found;
+	case PCIBIOS_BAD_REGISTER_NUMBER:
+		return XEN_PCI_ERR_invalid_offset;
+	case PCIBIOS_FUNC_NOT_SUPPORTED:
+		return XEN_PCI_ERR_not_implemented;
+	case PCIBIOS_SET_FAILED:
+		return XEN_PCI_ERR_access_denied;
+	}
+	return err;
+}
+
+int pciback_config_read(struct pci_dev *dev, int offset, int size,
+			u32 *ret_val)
+{
+	int err = 0;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	const struct config_field_entry *cfg_entry;
+	const struct config_field *field;
+	int req_start, req_end, field_start, field_end;
+	/* if read fails for any reason, return 0
+	 * (as if device didn't respond) */
+	u32 value = 0, tmp_val;
+
+	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: read %d bytes at 0x%x\n",
+		       pci_name(dev), size, offset);
+
+	if (!valid_request(offset, size)) {
+		err = XEN_PCI_ERR_invalid_offset;
+		goto out;
+	}
+
+	/* Get the real value first, then modify as appropriate */
+	switch (size) {
+	case 1:
+		err = pci_read_config_byte(dev, offset, (u8 *) &value);
+		break;
+	case 2:
+		err = pci_read_config_word(dev, offset, (u16 *) &value);
+		break;
+	case 4:
+		err = pci_read_config_dword(dev, offset, &value);
+		break;
+	}
+
+	list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
+		field = cfg_entry->field;
+
+		req_start = offset;
+		req_end = offset + size;
+		field_start = OFFSET(cfg_entry);
+		field_end = OFFSET(cfg_entry) + field->size;
+
+		if ((req_start >= field_start && req_start < field_end)
+		    || (req_end > field_start && req_end <= field_end)) {
+			err = conf_space_read(dev, cfg_entry, field_start,
+					      &tmp_val);
+			if (err)
+				goto out;
+
+			value = merge_value(value, tmp_val,
+					    get_mask(field->size),
+					    field_start - req_start);
+		}
+	}
+
+out:
+	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: read %d bytes at 0x%x = %x\n",
+		       pci_name(dev), size, offset, value);
+
+	*ret_val = value;
+	return pcibios_err_to_errno(err);
+}
+
+int pciback_config_write(struct pci_dev *dev, int offset, int size, u32 value)
+{
+	int err = 0, handled = 0;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	const struct config_field_entry *cfg_entry;
+	const struct config_field *field;
+	u32 tmp_val;
+	int req_start, req_end, field_start, field_end;
+
+	if (unlikely(verbose_request))
+		printk(KERN_DEBUG
+		       "pciback: %s: write request %d bytes at 0x%x = %x\n",
+		       pci_name(dev), size, offset, value);
+
+	if (!valid_request(offset, size))
+		return XEN_PCI_ERR_invalid_offset;
+
+	list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
+		field = cfg_entry->field;
+
+		req_start = offset;
+		req_end = offset + size;
+		field_start = OFFSET(cfg_entry);
+		field_end = OFFSET(cfg_entry) + field->size;
+
+		if ((req_start >= field_start && req_start < field_end)
+		    || (req_end > field_start && req_end <= field_end)) {
+			tmp_val = 0;
+
+			err = pciback_config_read(dev, field_start,
+						  field->size, &tmp_val);
+			if (err)
+				break;
+
+			tmp_val = merge_value(tmp_val, value, get_mask(size),
+					      req_start - field_start);
+
+			err = conf_space_write(dev, cfg_entry, field_start,
+					       tmp_val);
+
+			/* handled is set true here, but not every byte
+			 * may have been written! Properly detecting if
+			 * every byte is handled is unnecessary as the
+			 * flag is used to detect devices that need
+			 * special helpers to work correctly.
+			 */
+			handled = 1;
+		}
+	}
+
+	if (!handled && !err) {
+		/* By default, anything not specificially handled above is
+		 * read-only. The permissive flag changes this behavior so
+		 * that anything not specifically handled above is writable.
+		 * This means that some fields may still be read-only because
+		 * they have entries in the config_field list that intercept
+		 * the write and do nothing. */
+		if (dev_data->permissive || permissive) {
+			switch (size) {
+			case 1:
+				err = pci_write_config_byte(dev, offset,
+							    (u8) value);
+				break;
+			case 2:
+				err = pci_write_config_word(dev, offset,
+							    (u16) value);
+				break;
+			case 4:
+				err = pci_write_config_dword(dev, offset,
+							     (u32) value);
+				break;
+			}
+		} else if (!dev_data->warned_on_write) {
+			dev_data->warned_on_write = 1;
+			dev_warn(&dev->dev, "Driver tried to write to a "
+				 "read-only configuration space field at offset"
+				 " 0x%x, size %d. This may be harmless, but if "
+				 "you have problems with your device:\n"
+				 "1) see permissive attribute in sysfs\n"
+				 "2) report problems to the xen-devel "
+				 "mailing list along with details of your "
+				 "device obtained from lspci.\n", offset, size);
+		}
+	}
+
+	return pcibios_err_to_errno(err);
+}
+
+void pciback_config_free_dyn_fields(struct pci_dev *dev)
+{
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	struct config_field_entry *cfg_entry, *t;
+	const struct config_field *field;
+
+	dev_dbg(&dev->dev, "free-ing dynamically allocated virtual "
+			   "configuration space fields\n");
+	if (!dev_data)
+		return;
+
+	list_for_each_entry_safe(cfg_entry, t, &dev_data->config_fields, list) {
+		field = cfg_entry->field;
+
+		if (field->clean) {
+			field->clean((struct config_field *)field);
+
+			kfree(cfg_entry->data);
+
+			list_del(&cfg_entry->list);
+			kfree(cfg_entry);
+		}
+
+	}
+}
+
+void pciback_config_reset_dev(struct pci_dev *dev)
+{
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	const struct config_field_entry *cfg_entry;
+	const struct config_field *field;
+
+	dev_dbg(&dev->dev, "resetting virtual configuration space\n");
+	if (!dev_data)
+		return;
+
+	list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
+		field = cfg_entry->field;
+
+		if (field->reset)
+			field->reset(dev, OFFSET(cfg_entry), cfg_entry->data);
+	}
+}
+
+void pciback_config_free_dev(struct pci_dev *dev)
+{
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	struct config_field_entry *cfg_entry, *t;
+	const struct config_field *field;
+
+	dev_dbg(&dev->dev, "free-ing virtual configuration space fields\n");
+	if (!dev_data)
+		return;
+
+	list_for_each_entry_safe(cfg_entry, t, &dev_data->config_fields, list) {
+		list_del(&cfg_entry->list);
+
+		field = cfg_entry->field;
+
+		if (field->release)
+			field->release(dev, OFFSET(cfg_entry), cfg_entry->data);
+
+		kfree(cfg_entry);
+	}
+}
+
+int pciback_config_add_field_offset(struct pci_dev *dev,
+				    const struct config_field *field,
+				    unsigned int base_offset)
+{
+	int err = 0;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	struct config_field_entry *cfg_entry;
+	void *tmp;
+
+	cfg_entry = kmalloc(sizeof(*cfg_entry), GFP_KERNEL);
+	if (!cfg_entry) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	cfg_entry->data = NULL;
+	cfg_entry->field = field;
+	cfg_entry->base_offset = base_offset;
+
+	/* silently ignore duplicate fields */
+	err = pciback_field_is_dup(dev, OFFSET(cfg_entry));
+	if (err)
+		goto out;
+
+	if (field->init) {
+		tmp = field->init(dev, OFFSET(cfg_entry));
+
+		if (IS_ERR(tmp)) {
+			err = PTR_ERR(tmp);
+			goto out;
+		}
+
+		cfg_entry->data = tmp;
+	}
+
+	dev_dbg(&dev->dev, "added config field at offset 0x%02x\n",
+		OFFSET(cfg_entry));
+	list_add_tail(&cfg_entry->list, &dev_data->config_fields);
+
+out:
+	if (err)
+		kfree(cfg_entry);
+
+	return err;
+}
+
+/* This sets up the device's virtual configuration space to keep track of
+ * certain registers (like the base address registers (BARs) so that we can
+ * keep the client from manipulating them directly.
+ */
+int pciback_config_init_dev(struct pci_dev *dev)
+{
+	int err = 0;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+
+	dev_dbg(&dev->dev, "initializing virtual configuration space\n");
+
+	INIT_LIST_HEAD(&dev_data->config_fields);
+
+	err = pciback_config_header_add_fields(dev);
+	if (err)
+		goto out;
+
+	err = pciback_config_capability_add_fields(dev);
+	if (err)
+		goto out;
+
+	err = pciback_config_quirks_init(dev);
+
+out:
+	return err;
+}
+
+int pciback_config_init(void)
+{
+	return pciback_config_capability_init();
+}
diff --git a/drivers/xen/pciback/conf_space.h b/drivers/xen/pciback/conf_space.h
new file mode 100644
index 0000000..50ebef2
--- /dev/null
+++ b/drivers/xen/pciback/conf_space.h
@@ -0,0 +1,126 @@
+/*
+ * PCI Backend - Common data structures for overriding the configuration space
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#ifndef __XEN_PCIBACK_CONF_SPACE_H__
+#define __XEN_PCIBACK_CONF_SPACE_H__
+
+#include <linux/list.h>
+#include <linux/err.h>
+
+/* conf_field_init can return an errno in a ptr with ERR_PTR() */
+typedef void *(*conf_field_init) (struct pci_dev *dev, int offset);
+typedef void (*conf_field_reset) (struct pci_dev *dev, int offset, void *data);
+typedef void (*conf_field_free) (struct pci_dev *dev, int offset, void *data);
+
+typedef int (*conf_dword_write) (struct pci_dev *dev, int offset, u32 value,
+				 void *data);
+typedef int (*conf_word_write) (struct pci_dev *dev, int offset, u16 value,
+				void *data);
+typedef int (*conf_byte_write) (struct pci_dev *dev, int offset, u8 value,
+				void *data);
+typedef int (*conf_dword_read) (struct pci_dev *dev, int offset, u32 *value,
+				void *data);
+typedef int (*conf_word_read) (struct pci_dev *dev, int offset, u16 *value,
+			       void *data);
+typedef int (*conf_byte_read) (struct pci_dev *dev, int offset, u8 *value,
+			       void *data);
+
+/* These are the fields within the configuration space which we
+ * are interested in intercepting reads/writes to and changing their
+ * values.
+ */
+struct config_field {
+	unsigned int offset;
+	unsigned int size;
+	unsigned int mask;
+	conf_field_init init;
+	conf_field_reset reset;
+	conf_field_free release;
+	void (*clean) (struct config_field *field);
+	union {
+		struct {
+			conf_dword_write write;
+			conf_dword_read read;
+		} dw;
+		struct {
+			conf_word_write write;
+			conf_word_read read;
+		} w;
+		struct {
+			conf_byte_write write;
+			conf_byte_read read;
+		} b;
+	} u;
+	struct list_head list;
+};
+
+struct config_field_entry {
+	struct list_head list;
+	const struct config_field *field;
+	unsigned int base_offset;
+	void *data;
+};
+
+#define OFFSET(cfg_entry) ((cfg_entry)->base_offset+(cfg_entry)->field->offset)
+
+/* Add fields to a device - the add_fields macro expects to get a pointer to
+ * the first entry in an array (of which the ending is marked by size==0)
+ */
+int pciback_config_add_field_offset(struct pci_dev *dev,
+				    const struct config_field *field,
+				    unsigned int offset);
+
+static inline int pciback_config_add_field(struct pci_dev *dev,
+					   const struct config_field *field)
+{
+	return pciback_config_add_field_offset(dev, field, 0);
+}
+
+static inline int pciback_config_add_fields(struct pci_dev *dev,
+					    const struct config_field *field)
+{
+	int i, err = 0;
+	for (i = 0; field[i].size != 0; i++) {
+		err = pciback_config_add_field(dev, &field[i]);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+static inline int pciback_config_add_fields_offset(struct pci_dev *dev,
+					const struct config_field *field,
+					unsigned int offset)
+{
+	int i, err = 0;
+	for (i = 0; field[i].size != 0; i++) {
+		err = pciback_config_add_field_offset(dev, &field[i], offset);
+		if (err)
+			break;
+	}
+	return err;
+}
+
+/* Read/Write the real configuration space */
+int pciback_read_config_byte(struct pci_dev *dev, int offset, u8 *value,
+			     void *data);
+int pciback_read_config_word(struct pci_dev *dev, int offset, u16 *value,
+			     void *data);
+int pciback_read_config_dword(struct pci_dev *dev, int offset, u32 *value,
+			      void *data);
+int pciback_write_config_byte(struct pci_dev *dev, int offset, u8 value,
+			      void *data);
+int pciback_write_config_word(struct pci_dev *dev, int offset, u16 value,
+			      void *data);
+int pciback_write_config_dword(struct pci_dev *dev, int offset, u32 value,
+			       void *data);
+
+int pciback_config_capability_init(void);
+
+int pciback_config_header_add_fields(struct pci_dev *dev);
+int pciback_config_capability_add_fields(struct pci_dev *dev);
+
+#endif				/* __XEN_PCIBACK_CONF_SPACE_H__ */
diff --git a/drivers/xen/pciback/conf_space_capability.c b/drivers/xen/pciback/conf_space_capability.c
new file mode 100644
index 0000000..0ea84d6
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_capability.c
@@ -0,0 +1,66 @@
+/*
+ * PCI Backend - Handles the virtual fields found on the capability lists
+ *               in the configuration space.
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "pciback.h"
+#include "conf_space.h"
+#include "conf_space_capability.h"
+
+static LIST_HEAD(capabilities);
+
+static const struct config_field caplist_header[] = {
+	{
+	 .offset    = PCI_CAP_LIST_ID,
+	 .size      = 2, /* encompass PCI_CAP_LIST_ID & PCI_CAP_LIST_NEXT */
+	 .u.w.read  = pciback_read_config_word,
+	 .u.w.write = NULL,
+	},
+	{}
+};
+
+static inline void register_capability(struct pciback_config_capability *cap)
+{
+	list_add_tail(&cap->cap_list, &capabilities);
+}
+
+int pciback_config_capability_add_fields(struct pci_dev *dev)
+{
+	int err = 0;
+	struct pciback_config_capability *cap;
+	int cap_offset;
+
+	list_for_each_entry(cap, &capabilities, cap_list) {
+		cap_offset = pci_find_capability(dev, cap->capability);
+		if (cap_offset) {
+			dev_dbg(&dev->dev, "Found capability 0x%x at 0x%x\n",
+				cap->capability, cap_offset);
+
+			err = pciback_config_add_fields_offset(dev,
+							       caplist_header,
+							       cap_offset);
+			if (err)
+				goto out;
+			err = pciback_config_add_fields_offset(dev,
+							       cap->fields,
+							       cap_offset);
+			if (err)
+				goto out;
+		}
+	}
+
+out:
+	return err;
+}
+
+int pciback_config_capability_init(void)
+{
+	register_capability(&pciback_config_capability_vpd);
+	register_capability(&pciback_config_capability_pm);
+
+	return 0;
+}
diff --git a/drivers/xen/pciback/conf_space_capability.h b/drivers/xen/pciback/conf_space_capability.h
new file mode 100644
index 0000000..8da3ac4
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_capability.h
@@ -0,0 +1,26 @@
+/*
+ * PCI Backend - Data structures for special overlays for structures on
+ *               the capability list.
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#ifndef __PCIBACK_CONFIG_CAPABILITY_H__
+#define __PCIBACK_CONFIG_CAPABILITY_H__
+
+#include <linux/pci.h>
+#include <linux/list.h>
+
+struct pciback_config_capability {
+	struct list_head cap_list;
+
+	int capability;
+
+	/* If the device has the capability found above, add these fields */
+	const struct config_field *fields;
+};
+
+extern struct pciback_config_capability pciback_config_capability_vpd;
+extern struct pciback_config_capability pciback_config_capability_pm;
+
+#endif
diff --git a/drivers/xen/pciback/conf_space_capability_msi.c b/drivers/xen/pciback/conf_space_capability_msi.c
new file mode 100644
index 0000000..b15131e
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_capability_msi.c
@@ -0,0 +1,110 @@
+/*
+ * PCI Backend -- Configuration overlay for MSI capability
+ */
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include "conf_space.h"
+#include "conf_space_capability.h"
+#include <xen/interface/io/pciif.h>
+#include <xen/events.h>
+#include "pciback.h"
+
+int pciback_enable_msi(struct pciback_device *pdev,
+		struct pci_dev *dev, struct xen_pci_op *op)
+{
+	struct pciback_dev_data *dev_data;
+	int otherend = pdev->xdev->otherend_id;
+	int status;
+
+ 	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: enable MSI\n", pci_name(dev));
+
+	status = pci_enable_msi(dev);
+
+	if (status) {
+		printk(KERN_ERR "error enable msi for guest %x status %x\n",
+			otherend, status);
+		op->value = 0;
+		return XEN_PCI_ERR_op_failed;
+	}
+
+	/* The value the guest needs is actually the IDT vector, not the
+	 * the local domain's IRQ number. */
+	op->value = xen_gsi_from_irq(dev->irq);
+	dev_data = pci_get_drvdata(dev);
+	if (dev_data)
+		dev_data->ack_intr = 0;
+
+	return 0;
+}
+
+int pciback_disable_msi(struct pciback_device *pdev,
+		struct pci_dev *dev, struct xen_pci_op *op)
+{
+	struct pciback_dev_data *dev_data;
+
+ 	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: disable MSI\n", pci_name(dev));
+	pci_disable_msi(dev);
+
+	op->value = xen_gsi_from_irq(dev->irq);
+	dev_data = pci_get_drvdata(dev);
+	if (dev_data)
+		dev_data->ack_intr = 1;
+	return 0;
+}
+
+int pciback_enable_msix(struct pciback_device *pdev,
+		struct pci_dev *dev, struct xen_pci_op *op)
+{
+	struct pciback_dev_data *dev_data;
+	int i, result;
+	struct msix_entry *entries;
+
+ 	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: enable MSI-X\n", pci_name(dev));
+	if (op->value > SH_INFO_MAX_VEC)
+		return -EINVAL;
+
+	entries = kmalloc(op->value * sizeof(*entries), GFP_KERNEL);
+	if (entries == NULL)
+		return -ENOMEM;
+
+	for (i = 0; i < op->value; i++) {
+		entries[i].entry = op->msix_entries[i].entry;
+		entries[i].vector = op->msix_entries[i].vector;
+	}
+
+	result = pci_enable_msix(dev, entries, op->value);
+
+	for (i = 0; i < op->value; i++) {
+		op->msix_entries[i].entry = entries[i].entry;
+		op->msix_entries[i].vector =
+					xen_gsi_from_irq(entries[i].vector);
+	}
+
+	kfree(entries);
+
+	op->value = result;
+	dev_data = pci_get_drvdata(dev);
+	if (dev_data)
+		dev_data->ack_intr = 0;
+
+	return result;
+}
+
+int pciback_disable_msix(struct pciback_device *pdev,
+		struct pci_dev *dev, struct xen_pci_op *op)
+{
+	struct pciback_dev_data *dev_data;
+ 	if (unlikely(verbose_request))
+		printk(KERN_DEBUG "pciback: %s: disable MSI-X\n", pci_name(dev));
+	pci_disable_msix(dev);
+
+	op->value = xen_gsi_from_irq(dev->irq);
+	dev_data = pci_get_drvdata(dev);
+	if (dev_data)
+		dev_data->ack_intr = 1;
+	return 0;
+}
+
diff --git a/drivers/xen/pciback/conf_space_capability_pm.c b/drivers/xen/pciback/conf_space_capability_pm.c
new file mode 100644
index 0000000..0442616
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_capability_pm.c
@@ -0,0 +1,113 @@
+/*
+ * PCI Backend - Configuration space overlay for power management
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/pci.h>
+#include "conf_space.h"
+#include "conf_space_capability.h"
+
+static int pm_caps_read(struct pci_dev *dev, int offset, u16 *value,
+			void *data)
+{
+	int err;
+	u16 real_value;
+
+	err = pci_read_config_word(dev, offset, &real_value);
+	if (err)
+		goto out;
+
+	*value = real_value & ~PCI_PM_CAP_PME_MASK;
+
+out:
+	return err;
+}
+
+/* PM_OK_BITS specifies the bits that the driver domain is allowed to change.
+ * Can't allow driver domain to enable PMEs - they're shared */
+#define PM_OK_BITS (PCI_PM_CTRL_PME_STATUS|PCI_PM_CTRL_DATA_SEL_MASK)
+
+static int pm_ctrl_write(struct pci_dev *dev, int offset, u16 new_value,
+			 void *data)
+{
+	int err;
+	u16 old_value;
+	pci_power_t new_state, old_state;
+
+	err = pci_read_config_word(dev, offset, &old_value);
+	if (err)
+		goto out;
+
+	old_state = (pci_power_t)(old_value & PCI_PM_CTRL_STATE_MASK);
+	new_state = (pci_power_t)(new_value & PCI_PM_CTRL_STATE_MASK);
+
+	new_value &= PM_OK_BITS;
+	if ((old_value & PM_OK_BITS) != new_value) {
+		new_value = (old_value & ~PM_OK_BITS) | new_value;
+		err = pci_write_config_word(dev, offset, new_value);
+		if (err)
+			goto out;
+	}
+
+	/* Let pci core handle the power management change */
+	dev_dbg(&dev->dev, "set power state to %x\n", new_state);
+	err = pci_set_power_state(dev, new_state);
+	if (err) {
+		err = PCIBIOS_SET_FAILED;
+		goto out;
+	}
+
+ out:
+	return err;
+}
+
+/* Ensure PMEs are disabled */
+static void *pm_ctrl_init(struct pci_dev *dev, int offset)
+{
+	int err;
+	u16 value;
+
+	err = pci_read_config_word(dev, offset, &value);
+	if (err)
+		goto out;
+
+	if (value & PCI_PM_CTRL_PME_ENABLE) {
+		value &= ~PCI_PM_CTRL_PME_ENABLE;
+		err = pci_write_config_word(dev, offset, value);
+	}
+
+out:
+	return ERR_PTR(err);
+}
+
+static const struct config_field caplist_pm[] = {
+	{
+		.offset     = PCI_PM_PMC,
+		.size       = 2,
+		.u.w.read   = pm_caps_read,
+	},
+	{
+		.offset     = PCI_PM_CTRL,
+		.size       = 2,
+		.init       = pm_ctrl_init,
+		.u.w.read   = pciback_read_config_word,
+		.u.w.write  = pm_ctrl_write,
+	},
+	{
+		.offset     = PCI_PM_PPB_EXTENSIONS,
+		.size       = 1,
+		.u.b.read   = pciback_read_config_byte,
+	},
+	{
+		.offset     = PCI_PM_DATA_REGISTER,
+		.size       = 1,
+		.u.b.read   = pciback_read_config_byte,
+	},
+	{}
+};
+
+struct pciback_config_capability pciback_config_capability_pm = {
+	.capability = PCI_CAP_ID_PM,
+	.fields = caplist_pm,
+};
diff --git a/drivers/xen/pciback/conf_space_capability_vpd.c b/drivers/xen/pciback/conf_space_capability_vpd.c
new file mode 100644
index 0000000..e7b4d66
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_capability_vpd.c
@@ -0,0 +1,40 @@
+/*
+ * PCI Backend - Configuration space overlay for Vital Product Data
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/pci.h>
+#include "conf_space.h"
+#include "conf_space_capability.h"
+
+static int vpd_address_write(struct pci_dev *dev, int offset, u16 value,
+			     void *data)
+{
+	/* Disallow writes to the vital product data */
+	if (value & PCI_VPD_ADDR_F)
+		return PCIBIOS_SET_FAILED;
+	else
+		return pci_write_config_word(dev, offset, value);
+}
+
+static const struct config_field caplist_vpd[] = {
+	{
+	 .offset    = PCI_VPD_ADDR,
+	 .size      = 2,
+	 .u.w.read  = pciback_read_config_word,
+	 .u.w.write = vpd_address_write,
+	 },
+	{
+	 .offset     = PCI_VPD_DATA,
+	 .size       = 4,
+	 .u.dw.read  = pciback_read_config_dword,
+	 .u.dw.write = NULL,
+	 },
+	{}
+};
+
+struct pciback_config_capability pciback_config_capability_vpd = {
+	.capability = PCI_CAP_ID_VPD,
+	.fields = caplist_vpd,
+};
diff --git a/drivers/xen/pciback/conf_space_header.c b/drivers/xen/pciback/conf_space_header.c
new file mode 100644
index 0000000..cb450f4
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_header.c
@@ -0,0 +1,385 @@
+/*
+ * PCI Backend - Handles the virtual fields in the configuration space headers.
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "pciback.h"
+#include "conf_space.h"
+
+struct pci_bar_info {
+	u32 val;
+	u32 len_val;
+	int which;
+};
+
+#define is_enable_cmd(value) ((value)&(PCI_COMMAND_MEMORY|PCI_COMMAND_IO))
+#define is_master_cmd(value) ((value)&PCI_COMMAND_MASTER)
+
+static int command_read(struct pci_dev *dev, int offset, u16 *value, void *data)
+{
+	int i;
+	int ret;
+
+	ret = pciback_read_config_word(dev, offset, value, data);
+	if (!atomic_read(&dev->enable_cnt))
+		return ret;
+
+	for (i = 0; i < PCI_ROM_RESOURCE; i++) {
+		if (dev->resource[i].flags & IORESOURCE_IO)
+			*value |= PCI_COMMAND_IO;
+		if (dev->resource[i].flags & IORESOURCE_MEM)
+			*value |= PCI_COMMAND_MEMORY;
+	}
+
+	return ret;
+}
+
+static int command_write(struct pci_dev *dev, int offset, u16 value, void *data)
+{
+	struct pciback_dev_data *dev_data;
+	int err;
+
+	dev_data = pci_get_drvdata(dev);
+	if (!pci_is_enabled(dev) && is_enable_cmd(value)) {
+		if (unlikely(verbose_request))
+			printk(KERN_DEBUG "pciback: %s: enable\n",
+			       pci_name(dev));
+		err = pci_enable_device(dev);
+		if (err)
+			return err;
+		if (dev_data)
+			dev_data->enable_intx = 1;
+	} else if (pci_is_enabled(dev) && !is_enable_cmd(value)) {
+		if (unlikely(verbose_request))
+			printk(KERN_DEBUG "pciback: %s: disable\n",
+			       pci_name(dev));
+		pci_disable_device(dev);
+		if (dev_data)
+			dev_data->enable_intx = 0;
+	}
+
+	if (!dev->is_busmaster && is_master_cmd(value)) {
+		if (unlikely(verbose_request))
+			printk(KERN_DEBUG "pciback: %s: set bus master\n",
+			       pci_name(dev));
+		pci_set_master(dev);
+	}
+
+	if (value & PCI_COMMAND_INVALIDATE) {
+		if (unlikely(verbose_request))
+			printk(KERN_DEBUG
+			       "pciback: %s: enable memory-write-invalidate\n",
+			       pci_name(dev));
+		err = pci_set_mwi(dev);
+		if (err) {
+			printk(KERN_WARNING
+			       "pciback: %s: cannot enable "
+			       "memory-write-invalidate (%d)\n",
+			       pci_name(dev), err);
+			value &= ~PCI_COMMAND_INVALIDATE;
+		}
+	}
+
+	return pci_write_config_word(dev, offset, value);
+}
+
+static int rom_write(struct pci_dev *dev, int offset, u32 value, void *data)
+{
+	struct pci_bar_info *bar = data;
+
+	if (unlikely(!bar)) {
+		printk(KERN_WARNING "pciback: driver data not found for %s\n",
+		       pci_name(dev));
+		return XEN_PCI_ERR_op_failed;
+	}
+
+	/* A write to obtain the length must happen as a 32-bit write.
+	 * This does not (yet) support writing individual bytes
+	 */
+	if (value == ~PCI_ROM_ADDRESS_ENABLE)
+		bar->which = 1;
+	else {
+		u32 tmpval;
+		pci_read_config_dword(dev, offset, &tmpval);
+		if (tmpval != bar->val && value == bar->val) {
+			/* Allow restoration of bar value. */
+			pci_write_config_dword(dev, offset, bar->val);
+		}
+		bar->which = 0;
+	}
+
+	/* Do we need to support enabling/disabling the rom address here? */
+
+	return 0;
+}
+
+/* For the BARs, only allow writes which write ~0 or
+ * the correct resource information
+ * (Needed for when the driver probes the resource usage)
+ */
+static int bar_write(struct pci_dev *dev, int offset, u32 value, void *data)
+{
+	struct pci_bar_info *bar = data;
+
+	if (unlikely(!bar)) {
+		printk(KERN_WARNING "pciback: driver data not found for %s\n",
+		       pci_name(dev));
+		return XEN_PCI_ERR_op_failed;
+	}
+
+	/* A write to obtain the length must happen as a 32-bit write.
+	 * This does not (yet) support writing individual bytes
+	 */
+	if (value == ~0)
+		bar->which = 1;
+	else {
+		u32 tmpval;
+		pci_read_config_dword(dev, offset, &tmpval);
+		if (tmpval != bar->val && value == bar->val) {
+			/* Allow restoration of bar value. */
+			pci_write_config_dword(dev, offset, bar->val);
+		}
+		bar->which = 0;
+	}
+
+	return 0;
+}
+
+static int bar_read(struct pci_dev *dev, int offset, u32 * value, void *data)
+{
+	struct pci_bar_info *bar = data;
+
+	if (unlikely(!bar)) {
+		printk(KERN_WARNING "pciback: driver data not found for %s\n",
+		       pci_name(dev));
+		return XEN_PCI_ERR_op_failed;
+	}
+
+	*value = bar->which ? bar->len_val : bar->val;
+
+	return 0;
+}
+
+static inline void read_dev_bar(struct pci_dev *dev,
+				struct pci_bar_info *bar_info, int offset,
+				u32 len_mask)
+{
+	int	pos;
+	struct resource	*res = dev->resource;
+
+	if (offset == PCI_ROM_ADDRESS || offset == PCI_ROM_ADDRESS1)
+		pos = PCI_ROM_RESOURCE;
+	else {
+		pos = (offset - PCI_BASE_ADDRESS_0) / 4;
+		if (pos && ((res[pos - 1].flags & (PCI_BASE_ADDRESS_SPACE |
+				PCI_BASE_ADDRESS_MEM_TYPE_MASK)) ==
+			   (PCI_BASE_ADDRESS_SPACE_MEMORY |
+				PCI_BASE_ADDRESS_MEM_TYPE_64))) {
+			bar_info->val = res[pos - 1].start >> 32;
+			bar_info->len_val = res[pos - 1].end >> 32;
+			return;
+		}
+	}
+
+	bar_info->val = res[pos].start |
+			(res[pos].flags & PCI_REGION_FLAG_MASK);
+	bar_info->len_val = res[pos].end - res[pos].start + 1;
+}
+
+static void *bar_init(struct pci_dev *dev, int offset)
+{
+	struct pci_bar_info *bar = kmalloc(sizeof(*bar), GFP_KERNEL);
+
+	if (!bar)
+		return ERR_PTR(-ENOMEM);
+
+	read_dev_bar(dev, bar, offset, ~0);
+	bar->which = 0;
+
+	return bar;
+}
+
+static void *rom_init(struct pci_dev *dev, int offset)
+{
+	struct pci_bar_info *bar = kmalloc(sizeof(*bar), GFP_KERNEL);
+
+	if (!bar)
+		return ERR_PTR(-ENOMEM);
+
+	read_dev_bar(dev, bar, offset, ~PCI_ROM_ADDRESS_ENABLE);
+	bar->which = 0;
+
+	return bar;
+}
+
+static void bar_reset(struct pci_dev *dev, int offset, void *data)
+{
+	struct pci_bar_info *bar = data;
+
+	bar->which = 0;
+}
+
+static void bar_release(struct pci_dev *dev, int offset, void *data)
+{
+	kfree(data);
+}
+
+static int pciback_read_vendor(struct pci_dev *dev, int offset,
+			       u16 *value, void *data)
+{
+	*value = dev->vendor;
+
+	return 0;
+}
+
+static int pciback_read_device(struct pci_dev *dev, int offset,
+			       u16 *value, void *data)
+{
+	*value = dev->device;
+
+	return 0;
+}
+
+static int interrupt_read(struct pci_dev *dev, int offset, u8 * value,
+			  void *data)
+{
+	*value = (u8) dev->irq;
+
+	return 0;
+}
+
+static int bist_write(struct pci_dev *dev, int offset, u8 value, void *data)
+{
+	u8 cur_value;
+	int err;
+
+	err = pci_read_config_byte(dev, offset, &cur_value);
+	if (err)
+		goto out;
+
+	if ((cur_value & ~PCI_BIST_START) == (value & ~PCI_BIST_START)
+	    || value == PCI_BIST_START)
+		err = pci_write_config_byte(dev, offset, value);
+
+out:
+	return err;
+}
+
+static const struct config_field header_common[] = {
+	{
+	 .offset    = PCI_VENDOR_ID,
+	 .size      = 2,
+	 .u.w.read  = pciback_read_vendor,
+	},
+	{
+	 .offset    = PCI_DEVICE_ID,
+	 .size      = 2,
+	 .u.w.read  = pciback_read_device,
+	},
+	{
+	 .offset    = PCI_COMMAND,
+	 .size      = 2,
+	 .u.w.read  = command_read,
+	 .u.w.write = command_write,
+	},
+	{
+	 .offset    = PCI_INTERRUPT_LINE,
+	 .size      = 1,
+	 .u.b.read  = interrupt_read,
+	},
+	{
+	 .offset    = PCI_INTERRUPT_PIN,
+	 .size      = 1,
+	 .u.b.read  = pciback_read_config_byte,
+	},
+	{
+	 /* Any side effects of letting driver domain control cache line? */
+	 .offset    = PCI_CACHE_LINE_SIZE,
+	 .size      = 1,
+	 .u.b.read  = pciback_read_config_byte,
+	 .u.b.write = pciback_write_config_byte,
+	},
+	{
+	 .offset    = PCI_LATENCY_TIMER,
+	 .size      = 1,
+	 .u.b.read  = pciback_read_config_byte,
+	},
+	{
+	 .offset    = PCI_BIST,
+	 .size      = 1,
+	 .u.b.read  = pciback_read_config_byte,
+	 .u.b.write = bist_write,
+	},
+	{}
+};
+
+#define CFG_FIELD_BAR(reg_offset) 			\
+	{ 						\
+	 .offset     = reg_offset, 			\
+	 .size       = 4, 				\
+	 .init       = bar_init, 			\
+	 .reset      = bar_reset, 			\
+	 .release    = bar_release, 			\
+	 .u.dw.read  = bar_read, 			\
+	 .u.dw.write = bar_write, 			\
+	 }
+
+#define CFG_FIELD_ROM(reg_offset) 			\
+	{ 						\
+	 .offset     = reg_offset, 			\
+	 .size       = 4, 				\
+	 .init       = rom_init, 			\
+	 .reset      = bar_reset, 			\
+	 .release    = bar_release, 			\
+	 .u.dw.read  = bar_read, 			\
+	 .u.dw.write = rom_write, 			\
+	 }
+
+static const struct config_field header_0[] = {
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_0),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_1),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_2),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_3),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_4),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_5),
+	CFG_FIELD_ROM(PCI_ROM_ADDRESS),
+	{}
+};
+
+static const struct config_field header_1[] = {
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_0),
+	CFG_FIELD_BAR(PCI_BASE_ADDRESS_1),
+	CFG_FIELD_ROM(PCI_ROM_ADDRESS1),
+	{}
+};
+
+int pciback_config_header_add_fields(struct pci_dev *dev)
+{
+	int err;
+
+	err = pciback_config_add_fields(dev, header_common);
+	if (err)
+		goto out;
+
+	switch (dev->hdr_type) {
+	case PCI_HEADER_TYPE_NORMAL:
+		err = pciback_config_add_fields(dev, header_0);
+		break;
+
+	case PCI_HEADER_TYPE_BRIDGE:
+		err = pciback_config_add_fields(dev, header_1);
+		break;
+
+	default:
+		err = -EINVAL;
+		printk(KERN_ERR "pciback: %s: Unsupported header type %d!\n",
+		       pci_name(dev), dev->hdr_type);
+		break;
+	}
+
+out:
+	return err;
+}
diff --git a/drivers/xen/pciback/conf_space_quirks.c b/drivers/xen/pciback/conf_space_quirks.c
new file mode 100644
index 0000000..45c31fb
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_quirks.c
@@ -0,0 +1,140 @@
+/*
+ * PCI Backend - Handle special overlays for broken devices.
+ *
+ * Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ * Author: Chris Bookholt <hap10@epoch.ncsc.mil>
+ */
+
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include "pciback.h"
+#include "conf_space.h"
+#include "conf_space_quirks.h"
+
+LIST_HEAD(pciback_quirks);
+
+static inline const struct pci_device_id *
+match_one_device(const struct pci_device_id *id, const struct pci_dev *dev)
+{
+	if ((id->vendor == PCI_ANY_ID || id->vendor == dev->vendor) &&
+	    (id->device == PCI_ANY_ID || id->device == dev->device) &&
+	    (id->subvendor == PCI_ANY_ID ||
+				id->subvendor == dev->subsystem_vendor) &&
+	    (id->subdevice == PCI_ANY_ID ||
+				id->subdevice == dev->subsystem_device) &&
+	    !((id->class ^ dev->class) & id->class_mask))
+		return id;
+	return NULL;
+}
+
+struct pciback_config_quirk *pciback_find_quirk(struct pci_dev *dev)
+{
+	struct pciback_config_quirk *tmp_quirk;
+
+	list_for_each_entry(tmp_quirk, &pciback_quirks, quirks_list)
+		if (match_one_device(&tmp_quirk->devid, dev) != NULL)
+			goto out;
+	tmp_quirk = NULL;
+	printk(KERN_DEBUG
+	       "quirk didn't match any device pciback knows about\n");
+out:
+	return tmp_quirk;
+}
+
+static inline void register_quirk(struct pciback_config_quirk *quirk)
+{
+	list_add_tail(&quirk->quirks_list, &pciback_quirks);
+}
+
+int pciback_field_is_dup(struct pci_dev *dev, unsigned int reg)
+{
+	int ret = 0;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+	struct config_field_entry *cfg_entry;
+
+	list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
+		if (OFFSET(cfg_entry) == reg) {
+			ret = 1;
+			break;
+		}
+	}
+	return ret;
+}
+
+int pciback_config_quirks_add_field(struct pci_dev *dev, struct config_field
+				    *field)
+{
+	int err = 0;
+
+	switch (field->size) {
+	case 1:
+		field->u.b.read = pciback_read_config_byte;
+		field->u.b.write = pciback_write_config_byte;
+		break;
+	case 2:
+		field->u.w.read = pciback_read_config_word;
+		field->u.w.write = pciback_write_config_word;
+		break;
+	case 4:
+		field->u.dw.read = pciback_read_config_dword;
+		field->u.dw.write = pciback_write_config_dword;
+		break;
+	default:
+		err = -EINVAL;
+		goto out;
+	}
+
+	pciback_config_add_field(dev, field);
+
+out:
+	return err;
+}
+
+int pciback_config_quirks_init(struct pci_dev *dev)
+{
+	struct pciback_config_quirk *quirk;
+	int ret = 0;
+
+	quirk = kzalloc(sizeof(*quirk), GFP_ATOMIC);
+	if (!quirk) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	quirk->devid.vendor = dev->vendor;
+	quirk->devid.device = dev->device;
+	quirk->devid.subvendor = dev->subsystem_vendor;
+	quirk->devid.subdevice = dev->subsystem_device;
+	quirk->devid.class = 0;
+	quirk->devid.class_mask = 0;
+	quirk->devid.driver_data = 0UL;
+
+	quirk->pdev = dev;
+
+	register_quirk(quirk);
+out:
+	return ret;
+}
+
+void pciback_config_field_free(struct config_field *field)
+{
+	kfree(field);
+}
+
+int pciback_config_quirk_release(struct pci_dev *dev)
+{
+	struct pciback_config_quirk *quirk;
+	int ret = 0;
+
+	quirk = pciback_find_quirk(dev);
+	if (!quirk) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	list_del(&quirk->quirks_list);
+	kfree(quirk);
+
+out:
+	return ret;
+}
diff --git a/drivers/xen/pciback/conf_space_quirks.h b/drivers/xen/pciback/conf_space_quirks.h
new file mode 100644
index 0000000..acd0e1a
--- /dev/null
+++ b/drivers/xen/pciback/conf_space_quirks.h
@@ -0,0 +1,35 @@
+/*
+ * PCI Backend - Data structures for special overlays for broken devices.
+ *
+ * Ryan Wilson <hap9@epoch.ncsc.mil>
+ * Chris Bookholt <hap10@epoch.ncsc.mil>
+ */
+
+#ifndef __XEN_PCIBACK_CONF_SPACE_QUIRKS_H__
+#define __XEN_PCIBACK_CONF_SPACE_QUIRKS_H__
+
+#include <linux/pci.h>
+#include <linux/list.h>
+
+struct pciback_config_quirk {
+	struct list_head quirks_list;
+	struct pci_device_id devid;
+	struct pci_dev *pdev;
+};
+
+struct pciback_config_quirk *pciback_find_quirk(struct pci_dev *dev);
+
+int pciback_config_quirks_add_field(struct pci_dev *dev, struct config_field
+				    *field);
+
+int pciback_config_quirks_remove_field(struct pci_dev *dev, int reg);
+
+int pciback_config_quirks_init(struct pci_dev *dev);
+
+void pciback_config_field_free(struct config_field *field);
+
+int pciback_config_quirk_release(struct pci_dev *dev);
+
+int pciback_field_is_dup(struct pci_dev *dev, unsigned int reg);
+
+#endif
diff --git a/drivers/xen/pciback/controller.c b/drivers/xen/pciback/controller.c
new file mode 100644
index 0000000..7f04f11
--- /dev/null
+++ b/drivers/xen/pciback/controller.c
@@ -0,0 +1,442 @@
+/*
+ * Copyright (C) 2007 Hewlett-Packard Development Company, L.P.
+ *      Alex Williamson <alex.williamson@hp.com>
+ *
+ * PCI "Controller" Backend - virtualize PCI bus topology based on PCI
+ * controllers.  Devices under the same PCI controller are exposed on the
+ * same virtual domain:bus.  Within a bus, device slots are virtualized
+ * to compact the bus.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307 USA
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ */
+
+#include <linux/acpi.h>
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include "pciback.h"
+
+#define PCI_MAX_BUSSES	255
+#define PCI_MAX_SLOTS	32
+
+struct controller_dev_entry {
+	struct list_head list;
+	struct pci_dev *dev;
+	unsigned int devfn;
+};
+
+struct controller_list_entry {
+	struct list_head list;
+	struct pci_controller *controller;
+	unsigned int domain;
+	unsigned int bus;
+	unsigned int next_devfn;
+	struct list_head dev_list;
+};
+
+struct controller_dev_data {
+	struct list_head list;
+	unsigned int next_domain;
+	unsigned int next_bus;
+	spinlock_t lock;
+};
+
+struct walk_info {
+	struct pciback_device *pdev;
+	int resource_count;
+	int root_num;
+};
+
+struct pci_dev *pciback_get_pci_dev(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus,
+				    unsigned int devfn)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_dev_entry *dev_entry;
+	struct controller_list_entry *cntrl_entry;
+	struct pci_dev *dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	list_for_each_entry(cntrl_entry, &dev_data->list, list) {
+		if (cntrl_entry->domain != domain ||
+		    cntrl_entry->bus != bus)
+			continue;
+
+		list_for_each_entry(dev_entry, &cntrl_entry->dev_list, list) {
+			if (devfn == dev_entry->devfn) {
+				dev = dev_entry->dev;
+				goto found;
+			}
+		}
+	}
+found:
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+
+	return dev;
+}
+
+int pciback_add_pci_dev(struct pciback_device *pdev, struct pci_dev *dev,
+			int devid, publish_pci_dev_cb publish_cb)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_dev_entry *dev_entry;
+	struct controller_list_entry *cntrl_entry;
+	struct pci_controller *dev_controller = PCI_CONTROLLER(dev);
+	unsigned long flags;
+	int ret = 0, found = 0;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	/* Look to see if we already have a domain:bus for this controller */
+	list_for_each_entry(cntrl_entry, &dev_data->list, list) {
+		if (cntrl_entry->controller == dev_controller) {
+			found = 1;
+			break;
+		}
+	}
+
+	if (!found) {
+		cntrl_entry = kmalloc(sizeof(*cntrl_entry), GFP_ATOMIC);
+		if (!cntrl_entry) {
+			ret =  -ENOMEM;
+			goto out;
+		}
+
+		cntrl_entry->controller = dev_controller;
+		cntrl_entry->next_devfn = PCI_DEVFN(0, 0);
+
+		cntrl_entry->domain = dev_data->next_domain;
+		cntrl_entry->bus = dev_data->next_bus++;
+		if (dev_data->next_bus > PCI_MAX_BUSSES) {
+			dev_data->next_domain++;
+			dev_data->next_bus = 0;
+		}
+
+		INIT_LIST_HEAD(&cntrl_entry->dev_list);
+
+		list_add_tail(&cntrl_entry->list, &dev_data->list);
+	}
+
+	if (PCI_SLOT(cntrl_entry->next_devfn) > PCI_MAX_SLOTS) {
+		/*
+		 * While it seems unlikely, this can actually happen if
+		 * a controller has P2P bridges under it.
+		 */
+		xenbus_dev_fatal(pdev->xdev, -ENOSPC, "Virtual bus %04x:%02x "
+				 "is full, no room to export %04x:%02x:%02x.%x",
+				 cntrl_entry->domain, cntrl_entry->bus,
+				 pci_domain_nr(dev->bus), dev->bus->number,
+				 PCI_SLOT(dev->devfn), PCI_FUNC(dev->devfn));
+		ret = -ENOSPC;
+		goto out;
+	}
+
+	dev_entry = kmalloc(sizeof(*dev_entry), GFP_ATOMIC);
+	if (!dev_entry) {
+		if (list_empty(&cntrl_entry->dev_list)) {
+			list_del(&cntrl_entry->list);
+			kfree(cntrl_entry);
+		}
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	dev_entry->dev = dev;
+	dev_entry->devfn = cntrl_entry->next_devfn;
+
+	list_add_tail(&dev_entry->list, &cntrl_entry->dev_list);
+
+	cntrl_entry->next_devfn += PCI_DEVFN(1, 0);
+
+out:
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+
+	/* TODO: Publish virtual domain:bus:slot.func here. */
+
+	return ret;
+}
+
+void pciback_release_pci_dev(struct pciback_device *pdev, struct pci_dev *dev)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_list_entry *cntrl_entry;
+	struct controller_dev_entry *dev_entry = NULL;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	list_for_each_entry(cntrl_entry, &dev_data->list, list) {
+		if (cntrl_entry->controller != PCI_CONTROLLER(dev))
+			continue;
+
+		list_for_each_entry(dev_entry, &cntrl_entry->dev_list, list) {
+			if (dev_entry->dev == dev) {
+				found_dev = dev_entry->dev;
+				break;
+			}
+		}
+	}
+
+	if (!found_dev) {
+		spin_unlock_irqrestore(&dev_data->lock, flags);
+		return;
+	}
+
+	list_del(&dev_entry->list);
+	kfree(dev_entry);
+
+	if (list_empty(&cntrl_entry->dev_list)) {
+		list_del(&cntrl_entry->list);
+		kfree(cntrl_entry);
+	}
+
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+	pcistub_put_pci_dev(found_dev);
+}
+
+int pciback_init_devices(struct pciback_device *pdev)
+{
+	struct controller_dev_data *dev_data;
+
+	dev_data = kmalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	spin_lock_init(&dev_data->lock);
+
+	INIT_LIST_HEAD(&dev_data->list);
+
+	/* Starting domain:bus numbers */
+	dev_data->next_domain = 0;
+	dev_data->next_bus = 0;
+
+	pdev->pci_dev_data = dev_data;
+
+	return 0;
+}
+
+static acpi_status write_xenbus_resource(struct acpi_resource *res, void *data)
+{
+	struct walk_info *info = data;
+	struct acpi_resource_address64 addr;
+	acpi_status status;
+	int i, len, err;
+	char str[32], tmp[3];
+	unsigned char *ptr, *buf;
+
+	status = acpi_resource_to_address64(res, &addr);
+
+	/* Do we care about this range?  Let's check. */
+	if (!ACPI_SUCCESS(status) ||
+	    !(addr.resource_type == ACPI_MEMORY_RANGE ||
+	      addr.resource_type == ACPI_IO_RANGE) ||
+	    !addr.address_length || addr.producer_consumer != ACPI_PRODUCER)
+		return AE_OK;
+
+	/*
+	 * Furthermore, we really only care to tell the guest about
+	 * address ranges that require address translation of some sort.
+	 */
+	if (!(addr.resource_type == ACPI_MEMORY_RANGE &&
+	      addr.info.mem.translation) &&
+	    !(addr.resource_type == ACPI_IO_RANGE &&
+	      addr.info.io.translation))
+		return AE_OK;
+
+	/* Store the resource in xenbus for the guest */
+	len = snprintf(str, sizeof(str), "root-%d-resource-%d",
+		       info->root_num, info->resource_count);
+	if (unlikely(len >= (sizeof(str) - 1)))
+		return AE_OK;
+
+	buf = kzalloc((sizeof(*res) * 2) + 1, GFP_KERNEL);
+	if (!buf)
+		return AE_OK;
+
+	/* Clean out resource_source */
+	res->data.address64.resource_source.index = 0xFF;
+	res->data.address64.resource_source.string_length = 0;
+	res->data.address64.resource_source.string_ptr = NULL;
+
+	ptr = (unsigned char *)res;
+
+	/* Turn the acpi_resource into an ASCII byte stream */
+	for (i = 0; i < sizeof(*res); i++) {
+		snprintf(tmp, sizeof(tmp), "%02x", ptr[i]);
+		strncat(buf, tmp, 2);
+	}
+
+	err = xenbus_printf(XBT_NIL, info->pdev->xdev->nodename,
+			    str, "%s", buf);
+
+	if (!err)
+		info->resource_count++;
+
+	kfree(buf);
+
+	return AE_OK;
+}
+
+int pciback_publish_pci_roots(struct pciback_device *pdev,
+			      publish_pci_root_cb publish_root_cb)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_list_entry *cntrl_entry;
+	int i, root_num, len, err = 0;
+	unsigned int domain, bus;
+	char str[64];
+	struct walk_info info;
+
+	spin_lock(&dev_data->lock);
+
+	list_for_each_entry(cntrl_entry, &dev_data->list, list) {
+		/* First publish all the domain:bus info */
+		err = publish_root_cb(pdev, cntrl_entry->domain,
+				      cntrl_entry->bus);
+		if (err)
+			goto out;
+
+		/*
+		 * Now figure out which root-%d this belongs to
+		 * so we can associate resources with it.
+		 */
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+				   "root_num", "%d", &root_num);
+
+		if (err != 1)
+			goto out;
+
+		for (i = 0; i < root_num; i++) {
+			len = snprintf(str, sizeof(str), "root-%d", i);
+			if (unlikely(len >= (sizeof(str) - 1))) {
+				err = -ENOMEM;
+				goto out;
+			}
+
+			err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+					   str, "%x:%x", &domain, &bus);
+			if (err != 2)
+				goto out;
+
+			/* Is this the one we just published? */
+			if (domain == cntrl_entry->domain &&
+			    bus == cntrl_entry->bus)
+				break;
+		}
+
+		if (i == root_num)
+			goto out;
+
+		info.pdev = pdev;
+		info.resource_count = 0;
+		info.root_num = i;
+
+		/* Let ACPI do the heavy lifting on decoding resources */
+		acpi_walk_resources(cntrl_entry->controller->acpi_handle,
+				    METHOD_NAME__CRS, write_xenbus_resource,
+				    &info);
+
+		/* No resouces.  OK.  On to the next one */
+		if (!info.resource_count)
+			continue;
+
+		/* Store the number of resources we wrote for this root-%d */
+		len = snprintf(str, sizeof(str), "root-%d-resources", i);
+		if (unlikely(len >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
+				    "%d", info.resource_count);
+		if (err)
+			goto out;
+	}
+
+	/* Finally, write some magic to synchronize with the guest. */
+	len = snprintf(str, sizeof(str), "root-resource-magic");
+	if (unlikely(len >= (sizeof(str) - 1))) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
+			    "%lx", (sizeof(struct acpi_resource) * 2) + 1);
+
+out:
+	spin_unlock(&dev_data->lock);
+
+	return err;
+}
+
+void pciback_release_devices(struct pciback_device *pdev)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_list_entry *cntrl_entry, *c;
+	struct controller_dev_entry *dev_entry, *d;
+
+	list_for_each_entry_safe(cntrl_entry, c, &dev_data->list, list) {
+		list_for_each_entry_safe(dev_entry, d,
+					 &cntrl_entry->dev_list, list) {
+			list_del(&dev_entry->list);
+			pcistub_put_pci_dev(dev_entry->dev);
+			kfree(dev_entry);
+		}
+		list_del(&cntrl_entry->list);
+		kfree(cntrl_entry);
+	}
+
+	kfree(dev_data);
+	pdev->pci_dev_data = NULL;
+}
+
+int pciback_get_pcifront_dev(struct pci_dev *pcidev,
+		struct pciback_device *pdev,
+		unsigned int *domain, unsigned int *bus, unsigned int *devfn)
+{
+	struct controller_dev_data *dev_data = pdev->pci_dev_data;
+	struct controller_dev_entry *dev_entry;
+	struct controller_list_entry *cntrl_entry;
+	unsigned long flags;
+	int found = 0;
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	list_for_each_entry(cntrl_entry, &dev_data->list, list) {
+		list_for_each_entry(dev_entry, &cntrl_entry->dev_list, list) {
+			if ((dev_entry->dev->bus->number ==
+					pcidev->bus->number) &&
+				(dev_entry->dev->devfn ==
+					pcidev->devfn) &&
+				(pci_domain_nr(dev_entry->dev->bus) ==
+					pci_domain_nr(pcidev->bus))) {
+				found = 1;
+				*domain = cntrl_entry->domain;
+				*bus = cntrl_entry->bus;
+				*devfn = dev_entry->devfn;
+				goto out;
+			}
+		}
+	}
+out:
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+	return found;
+
+}
+
diff --git a/drivers/xen/pciback/passthrough.c b/drivers/xen/pciback/passthrough.c
new file mode 100644
index 0000000..5386beb
--- /dev/null
+++ b/drivers/xen/pciback/passthrough.c
@@ -0,0 +1,178 @@
+/*
+ * PCI Backend - Provides restricted access to the real PCI bus topology
+ *               to the frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/list.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include "pciback.h"
+
+struct passthrough_dev_data {
+	/* Access to dev_list must be protected by lock */
+	struct list_head dev_list;
+	spinlock_t lock;
+};
+
+struct pci_dev *pciback_get_pci_dev(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus,
+				    unsigned int devfn)
+{
+	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
+	struct pci_dev_entry *dev_entry;
+	struct pci_dev *dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	list_for_each_entry(dev_entry, &dev_data->dev_list, list) {
+		if (domain == (unsigned int)pci_domain_nr(dev_entry->dev->bus)
+		    && bus == (unsigned int)dev_entry->dev->bus->number
+		    && devfn == dev_entry->dev->devfn) {
+			dev = dev_entry->dev;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+
+	return dev;
+}
+
+int pciback_add_pci_dev(struct pciback_device *pdev, struct pci_dev *dev,
+			int devid, publish_pci_dev_cb publish_cb)
+{
+	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
+	struct pci_dev_entry *dev_entry;
+	unsigned long flags;
+	unsigned int domain, bus, devfn;
+	int err;
+
+	dev_entry = kmalloc(sizeof(*dev_entry), GFP_KERNEL);
+	if (!dev_entry)
+		return -ENOMEM;
+	dev_entry->dev = dev;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+	list_add_tail(&dev_entry->list, &dev_data->dev_list);
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+
+	/* Publish this device. */
+	domain = (unsigned int)pci_domain_nr(dev->bus);
+	bus = (unsigned int)dev->bus->number;
+	devfn = dev->devfn;
+	err = publish_cb(pdev, domain, bus, devfn, devid);
+
+	return err;
+}
+
+void pciback_release_pci_dev(struct pciback_device *pdev, struct pci_dev *dev)
+{
+	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
+	struct pci_dev_entry *dev_entry, *t;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dev_data->lock, flags);
+
+	list_for_each_entry_safe(dev_entry, t, &dev_data->dev_list, list) {
+		if (dev_entry->dev == dev) {
+			list_del(&dev_entry->list);
+			found_dev = dev_entry->dev;
+			kfree(dev_entry);
+		}
+	}
+
+	spin_unlock_irqrestore(&dev_data->lock, flags);
+
+	if (found_dev)
+		pcistub_put_pci_dev(found_dev);
+}
+
+int pciback_init_devices(struct pciback_device *pdev)
+{
+	struct passthrough_dev_data *dev_data;
+
+	dev_data = kmalloc(sizeof(*dev_data), GFP_KERNEL);
+	if (!dev_data)
+		return -ENOMEM;
+
+	spin_lock_init(&dev_data->lock);
+
+	INIT_LIST_HEAD(&dev_data->dev_list);
+
+	pdev->pci_dev_data = dev_data;
+
+	return 0;
+}
+
+int pciback_publish_pci_roots(struct pciback_device *pdev,
+			      publish_pci_root_cb publish_root_cb)
+{
+	int err = 0;
+	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
+	struct pci_dev_entry *dev_entry, *e;
+	struct pci_dev *dev;
+	int found;
+	unsigned int domain, bus;
+
+	spin_lock(&dev_data->lock);
+
+	list_for_each_entry(dev_entry, &dev_data->dev_list, list) {
+		/* Only publish this device as a root if none of its
+		 * parent bridges are exported
+		 */
+		found = 0;
+		dev = dev_entry->dev->bus->self;
+		for (; !found && dev != NULL; dev = dev->bus->self) {
+			list_for_each_entry(e, &dev_data->dev_list, list) {
+				if (dev == e->dev) {
+					found = 1;
+					break;
+				}
+			}
+		}
+
+		domain = (unsigned int)pci_domain_nr(dev_entry->dev->bus);
+		bus = (unsigned int)dev_entry->dev->bus->number;
+
+		if (!found) {
+			err = publish_root_cb(pdev, domain, bus);
+			if (err)
+				break;
+		}
+	}
+
+	spin_unlock(&dev_data->lock);
+
+	return err;
+}
+
+void pciback_release_devices(struct pciback_device *pdev)
+{
+	struct passthrough_dev_data *dev_data = pdev->pci_dev_data;
+	struct pci_dev_entry *dev_entry, *t;
+
+	list_for_each_entry_safe(dev_entry, t, &dev_data->dev_list, list) {
+		list_del(&dev_entry->list);
+		pcistub_put_pci_dev(dev_entry->dev);
+		kfree(dev_entry);
+	}
+
+	kfree(dev_data);
+	pdev->pci_dev_data = NULL;
+}
+
+int pciback_get_pcifront_dev(struct pci_dev *pcidev,
+			     struct pciback_device *pdev,
+			     unsigned int *domain, unsigned int *bus,
+			     unsigned int *devfn)
+
+{
+	*domain = pci_domain_nr(pcidev->bus);
+	*bus = pcidev->bus->number;
+	*devfn = pcidev->devfn;
+	return 1;
+}
diff --git a/drivers/xen/pciback/pci_stub.c b/drivers/xen/pciback/pci_stub.c
new file mode 100644
index 0000000..88c7ca1
--- /dev/null
+++ b/drivers/xen/pciback/pci_stub.c
@@ -0,0 +1,1370 @@
+/*
+ * PCI Stub Driver - Grabs devices in backend to be exported later
+ *
+ * Ryan Wilson <hap9@epoch.ncsc.mil>
+ * Chris Bookholt <hap10@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/rwsem.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/kref.h>
+#include <linux/pci.h>
+#include <linux/wait.h>
+#include <linux/sched.h>
+#include <asm/atomic.h>
+#include <xen/events.h>
+#include <asm/xen/pci.h>
+#include <asm/xen/hypervisor.h>
+#include "pciback.h"
+#include "conf_space.h"
+#include "conf_space_quirks.h"
+
+#define DRV_NAME	"pciback"
+
+static char *pci_devs_to_hide;
+wait_queue_head_t aer_wait_queue;
+/*Add sem for sync AER handling and pciback remove/reconfigue ops,
+* We want to avoid in middle of AER ops, pciback devices is being removed
+*/
+static DECLARE_RWSEM(pcistub_sem);
+module_param_named(hide, pci_devs_to_hide, charp, 0444);
+
+struct pcistub_device_id {
+	struct list_head slot_list;
+	int domain;
+	unsigned char bus;
+	unsigned int devfn;
+};
+static LIST_HEAD(pcistub_device_ids);
+static DEFINE_SPINLOCK(device_ids_lock);
+
+struct pcistub_device {
+	struct kref kref;
+	struct list_head dev_list;
+	spinlock_t lock;
+
+	struct pci_dev *dev;
+	struct pciback_device *pdev;/* non-NULL if struct pci_dev is in use */
+};
+
+/* Access to pcistub_devices & seized_devices lists and the initialize_devices
+ * flag must be locked with pcistub_devices_lock
+ */
+static DEFINE_SPINLOCK(pcistub_devices_lock);
+static LIST_HEAD(pcistub_devices);
+
+/* wait for device_initcall before initializing our devices
+ * (see pcistub_init_devices_late)
+ */
+static int initialize_devices;
+static LIST_HEAD(seized_devices);
+
+static struct pcistub_device *pcistub_device_alloc(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+
+	dev_dbg(&dev->dev, "pcistub_device_alloc\n");
+
+	psdev = kzalloc(sizeof(*psdev), GFP_ATOMIC);
+	if (!psdev)
+		return NULL;
+
+	psdev->dev = pci_dev_get(dev);
+	if (!psdev->dev) {
+		kfree(psdev);
+		return NULL;
+	}
+
+	kref_init(&psdev->kref);
+	spin_lock_init(&psdev->lock);
+
+	return psdev;
+}
+
+/* Don't call this directly as it's called by pcistub_device_put */
+static void pcistub_device_release(struct kref *kref)
+{
+	struct pcistub_device *psdev;
+
+	psdev = container_of(kref, struct pcistub_device, kref);
+
+	dev_dbg(&psdev->dev->dev, "pcistub_device_release\n");
+
+	xen_unregister_device_domain_owner(psdev->dev);
+
+	/* Clean-up the device */
+	pciback_reset_device(psdev->dev);
+	pciback_config_free_dyn_fields(psdev->dev);
+	pciback_config_free_dev(psdev->dev);
+	kfree(pci_get_drvdata(psdev->dev));
+	pci_set_drvdata(psdev->dev, NULL);
+
+	pci_dev_put(psdev->dev);
+
+	kfree(psdev);
+}
+
+static inline void pcistub_device_get(struct pcistub_device *psdev)
+{
+	kref_get(&psdev->kref);
+}
+
+static inline void pcistub_device_put(struct pcistub_device *psdev)
+{
+	kref_put(&psdev->kref, pcistub_device_release);
+}
+
+static struct pcistub_device *pcistub_device_find(int domain, int bus,
+						  int slot, int func)
+{
+	struct pcistub_device *psdev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev != NULL
+		    && domain == pci_domain_nr(psdev->dev->bus)
+		    && bus == psdev->dev->bus->number
+		    && PCI_DEVFN(slot, func) == psdev->dev->devfn) {
+			pcistub_device_get(psdev);
+			goto out;
+		}
+	}
+
+	/* didn't find it */
+	psdev = NULL;
+
+out:
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	return psdev;
+}
+
+static struct pci_dev *pcistub_device_get_pci_dev(struct pciback_device *pdev,
+						  struct pcistub_device *psdev)
+{
+	struct pci_dev *pci_dev = NULL;
+	unsigned long flags;
+
+	pcistub_device_get(psdev);
+
+	spin_lock_irqsave(&psdev->lock, flags);
+	if (!psdev->pdev) {
+		psdev->pdev = pdev;
+		pci_dev = psdev->dev;
+	}
+	spin_unlock_irqrestore(&psdev->lock, flags);
+
+	if (!pci_dev)
+		pcistub_device_put(psdev);
+
+	return pci_dev;
+}
+
+struct pci_dev *pcistub_get_pci_dev_by_slot(struct pciback_device *pdev,
+					    int domain, int bus,
+					    int slot, int func)
+{
+	struct pcistub_device *psdev;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev != NULL
+		    && domain == pci_domain_nr(psdev->dev->bus)
+		    && bus == psdev->dev->bus->number
+		    && PCI_DEVFN(slot, func) == psdev->dev->devfn) {
+			found_dev = pcistub_device_get_pci_dev(pdev, psdev);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	return found_dev;
+}
+
+struct pci_dev *pcistub_get_pci_dev(struct pciback_device *pdev,
+				    struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev == dev) {
+			found_dev = pcistub_device_get_pci_dev(pdev, psdev);
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	return found_dev;
+}
+
+void pcistub_put_pci_dev(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev, *found_psdev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev == dev) {
+			found_psdev = psdev;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+	/*hold this lock for avoiding breaking link between
+	* pcistub and pciback when AER is in processing
+	*/
+	down_write(&pcistub_sem);
+	/* Cleanup our device
+	 * (so it's ready for the next domain)
+	 */
+	pciback_reset_device(found_psdev->dev);
+	pciback_config_free_dyn_fields(found_psdev->dev);
+	pciback_config_reset_dev(found_psdev->dev);
+
+	spin_lock_irqsave(&found_psdev->lock, flags);
+	found_psdev->pdev = NULL;
+	spin_unlock_irqrestore(&found_psdev->lock, flags);
+
+	pcistub_device_put(found_psdev);
+	up_write(&pcistub_sem);
+}
+
+static int __devinit pcistub_match_one(struct pci_dev *dev,
+				       struct pcistub_device_id *pdev_id)
+{
+	/* Match the specified device by domain, bus, slot, func and also if
+	 * any of the device's parent bridges match.
+	 */
+	for (; dev != NULL; dev = dev->bus->self) {
+		if (pci_domain_nr(dev->bus) == pdev_id->domain
+		    && dev->bus->number == pdev_id->bus
+		    && dev->devfn == pdev_id->devfn)
+			return 1;
+
+		/* Sometimes topmost bridge links to itself. */
+		if (dev == dev->bus->self)
+			break;
+	}
+
+	return 0;
+}
+
+static int __devinit pcistub_match(struct pci_dev *dev)
+{
+	struct pcistub_device_id *pdev_id;
+	unsigned long flags;
+	int found = 0;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_for_each_entry(pdev_id, &pcistub_device_ids, slot_list) {
+		if (pcistub_match_one(dev, pdev_id)) {
+			found = 1;
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return found;
+}
+
+static int __devinit pcistub_init_device(struct pci_dev *dev)
+{
+	struct pciback_dev_data *dev_data;
+	int err = 0;
+
+	dev_dbg(&dev->dev, "initializing...\n");
+
+	/* The PCI backend is not intended to be a module (or to work with
+	 * removable PCI devices (yet). If it were, pciback_config_free()
+	 * would need to be called somewhere to free the memory allocated
+	 * here and then to call kfree(pci_get_drvdata(psdev->dev)).
+	 */
+	dev_data = kzalloc(sizeof(*dev_data) +  strlen(DRV_NAME "[]")
+				+ strlen(pci_name(dev)) + 1, GFP_ATOMIC);
+	if (!dev_data) {
+		err = -ENOMEM;
+		goto out;
+	}
+	pci_set_drvdata(dev, dev_data);
+
+	/*
+	 * Setup name for fake IRQ handler. It will only be enabled
+	 * once the device is turned on by the guest.
+	 */
+	sprintf(dev_data->irq_name, DRV_NAME "[%s]", pci_name(dev));
+
+	dev_dbg(&dev->dev, "initializing config\n");
+
+	init_waitqueue_head(&aer_wait_queue);
+	err = pciback_config_init_dev(dev);
+	if (err)
+		goto out;
+
+	/* HACK: Force device (& ACPI) to determine what IRQ it's on - we
+	 * must do this here because pcibios_enable_device may specify
+	 * the pci device's true irq (and possibly its other resources)
+	 * if they differ from what's in the configuration space.
+	 * This makes the assumption that the device's resources won't
+	 * change after this point (otherwise this code may break!)
+	 */
+	dev_dbg(&dev->dev, "enabling device\n");
+	err = pci_enable_device(dev);
+	if (err)
+		goto config_release;
+
+	/* Now disable the device (this also ensures some private device
+	 * data is setup before we export)
+	 */
+	dev_dbg(&dev->dev, "reset device\n");
+	pciback_reset_device(dev);
+
+	return 0;
+
+config_release:
+	pciback_config_free_dev(dev);
+
+out:
+	pci_set_drvdata(dev, NULL);
+	kfree(dev_data);
+	return err;
+}
+
+/*
+ * Because some initialization still happens on
+ * devices during fs_initcall, we need to defer
+ * full initialization of our devices until
+ * device_initcall.
+ */
+static int __init pcistub_init_devices_late(void)
+{
+	struct pcistub_device *psdev;
+	unsigned long flags;
+	int err = 0;
+
+	pr_debug("pciback: pcistub_init_devices_late\n");
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	while (!list_empty(&seized_devices)) {
+		psdev = container_of(seized_devices.next,
+				     struct pcistub_device, dev_list);
+		list_del(&psdev->dev_list);
+
+		spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+		err = pcistub_init_device(psdev->dev);
+		if (err) {
+			dev_err(&psdev->dev->dev,
+				"error %d initializing device\n", err);
+			kfree(psdev);
+			psdev = NULL;
+		}
+
+		spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+		if (psdev)
+			list_add_tail(&psdev->dev_list, &pcistub_devices);
+	}
+
+	initialize_devices = 1;
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+	return 0;
+}
+
+static int __devinit pcistub_seize(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+	unsigned long flags;
+	int err = 0;
+
+	psdev = pcistub_device_alloc(dev);
+	if (!psdev)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	if (initialize_devices) {
+		spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+		/* don't want irqs disabled when calling pcistub_init_device */
+		err = pcistub_init_device(psdev->dev);
+
+		spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+		if (!err)
+			list_add(&psdev->dev_list, &pcistub_devices);
+	} else {
+		dev_dbg(&dev->dev, "deferring initialization\n");
+		list_add(&psdev->dev_list, &seized_devices);
+	}
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+	if (err)
+		pcistub_device_put(psdev);
+
+	return err;
+}
+
+static int __devinit pcistub_probe(struct pci_dev *dev,
+				   const struct pci_device_id *id)
+{
+	int err = 0;
+
+	dev_dbg(&dev->dev, "probing...\n");
+
+	if (pcistub_match(dev)) {
+
+		if (dev->hdr_type != PCI_HEADER_TYPE_NORMAL
+		    && dev->hdr_type != PCI_HEADER_TYPE_BRIDGE) {
+			dev_err(&dev->dev, "can't export pci devices that "
+				"don't have a normal (0) or bridge (1) "
+				"header type!\n");
+			err = -ENODEV;
+			goto out;
+		}
+
+		dev_info(&dev->dev, "seizing device\n");
+		err = pcistub_seize(dev);
+	} else
+		/* Didn't find the device */
+		err = -ENODEV;
+
+out:
+	return err;
+}
+
+static void pcistub_remove(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev, *found_psdev = NULL;
+	unsigned long flags;
+
+	dev_dbg(&dev->dev, "removing\n");
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+
+	pciback_config_quirk_release(dev);
+
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (psdev->dev == dev) {
+			found_psdev = psdev;
+			break;
+		}
+	}
+
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+	if (found_psdev) {
+		dev_dbg(&dev->dev, "found device to remove - in use? %p\n",
+			found_psdev->pdev);
+
+		if (found_psdev->pdev) {
+			printk(KERN_WARNING "pciback: ****** removing device "
+			       "%s while still in-use! ******\n",
+			       pci_name(found_psdev->dev));
+			printk(KERN_WARNING "pciback: ****** driver domain may "
+			       "still access this device's i/o resources!\n");
+			printk(KERN_WARNING "pciback: ****** shutdown driver "
+			       "domain before binding device\n");
+			printk(KERN_WARNING "pciback: ****** to other drivers "
+			       "or domains\n");
+
+			pciback_release_pci_dev(found_psdev->pdev,
+						found_psdev->dev);
+		}
+
+		spin_lock_irqsave(&pcistub_devices_lock, flags);
+		list_del(&found_psdev->dev_list);
+		spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+
+		/* the final put for releasing from the list */
+		pcistub_device_put(found_psdev);
+	}
+}
+
+static const struct pci_device_id pcistub_ids[] = {
+	{
+	 .vendor = PCI_ANY_ID,
+	 .device = PCI_ANY_ID,
+	 .subvendor = PCI_ANY_ID,
+	 .subdevice = PCI_ANY_ID,
+	 },
+	{0,},
+};
+
+#define PCI_NODENAME_MAX 40
+static void kill_domain_by_device(struct pcistub_device *psdev)
+{
+	struct xenbus_transaction xbt;
+	int err;
+	char nodename[PCI_NODENAME_MAX];
+
+	if (!psdev)
+		dev_err(&psdev->dev->dev,
+			"device is NULL when do AER recovery/kill_domain\n");
+	snprintf(nodename, PCI_NODENAME_MAX, "/local/domain/0/backend/pci/%d/0",
+		psdev->pdev->xdev->otherend_id);
+	nodename[strlen(nodename)] = '\0';
+
+again:
+	err = xenbus_transaction_start(&xbt);
+	if (err) {
+		dev_err(&psdev->dev->dev,
+			"error %d when start xenbus transaction\n", err);
+		return;
+	}
+	/*PV AER handlers will set this flag*/
+	xenbus_printf(xbt, nodename, "aerState" , "aerfail");
+	err = xenbus_transaction_end(xbt, 0);
+	if (err) {
+		if (err == -EAGAIN)
+			goto again;
+		dev_err(&psdev->dev->dev,
+			"error %d when end xenbus transaction\n", err);
+		return;
+	}
+}
+
+/* For each aer recovery step error_detected, mmio_enabled, etc, front_end and
+ * backend need to have cooperation. In pciback, those steps will do similar
+ * jobs: send service request and waiting for front_end response.
+*/
+static pci_ers_result_t common_process(struct pcistub_device *psdev,
+		pci_channel_state_t state, int aer_cmd, pci_ers_result_t result)
+{
+	pci_ers_result_t res = result;
+	struct xen_pcie_aer_op *aer_op;
+	int ret;
+
+	/*with PV AER drivers*/
+	aer_op = &(psdev->pdev->sh_info->aer_op);
+	aer_op->cmd = aer_cmd ;
+	/*useful for error_detected callback*/
+	aer_op->err = state;
+	/*pcifront_end BDF*/
+	ret = pciback_get_pcifront_dev(psdev->dev, psdev->pdev,
+		&aer_op->domain, &aer_op->bus, &aer_op->devfn);
+	if (!ret) {
+		dev_err(&psdev->dev->dev,
+			"pciback: failed to get pcifront device\n");
+		return PCI_ERS_RESULT_NONE;
+	}
+	wmb();
+
+	dev_dbg(&psdev->dev->dev,
+			"pciback: aer_op %x dom %x bus %x devfn %x\n",
+			aer_cmd, aer_op->domain, aer_op->bus, aer_op->devfn);
+	/*local flag to mark there's aer request, pciback callback will use this
+	* flag to judge whether we need to check pci-front give aer service
+	* ack signal
+	*/
+	set_bit(_PCIB_op_pending, (unsigned long *)&psdev->pdev->flags);
+
+	/*It is possible that a pcifront conf_read_write ops request invokes
+	* the callback which cause the spurious execution of wake_up.
+	* Yet it is harmless and better than a spinlock here
+	*/
+	set_bit(_XEN_PCIB_active,
+		(unsigned long *)&psdev->pdev->sh_info->flags);
+	wmb();
+	notify_remote_via_irq(psdev->pdev->evtchn_irq);
+
+	ret = wait_event_timeout(aer_wait_queue, !(test_bit(_XEN_PCIB_active,
+		(unsigned long *)&psdev->pdev->sh_info->flags)), 300*HZ);
+
+	if (!ret) {
+		if (test_bit(_XEN_PCIB_active,
+			(unsigned long *)&psdev->pdev->sh_info->flags)) {
+			dev_err(&psdev->dev->dev,
+				"pcifront aer process not responding!\n");
+			clear_bit(_XEN_PCIB_active,
+			  (unsigned long *)&psdev->pdev->sh_info->flags);
+			aer_op->err = PCI_ERS_RESULT_NONE;
+			return res;
+		}
+	}
+	clear_bit(_PCIB_op_pending, (unsigned long *)&psdev->pdev->flags);
+
+	if (test_bit(_XEN_PCIF_active,
+		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		dev_dbg(&psdev->dev->dev,
+			"schedule pci_conf service in pciback \n");
+		test_and_schedule_op(psdev->pdev);
+	}
+
+	res = (pci_ers_result_t)aer_op->err;
+	return res;
+}
+
+/*
+* pciback_slot_reset: it will send the slot_reset request to  pcifront in case
+* of the device driver could provide this service, and then wait for pcifront
+* ack.
+* @dev: pointer to PCI devices
+* return value is used by aer_core do_recovery policy
+*/
+static pci_ers_result_t pciback_slot_reset(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+	pci_ers_result_t result;
+
+	result = PCI_ERS_RESULT_RECOVERED;
+	dev_dbg(&dev->dev, "pciback_slot_reset(bus:%x,devfn:%x)\n",
+		dev->bus->number, dev->devfn);
+
+	down_write(&pcistub_sem);
+	psdev = pcistub_device_find(pci_domain_nr(dev->bus),
+				dev->bus->number,
+				PCI_SLOT(dev->devfn),
+				PCI_FUNC(dev->devfn));
+
+	if (!psdev || !psdev->pdev) {
+		dev_err(&dev->dev,
+			"pciback device is not found/assigned\n");
+		goto end;
+	}
+
+	if (!psdev->pdev->sh_info) {
+		dev_err(&dev->dev, "pciback device is not connected or owned"
+			" by HVM, kill it\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+
+	if (!test_bit(_XEN_PCIB_AERHANDLER,
+		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		dev_err(&dev->dev,
+			"guest with no AER driver should have been killed\n");
+		goto release;
+	}
+	result = common_process(psdev, 1, XEN_PCI_OP_aer_slotreset, result);
+
+	if (result == PCI_ERS_RESULT_NONE ||
+		result == PCI_ERS_RESULT_DISCONNECT) {
+		dev_dbg(&dev->dev,
+			"No AER slot_reset service or disconnected!\n");
+		kill_domain_by_device(psdev);
+	}
+release:
+	pcistub_device_put(psdev);
+end:
+	up_write(&pcistub_sem);
+	return result;
+
+}
+
+
+/*pciback_mmio_enabled: it will send the mmio_enabled request to  pcifront
+* in case of the device driver could provide this service, and then wait
+* for pcifront ack
+* @dev: pointer to PCI devices
+* return value is used by aer_core do_recovery policy
+*/
+
+static pci_ers_result_t pciback_mmio_enabled(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+	pci_ers_result_t result;
+
+	result = PCI_ERS_RESULT_RECOVERED;
+	dev_dbg(&dev->dev, "pciback_mmio_enabled(bus:%x,devfn:%x)\n",
+		dev->bus->number, dev->devfn);
+
+	down_write(&pcistub_sem);
+	psdev = pcistub_device_find(pci_domain_nr(dev->bus),
+				dev->bus->number,
+				PCI_SLOT(dev->devfn),
+				PCI_FUNC(dev->devfn));
+
+	if (!psdev || !psdev->pdev) {
+		dev_err(&dev->dev,
+			"pciback device is not found/assigned\n");
+		goto end;
+	}
+
+	if (!psdev->pdev->sh_info) {
+		dev_err(&dev->dev, "pciback device is not connected or owned"
+			" by HVM, kill it\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+
+	if (!test_bit(_XEN_PCIB_AERHANDLER,
+		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		dev_err(&dev->dev,
+			"guest with no AER driver should have been killed\n");
+		goto release;
+	}
+	result = common_process(psdev, 1, XEN_PCI_OP_aer_mmio, result);
+
+	if (result == PCI_ERS_RESULT_NONE ||
+		result == PCI_ERS_RESULT_DISCONNECT) {
+		dev_dbg(&dev->dev,
+			"No AER mmio_enabled service or disconnected!\n");
+		kill_domain_by_device(psdev);
+	}
+release:
+	pcistub_device_put(psdev);
+end:
+	up_write(&pcistub_sem);
+	return result;
+}
+
+/*pciback_error_detected: it will send the error_detected request to  pcifront
+* in case of the device driver could provide this service, and then wait
+* for pcifront ack.
+* @dev: pointer to PCI devices
+* @error: the current PCI connection state
+* return value is used by aer_core do_recovery policy
+*/
+
+static pci_ers_result_t pciback_error_detected(struct pci_dev *dev,
+	pci_channel_state_t error)
+{
+	struct pcistub_device *psdev;
+	pci_ers_result_t result;
+
+	result = PCI_ERS_RESULT_CAN_RECOVER;
+	dev_dbg(&dev->dev, "pciback_error_detected(bus:%x,devfn:%x)\n",
+		dev->bus->number, dev->devfn);
+
+	down_write(&pcistub_sem);
+	psdev = pcistub_device_find(pci_domain_nr(dev->bus),
+				dev->bus->number,
+				PCI_SLOT(dev->devfn),
+				PCI_FUNC(dev->devfn));
+
+	if (!psdev || !psdev->pdev) {
+		dev_err(&dev->dev,
+			"pciback device is not found/assigned\n");
+		goto end;
+	}
+
+	if (!psdev->pdev->sh_info) {
+		dev_err(&dev->dev, "pciback device is not connected or owned"
+			" by HVM, kill it\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+
+	/*Guest owns the device yet no aer handler regiested, kill guest*/
+	if (!test_bit(_XEN_PCIB_AERHANDLER,
+		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		dev_dbg(&dev->dev, "guest may have no aer driver, kill it\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+	result = common_process(psdev, error, XEN_PCI_OP_aer_detected, result);
+
+	if (result == PCI_ERS_RESULT_NONE ||
+		result == PCI_ERS_RESULT_DISCONNECT) {
+		dev_dbg(&dev->dev,
+			"No AER error_detected service or disconnected!\n");
+		kill_domain_by_device(psdev);
+	}
+release:
+	pcistub_device_put(psdev);
+end:
+	up_write(&pcistub_sem);
+	return result;
+}
+
+/*pciback_error_resume: it will send the error_resume request to  pcifront
+* in case of the device driver could provide this service, and then wait
+* for pcifront ack.
+* @dev: pointer to PCI devices
+*/
+
+static void pciback_error_resume(struct pci_dev *dev)
+{
+	struct pcistub_device *psdev;
+
+	dev_dbg(&dev->dev, "pciback_error_resume(bus:%x,devfn:%x)\n",
+		dev->bus->number, dev->devfn);
+
+	down_write(&pcistub_sem);
+	psdev = pcistub_device_find(pci_domain_nr(dev->bus),
+				dev->bus->number,
+				PCI_SLOT(dev->devfn),
+				PCI_FUNC(dev->devfn));
+
+	if (!psdev || !psdev->pdev) {
+		dev_err(&dev->dev,
+			"pciback device is not found/assigned\n");
+		goto end;
+	}
+
+	if (!psdev->pdev->sh_info) {
+		dev_err(&dev->dev, "pciback device is not connected or owned"
+			" by HVM, kill it\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+
+	if (!test_bit(_XEN_PCIB_AERHANDLER,
+		(unsigned long *)&psdev->pdev->sh_info->flags)) {
+		dev_err(&dev->dev,
+			"guest with no AER driver should have been killed\n");
+		kill_domain_by_device(psdev);
+		goto release;
+	}
+	common_process(psdev, 1, XEN_PCI_OP_aer_resume,
+		       PCI_ERS_RESULT_RECOVERED);
+release:
+	pcistub_device_put(psdev);
+end:
+	up_write(&pcistub_sem);
+	return;
+}
+
+/*add pciback AER handling*/
+static struct pci_error_handlers pciback_error_handler = {
+	.error_detected = pciback_error_detected,
+	.mmio_enabled = pciback_mmio_enabled,
+	.slot_reset = pciback_slot_reset,
+	.resume = pciback_error_resume,
+};
+
+/*
+ * Note: There is no MODULE_DEVICE_TABLE entry here because this isn't
+ * for a normal device. I don't want it to be loaded automatically.
+ */
+
+static struct pci_driver pciback_pci_driver = {
+	.name = DRV_NAME,
+	.id_table = pcistub_ids,
+	.probe = pcistub_probe,
+	.remove = pcistub_remove,
+	.err_handler = &pciback_error_handler,
+};
+
+static inline int str_to_slot(const char *buf, int *domain, int *bus,
+			      int *slot, int *func)
+{
+	int err;
+
+	err = sscanf(buf, " %x:%x:%x.%x", domain, bus, slot, func);
+	if (err == 4)
+		return 0;
+	else if (err < 0)
+		return -EINVAL;
+
+	/* try again without domain */
+	*domain = 0;
+	err = sscanf(buf, " %x:%x.%x", bus, slot, func);
+	if (err == 3)
+		return 0;
+
+	return -EINVAL;
+}
+
+static inline int str_to_quirk(const char *buf, int *domain, int *bus, int
+			       *slot, int *func, int *reg, int *size, int *mask)
+{
+	int err;
+
+	err =
+	    sscanf(buf, " %04x:%02x:%02x.%1x-%08x:%1x:%08x", domain, bus, slot,
+		   func, reg, size, mask);
+	if (err == 7)
+		return 0;
+	return -EINVAL;
+}
+
+static int pcistub_device_id_add(int domain, int bus, int slot, int func)
+{
+	struct pcistub_device_id *pci_dev_id;
+	unsigned long flags;
+
+	pci_dev_id = kmalloc(sizeof(*pci_dev_id), GFP_KERNEL);
+	if (!pci_dev_id)
+		return -ENOMEM;
+
+	pci_dev_id->domain = domain;
+	pci_dev_id->bus = bus;
+	pci_dev_id->devfn = PCI_DEVFN(slot, func);
+
+	pr_debug("pciback: wants to seize %04x:%02x:%02x.%01x\n",
+		 domain, bus, slot, func);
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_add_tail(&pci_dev_id->slot_list, &pcistub_device_ids);
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return 0;
+}
+
+static int pcistub_device_id_remove(int domain, int bus, int slot, int func)
+{
+	struct pcistub_device_id *pci_dev_id, *t;
+	int devfn = PCI_DEVFN(slot, func);
+	int err = -ENOENT;
+	unsigned long flags;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_for_each_entry_safe(pci_dev_id, t, &pcistub_device_ids,
+				 slot_list) {
+		if (pci_dev_id->domain == domain
+		    && pci_dev_id->bus == bus && pci_dev_id->devfn == devfn) {
+			/* Don't break; here because it's possible the same
+			 * slot could be in the list more than once
+			 */
+			list_del(&pci_dev_id->slot_list);
+			kfree(pci_dev_id);
+
+			err = 0;
+
+			pr_debug("pciback: removed %04x:%02x:%02x.%01x from "
+				 "seize list\n", domain, bus, slot, func);
+		}
+	}
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return err;
+}
+
+static int pcistub_reg_add(int domain, int bus, int slot, int func, int reg,
+			   int size, int mask)
+{
+	int err = 0;
+	struct pcistub_device *psdev;
+	struct pci_dev *dev;
+	struct config_field *field;
+
+	psdev = pcistub_device_find(domain, bus, slot, func);
+	if (!psdev || !psdev->dev) {
+		err = -ENODEV;
+		goto out;
+	}
+	dev = psdev->dev;
+
+	field = kzalloc(sizeof(*field), GFP_ATOMIC);
+	if (!field) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	field->offset = reg;
+	field->size = size;
+	field->mask = mask;
+	field->init = NULL;
+	field->reset = NULL;
+	field->release = NULL;
+	field->clean = pciback_config_field_free;
+
+	err = pciback_config_quirks_add_field(dev, field);
+	if (err)
+		kfree(field);
+out:
+	return err;
+}
+
+static ssize_t pcistub_slot_add(struct device_driver *drv, const char *buf,
+				size_t count)
+{
+	int domain, bus, slot, func;
+	int err;
+
+	err = str_to_slot(buf, &domain, &bus, &slot, &func);
+	if (err)
+		goto out;
+
+	err = pcistub_device_id_add(domain, bus, slot, func);
+
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+
+DRIVER_ATTR(new_slot, S_IWUSR, NULL, pcistub_slot_add);
+
+static ssize_t pcistub_slot_remove(struct device_driver *drv, const char *buf,
+				   size_t count)
+{
+	int domain, bus, slot, func;
+	int err;
+
+	err = str_to_slot(buf, &domain, &bus, &slot, &func);
+	if (err)
+		goto out;
+
+	err = pcistub_device_id_remove(domain, bus, slot, func);
+
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+
+DRIVER_ATTR(remove_slot, S_IWUSR, NULL, pcistub_slot_remove);
+
+static ssize_t pcistub_slot_show(struct device_driver *drv, char *buf)
+{
+	struct pcistub_device_id *pci_dev_id;
+	size_t count = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_for_each_entry(pci_dev_id, &pcistub_device_ids, slot_list) {
+		if (count >= PAGE_SIZE)
+			break;
+
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "%04x:%02x:%02x.%01x\n",
+				   pci_dev_id->domain, pci_dev_id->bus,
+				   PCI_SLOT(pci_dev_id->devfn),
+				   PCI_FUNC(pci_dev_id->devfn));
+	}
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return count;
+}
+
+DRIVER_ATTR(slots, S_IRUSR, pcistub_slot_show, NULL);
+
+static ssize_t pcistub_irq_handler_show(struct device_driver *drv, char *buf)
+{
+	struct pcistub_device *psdev;
+	struct pciback_dev_data *dev_data;
+	size_t count = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (count >= PAGE_SIZE)
+			break;
+		if (!psdev->dev)
+			continue;
+		dev_data = pci_get_drvdata(psdev->dev);
+		if (!dev_data)
+			continue;
+		count +=
+		    scnprintf(buf + count, PAGE_SIZE - count, "%s:%s:%sing:%ld\n",
+			      pci_name(psdev->dev),
+			      dev_data->isr_on ? "on" : "off",
+			      dev_data->ack_intr ? "ack" : "not ack",
+			      dev_data->handled);
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	return count;
+}
+
+DRIVER_ATTR(irq_handlers, S_IRUSR, pcistub_irq_handler_show, NULL);
+
+static ssize_t pcistub_irq_handler_switch(struct device_driver *drv,
+					  const char *buf,
+					  size_t count)
+{
+	struct pcistub_device *psdev;
+	struct pciback_dev_data *dev_data;
+	int domain, bus, slot, func;
+	int err = -ENOENT;
+
+	err = str_to_slot(buf, &domain, &bus, &slot, &func);
+	if (err)
+		goto out;
+
+	psdev = pcistub_device_find(domain, bus, slot, func);
+
+	if (!psdev)
+		goto out;
+
+	dev_data = pci_get_drvdata(psdev->dev);
+	if (!dev_data)
+		goto out;
+
+	dev_dbg(&psdev->dev->dev, "%s fake irq handler: %d->%d\n",
+		dev_data->irq_name, dev_data->isr_on,
+		!dev_data->isr_on);
+
+	dev_data->isr_on = !(dev_data->isr_on);
+	if (dev_data->isr_on)
+		dev_data->ack_intr = 1;
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+DRIVER_ATTR(irq_handler_state, S_IWUSR, NULL, pcistub_irq_handler_switch);
+
+static ssize_t pcistub_quirk_add(struct device_driver *drv, const char *buf,
+				 size_t count)
+{
+	int domain, bus, slot, func, reg, size, mask;
+	int err;
+
+	err = str_to_quirk(buf, &domain, &bus, &slot, &func, &reg, &size,
+			   &mask);
+	if (err)
+		goto out;
+
+	err = pcistub_reg_add(domain, bus, slot, func, reg, size, mask);
+
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+
+static ssize_t pcistub_quirk_show(struct device_driver *drv, char *buf)
+{
+	int count = 0;
+	unsigned long flags;
+	struct pciback_config_quirk *quirk;
+	struct pciback_dev_data *dev_data;
+	const struct config_field *field;
+	const struct config_field_entry *cfg_entry;
+
+	spin_lock_irqsave(&device_ids_lock, flags);
+	list_for_each_entry(quirk, &pciback_quirks, quirks_list) {
+		if (count >= PAGE_SIZE)
+			goto out;
+
+		count += scnprintf(buf + count, PAGE_SIZE - count,
+				   "%02x:%02x.%01x\n\t%04x:%04x:%04x:%04x\n",
+				   quirk->pdev->bus->number,
+				   PCI_SLOT(quirk->pdev->devfn),
+				   PCI_FUNC(quirk->pdev->devfn),
+				   quirk->devid.vendor, quirk->devid.device,
+				   quirk->devid.subvendor,
+				   quirk->devid.subdevice);
+
+		dev_data = pci_get_drvdata(quirk->pdev);
+
+		list_for_each_entry(cfg_entry, &dev_data->config_fields, list) {
+			field = cfg_entry->field;
+			if (count >= PAGE_SIZE)
+				goto out;
+
+			count += scnprintf(buf + count, PAGE_SIZE - count,
+					   "\t\t%08x:%01x:%08x\n",
+					   cfg_entry->base_offset +
+					   field->offset, field->size,
+					   field->mask);
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&device_ids_lock, flags);
+
+	return count;
+}
+
+DRIVER_ATTR(quirks, S_IRUSR | S_IWUSR, pcistub_quirk_show, pcistub_quirk_add);
+
+static ssize_t permissive_add(struct device_driver *drv, const char *buf,
+			      size_t count)
+{
+	int domain, bus, slot, func;
+	int err;
+	struct pcistub_device *psdev;
+	struct pciback_dev_data *dev_data;
+	err = str_to_slot(buf, &domain, &bus, &slot, &func);
+	if (err)
+		goto out;
+	psdev = pcistub_device_find(domain, bus, slot, func);
+	if (!psdev) {
+		err = -ENODEV;
+		goto out;
+	}
+	if (!psdev->dev) {
+		err = -ENODEV;
+		goto release;
+	}
+	dev_data = pci_get_drvdata(psdev->dev);
+	/* the driver data for a device should never be null at this point */
+	if (!dev_data) {
+		err = -ENXIO;
+		goto release;
+	}
+	if (!dev_data->permissive) {
+		dev_data->permissive = 1;
+		/* Let user know that what they're doing could be unsafe */
+		dev_warn(&psdev->dev->dev, "enabling permissive mode "
+			 "configuration space accesses!\n");
+		dev_warn(&psdev->dev->dev,
+			 "permissive mode is potentially unsafe!\n");
+	}
+release:
+	pcistub_device_put(psdev);
+out:
+	if (!err)
+		err = count;
+	return err;
+}
+
+static ssize_t permissive_show(struct device_driver *drv, char *buf)
+{
+	struct pcistub_device *psdev;
+	struct pciback_dev_data *dev_data;
+	size_t count = 0;
+	unsigned long flags;
+	spin_lock_irqsave(&pcistub_devices_lock, flags);
+	list_for_each_entry(psdev, &pcistub_devices, dev_list) {
+		if (count >= PAGE_SIZE)
+			break;
+		if (!psdev->dev)
+			continue;
+		dev_data = pci_get_drvdata(psdev->dev);
+		if (!dev_data || !dev_data->permissive)
+			continue;
+		count +=
+		    scnprintf(buf + count, PAGE_SIZE - count, "%s\n",
+			      pci_name(psdev->dev));
+	}
+	spin_unlock_irqrestore(&pcistub_devices_lock, flags);
+	return count;
+}
+
+DRIVER_ATTR(permissive, S_IRUSR | S_IWUSR, permissive_show, permissive_add);
+
+static void pcistub_exit(void)
+{
+	driver_remove_file(&pciback_pci_driver.driver, &driver_attr_new_slot);
+	driver_remove_file(&pciback_pci_driver.driver,
+			   &driver_attr_remove_slot);
+	driver_remove_file(&pciback_pci_driver.driver, &driver_attr_slots);
+	driver_remove_file(&pciback_pci_driver.driver, &driver_attr_quirks);
+	driver_remove_file(&pciback_pci_driver.driver, &driver_attr_permissive);
+	driver_remove_file(&pciback_pci_driver.driver,
+			   &driver_attr_irq_handlers);
+	driver_remove_file(&pciback_pci_driver.driver,
+			   &driver_attr_irq_handler_state);
+	pci_unregister_driver(&pciback_pci_driver);
+}
+
+static int __init pcistub_init(void)
+{
+	int pos = 0;
+	int err = 0;
+	int domain, bus, slot, func;
+	int parsed;
+
+	if (pci_devs_to_hide && *pci_devs_to_hide) {
+		do {
+			parsed = 0;
+
+			err = sscanf(pci_devs_to_hide + pos,
+				     " (%x:%x:%x.%x) %n",
+				     &domain, &bus, &slot, &func, &parsed);
+			if (err != 4) {
+				domain = 0;
+				err = sscanf(pci_devs_to_hide + pos,
+					     " (%x:%x.%x) %n",
+					     &bus, &slot, &func, &parsed);
+				if (err != 3)
+					goto parse_error;
+			}
+
+			err = pcistub_device_id_add(domain, bus, slot, func);
+			if (err)
+				goto out;
+
+			/* if parsed<=0, we've reached the end of the string */
+			pos += parsed;
+		} while (parsed > 0 && pci_devs_to_hide[pos]);
+	}
+
+	/* If we're the first PCI Device Driver to register, we're the
+	 * first one to get offered PCI devices as they become
+	 * available (and thus we can be the first to grab them)
+	 */
+	err = pci_register_driver(&pciback_pci_driver);
+	if (err < 0)
+		goto out;
+
+	err = driver_create_file(&pciback_pci_driver.driver,
+				 &driver_attr_new_slot);
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					 &driver_attr_remove_slot);
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					 &driver_attr_slots);
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					 &driver_attr_quirks);
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					 &driver_attr_permissive);
+
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					 &driver_attr_irq_handlers);
+	if (!err)
+		err = driver_create_file(&pciback_pci_driver.driver,
+					&driver_attr_irq_handler_state);
+	if (err)
+		pcistub_exit();
+
+out:
+	return err;
+
+parse_error:
+	printk(KERN_ERR "pciback: Error parsing pci_devs_to_hide at \"%s\"\n",
+	       pci_devs_to_hide + pos);
+	return -EINVAL;
+}
+
+#ifndef MODULE
+/*
+ * fs_initcall happens before device_initcall
+ * so pciback *should* get called first (b/c we
+ * want to suck up any device before other drivers
+ * get a chance by being the first pci device
+ * driver to register)
+ */
+fs_initcall(pcistub_init);
+#endif
+
+static int __init pciback_init(void)
+{
+	int err;
+
+	if (!xen_initial_domain())
+		return -ENODEV;
+
+	err = pciback_config_init();
+	if (err)
+		return err;
+
+#ifdef MODULE
+	err = pcistub_init();
+	if (err < 0)
+		return err;
+#endif
+
+	pcistub_init_devices_late();
+	err = pciback_xenbus_register();
+	if (err)
+		pcistub_exit();
+
+	return err;
+}
+
+static void __exit pciback_cleanup(void)
+{
+	pciback_xenbus_unregister();
+	pcistub_exit();
+}
+
+module_init(pciback_init);
+module_exit(pciback_cleanup);
+
+MODULE_LICENSE("Dual BSD/GPL");
diff --git a/drivers/xen/pciback/pciback.h b/drivers/xen/pciback/pciback.h
new file mode 100644
index 0000000..fc31052
--- /dev/null
+++ b/drivers/xen/pciback/pciback.h
@@ -0,0 +1,142 @@
+/*
+ * PCI Backend Common Data Structures & Function Declarations
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#ifndef __XEN_PCIBACK_H__
+#define __XEN_PCIBACK_H__
+
+#include <linux/pci.h>
+#include <linux/interrupt.h>
+#include <xen/xenbus.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/workqueue.h>
+#include <asm/atomic.h>
+#include <xen/interface/io/pciif.h>
+
+struct pci_dev_entry {
+	struct list_head list;
+	struct pci_dev *dev;
+};
+
+#define _PDEVF_op_active 	(0)
+#define PDEVF_op_active 	(1<<(_PDEVF_op_active))
+#define _PCIB_op_pending	(1)
+#define PCIB_op_pending		(1<<(_PCIB_op_pending))
+
+struct pciback_device {
+	void *pci_dev_data;
+	spinlock_t dev_lock;
+
+	struct xenbus_device *xdev;
+
+	struct xenbus_watch be_watch;
+	u8 be_watching;
+
+	int evtchn_irq;
+
+	struct xen_pci_sharedinfo *sh_info;
+
+	unsigned long flags;
+
+	struct work_struct op_work;
+};
+
+struct pciback_dev_data {
+	struct list_head config_fields;
+	unsigned int permissive : 1;
+	unsigned int warned_on_write : 1;
+	unsigned int enable_intx : 1;
+	unsigned int isr_on : 1; /* Whether the IRQ handler is installed. */ 
+	unsigned int ack_intr : 1; /* .. and ACK-ing */
+	unsigned long handled;
+	unsigned int irq; /* Saved in case device transitions to MSI/MSI-X */
+	char irq_name[0]; /* pciback[000:04:00.0] */
+};
+
+/* Used by XenBus and pciback_ops.c */
+extern wait_queue_head_t aer_wait_queue;
+extern struct workqueue_struct *pciback_wq;
+/* Used by pcistub.c and conf_space_quirks.c */
+extern struct list_head pciback_quirks;
+
+/* Get/Put PCI Devices that are hidden from the PCI Backend Domain */
+struct pci_dev *pcistub_get_pci_dev_by_slot(struct pciback_device *pdev,
+					    int domain, int bus,
+					    int slot, int func);
+struct pci_dev *pcistub_get_pci_dev(struct pciback_device *pdev,
+				    struct pci_dev *dev);
+void pcistub_put_pci_dev(struct pci_dev *dev);
+
+/* Ensure a device is turned off or reset */
+void pciback_reset_device(struct pci_dev *pdev);
+
+/* Access a virtual configuration space for a PCI device */
+int pciback_config_init(void);
+int pciback_config_init_dev(struct pci_dev *dev);
+void pciback_config_free_dyn_fields(struct pci_dev *dev);
+void pciback_config_reset_dev(struct pci_dev *dev);
+void pciback_config_free_dev(struct pci_dev *dev);
+int pciback_config_read(struct pci_dev *dev, int offset, int size,
+			u32 *ret_val);
+int pciback_config_write(struct pci_dev *dev, int offset, int size, u32 value);
+
+/* Handle requests for specific devices from the frontend */
+typedef int (*publish_pci_dev_cb) (struct pciback_device *pdev,
+				   unsigned int domain, unsigned int bus,
+				   unsigned int devfn, unsigned int devid);
+typedef int (*publish_pci_root_cb) (struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus);
+int pciback_add_pci_dev(struct pciback_device *pdev, struct pci_dev *dev,
+			int devid, publish_pci_dev_cb publish_cb);
+void pciback_release_pci_dev(struct pciback_device *pdev, struct pci_dev *dev);
+struct pci_dev *pciback_get_pci_dev(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus,
+				    unsigned int devfn);
+
+/**
+* Add for domain0 PCIE-AER handling. Get guest domain/bus/devfn in pciback
+* before sending aer request to pcifront, so that guest could identify
+* device, coopearte with pciback to finish aer recovery job if device driver
+* has the capability
+*/
+
+int pciback_get_pcifront_dev(struct pci_dev *pcidev,
+			     struct pciback_device *pdev,
+			     unsigned int *domain, unsigned int *bus,
+			     unsigned int *devfn);
+int pciback_init_devices(struct pciback_device *pdev);
+int pciback_publish_pci_roots(struct pciback_device *pdev,
+			      publish_pci_root_cb cb);
+void pciback_release_devices(struct pciback_device *pdev);
+
+/* Handles events from front-end */
+irqreturn_t pciback_handle_event(int irq, void *dev_id);
+void pciback_do_op(struct work_struct *data);
+
+int pciback_xenbus_register(void);
+void pciback_xenbus_unregister(void);
+
+#ifdef CONFIG_PCI_MSI
+int pciback_enable_msi(struct pciback_device *pdev,
+			struct pci_dev *dev, struct xen_pci_op *op);
+
+int pciback_disable_msi(struct pciback_device *pdev,
+			struct pci_dev *dev, struct xen_pci_op *op);
+
+
+int pciback_enable_msix(struct pciback_device *pdev,
+			struct pci_dev *dev, struct xen_pci_op *op);
+
+int pciback_disable_msix(struct pciback_device *pdev,
+			struct pci_dev *dev, struct xen_pci_op *op);
+#endif
+extern int verbose_request;
+
+void test_and_schedule_op(struct pciback_device *pdev);
+#endif
+
+/* Handles shared IRQs that can to device domain and control domain. */
+void pciback_irq_handler(struct pci_dev *dev, int reset);
+irqreturn_t pciback_guest_interrupt(int irq, void *dev_id);
diff --git a/drivers/xen/pciback/pciback_ops.c b/drivers/xen/pciback/pciback_ops.c
new file mode 100644
index 0000000..5543881
--- /dev/null
+++ b/drivers/xen/pciback/pciback_ops.c
@@ -0,0 +1,242 @@
+/*
+ * PCI Backend Operations - respond to PCI requests from Frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/wait.h>
+#include <linux/bitops.h>
+#include <xen/events.h>
+#include <linux/sched.h>
+#include "pciback.h"
+
+int verbose_request;
+module_param(verbose_request, int, 0644);
+
+/* Ensure a device is has the fake IRQ handler "turned on/off" and is
+ * ready to be exported. This MUST be run after pciback_reset_device
+ * which does the actual PCI device enable/disable.
+ */
+void pciback_control_isr(struct pci_dev *dev, int reset)
+{
+	struct pciback_dev_data *dev_data;
+	int rc;
+	int enable = 0;
+
+	dev_data = pci_get_drvdata(dev);
+	if (!dev_data)
+		return;
+
+	/* We don't deal with bridges */
+	if (dev->hdr_type != PCI_HEADER_TYPE_NORMAL)
+		return;
+
+	if (reset) {
+		dev_data->enable_intx = 0;
+		dev_data->ack_intr = 0;
+	}
+	enable =  dev_data->enable_intx;
+
+	/* Asked to disable, but ISR isn't runnig */
+	if (!enable && !dev_data->isr_on)
+		return;
+
+	/* Squirrel away the IRQs in the dev_data. We need this
+	 * b/c when device transitions to MSI, the dev->irq is
+	 * overwritten with the MSI vector.
+	 */
+	if (enable)
+		dev_data->irq = dev->irq;
+
+	dev_dbg(&dev->dev, "%s: #%d %s %s%s %s-> %s\n",
+		dev_data->irq_name,
+		dev_data->irq,
+		pci_is_enabled(dev) ? "on" : "off",
+		dev->msi_enabled ? "MSI" : "",
+		dev->msix_enabled ? "MSI/X" : "",
+		dev_data->isr_on ? "enable" : "disable",
+		enable ? "enable" : "disable");
+
+	if (enable) {
+		rc = request_irq(dev_data->irq,
+				pciback_guest_interrupt, IRQF_SHARED,
+				dev_data->irq_name, dev);
+		if (rc) {
+			dev_err(&dev->dev, "%s: failed to install fake IRQ " \
+				"handler for IRQ %d! (rc:%d)\n", dev_data->irq_name,
+				dev_data->irq, rc);
+			goto out;
+		}
+	}
+	else {
+		free_irq(dev_data->irq, dev);
+		dev_data->irq = 0;
+	}
+	dev_data->isr_on = enable;
+	dev_data->ack_intr = enable;
+out:
+	dev_dbg(&dev->dev, "%s: #%d %s %s%s %s\n",
+		dev_data->irq_name,
+		dev_data->irq,
+		pci_is_enabled(dev) ? "on" : "off",
+		dev->msi_enabled ? "MSI" : "",
+		dev->msix_enabled ? "MSI/X" : "",
+		enable ? (dev_data->isr_on ? "enabled" : "failed to enable") :
+			(dev_data->isr_on ? "failed to disable" : "disabled"));
+}
+
+/* Ensure a device is "turned off" and ready to be exported.
+ * (Also see pciback_config_reset to ensure virtual configuration space is
+ * ready to be re-exported)
+ */
+void pciback_reset_device(struct pci_dev *dev)
+{
+	u16 cmd;
+
+	pciback_control_isr(dev, 1 /* reset device */);
+
+	/* Disable devices (but not bridges) */
+	if (dev->hdr_type == PCI_HEADER_TYPE_NORMAL) {
+#ifdef CONFIG_PCI_MSI
+		/* The guest could have been abruptly killed without
+		 * disabling MSI/MSI-X interrupts.*/
+		if (dev->msix_enabled)
+			pci_disable_msix(dev);
+		if (dev->msi_enabled)
+			pci_disable_msi(dev);
+#endif
+		pci_disable_device(dev);
+
+		pci_write_config_word(dev, PCI_COMMAND, 0);
+
+		dev->is_busmaster = 0;
+	} else {
+		pci_read_config_word(dev, PCI_COMMAND, &cmd);
+		if (cmd & (PCI_COMMAND_INVALIDATE)) {
+			cmd &= ~(PCI_COMMAND_INVALIDATE);
+			pci_write_config_word(dev, PCI_COMMAND, cmd);
+
+			dev->is_busmaster = 0;
+		}
+	}
+}
+/*
+* Now the same evtchn is used for both pcifront conf_read_write request
+* as well as pcie aer front end ack. We use a new work_queue to schedule
+* pciback conf_read_write service for avoiding confict with aer_core
+* do_recovery job which also use the system default work_queue
+*/
+void test_and_schedule_op(struct pciback_device *pdev)
+{
+	/* Check that frontend is requesting an operation and that we are not
+	 * already processing a request */
+	if (test_bit(_XEN_PCIF_active, (unsigned long *)&pdev->sh_info->flags)
+	    && !test_and_set_bit(_PDEVF_op_active, &pdev->flags)) {
+		queue_work(pciback_wq, &pdev->op_work);
+	}
+	/*_XEN_PCIB_active should have been cleared by pcifront. And also make
+	sure pciback is waiting for ack by checking _PCIB_op_pending*/
+	if (!test_bit(_XEN_PCIB_active, (unsigned long *)&pdev->sh_info->flags)
+	    && test_bit(_PCIB_op_pending, &pdev->flags)) {
+		wake_up(&aer_wait_queue);
+	}
+}
+
+/* Performing the configuration space reads/writes must not be done in atomic
+ * context because some of the pci_* functions can sleep (mostly due to ACPI
+ * use of semaphores). This function is intended to be called from a work
+ * queue in process context taking a struct pciback_device as a parameter */
+
+void pciback_do_op(struct work_struct *data)
+{
+	struct pciback_device *pdev =
+		container_of(data, struct pciback_device, op_work);
+	struct pci_dev *dev;
+	struct pciback_dev_data *dev_data = NULL;
+	struct xen_pci_op *op = &pdev->sh_info->op;
+	int test_intx = 0;
+
+	dev = pciback_get_pci_dev(pdev, op->domain, op->bus, op->devfn);
+
+	if (dev == NULL)
+		op->err = XEN_PCI_ERR_dev_not_found;
+	else {
+		dev_data = pci_get_drvdata(dev);
+		if (dev_data)
+			test_intx = dev_data->enable_intx;
+		switch (op->cmd) {
+		case XEN_PCI_OP_conf_read:
+			op->err = pciback_config_read(dev,
+				  op->offset, op->size, &op->value);
+			break;
+		case XEN_PCI_OP_conf_write:
+			op->err = pciback_config_write(dev,
+				  op->offset, op->size,	op->value);
+			break;
+#ifdef CONFIG_PCI_MSI
+		case XEN_PCI_OP_enable_msi:
+			op->err = pciback_enable_msi(pdev, dev, op);
+			break;
+		case XEN_PCI_OP_disable_msi:
+			op->err = pciback_disable_msi(pdev, dev, op);
+			break;
+		case XEN_PCI_OP_enable_msix:
+			op->err = pciback_enable_msix(pdev, dev, op);
+			break;
+		case XEN_PCI_OP_disable_msix:
+			op->err = pciback_disable_msix(pdev, dev, op);
+			break;
+#endif
+		default:
+			op->err = XEN_PCI_ERR_not_implemented;	
+			break;
+		}
+	}
+	if (!op->err && dev && dev_data) {
+		/* Transition detected */
+		if ((dev_data->enable_intx != test_intx))
+			pciback_control_isr(dev, 0 /* no reset */);
+	}
+	/* Tell the driver domain that we're done. */
+	wmb();
+	clear_bit(_XEN_PCIF_active, (unsigned long *)&pdev->sh_info->flags);
+	notify_remote_via_irq(pdev->evtchn_irq);
+
+	/* Mark that we're done. */
+	smp_mb__before_clear_bit(); /* /after/ clearing PCIF_active */
+	clear_bit(_PDEVF_op_active, &pdev->flags);
+	smp_mb__after_clear_bit(); /* /before/ final check for work */
+
+	/* Check to see if the driver domain tried to start another request in
+	 * between clearing _XEN_PCIF_active and clearing _PDEVF_op_active.
+	*/
+	test_and_schedule_op(pdev);
+}
+
+irqreturn_t pciback_handle_event(int irq, void *dev_id)
+{
+	struct pciback_device *pdev = dev_id;
+
+	test_and_schedule_op(pdev);
+
+	return IRQ_HANDLED;
+}
+irqreturn_t pciback_guest_interrupt(int irq, void *dev_id)
+{
+	struct pci_dev *dev = (struct pci_dev *)dev_id;
+	struct pciback_dev_data *dev_data = pci_get_drvdata(dev);
+
+	if (dev_data->isr_on && dev_data->ack_intr) {
+		dev_data->handled++;
+		if ((dev_data->handled % 1000) == 0) {
+			if (xen_ignore_irq(irq)) {
+				printk(KERN_INFO "%s IRQ line is not shared "
+					"with other domains. Turning ISR off\n",
+					 dev_data->irq_name);
+				dev_data->ack_intr = 0;
+			}
+		}
+		return IRQ_HANDLED;
+	}
+	return IRQ_NONE;
+}
diff --git a/drivers/xen/pciback/slot.c b/drivers/xen/pciback/slot.c
new file mode 100644
index 0000000..efb922d
--- /dev/null
+++ b/drivers/xen/pciback/slot.c
@@ -0,0 +1,191 @@
+/*
+ * PCI Backend - Provides a Virtual PCI bus (with real devices)
+ *               to the frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil> (vpci.c)
+ *   Author: Tristan Gingold <tristan.gingold@bull.net>, from vpci.c
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include "pciback.h"
+
+/* There are at most 32 slots in a pci bus.  */
+#define PCI_SLOT_MAX 32
+
+#define PCI_BUS_NBR 2
+
+struct slot_dev_data {
+	/* Access to dev_list must be protected by lock */
+	struct pci_dev *slots[PCI_BUS_NBR][PCI_SLOT_MAX];
+	spinlock_t lock;
+};
+
+struct pci_dev *pciback_get_pci_dev(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus,
+				    unsigned int devfn)
+{
+	struct pci_dev *dev = NULL;
+	struct slot_dev_data *slot_dev = pdev->pci_dev_data;
+	unsigned long flags;
+
+	if (domain != 0 || PCI_FUNC(devfn) != 0)
+		return NULL;
+
+	if (PCI_SLOT(devfn) >= PCI_SLOT_MAX || bus >= PCI_BUS_NBR)
+		return NULL;
+
+	spin_lock_irqsave(&slot_dev->lock, flags);
+	dev = slot_dev->slots[bus][PCI_SLOT(devfn)];
+	spin_unlock_irqrestore(&slot_dev->lock, flags);
+
+	return dev;
+}
+
+int pciback_add_pci_dev(struct pciback_device *pdev, struct pci_dev *dev,
+			int devid, publish_pci_dev_cb publish_cb)
+{
+	int err = 0, slot, bus;
+	struct slot_dev_data *slot_dev = pdev->pci_dev_data;
+	unsigned long flags;
+
+	if ((dev->class >> 24) == PCI_BASE_CLASS_BRIDGE) {
+		err = -EFAULT;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Can't export bridges on the virtual PCI bus");
+		goto out;
+	}
+
+	spin_lock_irqsave(&slot_dev->lock, flags);
+
+	/* Assign to a new slot on the virtual PCI bus */
+	for (bus = 0; bus < PCI_BUS_NBR; bus++)
+		for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+			if (slot_dev->slots[bus][slot] == NULL) {
+				printk(KERN_INFO
+				       "pciback: slot: %s: assign to virtual "
+				       "slot %d, bus %d\n",
+				       pci_name(dev), slot, bus);
+				slot_dev->slots[bus][slot] = dev;
+				goto unlock;
+			}
+		}
+
+	err = -ENOMEM;
+	xenbus_dev_fatal(pdev->xdev, err,
+			 "No more space on root virtual PCI bus");
+
+unlock:
+	spin_unlock_irqrestore(&slot_dev->lock, flags);
+
+	/* Publish this device. */
+	if (!err)
+		err = publish_cb(pdev, 0, 0, PCI_DEVFN(slot, 0), devid);
+
+out:
+	return err;
+}
+
+void pciback_release_pci_dev(struct pciback_device *pdev, struct pci_dev *dev)
+{
+	int slot, bus;
+	struct slot_dev_data *slot_dev = pdev->pci_dev_data;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&slot_dev->lock, flags);
+
+	for (bus = 0; bus < PCI_BUS_NBR; bus++)
+		for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+			if (slot_dev->slots[bus][slot] == dev) {
+				slot_dev->slots[bus][slot] = NULL;
+				found_dev = dev;
+				goto out;
+			}
+		}
+
+out:
+	spin_unlock_irqrestore(&slot_dev->lock, flags);
+
+	if (found_dev)
+		pcistub_put_pci_dev(found_dev);
+}
+
+int pciback_init_devices(struct pciback_device *pdev)
+{
+	int slot, bus;
+	struct slot_dev_data *slot_dev;
+
+	slot_dev = kmalloc(sizeof(*slot_dev), GFP_KERNEL);
+	if (!slot_dev)
+		return -ENOMEM;
+
+	spin_lock_init(&slot_dev->lock);
+
+	for (bus = 0; bus < PCI_BUS_NBR; bus++)
+		for (slot = 0; slot < PCI_SLOT_MAX; slot++)
+			slot_dev->slots[bus][slot] = NULL;
+
+	pdev->pci_dev_data = slot_dev;
+
+	return 0;
+}
+
+int pciback_publish_pci_roots(struct pciback_device *pdev,
+			      publish_pci_root_cb publish_cb)
+{
+	/* The Virtual PCI bus has only one root */
+	return publish_cb(pdev, 0, 0);
+}
+
+void pciback_release_devices(struct pciback_device *pdev)
+{
+	int slot, bus;
+	struct slot_dev_data *slot_dev = pdev->pci_dev_data;
+	struct pci_dev *dev;
+
+	for (bus = 0; bus < PCI_BUS_NBR; bus++)
+		for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+			dev = slot_dev->slots[bus][slot];
+			if (dev != NULL)
+				pcistub_put_pci_dev(dev);
+		}
+
+	kfree(slot_dev);
+	pdev->pci_dev_data = NULL;
+}
+
+int pciback_get_pcifront_dev(struct pci_dev *pcidev,
+			     struct pciback_device *pdev,
+			     unsigned int *domain, unsigned int *bus,
+			     unsigned int *devfn)
+{
+	int slot, busnr;
+	struct slot_dev_data *slot_dev = pdev->pci_dev_data;
+	struct pci_dev *dev;
+	int found = 0;
+	unsigned long flags;
+
+	spin_lock_irqsave(&slot_dev->lock, flags);
+
+	for (busnr = 0; busnr < PCI_BUS_NBR; bus++)
+		for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+			dev = slot_dev->slots[busnr][slot];
+			if (dev && dev->bus->number == pcidev->bus->number
+				&& dev->devfn == pcidev->devfn
+				&& pci_domain_nr(dev->bus) ==
+					pci_domain_nr(pcidev->bus)) {
+				found = 1;
+				*domain = 0;
+				*bus = busnr;
+				*devfn = PCI_DEVFN(slot, 0);
+				goto out;
+			}
+		}
+out:
+	spin_unlock_irqrestore(&slot_dev->lock, flags);
+	return found;
+
+}
diff --git a/drivers/xen/pciback/vpci.c b/drivers/xen/pciback/vpci.c
new file mode 100644
index 0000000..2857ab8
--- /dev/null
+++ b/drivers/xen/pciback/vpci.c
@@ -0,0 +1,244 @@
+/*
+ * PCI Backend - Provides a Virtual PCI bus (with real devices)
+ *               to the frontend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/pci.h>
+#include <linux/spinlock.h>
+#include "pciback.h"
+
+#define PCI_SLOT_MAX 32
+
+struct vpci_dev_data {
+	/* Access to dev_list must be protected by lock */
+	struct list_head dev_list[PCI_SLOT_MAX];
+	spinlock_t lock;
+};
+
+static inline struct list_head *list_first(struct list_head *head)
+{
+	return head->next;
+}
+
+struct pci_dev *pciback_get_pci_dev(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus,
+				    unsigned int devfn)
+{
+	struct pci_dev_entry *entry;
+	struct pci_dev *dev = NULL;
+	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
+	unsigned long flags;
+
+	if (domain != 0 || bus != 0)
+		return NULL;
+
+	if (PCI_SLOT(devfn) < PCI_SLOT_MAX) {
+		spin_lock_irqsave(&vpci_dev->lock, flags);
+
+		list_for_each_entry(entry,
+				    &vpci_dev->dev_list[PCI_SLOT(devfn)],
+				    list) {
+			if (PCI_FUNC(entry->dev->devfn) == PCI_FUNC(devfn)) {
+				dev = entry->dev;
+				break;
+			}
+		}
+
+		spin_unlock_irqrestore(&vpci_dev->lock, flags);
+	}
+	return dev;
+}
+
+static inline int match_slot(struct pci_dev *l, struct pci_dev *r)
+{
+	if (pci_domain_nr(l->bus) == pci_domain_nr(r->bus)
+	    && l->bus == r->bus && PCI_SLOT(l->devfn) == PCI_SLOT(r->devfn))
+		return 1;
+
+	return 0;
+}
+
+int pciback_add_pci_dev(struct pciback_device *pdev, struct pci_dev *dev,
+			int devid, publish_pci_dev_cb publish_cb)
+{
+	int err = 0, slot, func = -1;
+	struct pci_dev_entry *t, *dev_entry;
+	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
+	unsigned long flags;
+
+	if ((dev->class >> 24) == PCI_BASE_CLASS_BRIDGE) {
+		err = -EFAULT;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Can't export bridges on the virtual PCI bus");
+		goto out;
+	}
+
+	dev_entry = kmalloc(sizeof(*dev_entry), GFP_KERNEL);
+	if (!dev_entry) {
+		err = -ENOMEM;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error adding entry to virtual PCI bus");
+		goto out;
+	}
+
+	dev_entry->dev = dev;
+
+	spin_lock_irqsave(&vpci_dev->lock, flags);
+
+	/* Keep multi-function devices together on the virtual PCI bus */
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+		if (!list_empty(&vpci_dev->dev_list[slot])) {
+			t = list_entry(list_first(&vpci_dev->dev_list[slot]),
+				       struct pci_dev_entry, list);
+
+			if (match_slot(dev, t->dev)) {
+				pr_info("pciback: vpci: %s: "
+					"assign to virtual slot %d func %d\n",
+					pci_name(dev), slot,
+					PCI_FUNC(dev->devfn));
+				list_add_tail(&dev_entry->list,
+					      &vpci_dev->dev_list[slot]);
+				func = PCI_FUNC(dev->devfn);
+				goto unlock;
+			}
+		}
+	}
+
+	/* Assign to a new slot on the virtual PCI bus */
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+		if (list_empty(&vpci_dev->dev_list[slot])) {
+			printk(KERN_INFO
+			       "pciback: vpci: %s: assign to virtual slot %d\n",
+			       pci_name(dev), slot);
+			list_add_tail(&dev_entry->list,
+				      &vpci_dev->dev_list[slot]);
+			func = PCI_FUNC(dev->devfn);
+			goto unlock;
+		}
+	}
+
+	err = -ENOMEM;
+	xenbus_dev_fatal(pdev->xdev, err,
+			 "No more space on root virtual PCI bus");
+
+unlock:
+	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+
+	/* Publish this device. */
+	if (!err)
+		err = publish_cb(pdev, 0, 0, PCI_DEVFN(slot, func), devid);
+
+out:
+	return err;
+}
+
+void pciback_release_pci_dev(struct pciback_device *pdev, struct pci_dev *dev)
+{
+	int slot;
+	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
+	struct pci_dev *found_dev = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&vpci_dev->lock, flags);
+
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+		struct pci_dev_entry *e, *tmp;
+		list_for_each_entry_safe(e, tmp, &vpci_dev->dev_list[slot],
+					 list) {
+			if (e->dev == dev) {
+				list_del(&e->list);
+				found_dev = e->dev;
+				kfree(e);
+				goto out;
+			}
+		}
+	}
+
+out:
+	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+
+	if (found_dev)
+		pcistub_put_pci_dev(found_dev);
+}
+
+int pciback_init_devices(struct pciback_device *pdev)
+{
+	int slot;
+	struct vpci_dev_data *vpci_dev;
+
+	vpci_dev = kmalloc(sizeof(*vpci_dev), GFP_KERNEL);
+	if (!vpci_dev)
+		return -ENOMEM;
+
+	spin_lock_init(&vpci_dev->lock);
+
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++)
+		INIT_LIST_HEAD(&vpci_dev->dev_list[slot]);
+
+	pdev->pci_dev_data = vpci_dev;
+
+	return 0;
+}
+
+int pciback_publish_pci_roots(struct pciback_device *pdev,
+			      publish_pci_root_cb publish_cb)
+{
+	/* The Virtual PCI bus has only one root */
+	return publish_cb(pdev, 0, 0);
+}
+
+void pciback_release_devices(struct pciback_device *pdev)
+{
+	int slot;
+	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
+
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+		struct pci_dev_entry *e, *tmp;
+		list_for_each_entry_safe(e, tmp, &vpci_dev->dev_list[slot],
+					 list) {
+			list_del(&e->list);
+			pcistub_put_pci_dev(e->dev);
+			kfree(e);
+		}
+	}
+
+	kfree(vpci_dev);
+	pdev->pci_dev_data = NULL;
+}
+
+int pciback_get_pcifront_dev(struct pci_dev *pcidev,
+			     struct pciback_device *pdev,
+			     unsigned int *domain, unsigned int *bus,
+			     unsigned int *devfn)
+{
+	struct pci_dev_entry *entry;
+	struct pci_dev *dev = NULL;
+	struct vpci_dev_data *vpci_dev = pdev->pci_dev_data;
+	unsigned long flags;
+	int found = 0, slot;
+
+	spin_lock_irqsave(&vpci_dev->lock, flags);
+	for (slot = 0; slot < PCI_SLOT_MAX; slot++) {
+		list_for_each_entry(entry,
+			    &vpci_dev->dev_list[slot],
+			    list) {
+			dev = entry->dev;
+			if (dev && dev->bus->number == pcidev->bus->number
+				&& pci_domain_nr(dev->bus) ==
+					pci_domain_nr(pcidev->bus)
+				&& dev->devfn == pcidev->devfn) {
+				found = 1;
+				*domain = 0;
+				*bus = 0;
+				*devfn = PCI_DEVFN(slot,
+					 PCI_FUNC(pcidev->devfn));
+			}
+		}
+	}
+	spin_unlock_irqrestore(&vpci_dev->lock, flags);
+	return found;
+}
diff --git a/drivers/xen/pciback/xenbus.c b/drivers/xen/pciback/xenbus.c
new file mode 100644
index 0000000..993b659
--- /dev/null
+++ b/drivers/xen/pciback/xenbus.c
@@ -0,0 +1,726 @@
+/*
+ * PCI Backend Xenbus Setup - handles setup with frontend and xend
+ *
+ *   Author: Ryan Wilson <hap9@epoch.ncsc.mil>
+ */
+#include <linux/module.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/vmalloc.h>
+#include <linux/workqueue.h>
+#include <xen/xenbus.h>
+#include <xen/events.h>
+#include <asm/xen/pci.h>
+#include <linux/workqueue.h>
+#include "pciback.h"
+
+#define INVALID_EVTCHN_IRQ  (-1)
+struct workqueue_struct *pciback_wq;
+
+static struct pciback_device *alloc_pdev(struct xenbus_device *xdev)
+{
+	struct pciback_device *pdev;
+
+	pdev = kzalloc(sizeof(struct pciback_device), GFP_KERNEL);
+	if (pdev == NULL)
+		goto out;
+	dev_dbg(&xdev->dev, "allocated pdev @ 0x%p\n", pdev);
+
+	pdev->xdev = xdev;
+	dev_set_drvdata(&xdev->dev, pdev);
+
+	spin_lock_init(&pdev->dev_lock);
+
+	pdev->sh_info = NULL;
+	pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
+	pdev->be_watching = 0;
+
+	INIT_WORK(&pdev->op_work, pciback_do_op);
+
+	if (pciback_init_devices(pdev)) {
+		kfree(pdev);
+		pdev = NULL;
+	}
+out:
+	return pdev;
+}
+
+static void pciback_disconnect(struct pciback_device *pdev)
+{
+	spin_lock(&pdev->dev_lock);
+
+	/* Ensure the guest can't trigger our handler before removing devices */
+	if (pdev->evtchn_irq != INVALID_EVTCHN_IRQ) {
+		unbind_from_irqhandler(pdev->evtchn_irq, pdev);
+		pdev->evtchn_irq = INVALID_EVTCHN_IRQ;
+	}
+	spin_unlock(&pdev->dev_lock);
+
+	/* If the driver domain started an op, make sure we complete it
+	 * before releasing the shared memory */
+
+	/* Note, the workqueue does not use spinlocks at all.*/
+	flush_workqueue(pciback_wq);
+
+	spin_lock(&pdev->dev_lock);
+	if (pdev->sh_info != NULL) {
+		xenbus_unmap_ring_vfree(pdev->xdev, pdev->sh_info);
+		pdev->sh_info = NULL;
+	}
+	spin_unlock(&pdev->dev_lock);
+
+}
+
+static void free_pdev(struct pciback_device *pdev)
+{
+	if (pdev->be_watching) {
+		unregister_xenbus_watch(&pdev->be_watch);
+		pdev->be_watching = 0;
+	}
+
+	pciback_disconnect(pdev);
+
+	pciback_release_devices(pdev);
+
+	dev_set_drvdata(&pdev->xdev->dev, NULL);
+	pdev->xdev = NULL;
+
+	kfree(pdev);
+}
+
+static int pciback_do_attach(struct pciback_device *pdev, int gnt_ref,
+			     int remote_evtchn)
+{
+	int err = 0;
+	void *vaddr;
+
+	dev_dbg(&pdev->xdev->dev,
+		"Attaching to frontend resources - gnt_ref=%d evtchn=%d\n",
+		gnt_ref, remote_evtchn);
+
+	err = xenbus_map_ring_valloc(pdev->xdev, gnt_ref, &vaddr);
+	if (err < 0) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				"Error mapping other domain page in ours.");
+		goto out;
+	}
+
+	spin_lock(&pdev->dev_lock);
+	pdev->sh_info = vaddr;
+	spin_unlock(&pdev->dev_lock);
+
+	err = bind_interdomain_evtchn_to_irqhandler(
+		pdev->xdev->otherend_id, remote_evtchn, pciback_handle_event,
+		0, "pciback", pdev);
+	if (err < 0) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error binding event channel to IRQ");
+		goto out;
+	}
+
+	spin_lock(&pdev->dev_lock);
+	pdev->evtchn_irq = err;
+	spin_unlock(&pdev->dev_lock);
+	err = 0;
+
+	dev_dbg(&pdev->xdev->dev, "Attached!\n");
+out:
+	return err;
+}
+
+static int pciback_attach(struct pciback_device *pdev)
+{
+	int err = 0;
+	int gnt_ref, remote_evtchn;
+	char *magic = NULL;
+
+
+	/* Make sure we only do this setup once */
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateInitialised)
+		goto out;
+
+	/* Wait for frontend to state that it has published the configuration */
+	if (xenbus_read_driver_state(pdev->xdev->otherend) !=
+	    XenbusStateInitialised)
+		goto out;
+
+	dev_dbg(&pdev->xdev->dev, "Reading frontend config\n");
+
+	err = xenbus_gather(XBT_NIL, pdev->xdev->otherend,
+			    "pci-op-ref", "%u", &gnt_ref,
+			    "event-channel", "%u", &remote_evtchn,
+			    "magic", NULL, &magic, NULL);
+	if (err) {
+		/* If configuration didn't get read correctly, wait longer */
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading configuration from frontend");
+		goto out;
+	}
+
+	if (magic == NULL || strcmp(magic, XEN_PCI_MAGIC) != 0) {
+		xenbus_dev_fatal(pdev->xdev, -EFAULT,
+				 "version mismatch (%s/%s) with pcifront - "
+				 "halting pciback",
+				 magic, XEN_PCI_MAGIC);
+		goto out;
+	}
+
+	err = pciback_do_attach(pdev, gnt_ref, remote_evtchn);
+	if (err)
+		goto out;
+
+	dev_dbg(&pdev->xdev->dev, "Connecting...\n");
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateConnected);
+	if (err)
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error switching to connected state!");
+
+	dev_dbg(&pdev->xdev->dev, "Connected? %d\n", err);
+out:
+
+	kfree(magic);
+
+	return err;
+}
+
+static int pciback_publish_pci_dev(struct pciback_device *pdev,
+				   unsigned int domain, unsigned int bus,
+				   unsigned int devfn, unsigned int devid)
+{
+	int err;
+	int len;
+	char str[64];
+
+	len = snprintf(str, sizeof(str), "vdev-%d", devid);
+	if (unlikely(len >= (sizeof(str) - 1))) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
+			    "%04x:%02x:%02x.%02x", domain, bus,
+			    PCI_SLOT(devfn), PCI_FUNC(devfn));
+
+out:
+	return err;
+}
+
+static int pciback_export_device(struct pciback_device *pdev,
+				 int domain, int bus, int slot, int func,
+				 int devid)
+{
+	struct pci_dev *dev;
+	int err = 0;
+
+	dev_dbg(&pdev->xdev->dev, "exporting dom %x bus %x slot %x func %x\n",
+		domain, bus, slot, func);
+
+	dev = pcistub_get_pci_dev_by_slot(pdev, domain, bus, slot, func);
+	if (!dev) {
+		err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Couldn't locate PCI device "
+				 "(%04x:%02x:%02x.%01x)! "
+				 "perhaps already in-use?",
+				 domain, bus, slot, func);
+		goto out;
+	}
+
+	err = pciback_add_pci_dev(pdev, dev, devid, pciback_publish_pci_dev);
+	if (err)
+		goto out;
+
+	dev_dbg(&dev->dev, "registering for %d\n", pdev->xdev->otherend_id);
+	if (xen_register_device_domain_owner(dev,
+					     pdev->xdev->otherend_id) != 0) {
+		dev_err(&dev->dev, "device has been assigned to another " \
+			"domain! Over-writting the ownership, but beware.\n");
+		xen_unregister_device_domain_owner(dev);
+		xen_register_device_domain_owner(dev, pdev->xdev->otherend_id);
+	}
+
+	/* TODO: It'd be nice to export a bridge and have all of its children
+	 * get exported with it. This may be best done in xend (which will
+	 * have to calculate resource usage anyway) but we probably want to
+	 * put something in here to ensure that if a bridge gets given to a
+	 * driver domain, that all devices under that bridge are not given
+	 * to other driver domains (as he who controls the bridge can disable
+	 * it and stop the other devices from working).
+	 */
+out:
+	return err;
+}
+
+static int pciback_remove_device(struct pciback_device *pdev,
+				 int domain, int bus, int slot, int func)
+{
+	int err = 0;
+	struct pci_dev *dev;
+
+	dev_dbg(&pdev->xdev->dev, "removing dom %x bus %x slot %x func %x\n",
+		domain, bus, slot, func);
+
+	dev = pciback_get_pci_dev(pdev, domain, bus, PCI_DEVFN(slot, func));
+	if (!dev) {
+		err = -EINVAL;
+		dev_dbg(&pdev->xdev->dev, "Couldn't locate PCI device "
+			"(%04x:%02x:%02x.%01x)! not owned by this domain\n",
+			domain, bus, slot, func);
+		goto out;
+	}
+
+	dev_dbg(&dev->dev, "unregistering for %d\n", pdev->xdev->otherend_id);
+	xen_unregister_device_domain_owner(dev);
+
+	pciback_release_pci_dev(pdev, dev);
+
+out:
+	return err;
+}
+
+static int pciback_publish_pci_root(struct pciback_device *pdev,
+				    unsigned int domain, unsigned int bus)
+{
+	unsigned int d, b;
+	int i, root_num, len, err;
+	char str[64];
+
+	dev_dbg(&pdev->xdev->dev, "Publishing pci roots\n");
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+			   "root_num", "%d", &root_num);
+	if (err == 0 || err == -ENOENT)
+		root_num = 0;
+	else if (err < 0)
+		goto out;
+
+	/* Verify that we haven't already published this pci root */
+	for (i = 0; i < root_num; i++) {
+		len = snprintf(str, sizeof(str), "root-%d", i);
+		if (unlikely(len >= (sizeof(str) - 1))) {
+			err = -ENOMEM;
+			goto out;
+		}
+
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+				   str, "%x:%x", &d, &b);
+		if (err < 0)
+			goto out;
+		if (err != 2) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		if (d == domain && b == bus) {
+			err = 0;
+			goto out;
+		}
+	}
+
+	len = snprintf(str, sizeof(str), "root-%d", root_num);
+	if (unlikely(len >= (sizeof(str) - 1))) {
+		err = -ENOMEM;
+		goto out;
+	}
+
+	dev_dbg(&pdev->xdev->dev, "writing root %d at %04x:%02x\n",
+		root_num, domain, bus);
+
+	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, str,
+			    "%04x:%02x", domain, bus);
+	if (err)
+		goto out;
+
+	err = xenbus_printf(XBT_NIL, pdev->xdev->nodename,
+			    "root_num", "%d", (root_num + 1));
+
+out:
+	return err;
+}
+
+static int pciback_reconfigure(struct pciback_device *pdev)
+{
+	int err = 0;
+	int num_devs;
+	int domain, bus, slot, func;
+	int substate;
+	int i, len;
+	char state_str[64];
+	char dev_str[64];
+
+
+	dev_dbg(&pdev->xdev->dev, "Reconfiguring device ...\n");
+
+	/* Make sure we only reconfigure once */
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateReconfiguring)
+		goto out;
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, "num_devs", "%d",
+			   &num_devs);
+	if (err != 1) {
+		if (err >= 0)
+			err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading number of devices");
+		goto out;
+	}
+
+	for (i = 0; i < num_devs; i++) {
+		len = snprintf(state_str, sizeof(state_str), "state-%d", i);
+		if (unlikely(len >= (sizeof(state_str) - 1))) {
+			err = -ENOMEM;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "String overflow while reading "
+					 "configuration");
+			goto out;
+		}
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, state_str,
+				   "%d", &substate);
+		if (err != 1)
+			substate = XenbusStateUnknown;
+
+		switch (substate) {
+		case XenbusStateInitialising:
+			dev_dbg(&pdev->xdev->dev, "Attaching dev-%d ...\n", i);
+
+			len = snprintf(dev_str, sizeof(dev_str), "dev-%d", i);
+			if (unlikely(len >= (sizeof(dev_str) - 1))) {
+				err = -ENOMEM;
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "String overflow while "
+						 "reading configuration");
+				goto out;
+			}
+			err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+					   dev_str, "%x:%x:%x.%x",
+					   &domain, &bus, &slot, &func);
+			if (err < 0) {
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error reading device "
+						 "configuration");
+				goto out;
+			}
+			if (err != 4) {
+				err = -EINVAL;
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error parsing pci device "
+						 "configuration");
+				goto out;
+			}
+
+			err = pciback_export_device(pdev, domain, bus, slot,
+						    func, i);
+			if (err)
+				goto out;
+
+			/* Publish pci roots. */
+			err = pciback_publish_pci_roots(pdev,
+						pciback_publish_pci_root);
+			if (err) {
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error while publish PCI root"
+						 "buses for frontend");
+				goto out;
+			}
+
+			err = xenbus_printf(XBT_NIL, pdev->xdev->nodename,
+					    state_str, "%d",
+					    XenbusStateInitialised);
+			if (err) {
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error switching substate of "
+						 "dev-%d\n", i);
+				goto out;
+			}
+			break;
+
+		case XenbusStateClosing:
+			dev_dbg(&pdev->xdev->dev, "Detaching dev-%d ...\n", i);
+
+			len = snprintf(dev_str, sizeof(dev_str), "vdev-%d", i);
+			if (unlikely(len >= (sizeof(dev_str) - 1))) {
+				err = -ENOMEM;
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "String overflow while "
+						 "reading configuration");
+				goto out;
+			}
+			err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename,
+					   dev_str, "%x:%x:%x.%x",
+					   &domain, &bus, &slot, &func);
+			if (err < 0) {
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error reading device "
+						 "configuration");
+				goto out;
+			}
+			if (err != 4) {
+				err = -EINVAL;
+				xenbus_dev_fatal(pdev->xdev, err,
+						 "Error parsing pci device "
+						 "configuration");
+				goto out;
+			}
+
+			err = pciback_remove_device(pdev, domain, bus, slot,
+						    func);
+			if (err)
+				goto out;
+
+			/* TODO: If at some point we implement support for pci
+			 * root hot-remove on pcifront side, we'll need to
+			 * remove unnecessary xenstore nodes of pci roots here.
+			 */
+
+			break;
+
+		default:
+			break;
+		}
+	}
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateReconfigured);
+	if (err) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error switching to reconfigured state!");
+		goto out;
+	}
+
+out:
+	return 0;
+}
+
+static void pciback_frontend_changed(struct xenbus_device *xdev,
+				     enum xenbus_state fe_state)
+{
+	struct pciback_device *pdev = dev_get_drvdata(&xdev->dev);
+
+	dev_dbg(&xdev->dev, "fe state changed %d\n", fe_state);
+
+	switch (fe_state) {
+	case XenbusStateInitialised:
+		pciback_attach(pdev);
+		break;
+
+	case XenbusStateReconfiguring:
+		pciback_reconfigure(pdev);
+		break;
+
+	case XenbusStateConnected:
+		/* pcifront switched its state from reconfiguring to connected.
+		 * Then switch to connected state.
+		 */
+		xenbus_switch_state(xdev, XenbusStateConnected);
+		break;
+
+	case XenbusStateClosing:
+		pciback_disconnect(pdev);
+		xenbus_switch_state(xdev, XenbusStateClosing);
+		break;
+
+	case XenbusStateClosed:
+		pciback_disconnect(pdev);
+		xenbus_switch_state(xdev, XenbusStateClosed);
+		if (xenbus_dev_is_online(xdev))
+			break;
+		/* fall through if not online */
+	case XenbusStateUnknown:
+		dev_dbg(&xdev->dev, "frontend is gone! unregister device\n");
+		device_unregister(&xdev->dev);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int pciback_setup_backend(struct pciback_device *pdev)
+{
+	/* Get configuration from xend (if available now) */
+	int domain, bus, slot, func;
+	int err = 0;
+	int i, num_devs;
+	char dev_str[64];
+	char state_str[64];
+
+	/* It's possible we could get the call to setup twice, so make sure
+	 * we're not already connected.
+	 */
+	if (xenbus_read_driver_state(pdev->xdev->nodename) !=
+	    XenbusStateInitWait)
+		goto out;
+
+	dev_dbg(&pdev->xdev->dev, "getting be setup\n");
+
+	err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, "num_devs", "%d",
+			   &num_devs);
+	if (err != 1) {
+		if (err >= 0)
+			err = -EINVAL;
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error reading number of devices");
+		goto out;
+	}
+
+	for (i = 0; i < num_devs; i++) {
+		int l = snprintf(dev_str, sizeof(dev_str), "dev-%d", i);
+		if (unlikely(l >= (sizeof(dev_str) - 1))) {
+			err = -ENOMEM;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "String overflow while reading "
+					 "configuration");
+			goto out;
+		}
+
+		err = xenbus_scanf(XBT_NIL, pdev->xdev->nodename, dev_str,
+				   "%x:%x:%x.%x", &domain, &bus, &slot, &func);
+		if (err < 0) {
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error reading device configuration");
+			goto out;
+		}
+		if (err != 4) {
+			err = -EINVAL;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "Error parsing pci device "
+					 "configuration");
+			goto out;
+		}
+
+		err = pciback_export_device(pdev, domain, bus, slot, func, i);
+		if (err)
+			goto out;
+
+		/* Switch substate of this device. */
+		l = snprintf(state_str, sizeof(state_str), "state-%d", i);
+		if (unlikely(l >= (sizeof(state_str) - 1))) {
+			err = -ENOMEM;
+			xenbus_dev_fatal(pdev->xdev, err,
+					 "String overflow while reading "
+					 "configuration");
+			goto out;
+		}
+		err = xenbus_printf(XBT_NIL, pdev->xdev->nodename, state_str,
+				    "%d", XenbusStateInitialised);
+		if (err) {
+			xenbus_dev_fatal(pdev->xdev, err, "Error switching "
+					 "substate of dev-%d\n", i);
+			goto out;
+		}
+	}
+
+	err = pciback_publish_pci_roots(pdev, pciback_publish_pci_root);
+	if (err) {
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error while publish PCI root buses "
+				 "for frontend");
+		goto out;
+	}
+
+	err = xenbus_switch_state(pdev->xdev, XenbusStateInitialised);
+	if (err)
+		xenbus_dev_fatal(pdev->xdev, err,
+				 "Error switching to initialised state!");
+
+out:
+	if (!err)
+		/* see if pcifront is already configured (if not, we'll wait) */
+		pciback_attach(pdev);
+
+	return err;
+}
+
+static void pciback_be_watch(struct xenbus_watch *watch,
+			     const char **vec, unsigned int len)
+{
+	struct pciback_device *pdev =
+	    container_of(watch, struct pciback_device, be_watch);
+
+	switch (xenbus_read_driver_state(pdev->xdev->nodename)) {
+	case XenbusStateInitWait:
+		pciback_setup_backend(pdev);
+		break;
+
+	default:
+		break;
+	}
+}
+
+static int pciback_xenbus_probe(struct xenbus_device *dev,
+				const struct xenbus_device_id *id)
+{
+	int err = 0;
+	struct pciback_device *pdev = alloc_pdev(dev);
+
+	if (pdev == NULL) {
+		err = -ENOMEM;
+		xenbus_dev_fatal(dev, err,
+				 "Error allocating pciback_device struct");
+		goto out;
+	}
+
+	/* wait for xend to configure us */
+	err = xenbus_switch_state(dev, XenbusStateInitWait);
+	if (err)
+		goto out;
+
+	/* watch the backend node for backend configuration information */
+	err = xenbus_watch_path(dev, dev->nodename, &pdev->be_watch,
+				pciback_be_watch);
+	if (err)
+		goto out;
+
+	pdev->be_watching = 1;
+
+	/* We need to force a call to our callback here in case
+	 * xend already configured us!
+	 */
+	pciback_be_watch(&pdev->be_watch, NULL, 0);
+
+out:
+	return err;
+}
+
+static int pciback_xenbus_remove(struct xenbus_device *dev)
+{
+	struct pciback_device *pdev = dev_get_drvdata(&dev->dev);
+
+	if (pdev != NULL)
+		free_pdev(pdev);
+
+	return 0;
+}
+
+static const struct xenbus_device_id xenpci_ids[] = {
+	{"pci"},
+	{""},
+};
+
+static struct xenbus_driver xenbus_pciback_driver = {
+	.name 			= "pciback",
+	.owner 			= THIS_MODULE,
+	.ids 			= xenpci_ids,
+	.probe 			= pciback_xenbus_probe,
+	.remove 		= pciback_xenbus_remove,
+	.otherend_changed 	= pciback_frontend_changed,
+};
+
+int __init pciback_xenbus_register(void)
+{
+	pciback_wq = create_workqueue("pciback_workqueue");
+	if (!pciback_wq) {
+		printk(KERN_ERR "%s: create"
+			"pciback_workqueue failed\n",__FUNCTION__);
+		return -EFAULT;
+	}
+	return xenbus_register_backend(&xenbus_pciback_driver);
+}
+
+void __exit pciback_xenbus_unregister(void)
+{
+	destroy_workqueue(pciback_wq);
+	xenbus_unregister_driver(&xenbus_pciback_driver);
+}
-- 
1.7.1

