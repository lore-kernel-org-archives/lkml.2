Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932315Ab0JZBMq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 21:12:46 -0400
Received: from waldorf.bytemark.co.uk ([212.110.162.22]:37307 "EHLO
	waldorf.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756686Ab0JZBM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 21:12:26 -0400
From: "Emilio G. Cota" <cota@braap.org>
To: Martyn Welch <martyn.welch@ge.com>
Cc: Greg KH <greg@kroah.com>, LKML <linux-kernel@vger.kernel.org>,
        devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        Bill Pemberton <wfp5p@virginia.edu>, "Emilio G. Cota" <cota@braap.org>
Subject: [PATCH 29/30] staging/vme: remove unused vme_* functions and related code
Date: Mon, 25 Oct 2010 21:11:15 -0400
Message-Id: <1288055476-19438-30-git-send-email-cota@braap.org>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1288055476-19438-1-git-send-email-cota@braap.org>
References: <1288055476-19438-1-git-send-email-cota@braap.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

Signed-off-by: Emilio G. Cota <cota@braap.org>
---
 drivers/staging/vme/vme.c |  260 ---------------------------------------------
 drivers/staging/vme/vme.h |   24 ----
 2 files changed, 0 insertions(+), 284 deletions(-)

diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 88697aa..c50f764 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -344,17 +344,6 @@ err_image:
 }
 EXPORT_SYMBOL(vme_slave_request_ng);
 
-struct vme_resource
-*vme_slave_request(struct device *dev, vme_address_t address, vme_cycle_t cycle)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_slave_request_ng(bridge, address, cycle);
-	return NULL;
-}
-EXPORT_SYMBOL(vme_slave_request);
-
 int vme_slave_set(struct vme_resource *resource, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	dma_addr_t buf_base, vme_address_t aspace, vme_cycle_t cycle)
@@ -508,18 +497,6 @@ err_image:
 }
 EXPORT_SYMBOL(vme_master_request_ng);
 
-struct vme_resource
-*vme_master_request(struct device *dev, vme_address_t address,
-		    vme_cycle_t cycle, vme_width_t dwidth)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_master_request_ng(bridge, address, cycle, dwidth);
-	return NULL;
-}
-EXPORT_SYMBOL(vme_master_request);
-
 int vme_master_set(struct vme_resource *resource, int enabled,
 	unsigned long long vme_base, unsigned long long size,
 	vme_address_t aspace, vme_cycle_t cycle, vme_width_t dwidth)
@@ -769,16 +746,6 @@ err_ctrlr:
 }
 EXPORT_SYMBOL(vme_dma_request_ng);
 
-struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_dma_request_ng(bridge, route);
-	return NULL;
-}
-EXPORT_SYMBOL(vme_dma_request);
-
 /*
  * Start new list
  */
@@ -1095,17 +1062,6 @@ int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
 }
 EXPORT_SYMBOL(vme_irq_request_ng);
 
-int vme_irq_request(struct device *dev, int level, int statid,
-		    void (*callback)(int, int, void *), void *priv_data)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_irq_request_ng(bridge, level, statid, callback, priv_data);
-	return -EINVAL;
-}
-EXPORT_SYMBOL(vme_irq_request);
-
 void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid)
 {
 	if ((level < 1) || (level > 7)) {
@@ -1133,16 +1089,6 @@ void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_free_ng);
 
-void vme_irq_free(struct device *dev, int level, int statid)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_irq_free_ng(bridge, level, statid);
-	return;
-}
-EXPORT_SYMBOL(vme_irq_free);
-
 int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid)
 {
 	if ((level < 1) || (level > 7)) {
@@ -1159,16 +1105,6 @@ int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid)
 }
 EXPORT_SYMBOL(vme_irq_generate_ng);
 
-int vme_irq_generate(struct device *dev, int level, int statid)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_irq_generate_ng(bridge, level, statid);
-	return -EINVAL;
-}
-EXPORT_SYMBOL(vme_irq_generate);
-
 /*
  * Request the location monitor, return resource or NULL
  */
@@ -1225,16 +1161,6 @@ err_lm:
 }
 EXPORT_SYMBOL(vme_lm_request_ng);
 
-struct vme_resource *vme_lm_request(struct device *dev)
-{
-	struct vme_bridge *bridge = dev_to_bridge(dev);
-
-	if (bridge)
-		return vme_lm_request_ng(bridge);
-	return NULL;
-}
-EXPORT_SYMBOL(vme_lm_request);
-
 int vme_lm_count(struct vme_resource *resource)
 {
 	struct vme_lm_resource *lm;
@@ -1433,72 +1359,6 @@ static void vme_unregister_bus(struct vme_bridge *bridge)
 	mutex_unlock(&vme_buses_lock);
 }
 
