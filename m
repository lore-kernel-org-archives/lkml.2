Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab0KLLOP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Nov 2010 06:14:15 -0500
Received: from exprod5og112.obsmtp.com ([64.18.0.24]:36589 "EHLO
	exprod5og112.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756902Ab0KLLOL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Nov 2010 06:14:11 -0500
Subject: [PATCH 01/17] staging/vme: style: convert '&(foo)' to '&foo'
To: Greg KH <greg@kroah.com>
From: Martyn Welch <martyn.welch@ge.com>
Cc: devel@driverdev.osuosl.org,
        Juan David Gonzalez Cobas <david.cobas@gmail.com>,
        "Emilio G. Cota" <cota@braap.org>, LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Date: Fri, 12 Nov 2010 11:14:07 +0000
Message-ID: <20101112111406.11631.56656.stgit@ES-BJ21R4J>
In-Reply-To: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
References: <20101112111359.11631.84086.stgit@ES-BJ21R4J>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Emilio G. Cota <cota@braap.org>

done with
find . -name '*.c' | xargs perl -p -i -e 's/&\(([^()]+)\)/&$1/g'

Signed-off-by: Emilio G. Cota <cota@braap.org>
Acked-by: Martyn Welch <martyn.welch@ge.com>
---

 drivers/staging/vme/bridges/vme_ca91cx42.c |  181 ++++++++++++-------------
 drivers/staging/vme/bridges/vme_tsi148.c   |  204 ++++++++++++++--------------
 drivers/staging/vme/devices/vme_user.c     |   16 +-
 drivers/staging/vme/vme.c                  |  114 ++++++++--------
 4 files changed, 258 insertions(+), 257 deletions(-)


diff --git a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
index 4d74562..1f2089f 100644
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -58,7 +58,7 @@ static struct pci_driver ca91cx42_driver = {
 
 static u32 ca91cx42_DMA_irqhandler(struct ca91cx42_driver *bridge)
 {
-	wake_up(&(bridge->dma_queue));
+	wake_up(&bridge->dma_queue);
 
 	return CA91CX42_LINT_DMA;
 }
@@ -82,14 +82,14 @@ static u32 ca91cx42_LM_irqhandler(struct ca91cx42_driver *bridge, u32 stat)
 /* XXX This needs to be split into 4 queues */
 static u32 ca91cx42_MB_irqhandler(struct ca91cx42_driver *bridge, int mbox_mask)
 {
-	wake_up(&(bridge->mbox_queue));
+	wake_up(&bridge->mbox_queue);
 
 	return CA91CX42_LINT_MBOX;
 }
 
 static u32 ca91cx42_IACK_irqhandler(struct ca91cx42_driver *bridge)
 {
-	wake_up(&(bridge->iack_queue));
+	wake_up(&bridge->iack_queue);
 
 	return CA91CX42_LINT_SW_IACK;
 }
@@ -207,9 +207,9 @@ static int ca91cx42_irq_init(struct vme_bridge *ca91cx42_bridge)
 	pdev = container_of(ca91cx42_bridge->parent, struct pci_dev, dev);
 
 	/* Initialise list for VME bus errors */
-	INIT_LIST_HEAD(&(ca91cx42_bridge->vme_errors));
+	INIT_LIST_HEAD(&ca91cx42_bridge->vme_errors);
 
-	mutex_init(&(ca91cx42_bridge->irq_mtx));
+	mutex_init(&ca91cx42_bridge->irq_mtx);
 
 	/* Disable interrupts from PCI to VME */
 	iowrite32(0, bridge->base + VINT_EN);
@@ -299,7 +299,7 @@ int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
 	if (statid & 1)
 		return -EINVAL;
 
-	mutex_lock(&(bridge->vme_int));
+	mutex_lock(&bridge->vme_int);
 
 	tmp = ioread32(bridge->base + VINT_EN);
 
@@ -318,7 +318,7 @@ int ca91cx42_irq_generate(struct vme_bridge *ca91cx42_bridge, int level,
 	tmp = tmp & ~(1 << (level + 24));
 	iowrite32(tmp, bridge->base + VINT_EN);
 
-	mutex_unlock(&(bridge->vme_int));
+	mutex_unlock(&bridge->vme_int);
 
 	return 0;
 }
@@ -518,8 +518,8 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 		image->kern_base = NULL;
 		if (image->bus_resource.name != NULL)
 			kfree(image->bus_resource.name);
-		release_resource(&(image->bus_resource));
-		memset(&(image->bus_resource), 0, sizeof(struct resource));
+		release_resource(&image->bus_resource);
+		memset(&image->bus_resource, 0, sizeof(struct resource));
 	}
 
 	if (image->bus_resource.name == NULL) {
@@ -540,7 +540,7 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 	image->bus_resource.flags = IORESOURCE_MEM;
 
 	retval = pci_bus_alloc_resource(pdev->bus,
-		&(image->bus_resource), size, size, PCIBIOS_MIN_MEM,
+		&image->bus_resource, size, size, PCIBIOS_MIN_MEM,
 		0, NULL, NULL);
 	if (retval) {
 		dev_err(ca91cx42_bridge->parent, "Failed to allocate mem "
@@ -563,10 +563,10 @@ static int ca91cx42_alloc_resource(struct vme_master_resource *image,
 	iounmap(image->kern_base);
 	image->kern_base = NULL;
 err_remap:
-	release_resource(&(image->bus_resource));
+	release_resource(&image->bus_resource);
 err_resource:
 	kfree(image->bus_resource.name);
-	memset(&(image->bus_resource), 0, sizeof(struct resource));
+	memset(&image->bus_resource, 0, sizeof(struct resource));
 err_name:
 	return retval;
 }
@@ -578,9 +578,9 @@ static void ca91cx42_free_resource(struct vme_master_resource *image)
 {
 	iounmap(image->kern_base);
 	image->kern_base = NULL;
-	release_resource(&(image->bus_resource));
+	release_resource(&image->bus_resource);
 	kfree(image->bus_resource.name);
-	memset(&(image->bus_resource), 0, sizeof(struct resource));
+	memset(&image->bus_resource, 0, sizeof(struct resource));
 }
 
 
@@ -620,7 +620,7 @@ int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 		goto err_window;
 	}
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	/*
 	 * Let's allocate the resource here rather than further up the stack as
@@ -628,7 +628,7 @@ int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 	 */
 	retval = ca91cx42_alloc_resource(image, size);
 	if (retval) {
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(ca91cx42_bridge->parent, "Unable to allocate memory "
 			"for resource name\n");
 		retval = -ENOMEM;
@@ -672,7 +672,7 @@ int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 		temp_ctl |= CA91CX42_LSI_CTL_VDW_D64;
 		break;
 	default:
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(ca91cx42_bridge->parent, "Invalid data width\n");
 		retval = -EINVAL;
 		goto err_dwidth;
@@ -704,7 +704,7 @@ int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 	case VME_USER3:
 	case VME_USER4:
 	default:
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(ca91cx42_bridge->parent, "Invalid address space\n");
 		retval = -EINVAL;
 		goto err_aspace;
@@ -730,7 +730,7 @@ int ca91cx42_master_set(struct vme_master_resource *image, int enabled,
 
 	iowrite32(temp_ctl, bridge->base + CA91CX42_LSI_CTL[i]);
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 	return 0;
 
 err_aspace:
@@ -834,12 +834,12 @@ int ca91cx42_master_get(struct vme_master_resource *image, int *enabled,
 {
 	int retval;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	retval = __ca91cx42_master_get(image, enabled, vme_base, size, aspace,
 		cycle, dwidth);
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
 	return retval;
 }
@@ -855,7 +855,7 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
 	if (count == 0)
 		return 0;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	/* The following code handles VME address alignment problem
 	 * in order to assure the maximal data width cycle.
@@ -899,7 +899,7 @@ ssize_t ca91cx42_master_read(struct vme_master_resource *image, void *buf,
 	}
 out:
 	retval = count;
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
 	return retval;
 }
@@ -915,7 +915,7 @@ ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
 	if (count == 0)
 		return 0;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	/* Here we apply for the same strategy we do in master_read
 	 * function in order to assure D16 cycle when required.
@@ -954,7 +954,8 @@ ssize_t ca91cx42_master_write(struct vme_master_resource *image, void *buf,
 out:
 	retval = count;
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
+
 	return retval;
 }
 
@@ -974,10 +975,10 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	i = image->number;
 
 	/* Locking as we can only do one of these at a time */
-	mutex_lock(&(bridge->vme_rmw));
+	mutex_lock(&bridge->vme_rmw);
 
 	/* Lock image */
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	pci_addr = (u32)image->kern_base + offset;
 
@@ -1007,9 +1008,9 @@ unsigned int ca91cx42_master_rmw(struct vme_master_resource *image,
 	iowrite32(0, bridge->base + SCYC_CTL);
 
 out:
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
-	mutex_unlock(&(bridge->vme_rmw));
+	mutex_unlock(&bridge->vme_rmw);
 
 	return result;
 }
@@ -1036,14 +1037,14 @@ int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	}
 
 	/* Test descriptor alignment */
-	if ((unsigned long)&(entry->descriptor) & CA91CX42_DCPP_M) {
+	if ((unsigned long)&entry->descriptor & CA91CX42_DCPP_M) {
 		dev_err(dev, "Descriptor not aligned to 16 byte boundary as "
-			"required: %p\n", &(entry->descriptor));
+			"required: %p\n", &entry->descriptor);
 		retval = -EINVAL;
 		goto err_align;
 	}
 
-	memset(&(entry->descriptor), 0, sizeof(struct ca91cx42_dma_descriptor));
+	memset(&entry->descriptor, 0, sizeof(struct ca91cx42_dma_descriptor));
 
 	if (dest->type == VME_DMA_VME) {
 		entry->descriptor.dctl |= CA91CX42_DCTL_L2V;
@@ -1138,14 +1139,14 @@ int ca91cx42_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	entry->descriptor.dcpp = CA91CX42_DCPP_NULL;
 
 	/* Add to list */
-	list_add_tail(&(entry->list), &(list->entries));
+	list_add_tail(&entry->list, &list->entries);
 
 	/* Fill out previous descriptors "Next Address" */
-	if (entry->list.prev != &(list->entries)) {
+	if (entry->list.prev != &list->entries) {
 		prev = list_entry(entry->list.prev, struct ca91cx42_dma_entry,
 			list);
 		/* We need the bus address for the pointer */
-		desc_ptr = virt_to_bus(&(entry->descriptor));
+		desc_ptr = virt_to_bus(&entry->descriptor);
 		prev->descriptor.dcpp = desc_ptr & ~CA91CX42_DCPP_M;
 	}
 
@@ -1190,28 +1191,28 @@ int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 	bridge = ctrlr->parent->driver_priv;
 	dev = ctrlr->parent->parent;
 
-	mutex_lock(&(ctrlr->mtx));
+	mutex_lock(&ctrlr->mtx);
 
-	if (!(list_empty(&(ctrlr->running)))) {
+	if (!(list_empty(&ctrlr->running))) {
 		/*
 		 * XXX We have an active DMA transfer and currently haven't
 		 *     sorted out the mechanism for "pending" DMA transfers.
 		 *     Return busy.
 		 */
 		/* Need to add to pending here */
-		mutex_unlock(&(ctrlr->mtx));
+		mutex_unlock(&ctrlr->mtx);
 		return -EBUSY;
 	} else {
-		list_add(&(list->list), &(ctrlr->running));
+		list_add(&list->list, &ctrlr->running);
 	}
 
 	/* Get first bus address and write into registers */
-	entry = list_first_entry(&(list->entries), struct ca91cx42_dma_entry,
+	entry = list_first_entry(&list->entries, struct ca91cx42_dma_entry,
 		list);
 
-	bus_addr = virt_to_bus(&(entry->descriptor));
+	bus_addr = virt_to_bus(&entry->descriptor);
 
-	mutex_unlock(&(ctrlr->mtx));
+	mutex_unlock(&ctrlr->mtx);
 
 	iowrite32(0, bridge->base + DTBC);
 	iowrite32(bus_addr & ~CA91CX42_DCPP_M, bridge->base + DCPP);
@@ -1249,9 +1250,9 @@ int ca91cx42_dma_list_exec(struct vme_dma_list *list)
 	}
 
 	/* Remove list from running list */
-	mutex_lock(&(ctrlr->mtx));
-	list_del(&(list->list));
-	mutex_unlock(&(ctrlr->mtx));
+	mutex_lock(&ctrlr->mtx);
+	list_del(&list->list);
+	mutex_unlock(&ctrlr->mtx);
 
 	return retval;
 
@@ -1263,7 +1264,7 @@ int ca91cx42_dma_list_empty(struct vme_dma_list *list)
 	struct ca91cx42_dma_entry *entry;
 
 	/* detach and free each entry */
-	list_for_each_safe(pos, temp, &(list->entries)) {
+	list_for_each_safe(pos, temp, &list->entries) {
 		list_del(pos);
 		entry = list_entry(pos, struct ca91cx42_dma_entry, list);
 		kfree(entry);
@@ -1298,12 +1299,12 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 		return -EINVAL;
 	}
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* If we already have a callback attached, we can't move it! */
 	for (i = 0; i < lm->monitors; i++) {
 		if (bridge->lm_callback[i] != NULL) {
-			mutex_unlock(&(lm->mtx));
+			mutex_unlock(&lm->mtx);
 			dev_err(dev, "Location monitor callback attached, "
 				"can't reset\n");
 			return -EBUSY;
@@ -1321,7 +1322,7 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 		lm_ctl |= CA91CX42_LM_CTL_AS_A32;
 		break;
 	default:
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(dev, "Invalid address space\n");
 		return -EINVAL;
 		break;
@@ -1339,7 +1340,7 @@ int ca91cx42_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 	iowrite32(lm_base, bridge->base + LM_BS);
 	iowrite32(lm_ctl, bridge->base + LM_CTL);
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -1355,7 +1356,7 @@ int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
 
 	bridge = lm->parent->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	*lm_base = (unsigned long long)ioread32(bridge->base + LM_BS);
 	lm_ctl = ioread32(bridge->base + LM_CTL);
@@ -1380,7 +1381,7 @@ int ca91cx42_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
 	if (lm_ctl & CA91CX42_LM_CTL_DATA)
 		*cycle |= VME_DATA;
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return enabled;
 }
@@ -1400,19 +1401,19 @@ int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 	bridge = lm->parent->driver_priv;
 	dev = lm->parent->parent;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* Ensure that the location monitor is configured - need PGM or DATA */
 	lm_ctl = ioread32(bridge->base + LM_CTL);
 	if ((lm_ctl & (CA91CX42_LM_CTL_PGM | CA91CX42_LM_CTL_DATA)) == 0) {
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(dev, "Location monitor not properly configured\n");
 		return -EINVAL;
 	}
 
 	/* Check that a callback isn't already attached */
 	if (bridge->lm_callback[monitor] != NULL) {
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(dev, "Existing callback attached\n");
 		return -EBUSY;
 	}
@@ -1431,7 +1432,7 @@ int ca91cx42_lm_attach(struct vme_lm_resource *lm, int monitor,
 		iowrite32(lm_ctl, bridge->base + LM_CTL);
 	}
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -1446,7 +1447,7 @@ int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 
 	bridge = lm->parent->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* Disable Location Monitor and ensure previous interrupts are clear */
 	tmp = ioread32(bridge->base + LINT_EN);
@@ -1467,7 +1468,7 @@ int ca91cx42_lm_detach(struct vme_lm_resource *lm, int monitor)
 		iowrite32(tmp, bridge->base + LM_CTL);
 	}
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -1526,7 +1527,7 @@ static int ca91cx42_crcsr_init(struct vme_bridge *ca91cx42_bridge,
 
 	/* Allocate mem for CR/CSR image */
 	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&(bridge->crcsr_bus));
+		&bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for CR/CSR "
 			"image\n");
@@ -1632,12 +1633,12 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* Initialize wait queues & mutual exclusion flags */
-	init_waitqueue_head(&(ca91cx42_device->dma_queue));
-	init_waitqueue_head(&(ca91cx42_device->iack_queue));
-	mutex_init(&(ca91cx42_device->vme_int));
-	mutex_init(&(ca91cx42_device->vme_rmw));
+	init_waitqueue_head(&ca91cx42_device->dma_queue);
+	init_waitqueue_head(&ca91cx42_device->iack_queue);
+	mutex_init(&ca91cx42_device->vme_int);
+	mutex_init(&ca91cx42_device->vme_rmw);
 
-	ca91cx42_bridge->parent = &(pdev->dev);
+	ca91cx42_bridge->parent = &pdev->dev;
 	strcpy(ca91cx42_bridge->name, driver_name);
 
 	/* Setup IRQ */
@@ -1648,7 +1649,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* Add master windows to list */
-	INIT_LIST_HEAD(&(ca91cx42_bridge->master_resources));
+	INIT_LIST_HEAD(&ca91cx42_bridge->master_resources);
 	for (i = 0; i < CA91C142_MAX_MASTER; i++) {
 		master_image = kmalloc(sizeof(struct vme_master_resource),
 			GFP_KERNEL);
@@ -1659,7 +1660,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_master;
 		}
 		master_image->parent = ca91cx42_bridge;
-		spin_lock_init(&(master_image->lock));
+		spin_lock_init(&master_image->lock);
 		master_image->locked = 0;
 		master_image->number = i;
 		master_image->address_attr = VME_A16 | VME_A24 | VME_A32 |
@@ -1667,15 +1668,15 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		master_image->cycle_attr = VME_SCT | VME_BLT | VME_MBLT |
 			VME_SUPER | VME_USER | VME_PROG | VME_DATA;
 		master_image->width_attr = VME_D8 | VME_D16 | VME_D32 | VME_D64;
-		memset(&(master_image->bus_resource), 0,
+		memset(&master_image->bus_resource, 0,
 			sizeof(struct resource));
 		master_image->kern_base  = NULL;
-		list_add_tail(&(master_image->list),
-			&(ca91cx42_bridge->master_resources));
+		list_add_tail(&master_image->list,
+			&ca91cx42_bridge->master_resources);
 	}
 
 	/* Add slave windows to list */
-	INIT_LIST_HEAD(&(ca91cx42_bridge->slave_resources));
+	INIT_LIST_HEAD(&ca91cx42_bridge->slave_resources);
 	for (i = 0; i < CA91C142_MAX_SLAVE; i++) {
 		slave_image = kmalloc(sizeof(struct vme_slave_resource),
 			GFP_KERNEL);
@@ -1686,7 +1687,7 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_slave;
 		}
 		slave_image->parent = ca91cx42_bridge;
-		mutex_init(&(slave_image->mtx));
+		mutex_init(&slave_image->mtx);
 		slave_image->locked = 0;
 		slave_image->number = i;
 		slave_image->address_attr = VME_A24 | VME_A32 | VME_USER1 |
@@ -1698,12 +1699,12 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 
 		slave_image->cycle_attr = VME_SCT | VME_BLT | VME_MBLT |
 			VME_SUPER | VME_USER | VME_PROG | VME_DATA;
-		list_add_tail(&(slave_image->list),
-			&(ca91cx42_bridge->slave_resources));
+		list_add_tail(&slave_image->list,
+			&ca91cx42_bridge->slave_resources);
 	}
 
 	/* Add dma engines to list */
-	INIT_LIST_HEAD(&(ca91cx42_bridge->dma_resources));
+	INIT_LIST_HEAD(&ca91cx42_bridge->dma_resources);
 	for (i = 0; i < CA91C142_MAX_DMA; i++) {
 		dma_ctrlr = kmalloc(sizeof(struct vme_dma_resource),
 			GFP_KERNEL);
@@ -1714,19 +1715,19 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_dma;
 		}
 		dma_ctrlr->parent = ca91cx42_bridge;
-		mutex_init(&(dma_ctrlr->mtx));
+		mutex_init(&dma_ctrlr->mtx);
 		dma_ctrlr->locked = 0;
 		dma_ctrlr->number = i;
 		dma_ctrlr->route_attr = VME_DMA_VME_TO_MEM |
 			VME_DMA_MEM_TO_VME;
-		INIT_LIST_HEAD(&(dma_ctrlr->pending));
-		INIT_LIST_HEAD(&(dma_ctrlr->running));
-		list_add_tail(&(dma_ctrlr->list),
-			&(ca91cx42_bridge->dma_resources));
+		INIT_LIST_HEAD(&dma_ctrlr->pending);
+		INIT_LIST_HEAD(&dma_ctrlr->running);
+		list_add_tail(&dma_ctrlr->list,
+			&ca91cx42_bridge->dma_resources);
 	}
 
 	/* Add location monitor to list */
-	INIT_LIST_HEAD(&(ca91cx42_bridge->lm_resources));
+	INIT_LIST_HEAD(&ca91cx42_bridge->lm_resources);
 	lm = kmalloc(sizeof(struct vme_lm_resource), GFP_KERNEL);
 	if (lm == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for "
@@ -1735,11 +1736,11 @@ static int ca91cx42_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_lm;
 	}
 	lm->parent = ca91cx42_bridge;
-	mutex_init(&(lm->mtx));
+	mutex_init(&lm->mtx);
 	lm->locked = 0;
 	lm->number = 1;
 	lm->monitors = 4;
-	list_add_tail(&(lm->list), &(ca91cx42_bridge->lm_resources));
+	list_add_tail(&lm->list, &ca91cx42_bridge->lm_resources);
 
 	ca91cx42_bridge->slave_get = ca91cx42_slave_get;
 	ca91cx42_bridge->slave_set = ca91cx42_slave_set;
@@ -1786,28 +1787,28 @@ err_reg:
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 err_lm:
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->lm_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 err_dma:
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->dma_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 err_slave:
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->slave_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 err_master:
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->master_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
@@ -1870,28 +1871,28 @@ void ca91cx42_remove(struct pci_dev *pdev)
 	ca91cx42_crcsr_exit(ca91cx42_bridge, pdev);
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->lm_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->dma_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->slave_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(ca91cx42_bridge->master_resources)) {
+	list_for_each(pos, &ca91cx42_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
diff --git a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
index 492ddb2..1cba1fa 100644
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -81,11 +81,11 @@ static u32 tsi148_DMA_irqhandler(struct tsi148_driver *bridge,
 	u32 serviced = 0;
 
 	if (channel_mask & TSI148_LCSR_INTS_DMA0S) {
-		wake_up(&(bridge->dma_queue[0]));
+		wake_up(&bridge->dma_queue[0]);
 		serviced |= TSI148_LCSR_INTC_DMA0C;
 	}
 	if (channel_mask & TSI148_LCSR_INTS_DMA1S) {
-		wake_up(&(bridge->dma_queue[1]));
+		wake_up(&bridge->dma_queue[1]);
 		serviced |= TSI148_LCSR_INTC_DMA1C;
 	}
 
@@ -191,7 +191,7 @@ static u32 tsi148_VERR_irqhandler(struct vme_bridge *tsi148_bridge)
 	if (error) {
 		error->address = error_addr;
 		error->attributes = error_attrib;
-		list_add_tail(&(error->list), &(tsi148_bridge->vme_errors));
+		list_add_tail(&error->list, &tsi148_bridge->vme_errors);
 	} else {
 		dev_err(tsi148_bridge->parent, "Unable to alloc memory for "
 			"VMEbus Error reporting\n");
@@ -210,7 +210,7 @@ static u32 tsi148_VERR_irqhandler(struct vme_bridge *tsi148_bridge)
  */
 static u32 tsi148_IACK_irqhandler(struct tsi148_driver *bridge)
 {
-	wake_up(&(bridge->iack_queue));
+	wake_up(&bridge->iack_queue);
 
 	return TSI148_LCSR_INTC_IACKC;
 }
@@ -320,9 +320,9 @@ static int tsi148_irq_init(struct vme_bridge *tsi148_bridge)
 	bridge = tsi148_bridge->driver_priv;
 
 	/* Initialise list for VME bus errors */
-	INIT_LIST_HEAD(&(tsi148_bridge->vme_errors));
+	INIT_LIST_HEAD(&tsi148_bridge->vme_errors);
 
-	mutex_init(&(tsi148_bridge->irq_mtx));
+	mutex_init(&tsi148_bridge->irq_mtx);
 
 	result = request_irq(pdev->irq,
 			     tsi148_irqhandler,
@@ -452,7 +452,7 @@ int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
 
 	bridge = tsi148_bridge->driver_priv;
 
-	mutex_lock(&(bridge->vme_int));
+	mutex_lock(&bridge->vme_int);
 
 	/* Read VICR register */
 	tmp = ioread32be(bridge->base + TSI148_LCSR_VICR);
@@ -470,7 +470,7 @@ int tsi148_irq_generate(struct vme_bridge *tsi148_bridge, int level, int statid)
 	wait_event_interruptible(bridge->iack_queue,
 		tsi148_iack_received(bridge));
 
-	mutex_unlock(&(bridge->vme_int));
+	mutex_unlock(&bridge->vme_int);
 
 	return 0;
 }
@@ -496,7 +496,7 @@ static struct vme_bus_error *tsi148_find_error(struct vme_bridge *tsi148_bridge,
 	 */
 	err_pos = NULL;
 	/* Iterate through errors */
-	list_for_each(err_pos, &(tsi148_bridge->vme_errors)) {
+	list_for_each(err_pos, &tsi148_bridge->vme_errors) {
 		vme_err = list_entry(err_pos, struct vme_bus_error, list);
 		if ((vme_err->address >= address) &&
 			(vme_err->address < bound)) {
@@ -530,7 +530,7 @@ static void tsi148_clear_errors(struct vme_bridge *tsi148_bridge,
 	 */
 	err_pos = NULL;
 	/* Iterate through errors */
-	list_for_each_safe(err_pos, temp, &(tsi148_bridge->vme_errors)) {
+	list_for_each_safe(err_pos, temp, &tsi148_bridge->vme_errors) {
 		vme_err = list_entry(err_pos, struct vme_bus_error, list);
 
 		if ((vme_err->address >= address) &&
@@ -819,8 +819,8 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 		image->kern_base = NULL;
 		if (image->bus_resource.name != NULL)
 			kfree(image->bus_resource.name);
-		release_resource(&(image->bus_resource));
-		memset(&(image->bus_resource), 0, sizeof(struct resource));
+		release_resource(&image->bus_resource);
+		memset(&image->bus_resource, 0, sizeof(struct resource));
 	}
 
 	/* Exit here if size is zero */
@@ -845,7 +845,7 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 	image->bus_resource.flags = IORESOURCE_MEM;
 
 	retval = pci_bus_alloc_resource(pdev->bus,
-		&(image->bus_resource), size, size, PCIBIOS_MIN_MEM,
+		&image->bus_resource, size, size, PCIBIOS_MIN_MEM,
 		0, NULL, NULL);
 	if (retval) {
 		dev_err(tsi148_bridge->parent, "Failed to allocate mem "
@@ -868,10 +868,10 @@ static int tsi148_alloc_resource(struct vme_master_resource *image,
 	iounmap(image->kern_base);
 	image->kern_base = NULL;
 err_remap:
-	release_resource(&(image->bus_resource));
+	release_resource(&image->bus_resource);
 err_resource:
 	kfree(image->bus_resource.name);
-	memset(&(image->bus_resource), 0, sizeof(struct resource));
+	memset(&image->bus_resource, 0, sizeof(struct resource));
 err_name:
 	return retval;
 }
@@ -883,9 +883,9 @@ static void tsi148_free_resource(struct vme_master_resource *image)
 {
 	iounmap(image->kern_base);
 	image->kern_base = NULL;
-	release_resource(&(image->bus_resource));
+	release_resource(&image->bus_resource);
 	kfree(image->bus_resource.name);
-	memset(&(image->bus_resource), 0, sizeof(struct resource));
+	memset(&image->bus_resource, 0, sizeof(struct resource));
 }
 
 /*
@@ -924,7 +924,7 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 		goto err_window;
 	}
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	/* Let's allocate the resource here rather than further up the stack as
 	 * it avoids pushing loads of bus dependant stuff up the stack. If size
@@ -932,7 +932,7 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	 */
 	retval = tsi148_alloc_resource(image, size);
 	if (retval) {
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Unable to allocate memory for "
 			"resource\n");
 		goto err_res;
@@ -959,19 +959,19 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	reg_split(vme_offset, &vme_offset_high, &vme_offset_low);
 
 	if (pci_base_low & 0xFFFF) {
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid PCI base alignment\n");
 		retval = -EINVAL;
 		goto err_gran;
 	}
 	if (pci_bound_low & 0xFFFF) {
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid PCI bound alignment\n");
 		retval = -EINVAL;
 		goto err_gran;
 	}
 	if (vme_offset_low & 0xFFFF) {
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid VME Offset "
 			"alignment\n");
 		retval = -EINVAL;
@@ -1035,7 +1035,7 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 		temp_ctl |= TSI148_LCSR_OTAT_DBW_32;
 		break;
 	default:
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid data width\n");
 		retval = -EINVAL;
 		goto err_dwidth;
@@ -1072,7 +1072,7 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 		temp_ctl |= TSI148_LCSR_OTAT_AMODE_USER4;
 		break;
 	default:
-		spin_unlock(&(image->lock));
+		spin_unlock(&image->lock);
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		retval = -EINVAL;
 		goto err_aspace;
@@ -1109,7 +1109,7 @@ int tsi148_master_set(struct vme_master_resource *image, int enabled,
 	iowrite32be(temp_ctl, bridge->base + TSI148_LCSR_OT[i] +
 		TSI148_LCSR_OFFSET_OTAT);
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 	return 0;
 
 err_aspace:
@@ -1243,12 +1243,12 @@ int tsi148_master_get(struct vme_master_resource *image, int *enabled,
 {
 	int retval;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	retval = __tsi148_master_get(image, enabled, vme_base, size, aspace,
 		cycle, dwidth);
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
 	return retval;
 }
@@ -1266,7 +1266,7 @@ ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 
 	tsi148_bridge = image->parent;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	memcpy_fromio(buf, image->kern_base + offset, (unsigned int)count);
 	retval = count;
@@ -1289,7 +1289,7 @@ ssize_t tsi148_master_read(struct vme_master_resource *image, void *buf,
 	}
 
 skip_chk:
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
 	return retval;
 }
@@ -1312,7 +1312,7 @@ ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 
 	bridge = tsi148_bridge->driver_priv;
 
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	memcpy_toio(image->kern_base + offset, buf, (unsigned int)count);
 	retval = count;
@@ -1352,7 +1352,7 @@ ssize_t tsi148_master_write(struct vme_master_resource *image, void *buf,
 	}
 
 skip_chk:
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
 	return retval;
 }
@@ -1378,10 +1378,10 @@ unsigned int tsi148_master_rmw(struct vme_master_resource *image,
 	i = image->number;
 
 	/* Locking as we can only do one of these at a time */
-	mutex_lock(&(bridge->vme_rmw));
+	mutex_lock(&bridge->vme_rmw);
 
 	/* Lock image */
-	spin_lock(&(image->lock));
+	spin_lock(&image->lock);
 
 	pci_addr_high = ioread32be(bridge->base + TSI148_LCSR_OT[i] +
 		TSI148_LCSR_OFFSET_OTSAU);
@@ -1411,9 +1411,9 @@ unsigned int tsi148_master_rmw(struct vme_master_resource *image,
 	tmp &= ~TSI148_LCSR_VMCTRL_RMWEN;
 	iowrite32be(tmp, bridge->base + TSI148_LCSR_VMCTRL);
 
-	spin_unlock(&(image->lock));
+	spin_unlock(&image->lock);
 
-	mutex_unlock(&(bridge->vme_rmw));
+	mutex_unlock(&bridge->vme_rmw);
 
 	return result;
 }
@@ -1633,10 +1633,10 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	}
 
 	/* Test descriptor alignment */
-	if ((unsigned long)&(entry->descriptor) & 0x7) {
+	if ((unsigned long)&entry->descriptor & 0x7) {
 		dev_err(tsi148_bridge->parent, "Descriptor not aligned to 8 "
 			"byte boundary as required: %p\n",
-			&(entry->descriptor));
+			&entry->descriptor);
 		retval = -EINVAL;
 		goto err_align;
 	}
@@ -1644,7 +1644,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	/* Given we are going to fill out the structure, we probably don't
 	 * need to zero it, but better safe than sorry for now.
 	 */
-	memset(&(entry->descriptor), 0, sizeof(struct tsi148_dma_descriptor));
+	memset(&entry->descriptor, 0, sizeof(struct tsi148_dma_descriptor));
 
 	/* Fill out source part */
 	switch (src->type) {
@@ -1681,7 +1681,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 		entry->descriptor.dsat = TSI148_LCSR_DSAT_TYP_VME;
 
 		retval = tsi148_dma_set_vme_src_attributes(
-			tsi148_bridge->parent, &(entry->descriptor.dsat),
+			tsi148_bridge->parent, &entry->descriptor.dsat,
 			vme_attr->aspace, vme_attr->cycle, vme_attr->dwidth);
 		if (retval < 0)
 			goto err_source;
@@ -1719,7 +1719,7 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 		entry->descriptor.ddat = TSI148_LCSR_DDAT_TYP_VME;
 
 		retval = tsi148_dma_set_vme_dest_attributes(
-			tsi148_bridge->parent, &(entry->descriptor.ddat),
+			tsi148_bridge->parent, &entry->descriptor.ddat,
 			vme_attr->aspace, vme_attr->cycle, vme_attr->dwidth);
 		if (retval < 0)
 			goto err_dest;
@@ -1735,16 +1735,16 @@ int tsi148_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 	entry->descriptor.dcnt = (u32)count;
 
 	/* Add to list */
-	list_add_tail(&(entry->list), &(list->entries));
+	list_add_tail(&entry->list, &list->entries);
 
 	/* Fill out previous descriptors "Next Address" */
-	if (entry->list.prev != &(list->entries)) {
+	if (entry->list.prev != &list->entries) {
 		prev = list_entry(entry->list.prev, struct tsi148_dma_entry,
 			list);
 		/* We need the bus address for the pointer */
-		desc_ptr = virt_to_bus(&(entry->descriptor));
-		reg_split(desc_ptr, &(prev->descriptor.dnlau),
-			&(prev->descriptor.dnlal));
+		desc_ptr = virt_to_bus(&entry->descriptor);
+		reg_split(desc_ptr, &prev->descriptor.dnlau,
+			&prev->descriptor.dnlal);
 	}
 
 	return 0;
@@ -1799,30 +1799,30 @@ int tsi148_dma_list_exec(struct vme_dma_list *list)
 
 	bridge = tsi148_bridge->driver_priv;
 
-	mutex_lock(&(ctrlr->mtx));
+	mutex_lock(&ctrlr->mtx);
 
 	channel = ctrlr->number;
 
-	if (!list_empty(&(ctrlr->running))) {
+	if (!list_empty(&ctrlr->running)) {
 		/*
 		 * XXX We have an active DMA transfer and currently haven't
 		 *     sorted out the mechanism for "pending" DMA transfers.
 		 *     Return busy.
 		 */
 		/* Need to add to pending here */
-		mutex_unlock(&(ctrlr->mtx));
+		mutex_unlock(&ctrlr->mtx);
 		return -EBUSY;
 	} else {
-		list_add(&(list->list), &(ctrlr->running));
+		list_add(&list->list, &ctrlr->running);
 	}
 
 	/* Get first bus address and write into registers */
-	entry = list_first_entry(&(list->entries), struct tsi148_dma_entry,
+	entry = list_first_entry(&list->entries, struct tsi148_dma_entry,
 		list);
 
-	bus_addr = virt_to_bus(&(entry->descriptor));
+	bus_addr = virt_to_bus(&entry->descriptor);
 
-	mutex_unlock(&(ctrlr->mtx));
+	mutex_unlock(&ctrlr->mtx);
 
 	reg_split(bus_addr, &bus_addr_high, &bus_addr_low);
 
@@ -1850,9 +1850,9 @@ int tsi148_dma_list_exec(struct vme_dma_list *list)
 	}
 
 	/* Remove list from running list */
-	mutex_lock(&(ctrlr->mtx));
-	list_del(&(list->list));
-	mutex_unlock(&(ctrlr->mtx));
+	mutex_lock(&ctrlr->mtx);
+	list_del(&list->list);
+	mutex_unlock(&ctrlr->mtx);
 
 	return retval;
 }
@@ -1868,7 +1868,7 @@ int tsi148_dma_list_empty(struct vme_dma_list *list)
 	struct tsi148_dma_entry *entry;
 
 	/* detach and free each entry */
-	list_for_each_safe(pos, temp, &(list->entries)) {
+	list_for_each_safe(pos, temp, &list->entries) {
 		list_del(pos);
 		entry = list_entry(pos, struct tsi148_dma_entry, list);
 		kfree(entry);
@@ -1896,12 +1896,12 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 
 	bridge = tsi148_bridge->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* If we already have a callback attached, we can't move it! */
 	for (i = 0; i < lm->monitors; i++) {
 		if (bridge->lm_callback[i] != NULL) {
-			mutex_unlock(&(lm->mtx));
+			mutex_unlock(&lm->mtx);
 			dev_err(tsi148_bridge->parent, "Location monitor "
 				"callback attached, can't reset\n");
 			return -EBUSY;
@@ -1922,7 +1922,7 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 		lm_ctl |= TSI148_LCSR_LMAT_AS_A64;
 		break;
 	default:
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(tsi148_bridge->parent, "Invalid address space\n");
 		return -EINVAL;
 		break;
@@ -1943,7 +1943,7 @@ int tsi148_lm_set(struct vme_lm_resource *lm, unsigned long long lm_base,
 	iowrite32be(lm_base_low, bridge->base + TSI148_LCSR_LMBAL);
 	iowrite32be(lm_ctl, bridge->base + TSI148_LCSR_LMAT);
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -1959,7 +1959,7 @@ int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
 
 	bridge = lm->parent->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	lm_base_high = ioread32be(bridge->base + TSI148_LCSR_LMBAU);
 	lm_base_low = ioread32be(bridge->base + TSI148_LCSR_LMBAL);
@@ -1992,7 +1992,7 @@ int tsi148_lm_get(struct vme_lm_resource *lm, unsigned long long *lm_base,
 	if (lm_ctl & TSI148_LCSR_LMAT_DATA)
 		*cycle |= VME_DATA;
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return enabled;
 }
@@ -2013,12 +2013,12 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 
 	bridge = tsi148_bridge->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* Ensure that the location monitor is configured - need PGM or DATA */
 	lm_ctl = ioread32be(bridge->base + TSI148_LCSR_LMAT);
 	if ((lm_ctl & (TSI148_LCSR_LMAT_PGM | TSI148_LCSR_LMAT_DATA)) == 0) {
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(tsi148_bridge->parent, "Location monitor not properly "
 			"configured\n");
 		return -EINVAL;
@@ -2026,7 +2026,7 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 
 	/* Check that a callback isn't already attached */
 	if (bridge->lm_callback[monitor] != NULL) {
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 		dev_err(tsi148_bridge->parent, "Existing callback attached\n");
 		return -EBUSY;
 	}
@@ -2049,7 +2049,7 @@ int tsi148_lm_attach(struct vme_lm_resource *lm, int monitor,
 		iowrite32be(lm_ctl, bridge->base + TSI148_LCSR_LMAT);
 	}
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -2064,7 +2064,7 @@ int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 
 	bridge = lm->parent->driver_priv;
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* Disable Location Monitor and ensure previous interrupts are clear */
 	lm_en = ioread32be(bridge->base + TSI148_LCSR_INTEN);
@@ -2089,7 +2089,7 @@ int tsi148_lm_detach(struct vme_lm_resource *lm, int monitor)
 		iowrite32be(tmp, bridge->base + TSI148_LCSR_LMAT);
 	}
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	return 0;
 }
@@ -2142,7 +2142,7 @@ static int tsi148_crcsr_init(struct vme_bridge *tsi148_bridge,
 
 	/* Allocate mem for CR/CSR image */
 	bridge->crcsr_kernel = pci_alloc_consistent(pdev, VME_CRCSR_BUF_SIZE,
-		&(bridge->crcsr_bus));
+		&bridge->crcsr_bus);
 	if (bridge->crcsr_kernel == NULL) {
 		dev_err(tsi148_bridge->parent, "Failed to allocate memory for "
 			"CR/CSR image\n");
@@ -2280,13 +2280,13 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 	}
 
 	/* Initialize wait queues & mutual exclusion flags */
-	init_waitqueue_head(&(tsi148_device->dma_queue[0]));
-	init_waitqueue_head(&(tsi148_device->dma_queue[1]));
-	init_waitqueue_head(&(tsi148_device->iack_queue));
-	mutex_init(&(tsi148_device->vme_int));
-	mutex_init(&(tsi148_device->vme_rmw));
+	init_waitqueue_head(&tsi148_device->dma_queue[0]);
+	init_waitqueue_head(&tsi148_device->dma_queue[1]);
+	init_waitqueue_head(&tsi148_device->iack_queue);
+	mutex_init(&tsi148_device->vme_int);
+	mutex_init(&tsi148_device->vme_rmw);
 
-	tsi148_bridge->parent = &(pdev->dev);
+	tsi148_bridge->parent = &pdev->dev;
 	strcpy(tsi148_bridge->name, driver_name);
 
 	/* Setup IRQ */
@@ -2314,7 +2314,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_master;
 		}
 		tsi148_device->flush_image->parent = tsi148_bridge;
-		spin_lock_init(&(tsi148_device->flush_image->lock));
+		spin_lock_init(&tsi148_device->flush_image->lock);
 		tsi148_device->flush_image->locked = 1;
 		tsi148_device->flush_image->number = master_num;
 		tsi148_device->flush_image->address_attr = VME_A16 | VME_A24 |
@@ -2324,13 +2324,13 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			VME_2eSST160 | VME_2eSST267 | VME_2eSST320 | VME_SUPER |
 			VME_USER | VME_PROG | VME_DATA;
 		tsi148_device->flush_image->width_attr = VME_D16 | VME_D32;
-		memset(&(tsi148_device->flush_image->bus_resource), 0,
+		memset(&tsi148_device->flush_image->bus_resource, 0,
 			sizeof(struct resource));
 		tsi148_device->flush_image->kern_base  = NULL;
 	}
 
 	/* Add master windows to list */
-	INIT_LIST_HEAD(&(tsi148_bridge->master_resources));
+	INIT_LIST_HEAD(&tsi148_bridge->master_resources);
 	for (i = 0; i < master_num; i++) {
 		master_image = kmalloc(sizeof(struct vme_master_resource),
 			GFP_KERNEL);
@@ -2341,7 +2341,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_master;
 		}
 		master_image->parent = tsi148_bridge;
-		spin_lock_init(&(master_image->lock));
+		spin_lock_init(&master_image->lock);
 		master_image->locked = 0;
 		master_image->number = i;
 		master_image->address_attr = VME_A16 | VME_A24 | VME_A32 |
@@ -2351,15 +2351,15 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			VME_2eSST267 | VME_2eSST320 | VME_SUPER | VME_USER |
 			VME_PROG | VME_DATA;
 		master_image->width_attr = VME_D16 | VME_D32;
-		memset(&(master_image->bus_resource), 0,
+		memset(&master_image->bus_resource, 0,
 			sizeof(struct resource));
 		master_image->kern_base  = NULL;
-		list_add_tail(&(master_image->list),
-			&(tsi148_bridge->master_resources));
+		list_add_tail(&master_image->list,
+			&tsi148_bridge->master_resources);
 	}
 
 	/* Add slave windows to list */
-	INIT_LIST_HEAD(&(tsi148_bridge->slave_resources));
+	INIT_LIST_HEAD(&tsi148_bridge->slave_resources);
 	for (i = 0; i < TSI148_MAX_SLAVE; i++) {
 		slave_image = kmalloc(sizeof(struct vme_slave_resource),
 			GFP_KERNEL);
@@ -2370,7 +2370,7 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_slave;
 		}
 		slave_image->parent = tsi148_bridge;
-		mutex_init(&(slave_image->mtx));
+		mutex_init(&slave_image->mtx);
 		slave_image->locked = 0;
 		slave_image->number = i;
 		slave_image->address_attr = VME_A16 | VME_A24 | VME_A32 |
@@ -2380,12 +2380,12 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			VME_2eVME | VME_2eSST | VME_2eSSTB | VME_2eSST160 |
 			VME_2eSST267 | VME_2eSST320 | VME_SUPER | VME_USER |
 			VME_PROG | VME_DATA;
-		list_add_tail(&(slave_image->list),
-			&(tsi148_bridge->slave_resources));
+		list_add_tail(&slave_image->list,
+			&tsi148_bridge->slave_resources);
 	}
 
 	/* Add dma engines to list */
-	INIT_LIST_HEAD(&(tsi148_bridge->dma_resources));
+	INIT_LIST_HEAD(&tsi148_bridge->dma_resources);
 	for (i = 0; i < TSI148_MAX_DMA; i++) {
 		dma_ctrlr = kmalloc(sizeof(struct vme_dma_resource),
 			GFP_KERNEL);
@@ -2396,21 +2396,21 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 			goto err_dma;
 		}
 		dma_ctrlr->parent = tsi148_bridge;
-		mutex_init(&(dma_ctrlr->mtx));
+		mutex_init(&dma_ctrlr->mtx);
 		dma_ctrlr->locked = 0;
 		dma_ctrlr->number = i;
 		dma_ctrlr->route_attr = VME_DMA_VME_TO_MEM |
 			VME_DMA_MEM_TO_VME | VME_DMA_VME_TO_VME |
 			VME_DMA_MEM_TO_MEM | VME_DMA_PATTERN_TO_VME |
 			VME_DMA_PATTERN_TO_MEM;
-		INIT_LIST_HEAD(&(dma_ctrlr->pending));
-		INIT_LIST_HEAD(&(dma_ctrlr->running));
-		list_add_tail(&(dma_ctrlr->list),
-			&(tsi148_bridge->dma_resources));
+		INIT_LIST_HEAD(&dma_ctrlr->pending);
+		INIT_LIST_HEAD(&dma_ctrlr->running);
+		list_add_tail(&dma_ctrlr->list,
+			&tsi148_bridge->dma_resources);
 	}
 
 	/* Add location monitor to list */
-	INIT_LIST_HEAD(&(tsi148_bridge->lm_resources));
+	INIT_LIST_HEAD(&tsi148_bridge->lm_resources);
 	lm = kmalloc(sizeof(struct vme_lm_resource), GFP_KERNEL);
 	if (lm == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for "
@@ -2419,11 +2419,11 @@ static int tsi148_probe(struct pci_dev *pdev, const struct pci_device_id *id)
 		goto err_lm;
 	}
 	lm->parent = tsi148_bridge;
-	mutex_init(&(lm->mtx));
+	mutex_init(&lm->mtx);
 	lm->locked = 0;
 	lm->number = 1;
 	lm->monitors = 4;
-	list_add_tail(&(lm->list), &(tsi148_bridge->lm_resources));
+	list_add_tail(&lm->list, &tsi148_bridge->lm_resources);
 
 	tsi148_bridge->slave_get = tsi148_slave_get;
 	tsi148_bridge->slave_set = tsi148_slave_set;
@@ -2483,28 +2483,28 @@ err_reg:
 err_crcsr:
 err_lm:
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->lm_resources)) {
+	list_for_each(pos, &tsi148_bridge->lm_resources) {
 		lm = list_entry(pos, struct vme_lm_resource, list);
 		list_del(pos);
 		kfree(lm);
 	}
 err_dma:
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->dma_resources)) {
+	list_for_each(pos, &tsi148_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 err_slave:
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->slave_resources)) {
+	list_for_each(pos, &tsi148_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 err_master:
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->master_resources)) {
+	list_for_each(pos, &tsi148_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
@@ -2589,21 +2589,21 @@ static void tsi148_remove(struct pci_dev *pdev)
 	tsi148_crcsr_exit(tsi148_bridge, pdev);
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->dma_resources)) {
+	list_for_each(pos, &tsi148_bridge->dma_resources) {
 		dma_ctrlr = list_entry(pos, struct vme_dma_resource, list);
 		list_del(pos);
 		kfree(dma_ctrlr);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->slave_resources)) {
+	list_for_each(pos, &tsi148_bridge->slave_resources) {
 		slave_image = list_entry(pos, struct vme_slave_resource, list);
 		list_del(pos);
 		kfree(slave_image);
 	}
 
 	/* resources are stored in link list */
-	list_for_each(pos, &(tsi148_bridge->master_resources)) {
+	list_for_each(pos, &tsi148_bridge->master_resources) {
 		master_image = list_entry(pos, struct vme_master_resource,
 			list);
 		list_del(pos);
diff --git a/drivers/staging/vme/devices/vme_user.c b/drivers/staging/vme/devices/vme_user.c
index 71bbc52..cbe2e11 100644
--- a/drivers/staging/vme/devices/vme_user.c
+++ b/drivers/staging/vme/devices/vme_user.c
@@ -470,9 +470,9 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			 *	to userspace as they are
 			 */
 			retval = vme_master_get(image[minor].resource,
-				&(master.enable), &(master.vme_addr),
-				&(master.size), &(master.aspace),
-				&(master.cycle), &(master.dwidth));
+				&master.enable, &master.vme_addr,
+				&master.size, &master.aspace,
+				&master.cycle, &master.dwidth);
 
 			copied = copy_to_user((char *)arg, &master,
 				sizeof(struct vme_master));
@@ -514,9 +514,9 @@ static int vme_user_ioctl(struct inode *inode, struct file *file,
 			 *	to userspace as they are
 			 */
 			retval = vme_slave_get(image[minor].resource,
-				&(slave.enable), &(slave.vme_addr),
-				&(slave.size), &pci_addr, &(slave.aspace),
-				&(slave.cycle));
+				&slave.enable, &slave.vme_addr,
+				&slave.size, &pci_addr, &slave.aspace,
+				&slave.cycle);
 
 			copied = copy_to_user((char *)arg, &slave,
 				sizeof(struct vme_slave));
@@ -683,7 +683,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 	for (i = 0; i < VME_DEVS; i++) {
 		image[i].kern_buf = NULL;
 		image[i].pci_buf = 0;
-		sema_init(&(image[i].sem), 1);
+		sema_init(&image[i].sem, 1);
 		image[i].device = NULL;
 		image[i].resource = NULL;
 		image[i].users = 0;
@@ -727,7 +727,7 @@ static int __init vme_user_probe(struct device *dev, int cur_bus, int cur_slot)
 		}
 		image[i].size_buf = PCI_BUF_SIZE;
 		image[i].kern_buf = vme_alloc_consistent(image[i].resource,
-			image[i].size_buf, &(image[i].pci_buf));
+			image[i].size_buf, &image[i].pci_buf);
 		if (image[i].kern_buf == NULL) {
 			printk(KERN_WARNING "Unable to allocate memory for "
 				"buffer\n");
diff --git a/drivers/staging/vme/vme.c b/drivers/staging/vme/vme.c
index 093fbff..47e9d5c 100644
--- a/drivers/staging/vme/vme.c
+++ b/drivers/staging/vme/vme.c
@@ -245,7 +245,7 @@ struct vme_resource *vme_slave_request(struct device *dev,
 	}
 
 	/* Loop through slave resources */
-	list_for_each(slave_pos, &(bridge->slave_resources)) {
+	list_for_each(slave_pos, &bridge->slave_resources) {
 		slave_image = list_entry(slave_pos,
 			struct vme_slave_resource, list);
 
@@ -255,17 +255,17 @@ struct vme_resource *vme_slave_request(struct device *dev,
 		}
 
 		/* Find an unlocked and compatible image */
-		mutex_lock(&(slave_image->mtx));
+		mutex_lock(&slave_image->mtx);
 		if (((slave_image->address_attr & address) == address) &&
 			((slave_image->cycle_attr & cycle) == cycle) &&
 			(slave_image->locked == 0)) {
 
 			slave_image->locked = 1;
-			mutex_unlock(&(slave_image->mtx));
+			mutex_unlock(&slave_image->mtx);
 			allocated_image = slave_image;
 			break;
 		}
-		mutex_unlock(&(slave_image->mtx));
+		mutex_unlock(&slave_image->mtx);
 	}
 
 	/* No free image */
@@ -278,15 +278,15 @@ struct vme_resource *vme_slave_request(struct device *dev,
 		goto err_alloc;
 	}
 	resource->type = VME_SLAVE;
-	resource->entry = &(allocated_image->list);
+	resource->entry = &allocated_image->list;
 
 	return resource;
 
 err_alloc:
 	/* Unlock image */
-	mutex_lock(&(slave_image->mtx));
+	mutex_lock(&slave_image->mtx);
 	slave_image->locked = 0;
-	mutex_unlock(&(slave_image->mtx));
+	mutex_unlock(&slave_image->mtx);
 err_image:
 err_bus:
 	return NULL;
@@ -369,12 +369,12 @@ void vme_slave_free(struct vme_resource *resource)
 	}
 
 	/* Unlock image */
-	mutex_lock(&(slave_image->mtx));
+	mutex_lock(&slave_image->mtx);
 	if (slave_image->locked == 0)
 		printk(KERN_ERR "Image is already free\n");
 
 	slave_image->locked = 0;
-	mutex_unlock(&(slave_image->mtx));
+	mutex_unlock(&slave_image->mtx);
 
 	/* Free up resource memory */
 	kfree(resource);
@@ -401,7 +401,7 @@ struct vme_resource *vme_master_request(struct device *dev,
 	}
 
 	/* Loop through master resources */
-	list_for_each(master_pos, &(bridge->master_resources)) {
+	list_for_each(master_pos, &bridge->master_resources) {
 		master_image = list_entry(master_pos,
 			struct vme_master_resource, list);
 
@@ -411,18 +411,18 @@ struct vme_resource *vme_master_request(struct device *dev,
 		}
 
 		/* Find an unlocked and compatible image */
-		spin_lock(&(master_image->lock));
+		spin_lock(&master_image->lock);
 		if (((master_image->address_attr & address) == address) &&
 			((master_image->cycle_attr & cycle) == cycle) &&
 			((master_image->width_attr & dwidth) == dwidth) &&
 			(master_image->locked == 0)) {
 
 			master_image->locked = 1;
-			spin_unlock(&(master_image->lock));
+			spin_unlock(&master_image->lock);
 			allocated_image = master_image;
 			break;
 		}
-		spin_unlock(&(master_image->lock));
+		spin_unlock(&master_image->lock);
 	}
 
 	/* Check to see if we found a resource */
@@ -437,16 +437,16 @@ struct vme_resource *vme_master_request(struct device *dev,
 		goto err_alloc;
 	}
 	resource->type = VME_MASTER;
-	resource->entry = &(allocated_image->list);
+	resource->entry = &allocated_image->list;
 
 	return resource;
 
 	kfree(resource);
 err_alloc:
 	/* Unlock image */
-	spin_lock(&(master_image->lock));
+	spin_lock(&master_image->lock);
 	master_image->locked = 0;
-	spin_unlock(&(master_image->lock));
+	spin_unlock(&master_image->lock);
 err_image:
 err_bus:
 	return NULL;
@@ -628,12 +628,12 @@ void vme_master_free(struct vme_resource *resource)
 	}
 
 	/* Unlock image */
-	spin_lock(&(master_image->lock));
+	spin_lock(&master_image->lock);
 	if (master_image->locked == 0)
 		printk(KERN_ERR "Image is already free\n");
 
 	master_image->locked = 0;
-	spin_unlock(&(master_image->lock));
+	spin_unlock(&master_image->lock);
 
 	/* Free up resource memory */
 	kfree(resource);
@@ -662,7 +662,7 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 	}
 
 	/* Loop through DMA resources */
-	list_for_each(dma_pos, &(bridge->dma_resources)) {
+	list_for_each(dma_pos, &bridge->dma_resources) {
 		dma_ctrlr = list_entry(dma_pos,
 			struct vme_dma_resource, list);
 
@@ -672,16 +672,16 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 		}
 
 		/* Find an unlocked and compatible controller */
-		mutex_lock(&(dma_ctrlr->mtx));
+		mutex_lock(&dma_ctrlr->mtx);
 		if (((dma_ctrlr->route_attr & route) == route) &&
 			(dma_ctrlr->locked == 0)) {
 
 			dma_ctrlr->locked = 1;
-			mutex_unlock(&(dma_ctrlr->mtx));
+			mutex_unlock(&dma_ctrlr->mtx);
 			allocated_ctrlr = dma_ctrlr;
 			break;
 		}
-		mutex_unlock(&(dma_ctrlr->mtx));
+		mutex_unlock(&dma_ctrlr->mtx);
 	}
 
 	/* Check to see if we found a resource */
@@ -694,15 +694,15 @@ struct vme_resource *vme_dma_request(struct device *dev, vme_dma_route_t route)
 		goto err_alloc;
 	}
 	resource->type = VME_DMA;
-	resource->entry = &(allocated_ctrlr->list);
+	resource->entry = &allocated_ctrlr->list;
 
 	return resource;
 
 err_alloc:
 	/* Unlock image */
-	mutex_lock(&(dma_ctrlr->mtx));
+	mutex_lock(&dma_ctrlr->mtx);
 	dma_ctrlr->locked = 0;
-	mutex_unlock(&(dma_ctrlr->mtx));
+	mutex_unlock(&dma_ctrlr->mtx);
 err_ctrlr:
 err_bus:
 	return NULL;
@@ -729,9 +729,9 @@ struct vme_dma_list *vme_new_dma_list(struct vme_resource *resource)
 		printk(KERN_ERR "Unable to allocate memory for new dma list\n");
 		return NULL;
 	}
-	INIT_LIST_HEAD(&(dma_list->entries));
+	INIT_LIST_HEAD(&dma_list->entries);
 	dma_list->parent = ctrlr;
-	mutex_init(&(dma_list->mtx));
+	mutex_init(&dma_list->mtx);
 
 	return dma_list;
 }
@@ -880,14 +880,14 @@ int vme_dma_list_add(struct vme_dma_list *list, struct vme_dma_attr *src,
 		return -EINVAL;
 	}
 
-	if (!mutex_trylock(&(list->mtx))) {
+	if (!mutex_trylock(&list->mtx)) {
 		printk(KERN_ERR "Link List already submitted\n");
 		return -EINVAL;
 	}
 
 	retval = bridge->dma_list_add(list, src, dest, count);
 
-	mutex_unlock(&(list->mtx));
+	mutex_unlock(&list->mtx);
 
 	return retval;
 }
@@ -903,11 +903,11 @@ int vme_dma_list_exec(struct vme_dma_list *list)
 		return -EINVAL;
 	}
 
-	mutex_lock(&(list->mtx));
+	mutex_lock(&list->mtx);
 
 	retval = bridge->dma_list_exec(list);
 
-	mutex_unlock(&(list->mtx));
+	mutex_unlock(&list->mtx);
 
 	return retval;
 }
@@ -923,7 +923,7 @@ int vme_dma_list_free(struct vme_dma_list *list)
 		return -EINVAL;
 	}
 
-	if (!mutex_trylock(&(list->mtx))) {
+	if (!mutex_trylock(&list->mtx)) {
 		printk(KERN_ERR "Link List in use\n");
 		return -EINVAL;
 	}
@@ -935,10 +935,10 @@ int vme_dma_list_free(struct vme_dma_list *list)
 	retval = bridge->dma_list_empty(list);
 	if (retval) {
 		printk(KERN_ERR "Unable to empty link-list entries\n");
-		mutex_unlock(&(list->mtx));
+		mutex_unlock(&list->mtx);
 		return retval;
 	}
-	mutex_unlock(&(list->mtx));
+	mutex_unlock(&list->mtx);
 	kfree(list);
 
 	return retval;
@@ -956,20 +956,20 @@ int vme_dma_free(struct vme_resource *resource)
 
 	ctrlr = list_entry(resource->entry, struct vme_dma_resource, list);
 
-	if (!mutex_trylock(&(ctrlr->mtx))) {
+	if (!mutex_trylock(&ctrlr->mtx)) {
 		printk(KERN_ERR "Resource busy, can't free\n");
 		return -EBUSY;
 	}
 
-	if (!(list_empty(&(ctrlr->pending)) && list_empty(&(ctrlr->running)))) {
+	if (!(list_empty(&ctrlr->pending) && list_empty(&ctrlr->running))) {
 		printk(KERN_WARNING "Resource still processing transfers\n");
-		mutex_unlock(&(ctrlr->mtx));
+		mutex_unlock(&ctrlr->mtx);
 		return -EBUSY;
 	}
 
 	ctrlr->locked = 0;
 
-	mutex_unlock(&(ctrlr->mtx));
+	mutex_unlock(&ctrlr->mtx);
 
 	return 0;
 }
@@ -1013,10 +1013,10 @@ int vme_irq_request(struct device *dev, int level, int statid,
 		return -EINVAL;
 	}
 
-	mutex_lock(&(bridge->irq_mtx));
+	mutex_lock(&bridge->irq_mtx);
 
 	if (bridge->irq[level - 1].callback[statid].func) {
-		mutex_unlock(&(bridge->irq_mtx));
+		mutex_unlock(&bridge->irq_mtx);
 		printk(KERN_WARNING "VME Interrupt already taken\n");
 		return -EBUSY;
 	}
@@ -1028,7 +1028,7 @@ int vme_irq_request(struct device *dev, int level, int statid,
 	/* Enable IRQ level */
 	bridge->irq_set(bridge, level, 1, 1);
 
-	mutex_unlock(&(bridge->irq_mtx));
+	mutex_unlock(&bridge->irq_mtx);
 
 	return 0;
 }
@@ -1054,7 +1054,7 @@ void vme_irq_free(struct device *dev, int level, int statid)
 		return;
 	}
 
-	mutex_lock(&(bridge->irq_mtx));
+	mutex_lock(&bridge->irq_mtx);
 
 	bridge->irq[level - 1].count--;
 
@@ -1065,7 +1065,7 @@ void vme_irq_free(struct device *dev, int level, int statid)
 	bridge->irq[level - 1].callback[statid].func = NULL;
 	bridge->irq[level - 1].callback[statid].priv_data = NULL;
 
-	mutex_unlock(&(bridge->irq_mtx));
+	mutex_unlock(&bridge->irq_mtx);
 }
 EXPORT_SYMBOL(vme_irq_free);
 
@@ -1111,7 +1111,7 @@ struct vme_resource *vme_lm_request(struct device *dev)
 	}
 
 	/* Loop through DMA resources */
-	list_for_each(lm_pos, &(bridge->lm_resources)) {
+	list_for_each(lm_pos, &bridge->lm_resources) {
 		lm = list_entry(lm_pos,
 			struct vme_lm_resource, list);
 
@@ -1122,14 +1122,14 @@ struct vme_resource *vme_lm_request(struct device *dev)
 		}
 
 		/* Find an unlocked controller */
-		mutex_lock(&(lm->mtx));
+		mutex_lock(&lm->mtx);
 		if (lm->locked == 0) {
 			lm->locked = 1;
-			mutex_unlock(&(lm->mtx));
+			mutex_unlock(&lm->mtx);
 			allocated_lm = lm;
 			break;
 		}
-		mutex_unlock(&(lm->mtx));
+		mutex_unlock(&lm->mtx);
 	}
 
 	/* Check to see if we found a resource */
@@ -1142,15 +1142,15 @@ struct vme_resource *vme_lm_request(struct device *dev)
 		goto err_alloc;
 	}
 	resource->type = VME_LM;
-	resource->entry = &(allocated_lm->list);
+	resource->entry = &allocated_lm->list;
 
 	return resource;
 
 err_alloc:
 	/* Unlock image */
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 	lm->locked = 0;
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 err_lm:
 err_bus:
 	return NULL;
@@ -1270,7 +1270,7 @@ void vme_lm_free(struct vme_resource *resource)
 
 	lm = list_entry(resource->entry, struct vme_lm_resource, list);
 
-	mutex_lock(&(lm->mtx));
+	mutex_lock(&lm->mtx);
 
 	/* XXX
 	 * Check to see that there aren't any callbacks still attached, if
@@ -1279,7 +1279,7 @@ void vme_lm_free(struct vme_resource *resource)
 
 	lm->locked = 0;
 
-	mutex_unlock(&(lm->mtx));
+	mutex_unlock(&lm->mtx);
 
 	kfree(resource);
 }
@@ -1343,11 +1343,11 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	 * specification.
 	 */
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &(bridge->dev[i]);
+		dev = &bridge->dev[i];
 		memset(dev, 0, sizeof(struct device));
 
 		dev->parent = bridge->parent;
-		dev->bus = &(vme_bus_type);
+		dev->bus = &vme_bus_type;
 		/*
 		 * We save a pointer to the bridge in platform_data so that we
 		 * can get to it later. We keep driver_data for use by the
@@ -1366,7 +1366,7 @@ int vme_register_bridge(struct vme_bridge *bridge)
 	i = VME_SLOTS_MAX;
 err_reg:
 	while (i > -1) {
-		dev = &(bridge->dev[i]);
+		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
 	vme_free_bus_num(bridge->num);
@@ -1381,7 +1381,7 @@ void vme_unregister_bridge(struct vme_bridge *bridge)
 
 
 	for (i = 0; i < VME_SLOTS_MAX; i++) {
-		dev = &(bridge->dev[i]);
+		dev = &bridge->dev[i];
 		device_unregister(dev);
 	}
 	vme_free_bus_num(bridge->num);
@@ -1418,7 +1418,7 @@ static int vme_calc_slot(struct device *dev)
 	/* Determine slot number */
 	num = 0;
 	while (num < VME_SLOTS_MAX) {
-		if (&(bridge->dev[num]) == dev)
+		if (&bridge->dev[num] == dev)
 			break;
 
 		num++;


--
Martyn Welch (Principal Software Engineer)   |   Registered in England and
GE Intelligent Platforms                     |   Wales (3828642) at 100
T +44(0)127322748                            |   Barbirolli Square, Manchester,
E martyn.welch@ge.com                        |   M2 3AB  VAT:GB 927559189
