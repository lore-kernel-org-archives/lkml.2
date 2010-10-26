Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756857Ab0JZBMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:30 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37313 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932284Ab0JZBM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:28 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 30/30] staging/vme: remove _ng suffixes
Date: Mon, 25 Oct 2010 21:11:16 -0400
Message-Id: <1288055476-19438-31-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

This completes the transition to the new model.

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/bridges/vme_ca91cx42.c |    6 +-
 drivers/staging/vme/bridges/vme_tsi148.c   |    4 +-
 drivers/staging/vme/devices/vme_user.c     |   10 ++--
 drivers/staging/vme/vme.c                  |   78 ++++++++++++++--------------
 drivers/staging/vme/vme.h                  |   28 +++++-----
 5 files changed, 63 insertions(+), 63 deletions(-)

diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 0f7dd66..d702bdb 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1773,7 +1773,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	/* Need to save ca91cx42_bridge pointer locally in link list for use in
 	 * ca91cx42_remove()
 	 */
-	retval = vme_register_bridge_ng(ca91cx42_bridge);
+	retval = vme_register_bridge(ca91cx42_bridge);
 	if (retval != 0) {
 		dev_err(&pdev->dev, "Chip Registration failed.\n");
 		goto err_reg;
@@ -1783,7 +1783,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 	return 0;
 
-	vme_unregister_bridge_ng(ca91cx42_bridge);
+	vme_unregister_bridge(ca91cx42_bridge);
 err_reg:
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
@@ -1867,7 +1867,7 @@ static void ca91cx42_remove(struct pci_dev *pdev)
 	iowrite32(0x00F00000, bridge->base + VSI6_CTL);
 	iowrite32(0x00F00000, bridge->base + VSI7_CTL);
 
-	vme_unregister_bridge_ng(ca91cx42_bridge);
+	vme_unregister_bridge(ca91cx42_bridge);
 
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index b12d517..77bf4ce 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2464,7 +2464,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_crcsr;
 	}
 
-	retval = vme_register_bridge_ng(tsi148_bridge);
+	retval = vme_register_bridge(tsi148_bridge);
 	if (retval != 0) {
 		dev_err(&pdev->dev, "Chip Registration failed.\n");
 		goto err_reg;
@@ -2587,7 +2587,7 @@ static void tsi148_remove(struct pci_dev *pdev)
 
 	tsi148_irq_exit(tsi148_bridge, pdev);
 
-	vme_unregister_bridge_ng(tsi148_bridge);
+	vme_unregister_bridge(tsi148_bridge);
 
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 030f5ee..57c0e00 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -602,7 +602,7 @@ static void buf_unalloc(int num)
 	}
 }
 
-static struct vme_driver_ng vme_user_driver_ng = {
+static struct vme_driver vme_user_driver = {
 	.name = driver_name,
 	.match = vme_user_match,
 	.probe = vme_user_probe,
@@ -629,7 +629,7 @@ static int __init vme_user_init(void)
 		bus_num = USER_BUS_MAX;
 	}
 
-	return vme_register_driver_ng(&vme_user_driver_ng, 1);
+	return vme_register_driver(&vme_user_driver, 1);
 }
 
 /* NOTE: This only supports one device per bus */
@@ -703,7 +703,7 @@ vme_user_probe(struct device *dev, unsigned int bus_id, unsigned int id)
 		 * supporting A16 addressing, so we request A24 supported
 		 * by all windows.
 		 */