-/* Note: device_release(dev) throws a warning if dev->release isn't filled in */
-static void vme_dev_release(struct device *dev)
-{
-}
-
-int vme_register_bridge(struct vme_bridge *bridge)
-{
-	struct device *dev;
-	int retval;
-	int i;
-
-	retval = vme_register_bus(bridge);
-	if (retval)
-		return retval;
-
-	/* This creates 32 vme "slot" devices. This equates to a slot for each
-	 * ID available in a system conforming to the ANSI/VITA 1-1994
-	 * specification.
-	 */
-	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
-		memset(dev, 0, sizeof(struct device));
-
-		dev->parent = bridge->parent;
-		dev->bus = &vme_bus_type;
-		dev->release = vme_dev_release;
-		/*
-		 * We save a pointer to the bridge in platform_data so that we
-		 * can get to it later. We keep driver_data for use by the
-		 * driver that binds against the slot
-		 */
-		dev->platform_data = bridge;
-		dev_set_name(dev, "vme-%x.%x", bridge->num, i + 1);
-
-		retval = device_register(dev);
-		if (retval)
-			goto err_reg;
-	}
-
-	return retval;
-
-	i = VME_SLOTS_MAX;
-err_reg:
-	while (i > -1) {
-		dev = &bridge->dev[i];
-		device_unregister(dev);
-	}
-	vme_unregister_bus(bridge);
-	return retval;
-}
-EXPORT_SYMBOL(vme_register_bridge);
-
-void vme_unregister_bridge(struct vme_bridge *bridge)
-{
-	int i;
-	struct device *dev;
-
-
-	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &bridge->dev[i];
-		device_unregister(dev);
-	}
-	vme_unregister_bus(bridge);
-}
-EXPORT_SYMBOL(vme_unregister_bridge);
-
 /**
  * vme_register_bridge_ng - register a VME bridge in the VME core
  * @bridge:	VME bridge to register
@@ -1524,21 +1384,6 @@ EXPORT_SYMBOL(vme_unregister_bridge_ng);
 
 /* - Driver Registration --------------------------------------------------- */
 
-int vme_register_driver(struct vme_driver *drv)
-{
-	drv->driver.name = drv->name;
-	drv->driver.bus = &vme_bus_type;
-
-	return driver_register(&drv->driver);
-}
-EXPORT_SYMBOL(vme_register_driver);
-
-void vme_unregister_driver(struct vme_driver *drv)
-{
-	driver_unregister(&drv->driver);
-}
-EXPORT_SYMBOL(vme_unregister_driver);
-
 static void vme_dev_release_ng(struct device *dev)
 {
 	kfree(to_vme_dev(dev));
@@ -1666,111 +1511,6 @@ EXPORT_SYMBOL(vme_register_driver_ng);
 
 /* - Bus Registration ------------------------------------------------------ */
 
-static int vme_calc_slot(struct device *dev)
-{
-	struct vme_bridge *bridge;
-	int num;
-
-	bridge = dev_to_bridge(dev);
-
-	/* Determine slot number */
-	num = 0;
-	while (num < VME_SLOTS_MAX) {
-		if (&bridge->dev[num] == dev)
-			break;
-
-		num++;
-	}
-	if (num == VME_SLOTS_MAX) {
-		dev_err(dev, "Failed to identify slot\n");
-		num = 0;
-		goto err_dev;
-	}
-	num++;
-
-err_dev:
-	return num;
-}
-
-static struct vme_driver *dev_to_vme_driver(struct device *dev)
-{
-	if (dev->driver == NULL)
-		printk(KERN_ERR "Bugger dev->driver is NULL\n");
-
-	return container_of(dev->driver, struct vme_driver, driver);
-}
-
-static int vme_bus_match(struct device *dev, struct device_driver *drv)
-{
-	struct vme_bridge *bridge;
-	struct vme_driver *driver;
-	int i, num;
-
-	bridge = dev_to_bridge(dev);
-	driver = container_of(drv, struct vme_driver, driver);
-
-	num = vme_calc_slot(dev);
-	if (!num)
-		goto err_dev;
-
-	if (driver->bind_table == NULL) {
-		dev_err(dev, "Bind table NULL\n");
-		goto err_table;
-	}
-
-	i = 0;
-	while ((driver->bind_table[i].bus != 0) ||
-		(driver->bind_table[i].slot != 0)) {
-
-		if (bridge->num == driver->bind_table[i].bus) {
-			if (num == driver->bind_table[i].slot)
-				return 1;
-
-			if (driver->bind_table[i].slot == VME_SLOT_ALL)
-				return 1;
-
-			if ((driver->bind_table[i].slot == VME_SLOT_CURRENT) &&
-				(num == vme_slot_get(dev)))
-				return 1;
-		}
-		i++;
-	}
-
-err_dev:
-err_table:
-	return 0;
-}
-
-static int vme_bus_probe(struct device *dev)
-{
-	struct vme_bridge *bridge;
-	struct vme_driver *driver;
-	int retval = -ENODEV;
-
-	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
-
-	if (driver->probe != NULL)
-		retval = driver->probe(dev, bridge->num, vme_calc_slot(dev));
-
-	return retval;
-}
-
-static int vme_bus_remove(struct device *dev)
-{
-	struct vme_bridge *bridge;
-	struct vme_driver *driver;
-	int retval = -ENODEV;
-
-	driver = dev_to_vme_driver(dev);
-	bridge = dev_to_bridge(dev);
-
-	if (driver->remove != NULL)
-		retval = driver->remove(dev, bridge->num, vme_calc_slot(dev));
-
-	return retval;
-}
-
 static int vme_bus_match_ng(struct device *dev, struct device_driver *drv)
 {
 	struct vme_driver_ng *vme_driver = to_vme_driver_ng(drv);
diff --git a/drivers/staging/vme/vme.h b/drivers/staging/vme/vme.h
index a5dd284..0d9cfb6 100644
--- a/drivers/staging/vme/vme.h
+++ b/drivers/staging/vme/vme.h
@@ -97,16 +97,6 @@ struct vme_device_id {
 	int slot;
 };
 
-struct vme_driver {
-	struct list_head node;
-	char *name;
-	const struct vme_device_id *bind_table;
-	int (*probe)  (struct device *, int, int);
-	int (*remove) (struct device *, int, int);
-	void (*shutdown) (void);
-	struct device_driver    driver;
-};
-
 /**
  * struct vme_driver_ng - represent a VME driver
  * @name: driver name
@@ -304,8 +294,6 @@ void vme_free_consistent(struct vme_resource *, size_t,  void *,
 
 size_t vme_get_size(struct vme_resource *);
 
-struct vme_resource *vme_slave_request(struct device *, vme_address_t,
-	vme_cycle_t);
 struct vme_resource *vme_slave_request_ng(struct vme_bridge *bridge,
 					  vme_address_t address,
 					  vme_cycle_t cycle);
@@ -315,8 +303,6 @@ int vme_slave_get(struct vme_resource *, int *, unsigned long long *,
 	unsigned long long *, dma_addr_t *, vme_address_t *, vme_cycle_t *);
 void vme_slave_free(struct vme_resource *);
 
-struct vme_resource *vme_master_request(struct device *, vme_address_t,
-	vme_cycle_t, vme_width_t);
 struct vme_resource *vme_master_request_ng(struct vme_bridge *bridge,
 					   vme_address_t address,
 					   vme_cycle_t cycle,
@@ -331,7 +317,6 @@ unsigned int vme_master_rmw(struct vme_resource *, unsigned int, unsigned int,
 	unsigned int, loff_t);
 void vme_master_free(struct vme_resource *);
 
-struct vme_resource *vme_dma_request(struct device *, vme_dma_route_t);
 struct vme_resource *vme_dma_request_ng(struct vme_bridge *bridge, vme_dma_route_t route);
 struct vme_dma_list *vme_new_dma_list(struct vme_resource *);
 struct vme_dma_attr *vme_dma_pattern_attribute(u32, vme_pattern_t);
@@ -345,16 +330,11 @@ int vme_dma_list_exec(struct vme_dma_list *);
 int vme_dma_list_free(struct vme_dma_list *);
 int vme_dma_free(struct vme_resource *);
 
-int vme_irq_request(struct device *, int, int,
-	void (*callback)(int, int, void *), void *);
 int vme_irq_request_ng(struct vme_bridge *bridge, int level, int statid,
 		       void (*callback)(int, int, void *), void *priv_data);
-void vme_irq_free(struct device *, int, int);
 void vme_irq_free_ng(struct vme_bridge *bridge, int level, int statid);
-int vme_irq_generate(struct device *, int, int);
 int vme_irq_generate_ng(struct vme_bridge *bridge, int level, int statid);
 
-struct vme_resource * vme_lm_request(struct device *);
 struct vme_resource *vme_lm_request_ng(struct vme_bridge *bridge);
 int vme_lm_count(struct vme_resource *);
 int vme_lm_set(struct vme_resource *, unsigned long long, vme_address_t,
@@ -367,9 +347,7 @@ void vme_lm_free(struct vme_resource *);
 
 int vme_slot_get(struct device *);
 
-int vme_register_driver(struct vme_driver *);
 int vme_register_driver_ng(struct vme_driver_ng *vme_driver, unsigned int n_devs);
-void vme_unregister_driver(struct vme_driver *);
 void vme_unregister_driver_ng(struct vme_driver_ng *vme_driver);
 
 struct vme_bridge *vme_get_bridge(unsigned int bus_id);
@@ -377,9 +355,7 @@ void vme_put_bridge(struct vme_bridge *bridge);
 
 /* functions for VME bridges */
 void vme_irq_handler(struct vme_bridge *, int, int);
-int vme_register_bridge(struct vme_bridge *);
 int vme_register_bridge_ng(struct vme_bridge *bridge);
-void vme_unregister_bridge(struct vme_bridge *);
 void vme_unregister_bridge_ng(struct vme_bridge *bridge);
 
 
-- 
1.7.1