-		image[i].resource = vme_slave_request_ng(bridges[0], VME_A24, VME_SCT);
+		image[i].resource = vme_slave_request(bridges[0], VME_A24, VME_SCT);
 		if (image[i].resource == NULL) {
 			printk(KERN_WARNING "Unable to allocate slave "
 				"resource\n");
@@ -728,7 +728,7 @@ vme_user_probe(struct device *dev, unsigned int bus_id, unsigned int id)
 	 */
 	for (i = MASTER_MINOR; i < (MASTER_MAX + 1); i++) {
 		/* XXX Need to properly request attributes */
-		image[i].resource = vme_master_request_ng(bridges[0], VME_A32, VME_SCT, VME_D32);
+		image[i].resource = vme_master_request(bridges[0], VME_A32, VME_SCT, VME_D32);
 		if (image[i].resource == NULL) {
 			printk(KERN_WARNING "Unable to allocate master "
 				"resource\n");
@@ -858,7 +858,7 @@ static int __devexit vme_user_remove(struct device *dev, unsigned int bus_id, un
 
 static void __exit vme_user_exit(void)
 {
-	vme_unregister_driver_ng(&vme_user_driver_ng);
+	vme_unregister_driver(&vme_user_driver);
 }
 
 
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index c50f764..c638e08 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -289,7 +289,7 @@ static int vme_check_window(vme_address_t aspace, unsigned long long vme_base,
  * identifier.
  */
 struct vme_resource
-*vme_slave_request_ng(struct vme_bridge *bridge, vme_address_t address, vme_cycle_t cycle)
+*vme_slave_request(struct vme_bridge *bridge, vme_address_t address, vme_cycle_t cycle)
 {
 	struct list_head *slave_pos = NULL;
 	struct vme_slave_resource *allocated_image = NULL;
@@ -342,7 +342,7 @@ err_alloc:
 err_image:
 	return NULL;
 }
-EXPORT_SYMBOL(vme_slave_request_ng);
+EXPORT_SYMBOL(vme_slave_request);
 
 int vme_slave_set(struct vme_resource *resource, int enabled,
 	unsigned long long vme_base, unsigned long long size,
@@ -437,7 +437,7 @@ EXPORT_SYMBOL(vme_slave_free);
  * identifier.
  */
 struct vme_resource
-*vme_master_request_ng(struct vme_bridge *bridge, vme_address_t address,
+*vme_master_request(struct vme_bridge *bridge, vme_address_t address,
 		      vme_cycle_t cycle, vme_width_t dwidth)
 {
 	struct list_head *master_pos = NULL;
@@ -495,7 +495,7 @@ err_alloc:
 err_image:
 	return NULL;
 }
-EXPORT_SYMBOL(vme_master_request_ng);
+EXPORT_SYMBOL(vme_master_request);
 
 int vme_master_set(struct vme_resource *resource, int enabled,
 	unsigned long long vme_base, unsigned long long size,
@@ -689,7 +689,7 @@ EXPORT_SYMBOL(vme_master_free);
  * identifier.
  */
 struct vme_resource
-*vme_dma_request_ng(struct vme_bridge *bridge, vme_dma_route_t route)
+*vme_dma_request(struct vme_bridge *bridge, vme_dma_route_t route)
 {
 	struct list_head *dma_pos = NULL;
 	struct vme_dma_resource *allocated_ctrlr = NULL;
@@ -744,7 +744,7 @@ err_alloc:
 err_ctrlr:
 	return NULL;
 }
-EXPORT_SYMBOL(vme_dma_request_ng);
+EXPORT_SYMBOL(vme_dma_request);
 
 /*
  * Start new list
@@ -1028,7 +1028,7 @@ void vme_irq_handler(struct vme_bridge *bridge, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_handler);
 
-int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
+int vme_irq_request(struct vme_bridge *bridge, int level, int statid,
 		       void (*callback)(int, int, void *), void *priv_data)
 {
 	if ((level < 1) || (level > 7)) {
@@ -1060,9 +1060,9 @@ int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
 
 	return 0;
 }
-EXPORT_SYMBOL(vme_irq_request_ng);
+EXPORT_SYMBOL(vme_irq_request);
 
-void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid)
+void vme_irq_free(struct vme_bridge *bridge, int level, int statid)
 {
 	if ((level < 1) || (level > 7)) {
 		printk(KERN_ERR "Invalid interrupt level\n");
@@ -1087,9 +1087,9 @@ void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid)
 
 	mutex_unlock(&bridge->irq_mtx);
 }
-EXPORT_SYMBOL(vme_irq_free_ng);
+EXPORT_SYMBOL(vme_irq_free);
 
-int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid)
+int vme_irq_generate(struct vme_bridge *bridge, int level, int statid)
 {
 	if ((level < 1) || (level > 7)) {
 		printk(KERN_WARNING "Invalid interrupt level\n");
@@ -1103,12 +1103,12 @@ int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid)
 
 	return bridge->irq_generate(bridge, level, statid);
 }
-EXPORT_SYMBOL(vme_irq_generate_ng);
+EXPORT_SYMBOL(vme_irq_generate);
 
 /*
  * Request the location monitor, return resource or NULL
  */
-struct vme_resource *vme_lm_request_ng(struct vme_bridge *bridge)
+struct vme_resource *vme_lm_request(struct vme_bridge *bridge)
 {
 	struct list_head *lm_pos = NULL;
 	struct vme_lm_resource *allocated_lm = NULL;
@@ -1159,7 +1159,7 @@ err_alloc:
 err_lm:
 	return NULL;
 }
-EXPORT_SYMBOL(vme_lm_request_ng);
+EXPORT_SYMBOL(vme_lm_request);
 
 int vme_lm_count(struct vme_resource *resource)
 {
@@ -1360,43 +1360,43 @@ static void vme_unregister_bus(struct vme_bridge *bridge)
 }
 
 /**
- * vme_register_bridge_ng - register a VME bridge in the VME core
+ * vme_register_bridge - register a VME bridge in the VME core
  * @bridge:	VME bridge to register
  *
  * Upon calling this function, the bridge must be ready to process requests.
  */
-int vme_register_bridge_ng(struct vme_bridge *bridge)
+int vme_register_bridge(struct vme_bridge *bridge)
 {
 	return vme_register_bus(bridge);
 }
-EXPORT_SYMBOL(vme_register_bridge_ng);
+EXPORT_SYMBOL(vme_register_bridge);
 
 /**
  * vme_unregister_bridge_nr - unregister a VME bridge from the VME core
  * @bridge:	VME bridge to unregister
  */
-void vme_unregister_bridge_ng(struct vme_bridge *bridge)
+void vme_unregister_bridge(struct vme_bridge *bridge)
 {
 	vme_unregister_bus(bridge);
 }
-EXPORT_SYMBOL(vme_unregister_bridge_ng);
+EXPORT_SYMBOL(vme_unregister_bridge);
 
 
 /* - Driver Registration --------------------------------------------------- */
 
-static void vme_dev_release_ng(struct device *dev)
+static void vme_dev_release(struct device *dev)
 {
 	kfree(to_vme_dev(dev));
 }
 
 /**
- * vme_unregister_driver_ng - unregister a driver from the VME core
+ * vme_unregister_driver - unregister a driver from the VME core
  * @vme_driver:	VME driver to unregister
  *
  * First, all devices associated to the driver are unregistered; then the
  * driver is removed from the core.
  */
-void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver)
+void vme_unregister_driver(struct vme_driver *vme_driver)
 {
 	struct device *dev = vme_driver->devices;
 
@@ -1408,10 +1408,10 @@ void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver)
 	}
 	driver_unregister(&vme_driver->driver);
 }
-EXPORT_SYMBOL(vme_unregister_driver_ng);
+EXPORT_SYMBOL(vme_unregister_driver);
 
 static int
-__vme_register_driver_bus(struct vme_driver_ng *vme_driver, struct vme_bridge *bridge, unsigned int n_devs)
+__vme_register_driver_bus(struct vme_driver *vme_driver, struct vme_bridge *bridge, unsigned int n_devs)
 {
 	unsigned int id;
 	int error;
@@ -1425,7 +1425,7 @@ __vme_register_driver_bus(struct vme_driver_ng *vme_driver, struct vme_bridge *b
 			break;
 		}
 		vme_dev->dev.platform_data = vme_driver;
-		vme_dev->dev.release = vme_dev_release_ng;
+		vme_dev->dev.release = vme_dev_release;
 		vme_dev->dev.parent = bridge->parent;
 		vme_dev->dev.bus = &vme_bus_type;
 		vme_dev->bus_id = bridge->num;
@@ -1449,7 +1449,7 @@ __vme_register_driver_bus(struct vme_driver_ng *vme_driver, struct vme_bridge *b
 	return error;
 }
 
-static int __vme_register_driver(struct vme_driver_ng *vme_driver, unsigned n_devs)
+static int __vme_register_driver(struct vme_driver *vme_driver, unsigned n_devs)
 {
 	struct vme_bridge *bridge;
 	int error;
@@ -1478,7 +1478,7 @@ static int __vme_register_driver(struct vme_driver_ng *vme_driver, unsigned n_de
 }
 
 /**
- * vme_register_driver_ng - register a VME driver
+ * vme_register_driver - register a VME driver
  * @vme_driver:	VME driver to register in the VME core
  * @n_devs:	Number of devices (0 to n-1) to be matched for each bus
  *
@@ -1488,7 +1488,7 @@ static int __vme_register_driver(struct vme_driver_ng *vme_driver, unsigned n_de
  * If there is a match, .probe is called; otherwise the created device is
  * removed.
  */
-int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs)
+int vme_register_driver(struct vme_driver *vme_driver, unsigned int n_devs)
 {
 	int error;
 
@@ -1504,16 +1504,16 @@ int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs
 	if (!error && !vme_driver->devices)
 		error = -ENODEV;
 	if (error)
-		vme_unregister_driver_ng(vme_driver);
+		vme_unregister_driver(vme_driver);
 	return error;
 }
-EXPORT_SYMBOL(vme_register_driver_ng);
+EXPORT_SYMBOL(vme_register_driver);
 
 /* - Bus Registration ------------------------------------------------------ */
 
-static int vme_bus_match_ng(struct device *dev, struct device_driver *drv)
+static int vme_bus_match(struct device *dev, struct device_driver *drv)
 {
-	struct vme_driver_ng *vme_driver = to_vme_driver_ng(drv);
+	struct vme_driver *vme_driver = to_vme_driver(drv);
 
 	if (dev->platform_data == vme_driver) {
 		struct vme_dev *vme_dev = to_vme_dev(dev);
@@ -1526,9 +1526,9 @@ static int vme_bus_match_ng(struct device *dev, struct device_driver *drv)
 	return 0;
 }
 
-static int vme_bus_probe_ng(struct device *dev)
+static int vme_bus_probe(struct device *dev)
 {
-	struct vme_driver_ng *vme_driver = dev->platform_data;
+	struct vme_driver *vme_driver = dev->platform_data;
 
 	if (vme_driver->probe) {
 		struct vme_dev *vme_dev = to_vme_dev(dev);
@@ -1538,9 +1538,9 @@ static int vme_bus_probe_ng(struct device *dev)
 	return 0;
 }
 
-static int vme_bus_remove_ng(struct device *dev)
+static int vme_bus_remove(struct device *dev)
 {
-	struct vme_driver_ng *vme_driver = dev->platform_data;
+	struct vme_driver *vme_driver = dev->platform_data;
 
 	if (vme_driver->remove) {
 		struct vme_dev *vme_dev = to_vme_dev(dev);
@@ -1552,9 +1552,9 @@ static int vme_bus_remove_ng(struct device *dev)
 
 struct bus_type vme_bus_type = {
 	.name = "vme",
-	.match = vme_bus_match_ng,
-	.probe = vme_bus_probe_ng,
-	.remove = vme_bus_remove_ng,
+	.match = vme_bus_match,
+	.probe = vme_bus_probe,
+	.remove = vme_bus_remove,
 };
 EXPORT_SYMBOL(vme_bus_type);
 
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index 0d9cfb6..5080848 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -98,7 +98,7 @@ struct vme_device_id {
 };
 
 /**
- * struct vme_driver_ng - represent a VME driver
+ * struct vme_driver - represent a VME driver
  * @name: driver name
  * @match: callback for matching devices
  * @probe: callback for device binding
@@ -108,7 +108,7 @@ struct vme_device_id {
  * @devices: pointer to the first device controlled by this driver. From this
  * first device all others can be retrieved by traversing a list.
  */
-struct vme_driver_ng {
+struct vme_driver {
 	char *name;
 	int (*match)(struct device *, unsigned int, unsigned int);
 	int (*probe)(struct device *, unsigned int, unsigned int);
@@ -117,7 +117,7 @@ struct vme_driver_ng {
 	struct device_driver driver;
 	struct device *devices;
 };
-#define to_vme_driver_ng(x) container_of((x), struct vme_driver_ng, driver)
+#define to_vme_driver(x) container_of((x), struct vme_driver, driver)
 
 #define VME_CRCSR_BUF_SIZE (508*1024)
 #define VME_SLOTS_MAX 32
@@ -294,7 +294,7 @@ void vme_free_consistent(struct vme_resource *, size_t,  void *,
 
 size_t vme_get_size(struct vme_resource *);
 
-struct vme_resource *vme_slave_request_ng(struct vme_bridge *bridge,
+struct vme_resource *vme_slave_request(struct vme_bridge *bridge,
 					  vme_address_t address,
 					  vme_cycle_t cycle);
 int vme_slave_set(struct vme_resource *, int, unsigned long long,
@@ -303,7 +303,7 @@ int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
 	unsigned long long *, dma_addr_t *, vme_address_t *, vme_cycle_t *);
 void vme_slave_free(struct vme_resource *);
 
-struct vme_resource *vme_master_request_ng(struct vme_bridge *bridge,
+struct vme_resource *vme_master_request(struct vme_bridge *bridge,
 					   vme_address_t address,
 					   vme_cycle_t cycle,
 					   vme_width_t dwidth);
@@ -317,7 +317,7 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 	unsigned int, loff_t);
 void vme_master_free(struct vme_resource *);
 
-struct vme_resource *vme_dma_request_ng(struct vme_bridge *bridge, vme_dma_route_t route);
+struct vme_resource *vme_dma_request(struct vme_bridge *bridge, vme_dma_route_t route);
 struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
 struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
 struct vme_dma_attr *vme_dma_pci_attribute(dma_addr_t);
@@ -330,12 +330,12 @@ int vme_dma_list_exec(struct vme_dma_list *);
 int vme_dma_list_free(struct vme_dma_list *);
 int vme_dma_free(struct vme_resource *);
 
-int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
+int vme_irq_request(struct vme_bridge *bridge, int level, int statid,
 		       void (*callback)(int, int, void *), void *priv_data);
-void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid);
-int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid);
+void vme_irq_free(struct vme_bridge *bridge, int level, int statid);
+int vme_irq_generate(struct vme_bridge *bridge, int level, int statid);
 
-struct vme_resource *vme_lm_request_ng(struct vme_bridge *bridge);
+struct vme_resource *vme_lm_request(struct vme_bridge *bridge);
 int vme_lm_count(struct vme_resource *);
 int vme_lm_set(struct vme_resource *, unsigned long long, vme_address_t,
 	vme_cycle_t);
@@ -347,16 +347,16 @@ void vme_lm_free(struct vme_resource *);
 
 int vme_slot_get(struct device *);
 
-int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs);
-void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver);
+int vme_register_driver(struct vme_driver *vme_driver, unsigned int n_devs);
+void vme_unregister_driver(struct vme_driver *vme_driver);
 
 struct vme_bridge *vme_get_bridge(unsigned int bus_id);
 void vme_put_bridge(struct vme_bridge *bridge);
 
 /* functions for VME bridges */
 void vme_irq_handler(struct vme_bridge *, int, int);
-int vme_register_bridge_ng(struct vme_bridge *bridge);
-void vme_unregister_bridge_ng(struct vme_bridge *bridge);
+int vme_register_bridge(struct vme_bridge *bridge);
+void vme_unregister_bridge(struct vme_bridge *bridge);
 
 
 #endif /* _VME_H_ */
-- 
1.7.1

