Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751816Ab0GJHNI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 03:13:08 -0400
Received: from hera.kernel.org ([140.211.167.34]:34568 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751613Ab0GJHNF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 03:13:05 -0400
Date: Sat, 10 Jul 2010 07:12:46 +0000
From: Denis Kirjanov <dkirjanov@hera.kernel.org>
To: gregkh@suse.de
Cc: liodot@gmail.com, charrer@alacritech.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH -staging] slicoss: kill functions prototypes and reorder
	functions
Message-ID: <20100710071246.GA28570@hera.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 10 Jul 2010 07:12:50 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder functions to kill their prototypes.

Signed-off-by: Denis Kirjanov <dkirjanov@kernel.org>
---
drivers/staging/slicoss/slicoss.c | 3910 ++++++++++++++++++-------------------
 1 files changed, 1920 insertions(+), 1990 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index d3fc577..d442e3b 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -97,66 +97,6 @@
 #include "slichw.h"
 #include "slic.h"
 
-static struct net_device_stats *slic_get_stats(struct net_device *dev);
-static int slic_entry_open(struct net_device *dev);
-static int slic_entry_halt(struct net_device *dev);
-static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd);
-static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev);
-static void slic_xmit_fail(struct adapter *adapter, struct sk_buff *skb,
-			   void *cmd, u32 skbtype, u32 status);
-static void slic_config_pci(struct pci_dev *pcidev);
-static struct sk_buff *slic_rcvqueue_getnext(struct adapter *adapter);
-static int slic_mac_set_address(struct net_device *dev, void *ptr);
-static void slic_link_event_handler(struct adapter *adapter);
-static void slic_upr_request_complete(struct adapter *adapter, u32 isr);
-static int slic_rspqueue_init(struct adapter *adapter);
-static void slic_rspqueue_free(struct adapter *adapter);
-static struct slic_rspbuf *slic_rspqueue_getnext(struct adapter *adapter);
-static int slic_cmdq_init(struct adapter *adapter);
-static void slic_cmdq_free(struct adapter *adapter);
-static void slic_cmdq_reset(struct adapter *adapter);
-static void slic_cmdq_addcmdpage(struct adapter *adapter, u32 *page);
-static void slic_cmdq_getdone(struct adapter *adapter);
-static void slic_cmdq_putdone_irq(struct adapter *adapter,
-				  struct slic_hostcmd *cmd);
-static struct slic_hostcmd *slic_cmdq_getfree(struct adapter *adapter);
-static int slic_rcvqueue_init(struct adapter *adapter);
-static int slic_rcvqueue_fill(struct adapter *adapter);
-static u32 slic_rcvqueue_reinsert(struct adapter *adapter, struct sk_buff *skb);
-static void slic_rcvqueue_free(struct adapter *adapter);
-static void slic_adapter_set_hwaddr(struct adapter *adapter);
-static int slic_card_init(struct sliccard *card, struct adapter *adapter);
-static void slic_intagg_set(struct adapter *adapter, u32 value);
-static int slic_card_download(struct adapter *adapter);
-static u32 slic_card_locate(struct adapter *adapter);
-static int slic_if_init(struct adapter *adapter);
-static int slic_adapter_allocresources(struct adapter *adapter);
-static void slic_adapter_freeresources(struct adapter *adapter);
-static void slic_link_config(struct adapter *adapter, u32 linkspeed,
-			     u32 linkduplex);
-static void slic_unmap_mmio_space(struct adapter *adapter);
-static void slic_card_cleanup(struct sliccard *card);
-static void slic_soft_reset(struct adapter *adapter);
-static bool slic_mac_filter(struct adapter *adapter,
-			    struct ether_header *ether_frame);
-static void slic_mac_address_config(struct adapter *adapter);
-static void slic_mac_config(struct adapter *adapter);
-static void slic_mcast_set_mask(struct adapter *adapter);
-static void slic_config_set(struct adapter *adapter, bool linkchange);
-static void slic_config_clear(struct adapter *adapter);
-static void slic_config_get(struct adapter *adapter, u32 config,
-			    u32 configh);
-static void slic_timer_load_check(ulong context);
-static void slic_assert_fail(void);
-static ushort slic_eeprom_cksum(char *m, int len);
-static void slic_upr_start(struct adapter *adapter);
-static void slic_link_upr_complete(struct adapter *adapter, u32 Isr);
-static int  slic_upr_request(struct adapter *adapter, u32 upr_request,
-			     u32 upr_data, u32 upr_data_h, u32 upr_buffer,
-			     u32 upr_buffer_h);
-static void slic_mcast_set_list(struct net_device *dev);
-
-
 static uint slic_first_init = 1;
 static char *slic_banner = "Alacritech SLIC Technology(tm) Server "\
 		"and Storage Accelerator (Non-Accelerated)";
@@ -206,6 +146,17 @@ MODULE_DEVICE_TABLE(pci, slic_pci_tbl);
 #undef ASSERT
 #endif
 
+static void slic_assert_fail(void)
+{
+	u32 cpuid;
+	u32 curr_pid;
+	cpuid = smp_processor_id();
+	curr_pid = current->pid;
+
+	printk(KERN_ERR "%s CPU # %d ---- PID # %d\n",
+	       __func__, cpuid, curr_pid);
+}
+
 #ifndef ASSERT
 #define ASSERT(a) do {							\
 	if (!(a)) {							\
@@ -241,13 +192,6 @@ MODULE_DEVICE_TABLE(pci, slic_pci_tbl);
 			_adapter->handle_lock.flags);                   \
 }
 
-static void slic_debug_init(void);
-static void slic_debug_cleanup(void);
-static void slic_debug_adapter_create(struct adapter *adapter);
-static void slic_debug_adapter_destroy(struct adapter *adapter);
-static void slic_debug_card_create(struct sliccard *card);
-static void slic_debug_card_destroy(struct sliccard *card);
-
 static inline void slic_reg32_write(void __iomem *reg, u32 value, bool flush)
 {
 	writel(value, reg);
@@ -272,1016 +216,6 @@ static inline void slic_reg64_write(struct adapter *adapter, void __iomem *reg,
 				adapter->bit64reglock.flags);
 }
 
-static void slic_init_driver(void)
-{
-	if (slic_first_init) {
-		slic_first_init = 0;
-		spin_lock_init(&slic_global.driver_lock.lock);
-		slic_debug_init();
-	}
-}
-
-static void slic_init_adapter(struct net_device *netdev,
-			      struct pci_dev *pcidev,
-			      const struct pci_device_id *pci_tbl_entry,
-			      void __iomem *memaddr, int chip_idx)
-{
-	ushort index;
-	struct slic_handle *pslic_handle;
-	struct adapter *adapter = netdev_priv(netdev);
-
-/*	adapter->pcidev = pcidev;*/
-	adapter->vendid = pci_tbl_entry->vendor;
-	adapter->devid = pci_tbl_entry->device;
-	adapter->subsysid = pci_tbl_entry->subdevice;
-	adapter->busnumber = pcidev->bus->number;
-	adapter->slotnumber = ((pcidev->devfn >> 3) & 0x1F);
-	adapter->functionnumber = (pcidev->devfn & 0x7);
-	adapter->memorylength = pci_resource_len(pcidev, 0);
-	adapter->slic_regs = (__iomem struct slic_regs *)memaddr;
-	adapter->irq = pcidev->irq;
-/*	adapter->netdev = netdev;*/
-	adapter->next_netdevice = head_netdevice;
-	head_netdevice = netdev;
-	adapter->chipid = chip_idx;
-	adapter->port = 0;	/*adapter->functionnumber;*/
-	adapter->cardindex = adapter->port;
-	adapter->memorybase = memaddr;
-	spin_lock_init(&adapter->upr_lock.lock);
-	spin_lock_init(&adapter->bit64reglock.lock);
-	spin_lock_init(&adapter->adapter_lock.lock);
-	spin_lock_init(&adapter->reset_lock.lock);
-	spin_lock_init(&adapter->handle_lock.lock);
-
-	adapter->card_size = 1;
-	/*
-	  Initialize slic_handle array
-	*/
-	ASSERT(SLIC_CMDQ_MAXCMDS <= 0xFFFF);
-	/*
-	 Start with 1.  0 is an invalid host handle.
-	*/
-	for (index = 1, pslic_handle = &adapter->slic_handles[1];
-	     index < SLIC_CMDQ_MAXCMDS; index++, pslic_handle++) {
-
-		pslic_handle->token.handle_index = index;
-		pslic_handle->type = SLIC_HANDLE_FREE;
-		pslic_handle->next = adapter->pfree_slic_handles;
-		adapter->pfree_slic_handles = pslic_handle;
-	}
-	adapter->pshmem = (struct slic_shmem *)
-					pci_alloc_consistent(adapter->pcidev,
-					sizeof(struct slic_shmem),
-					&adapter->
-					phys_shmem);
-	ASSERT(adapter->pshmem);
-
-	memset(adapter->pshmem, 0, sizeof(struct slic_shmem));
-
-	return;
-}
-
-static const struct net_device_ops slic_netdev_ops = {
-	.ndo_open		= slic_entry_open,
-	.ndo_stop		= slic_entry_halt,
-	.ndo_start_xmit		= slic_xmit_start,
-	.ndo_do_ioctl		= slic_ioctl,
-	.ndo_set_mac_address	= slic_mac_set_address,
-	.ndo_get_stats		= slic_get_stats,
-	.ndo_set_multicast_list	= slic_mcast_set_list,
-	.ndo_validate_addr	= eth_validate_addr,
-	.ndo_change_mtu		= eth_change_mtu,
-};
-
-static int __devinit slic_entry_probe(struct pci_dev *pcidev,
-			       const struct pci_device_id *pci_tbl_entry)
-{
-	static int cards_found;
-	static int did_version;
-	int err = -ENODEV;
-	struct net_device *netdev;
-	struct adapter *adapter;
-	void __iomem *memmapped_ioaddr = NULL;
-	u32 status = 0;
-	ulong mmio_start = 0;
-	ulong mmio_len = 0;
-	struct sliccard *card = NULL;
-	int pci_using_dac = 0;
-
-	slic_global.dynamic_intagg = dynamic_intagg;
-
-	err = pci_enable_device(pcidev);
-
-	if (err)
-		return err;
-
-	if (slic_debug > 0 && did_version++ == 0) {
-		printk(KERN_DEBUG "%s\n", slic_banner);
-		printk(KERN_DEBUG "%s\n", slic_proc_version);
-	}
-
-	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
-		pci_using_dac = 1;
-		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
-			dev_err(&pcidev->dev, "unable to obtain 64-bit DMA for "
-					"consistent allocations\n");
-			goto err_out_disable_pci;
-		}
-	} else if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
-		pci_using_dac = 0;
-		pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
-	} else {
-		dev_err(&pcidev->dev, "no usable DMA configuration\n");
-		goto err_out_disable_pci;
-	}
-
-	err = pci_request_regions(pcidev, DRV_NAME);
-	if (err) {
-		dev_err(&pcidev->dev, "can't obtain PCI resources\n");
-		goto err_out_disable_pci;
-	}
-
-	pci_set_master(pcidev);
-
-	netdev = alloc_etherdev(sizeof(struct adapter));
-	if (!netdev) {
-		err = -ENOMEM;
-		goto err_out_exit_slic_probe;
-	}
-
-	SET_NETDEV_DEV(netdev, &pcidev->dev);
-
-	pci_set_drvdata(pcidev, netdev);
-	adapter = netdev_priv(netdev);
-	adapter->netdev = netdev;
-	adapter->pcidev = pcidev;
-	if (pci_using_dac)
-		netdev->features |= NETIF_F_HIGHDMA;
-
-	mmio_start = pci_resource_start(pcidev, 0);
-	mmio_len = pci_resource_len(pcidev, 0);
-
-
-/*	memmapped_ioaddr =  (u32)ioremap_nocache(mmio_start, mmio_len);*/
-	memmapped_ioaddr = ioremap(mmio_start, mmio_len);
-	if (!memmapped_ioaddr) {
-		dev_err(&pcidev->dev, "cannot remap MMIO region %lx @ %lx\n",
-			mmio_len, mmio_start);
-		goto err_out_free_netdev;
-	}
-
-	slic_config_pci(pcidev);
-
-	slic_init_driver();
-
-	slic_init_adapter(netdev,
-			  pcidev, pci_tbl_entry, memmapped_ioaddr, cards_found);
-
-	status = slic_card_locate(adapter);
-	if (status) {
-		dev_err(&pcidev->dev, "cannot locate card\n");
-		goto err_out_free_mmio_region;
-	}
-
-	card = adapter->card;
-
-	if (!adapter->allocated) {
-		card->adapters_allocated++;
-		adapter->allocated = 1;
-	}
-
-	status = slic_card_init(card, adapter);
-
-	if (status != 0) {
-		card->state = CARD_FAIL;
-		adapter->state = ADAPT_FAIL;
-		adapter->linkstate = LINK_DOWN;
-		dev_err(&pcidev->dev, "FAILED status[%x]\n", status);
-	} else {
-		slic_adapter_set_hwaddr(adapter);
-	}
-
-	netdev->base_addr = (unsigned long)adapter->memorybase;
-	netdev->irq = adapter->irq;
-	netdev->netdev_ops = &slic_netdev_ops;
-
-	slic_debug_adapter_create(adapter);
-
-	strcpy(netdev->name, "eth%d");
-	err = register_netdev(netdev);
-	if (err) {
-		dev_err(&pcidev->dev, "Cannot register net device, aborting.\n");
-		goto err_out_unmap;
-	}
-
-	cards_found++;
-
-	return status;
-
-err_out_unmap:
-	iounmap(memmapped_ioaddr);
-err_out_free_mmio_region:
-	release_mem_region(mmio_start, mmio_len);
-err_out_free_netdev:
-	free_netdev(netdev);
-err_out_exit_slic_probe:
-	pci_release_regions(pcidev);
-err_out_disable_pci:
-	pci_disable_device(pcidev);
-	return err;
-}
-
-static int slic_entry_open(struct net_device *dev)
-{
-	struct adapter *adapter = netdev_priv(dev);
-	struct sliccard *card = adapter->card;
-	u32 locked = 0;
-	int status;
-
-	ASSERT(adapter);
-	ASSERT(card);
-
-	netif_stop_queue(adapter->netdev);
-
-	spin_lock_irqsave(&slic_global.driver_lock.lock,
-				slic_global.driver_lock.flags);
-	locked = 1;
-	if (!adapter->activated) {
-		card->adapters_activated++;
-		slic_global.num_slic_ports_active++;
-		adapter->activated = 1;
-	}
-	status = slic_if_init(adapter);
-
-	if (status != 0) {
-		if (adapter->activated) {
-			card->adapters_activated--;
-			slic_global.num_slic_ports_active--;
-			adapter->activated = 0;
-		}
-		if (locked) {
-			spin_unlock_irqrestore(&slic_global.driver_lock.lock,
-						slic_global.driver_lock.flags);
-			locked = 0;
-		}
-		return status;
-	}
-	if (!card->master)
-		card->master = adapter;
-
-	if (locked) {
-		spin_unlock_irqrestore(&slic_global.driver_lock.lock,
-					slic_global.driver_lock.flags);
-		locked = 0;
-	}
-
-	return 0;
-}
-
-static void __devexit slic_entry_remove(struct pci_dev *pcidev)
-{
-	struct net_device *dev = pci_get_drvdata(pcidev);
-	u32 mmio_start = 0;
-	uint mmio_len = 0;
-	struct adapter *adapter = netdev_priv(dev);
-	struct sliccard *card;
-	struct mcast_address *mcaddr, *mlist;
-
-	ASSERT(adapter);
-	slic_adapter_freeresources(adapter);
-	slic_unmap_mmio_space(adapter);
-	unregister_netdev(dev);
-
-	mmio_start = pci_resource_start(pcidev, 0);
-	mmio_len = pci_resource_len(pcidev, 0);
-
-	release_mem_region(mmio_start, mmio_len);
-
-	iounmap((void __iomem *)dev->base_addr);
-	/* free multicast addresses */
-	mlist = adapter->mcastaddrs;
-	while (mlist) {
-		mcaddr = mlist;
-		mlist = mlist->next;
-		kfree(mcaddr);
-	}
-	ASSERT(adapter->card);
-	card = adapter->card;
-	ASSERT(card->adapters_allocated);
-	card->adapters_allocated--;
-	adapter->allocated = 0;
-	if (!card->adapters_allocated) {
-		struct sliccard *curr_card = slic_global.slic_card;
-		if (curr_card == card) {
-			slic_global.slic_card = card->next;
-		} else {
-			while (curr_card->next != card)
-				curr_card = curr_card->next;
-			ASSERT(curr_card);
-			curr_card->next = card->next;
-		}
-		ASSERT(slic_global.num_slic_cards);
-		slic_global.num_slic_cards--;
-		slic_card_cleanup(card);
-	}
-	kfree(dev);
-	pci_release_regions(pcidev);
-}
-
-static int slic_entry_halt(struct net_device *dev)
-{
-	struct adapter *adapter = netdev_priv(dev);
-	struct sliccard *card = adapter->card;
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-
-	spin_lock_irqsave(&slic_global.driver_lock.lock,
-				slic_global.driver_lock.flags);
-	ASSERT(card);
-	netif_stop_queue(adapter->netdev);
-	adapter->state = ADAPT_DOWN;
-	adapter->linkstate = LINK_DOWN;
-	adapter->upr_list = NULL;
-	adapter->upr_busy = 0;
-	adapter->devflags_prev = 0;
-	ASSERT(card->adapter[adapter->cardindex] == adapter);
-	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
-	adapter->all_reg_writes++;
-	adapter->icr_reg_writes++;
-	slic_config_clear(adapter);
-	if (adapter->activated) {
-		card->adapters_activated--;
-		slic_global.num_slic_ports_active--;
-		adapter->activated = 0;
-	}
-#ifdef AUTOMATIC_RESET
-	slic_reg32_write(&slic_regs->slic_reset_iface, 0, FLUSH);
-#endif
-	/*
-	 *  Reset the adapter's cmd queues
-	 */
-	slic_cmdq_reset(adapter);
-
-#ifdef AUTOMATIC_RESET
-	if (!card->adapters_activated)
-		slic_card_init(card, adapter);
-#endif
-
-	spin_unlock_irqrestore(&slic_global.driver_lock.lock,
-				slic_global.driver_lock.flags);
-	return 0;
-}
-
-static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
-{
-	struct adapter *adapter = netdev_priv(dev);
-	struct ethtool_cmd edata;
-	struct ethtool_cmd ecmd;
-	u32 data[7];
-	u32 intagg;
-
-	ASSERT(rq);
-	switch (cmd) {
-	case SIOCSLICSETINTAGG:
-		if (copy_from_user(data, rq->ifr_data, 28))
-			return -EFAULT;
-		intagg = data[0];
-		dev_err(&dev->dev, "%s: set interrupt aggregation to %d\n",
-			__func__, intagg);
-		slic_intagg_set(adapter, intagg);
-		return 0;
-
-#ifdef SLIC_TRACE_DUMP_ENABLED
-	case SIOCSLICTRACEDUMP:
-		{
-			u32 value;
-			DBG_IOCTL("slic_ioctl  SIOCSLIC_TRACE_DUMP\n");
-
-			if (copy_from_user(data, rq->ifr_data, 28)) {
-				PRINT_ERROR
-				    ("slic: copy_from_user FAILED getting initial simba param\n");
-				return -EFAULT;
-			}
-
-			value = data[0];
-			if (tracemon_request == SLIC_DUMP_DONE) {
-				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested\n");
-				tracemon_request = SLIC_DUMP_REQUESTED;
-				tracemon_request_type = value;
-				tracemon_timestamp = jiffies;
-			} else if ((tracemon_request == SLIC_DUMP_REQUESTED) ||
-				   (tracemon_request ==
-				    SLIC_DUMP_IN_PROGRESS)) {
-				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
-			} else {
-				PRINT_ERROR
-				    ("ATK Diagnostic Trace Dump Requested\n");
-				tracemon_request = SLIC_DUMP_REQUESTED;
-				tracemon_request_type = value;
-				tracemon_timestamp = jiffies;
-			}
-			return 0;
-		}
-#endif
-	case SIOCETHTOOL:
-		ASSERT(adapter);
-		if (copy_from_user(&ecmd, rq->ifr_data, sizeof(ecmd)))
-			return -EFAULT;
-
-		if (ecmd.cmd == ETHTOOL_GSET) {
-			edata.supported = (SUPPORTED_10baseT_Half |
-					   SUPPORTED_10baseT_Full |
-					   SUPPORTED_100baseT_Half |
-					   SUPPORTED_100baseT_Full |
-					   SUPPORTED_Autoneg | SUPPORTED_MII);
-			edata.port = PORT_MII;
-			edata.transceiver = XCVR_INTERNAL;
-			edata.phy_address = 0;
-			if (adapter->linkspeed == LINK_100MB)
-				edata.speed = SPEED_100;
-			else if (adapter->linkspeed == LINK_10MB)
-				edata.speed = SPEED_10;
-			else
-				edata.speed = 0;
-
-			if (adapter->linkduplex == LINK_FULLD)
-				edata.duplex = DUPLEX_FULL;
-			else
-				edata.duplex = DUPLEX_HALF;
-
-			edata.autoneg = AUTONEG_ENABLE;
-			edata.maxtxpkt = 1;
-			edata.maxrxpkt = 1;
-			if (copy_to_user(rq->ifr_data, &edata, sizeof(edata)))
-				return -EFAULT;
-
-		} else if (ecmd.cmd == ETHTOOL_SSET) {
-			if (!capable(CAP_NET_ADMIN))
-				return -EPERM;
-
-			if (adapter->linkspeed == LINK_100MB)
-				edata.speed = SPEED_100;
-			else if (adapter->linkspeed == LINK_10MB)
-				edata.speed = SPEED_10;
-			else
-				edata.speed = 0;
-
-			if (adapter->linkduplex == LINK_FULLD)
-				edata.duplex = DUPLEX_FULL;
-			else
-				edata.duplex = DUPLEX_HALF;
-
-			edata.autoneg = AUTONEG_ENABLE;
-			edata.maxtxpkt = 1;
-			edata.maxrxpkt = 1;
-			if ((ecmd.speed != edata.speed) ||
-			    (ecmd.duplex != edata.duplex)) {
-				u32 speed;
-				u32 duplex;
-
-				if (ecmd.speed == SPEED_10)
-					speed = 0;
-				else
-					speed = PCR_SPEED_100;
-				if (ecmd.duplex == DUPLEX_FULL)
-					duplex = PCR_DUPLEX_FULL;
-				else
-					duplex = 0;
-				slic_link_config(adapter, speed, duplex);
-				slic_link_event_handler(adapter);
-			}
-		}
-		return 0;
-	default:
-		return -EOPNOTSUPP;
-	}
-}
-
-#define  XMIT_FAIL_LINK_STATE               1
-#define  XMIT_FAIL_ZERO_LENGTH              2
-#define  XMIT_FAIL_HOSTCMD_FAIL             3
-
-static void slic_xmit_build_request(struct adapter *adapter,
-			     struct slic_hostcmd *hcmd, struct sk_buff *skb)
-{
-	struct slic_host64_cmd *ihcmd;
-	ulong phys_addr;
-
-	ihcmd = &hcmd->cmd64;
-
-	ihcmd->flags = (adapter->port << IHFLG_IFSHFT);
-	ihcmd->command = IHCMD_XMT_REQ;
-	ihcmd->u.slic_buffers.totlen = skb->len;
-	phys_addr = pci_map_single(adapter->pcidev, skb->data, skb->len,
-			PCI_DMA_TODEVICE);
-	ihcmd->u.slic_buffers.bufs[0].paddrl = SLIC_GET_ADDR_LOW(phys_addr);
-	ihcmd->u.slic_buffers.bufs[0].paddrh = SLIC_GET_ADDR_HIGH(phys_addr);
-	ihcmd->u.slic_buffers.bufs[0].length = skb->len;
-#if defined(CONFIG_X86_64)
-	hcmd->cmdsize = (u32) ((((u64)&ihcmd->u.slic_buffers.bufs[1] -
-				     (u64) hcmd) + 31) >> 5);
-#elif defined(CONFIG_X86)
-	hcmd->cmdsize = ((((u32) &ihcmd->u.slic_buffers.bufs[1] -
-			   (u32) hcmd) + 31) >> 5);
-#else
-	Stop Compilation;
-#endif
-}
-
-#define NORMAL_ETHFRAME     0
-
-static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
-{
-	struct sliccard *card;
-	struct adapter *adapter = netdev_priv(dev);
-	struct slic_hostcmd *hcmd = NULL;
-	u32 status = 0;
-	u32 skbtype = NORMAL_ETHFRAME;
-	void *offloadcmd = NULL;
-
-	card = adapter->card;
-	ASSERT(card);
-	if ((adapter->linkstate != LINK_UP) ||
-	    (adapter->state != ADAPT_UP) || (card->state != CARD_UP)) {
-		status = XMIT_FAIL_LINK_STATE;
-		goto xmit_fail;
-
-	} else if (skb->len == 0) {
-		status = XMIT_FAIL_ZERO_LENGTH;
-		goto xmit_fail;
-	}
-
-	if (skbtype == NORMAL_ETHFRAME) {
-		hcmd = slic_cmdq_getfree(adapter);
-		if (!hcmd) {
-			adapter->xmitq_full = 1;
-			status = XMIT_FAIL_HOSTCMD_FAIL;
-			goto xmit_fail;
-		}
-		ASSERT(hcmd->pslic_handle);
-		ASSERT(hcmd->cmd64.hosthandle ==
-		       hcmd->pslic_handle->token.handle_token);
-		hcmd->skb = skb;
-		hcmd->busy = 1;
-		hcmd->type = SLIC_CMD_DUMB;
-		if (skbtype == NORMAL_ETHFRAME)
-			slic_xmit_build_request(adapter, hcmd, skb);
-	}
-	adapter->stats.tx_packets++;
-	adapter->stats.tx_bytes += skb->len;
-
-#ifdef DEBUG_DUMP
-	if (adapter->kill_card) {
-		struct slic_host64_cmd ihcmd;
-
-		ihcmd = &hcmd->cmd64;
-
-		ihcmd->flags |= 0x40;
-		adapter->kill_card = 0;	/* only do this once */
-	}
-#endif
-	if (hcmd->paddrh == 0) {
-		slic_reg32_write(&adapter->slic_regs->slic_cbar,
-				 (hcmd->paddrl | hcmd->cmdsize), DONT_FLUSH);
-	} else {
-		slic_reg64_write(adapter, &adapter->slic_regs->slic_cbar64,
-				 (hcmd->paddrl | hcmd->cmdsize),
-				 &adapter->slic_regs->slic_addr_upper,
-				 hcmd->paddrh, DONT_FLUSH);
-	}
-xmit_done:
-	return NETDEV_TX_OK;
-xmit_fail:
-	slic_xmit_fail(adapter, skb, offloadcmd, skbtype, status);
-	goto xmit_done;
-}
-
-static void slic_xmit_fail(struct adapter *adapter,
-		    struct sk_buff *skb,
-		    void *cmd, u32 skbtype, u32 status)
-{
-	if (adapter->xmitq_full)
-		netif_stop_queue(adapter->netdev);
-	if ((cmd == NULL) && (status <= XMIT_FAIL_HOSTCMD_FAIL)) {
-		switch (status) {
-		case XMIT_FAIL_LINK_STATE:
-			dev_err(&adapter->netdev->dev,
-				"reject xmit skb[%p: %x] linkstate[%s] "
-				"adapter[%s:%d] card[%s:%d]\n",
-				skb, skb->pkt_type,
-				SLIC_LINKSTATE(adapter->linkstate),
-				SLIC_ADAPTER_STATE(adapter->state),
-				adapter->state,
-				SLIC_CARD_STATE(adapter->card->state),
-				adapter->card->state);
-			break;
-		case XMIT_FAIL_ZERO_LENGTH:
-			dev_err(&adapter->netdev->dev,
-				"xmit_start skb->len == 0 skb[%p] type[%x]\n",
-				skb, skb->pkt_type);
-			break;
-		case XMIT_FAIL_HOSTCMD_FAIL:
-			dev_err(&adapter->netdev->dev,
-				"xmit_start skb[%p] type[%x] No host commands "
-				"available\n", skb, skb->pkt_type);
-			break;
-		default:
-			ASSERT(0);
-		}
-	}
-	dev_kfree_skb(skb);
-	adapter->stats.tx_dropped++;
-}
-
-static void slic_rcv_handle_error(struct adapter *adapter,
-					struct slic_rcvbuf *rcvbuf)
-{
-	struct slic_hddr_wds *hdr = (struct slic_hddr_wds *)rcvbuf->data;
-
-	if (adapter->devid != SLIC_1GB_DEVICE_ID) {
-		if (hdr->frame_status14 & VRHSTAT_802OE)
-			adapter->if_events.oflow802++;
-		if (hdr->frame_status14 & VRHSTAT_TPOFLO)
-			adapter->if_events.Tprtoflow++;
-		if (hdr->frame_status_b14 & VRHSTATB_802UE)
-			adapter->if_events.uflow802++;
-		if (hdr->frame_status_b14 & VRHSTATB_RCVE) {
-			adapter->if_events.rcvearly++;
-			adapter->stats.rx_fifo_errors++;
-		}
-		if (hdr->frame_status_b14 & VRHSTATB_BUFF) {
-			adapter->if_events.Bufov++;
-			adapter->stats.rx_over_errors++;
-		}
-		if (hdr->frame_status_b14 & VRHSTATB_CARRE) {
-			adapter->if_events.Carre++;
-			adapter->stats.tx_carrier_errors++;
-		}
-		if (hdr->frame_status_b14 & VRHSTATB_LONGE)
-			adapter->if_events.Longe++;
-		if (hdr->frame_status_b14 & VRHSTATB_PREA)
-			adapter->if_events.Invp++;
-		if (hdr->frame_status_b14 & VRHSTATB_CRC) {
-			adapter->if_events.Crc++;
-			adapter->stats.rx_crc_errors++;
-		}
-		if (hdr->frame_status_b14 & VRHSTATB_DRBL)
-			adapter->if_events.Drbl++;
-		if (hdr->frame_status_b14 & VRHSTATB_CODE)
-			adapter->if_events.Code++;
-		if (hdr->frame_status_b14 & VRHSTATB_TPCSUM)
-			adapter->if_events.TpCsum++;
-		if (hdr->frame_status_b14 & VRHSTATB_TPHLEN)
-			adapter->if_events.TpHlen++;
-		if (hdr->frame_status_b14 & VRHSTATB_IPCSUM)
-			adapter->if_events.IpCsum++;
-		if (hdr->frame_status_b14 & VRHSTATB_IPLERR)
-			adapter->if_events.IpLen++;
-		if (hdr->frame_status_b14 & VRHSTATB_IPHERR)
-			adapter->if_events.IpHlen++;
-	} else {
-		if (hdr->frame_statusGB & VGBSTAT_XPERR) {
-			u32 xerr = hdr->frame_statusGB >> VGBSTAT_XERRSHFT;
-
-			if (xerr == VGBSTAT_XCSERR)
-				adapter->if_events.TpCsum++;
-			if (xerr == VGBSTAT_XUFLOW)
-				adapter->if_events.Tprtoflow++;
-			if (xerr == VGBSTAT_XHLEN)
-				adapter->if_events.TpHlen++;
-		}
-		if (hdr->frame_statusGB & VGBSTAT_NETERR) {
-			u32 nerr =
-			    (hdr->
-			     frame_statusGB >> VGBSTAT_NERRSHFT) &
-			    VGBSTAT_NERRMSK;
-			if (nerr == VGBSTAT_NCSERR)
-				adapter->if_events.IpCsum++;
-			if (nerr == VGBSTAT_NUFLOW)
-				adapter->if_events.IpLen++;
-			if (nerr == VGBSTAT_NHLEN)
-				adapter->if_events.IpHlen++;
-		}
-		if (hdr->frame_statusGB & VGBSTAT_LNKERR) {
-			u32 lerr = hdr->frame_statusGB & VGBSTAT_LERRMSK;
-
-			if (lerr == VGBSTAT_LDEARLY)
-				adapter->if_events.rcvearly++;
-			if (lerr == VGBSTAT_LBOFLO)
-				adapter->if_events.Bufov++;
-			if (lerr == VGBSTAT_LCODERR)
-				adapter->if_events.Code++;
-			if (lerr == VGBSTAT_LDBLNBL)
-				adapter->if_events.Drbl++;
-			if (lerr == VGBSTAT_LCRCERR)
-				adapter->if_events.Crc++;
-			if (lerr == VGBSTAT_LOFLO)
-				adapter->if_events.oflow802++;
-			if (lerr == VGBSTAT_LUFLO)
-				adapter->if_events.uflow802++;
-		}
-	}
-	return;
-}
-
-#define TCP_OFFLOAD_FRAME_PUSHFLAG  0x10000000
-#define M_FAST_PATH                 0x0040
-
-static void slic_rcv_handler(struct adapter *adapter)
-{
-	struct sk_buff *skb;
-	struct slic_rcvbuf *rcvbuf;
-	u32 frames = 0;
-
-	while ((skb = slic_rcvqueue_getnext(adapter))) {
-		u32 rx_bytes;
-
-		ASSERT(skb->head);
-		rcvbuf = (struct slic_rcvbuf *)skb->head;
-		adapter->card->events++;
-		if (rcvbuf->status & IRHDDR_ERR) {
-			adapter->rx_errors++;
-			slic_rcv_handle_error(adapter, rcvbuf);
-			slic_rcvqueue_reinsert(adapter, skb);
-			continue;
-		}
-
-		if (!slic_mac_filter(adapter, (struct ether_header *)
-					rcvbuf->data)) {
-			slic_rcvqueue_reinsert(adapter, skb);
-			continue;
-		}
-		skb_pull(skb, SLIC_RCVBUF_HEADSIZE);
-		rx_bytes = (rcvbuf->length & IRHDDR_FLEN_MSK);
-		skb_put(skb, rx_bytes);
-		adapter->stats.rx_packets++;
-		adapter->stats.rx_bytes += rx_bytes;
-#if SLIC_OFFLOAD_IP_CHECKSUM
-		skb->ip_summed = CHECKSUM_UNNECESSARY;
-#endif
-
-		skb->dev = adapter->netdev;
-		skb->protocol = eth_type_trans(skb, skb->dev);
-		netif_rx(skb);
-
-		++frames;
-#if SLIC_INTERRUPT_PROCESS_LIMIT
-		if (frames >= SLIC_RCVQ_MAX_PROCESS_ISR) {
-			adapter->rcv_interrupt_yields++;
-			break;
-		}
-#endif
-	}
-	adapter->max_isr_rcvs = max(adapter->max_isr_rcvs, frames);
-}
-
-static void slic_xmit_complete(struct adapter *adapter)
-{
-	struct slic_hostcmd *hcmd;
-	struct slic_rspbuf *rspbuf;
-	u32 frames = 0;
-	struct slic_handle_word slic_handle_word;
-
-	do {
-		rspbuf = slic_rspqueue_getnext(adapter);
-		if (!rspbuf)
-			break;
-		adapter->xmit_completes++;
-		adapter->card->events++;
-		/*
-		 Get the complete host command buffer
-		*/
-		slic_handle_word.handle_token = rspbuf->hosthandle;
-		ASSERT(slic_handle_word.handle_index);
-		ASSERT(slic_handle_word.handle_index <= SLIC_CMDQ_MAXCMDS);
-		hcmd =
-		    (struct slic_hostcmd *)
-			adapter->slic_handles[slic_handle_word.handle_index].
-									address;
-/*      hcmd = (struct slic_hostcmd *) rspbuf->hosthandle; */
-		ASSERT(hcmd);
-		ASSERT(hcmd->pslic_handle ==
-		       &adapter->slic_handles[slic_handle_word.handle_index]);
-		if (hcmd->type == SLIC_CMD_DUMB) {
-			if (hcmd->skb)
-				dev_kfree_skb_irq(hcmd->skb);
-			slic_cmdq_putdone_irq(adapter, hcmd);
-		}
-		rspbuf->status = 0;
-		rspbuf->hosthandle = 0;
-		frames++;
-	} while (1);
-	adapter->max_isr_xmits = max(adapter->max_isr_xmits, frames);
-}
-
-static irqreturn_t slic_interrupt(int irq, void *dev_id)
-{
-	struct net_device *dev = (struct net_device *)dev_id;
-	struct adapter *adapter = netdev_priv(dev);
-	u32 isr;
-
-	if ((adapter->pshmem) && (adapter->pshmem->isr)) {
-		slic_reg32_write(&adapter->slic_regs->slic_icr,
-				 ICR_INT_MASK, FLUSH);
-		isr = adapter->isrcopy = adapter->pshmem->isr;
-		adapter->pshmem->isr = 0;
-		adapter->num_isrs++;
-		switch (adapter->card->state) {
-		case CARD_UP:
-			if (isr & ~ISR_IO) {
-				if (isr & ISR_ERR) {
-					adapter->error_interrupts++;
-					if (isr & ISR_RMISS) {
-						int count;
-						int pre_count;
-						int errors;
-
-						struct slic_rcvqueue *rcvq =
-						    &adapter->rcvqueue;
-
-						adapter->
-						    error_rmiss_interrupts++;
-						if (!rcvq->errors)
-							rcv_count = rcvq->count;
-						pre_count = rcvq->count;
-						errors = rcvq->errors;
-
-						while (rcvq->count <
-						       SLIC_RCVQ_FILLTHRESH) {
-							count =
-							    slic_rcvqueue_fill
-							    (adapter);
-							if (!count)
-								break;
-						}
-					} else if (isr & ISR_XDROP) {
-						dev_err(&dev->dev,
-							"isr & ISR_ERR [%x] "
-							"ISR_XDROP \n", isr);
-					} else {
-						dev_err(&dev->dev,
-							"isr & ISR_ERR [%x]\n",
-							isr);
-					}
-				}
-
-				if (isr & ISR_LEVENT) {
-					adapter->linkevent_interrupts++;
-					slic_link_event_handler(adapter);
-				}
-
-				if ((isr & ISR_UPC) ||
-				    (isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
-					adapter->upr_interrupts++;
-					slic_upr_request_complete(adapter, isr);
-				}
-			}
-
-			if (isr & ISR_RCV) {
-				adapter->rcv_interrupts++;
-				slic_rcv_handler(adapter);
-			}
-
-			if (isr & ISR_CMD) {
-				adapter->xmit_interrupts++;
-				slic_xmit_complete(adapter);
-			}
-			break;
-
-		case CARD_DOWN:
-			if ((isr & ISR_UPC) ||
-			    (isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
-				adapter->upr_interrupts++;
-				slic_upr_request_complete(adapter, isr);
-			}
-			break;
-
-		default:
-			break;
-		}
-
-		adapter->isrcopy = 0;
-		adapter->all_reg_writes += 2;
-		adapter->isr_reg_writes++;
-		slic_reg32_write(&adapter->slic_regs->slic_isr, 0, FLUSH);
-	} else {
-		adapter->false_interrupts++;
-	}
-	return IRQ_HANDLED;
-}
-
-/*
- * slic_link_event_handler -
- *
- * Initiate a link configuration sequence.  The link configuration begins
- * by issuing a READ_LINK_STATUS command to the Utility Processor on the
- * SLIC.  Since the command finishes asynchronously, the slic_upr_comlete
- * routine will follow it up witha UP configuration write command, which
- * will also complete asynchronously.
- *
- */
-static void slic_link_event_handler(struct adapter *adapter)
-{
-	int status;
-	struct slic_shmem *pshmem;
-
-	if (adapter->state != ADAPT_UP) {
-		/* Adapter is not operational.  Ignore.  */
-		return;
-	}
-
-	pshmem = (struct slic_shmem *)adapter->phys_shmem;
-
-#if defined(CONFIG_X86_64)
-	status = slic_upr_request(adapter,
-				  SLIC_UPR_RLSR,
-				  SLIC_GET_ADDR_LOW(&pshmem->linkstatus),
-				  SLIC_GET_ADDR_HIGH(&pshmem->linkstatus),
-				  0, 0);
-#elif defined(CONFIG_X86)
-	status = slic_upr_request(adapter, SLIC_UPR_RLSR,
-		(u32) &pshmem->linkstatus,	/* no 4GB wrap guaranteed */
-				  0, 0, 0);
-#else
-	Stop compilation;
-#endif
-	ASSERT(status == 0);
-}
-
-static void slic_init_cleanup(struct adapter *adapter)
-{
-	if (adapter->intrregistered) {
-		adapter->intrregistered = 0;
-		free_irq(adapter->netdev->irq, adapter->netdev);
-
-	}
-	if (adapter->pshmem) {
-		pci_free_consistent(adapter->pcidev,
-				    sizeof(struct slic_shmem),
-				    adapter->pshmem, adapter->phys_shmem);
-		adapter->pshmem = NULL;
-		adapter->phys_shmem = (dma_addr_t) NULL;
-	}
-
-	if (adapter->pingtimerset) {
-		adapter->pingtimerset = 0;
-		del_timer(&adapter->pingtimer);
-	}
-
-	slic_rspqueue_free(adapter);
-	slic_cmdq_free(adapter);
-	slic_rcvqueue_free(adapter);
-}
-
-static struct net_device_stats *slic_get_stats(struct net_device *dev)
-{
-	struct adapter *adapter = netdev_priv(dev);
-
-	ASSERT(adapter);
-	dev->stats.collisions = adapter->slic_stats.iface.xmit_collisions;
-	dev->stats.rx_errors = adapter->slic_stats.iface.rcv_errors;
-	dev->stats.tx_errors = adapter->slic_stats.iface.xmt_errors;
-	dev->stats.rx_missed_errors = adapter->slic_stats.iface.rcv_discards;
-	dev->stats.tx_heartbeat_errors = 0;
-	dev->stats.tx_aborted_errors = 0;
-	dev->stats.tx_window_errors = 0;
-	dev->stats.tx_fifo_errors = 0;
-	dev->stats.rx_frame_errors = 0;
-	dev->stats.rx_length_errors = 0;
-
-	return &dev->stats;
-}
-
-/*
- *  Allocate a mcast_address structure to hold the multicast address.
- *  Link it in.
- */
-static int slic_mcast_add_list(struct adapter *adapter, char *address)
-{
-	struct mcast_address *mcaddr, *mlist;
-
-	/* Check to see if it already exists */
-	mlist = adapter->mcastaddrs;
-	while (mlist) {
-		if (!compare_ether_addr(mlist->address, address))
-			return 0;
-		mlist = mlist->next;
-	}
-
-	/* Doesn't already exist.  Allocate a structure to hold it */
-	mcaddr = kmalloc(sizeof(struct mcast_address), GFP_ATOMIC);
-	if (mcaddr == NULL)
-		return 1;
-
-	memcpy(mcaddr->address, address, 6);
-
-	mcaddr->next = adapter->mcastaddrs;
-	adapter->mcastaddrs = mcaddr;
-
-	return 0;
-}
-
 /*
  * Functions to obtain the CRC corresponding to the destination mac address.
  * This is a standard ethernet CRC in that it is a 32-bit, reflected CRC using
@@ -1362,44 +296,6 @@ static void slic_mcast_set_bit(struct adapter *adapter, char *address)
 	adapter->mcastmask |= (u64) 1 << crcpoly;
 }
 
-static void slic_mcast_set_list(struct net_device *dev)
-{
-	struct adapter *adapter = netdev_priv(dev);
-	int status = 0;
-	char *addresses;
-	struct netdev_hw_addr *ha;
-
-	ASSERT(adapter);
-
-	netdev_for_each_mc_addr(ha, dev) {
-		addresses = (char *) &ha->addr;
-		status = slic_mcast_add_list(adapter, addresses);
-		if (status != 0)
-			break;
-		slic_mcast_set_bit(adapter, addresses);
-	}
-
-	if (adapter->devflags_prev != dev->flags) {
-		adapter->macopts = MAC_DIRECTED;
-		if (dev->flags) {
-			if (dev->flags & IFF_BROADCAST)
-				adapter->macopts |= MAC_BCAST;
-			if (dev->flags & IFF_PROMISC)
-				adapter->macopts |= MAC_PROMISC;
-			if (dev->flags & IFF_ALLMULTI)
-				adapter->macopts |= MAC_ALLMCAST;
-			if (dev->flags & IFF_MULTICAST)
-				adapter->macopts |= MAC_MCAST;
-		}
-		adapter->devflags_prev = dev->flags;
-		slic_config_set(adapter, true);
-	} else {
-		if (status == 0)
-			slic_mcast_set_mask(adapter);
-	}
-	return;
-}
-
 static void slic_mcast_set_mask(struct adapter *adapter)
 {
 	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
@@ -1439,125 +335,6 @@ static void slic_timer_ping(ulong dev)
 	add_timer(&adapter->pingtimer);
 }
 
-/*
- *  slic_if_init
- *
- *  Perform initialization of our slic interface.
- *
- */
-static int slic_if_init(struct adapter *adapter)
-{
-	struct sliccard *card = adapter->card;
-	struct net_device *dev = adapter->netdev;
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-	struct slic_shmem *pshmem;
-	int rc;
-
-	ASSERT(card);
-
-	/* adapter should be down at this point */
-	if (adapter->state != ADAPT_DOWN) {
-		dev_err(&dev->dev, "%s: adapter->state != ADAPT_DOWN\n",
-			__func__);
-		rc = -EIO;
-		goto err;
-	}
-	ASSERT(adapter->linkstate == LINK_DOWN);
-
-	adapter->devflags_prev = dev->flags;
-	adapter->macopts = MAC_DIRECTED;
-	if (dev->flags) {
-		if (dev->flags & IFF_BROADCAST)
-			adapter->macopts |= MAC_BCAST;
-		if (dev->flags & IFF_PROMISC)
-			adapter->macopts |= MAC_PROMISC;
-		if (dev->flags & IFF_ALLMULTI)
-			adapter->macopts |= MAC_ALLMCAST;
-		if (dev->flags & IFF_MULTICAST)
-			adapter->macopts |= MAC_MCAST;
-	}
-	rc = slic_adapter_allocresources(adapter);
-	if (rc) {
-		dev_err(&dev->dev,
-			"%s: slic_adapter_allocresources FAILED %x\n",
-			__func__, rc);
-		slic_adapter_freeresources(adapter);
-		goto err;
-	}
-
-	if (!adapter->queues_initialized) {
-		if ((rc = slic_rspqueue_init(adapter)))
-			goto err;
-		if ((rc = slic_cmdq_init(adapter)))
-			goto err;
-		if ((rc = slic_rcvqueue_init(adapter)))
-			goto err;
-		adapter->queues_initialized = 1;
-	}
-
-	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
-	mdelay(1);
-
-	if (!adapter->isp_initialized) {
-		pshmem = (struct slic_shmem *)adapter->phys_shmem;
-
-		spin_lock_irqsave(&adapter->bit64reglock.lock,
-					adapter->bit64reglock.flags);
-
-#if defined(CONFIG_X86_64)
-		slic_reg32_write(&slic_regs->slic_addr_upper,
-				 SLIC_GET_ADDR_HIGH(&pshmem->isr), DONT_FLUSH);
-		slic_reg32_write(&slic_regs->slic_isp,
-				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
-#elif defined(CONFIG_X86)
-		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
-		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
-#else
-		Stop Compilations
-#endif
-		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
-					adapter->bit64reglock.flags);
-		adapter->isp_initialized = 1;
-	}
-
-	adapter->state = ADAPT_UP;
-	if (!card->loadtimerset) {
-		init_timer(&card->loadtimer);
-		card->loadtimer.expires =
-		    jiffies + (SLIC_LOADTIMER_PERIOD * HZ);
-		card->loadtimer.data = (ulong) card;
-		card->loadtimer.function = &slic_timer_load_check;
-		add_timer(&card->loadtimer);
-
-		card->loadtimerset = 1;
-	}
-
-	if (!adapter->pingtimerset) {
-		init_timer(&adapter->pingtimer);
-		adapter->pingtimer.expires =
-		    jiffies + (PING_TIMER_INTERVAL * HZ);
-		adapter->pingtimer.data = (ulong) dev;
-		adapter->pingtimer.function = &slic_timer_ping;
-		add_timer(&adapter->pingtimer);
-		adapter->pingtimerset = 1;
-		adapter->card->pingstatus = ISR_PINGMASK;
-	}
-
-	/*
-	 *    clear any pending events, then enable interrupts
-	 */
-	adapter->isrcopy = 0;
-	adapter->pshmem->isr = 0;
-	slic_reg32_write(&slic_regs->slic_isr, 0, FLUSH);
-	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_ON, FLUSH);
-
-	slic_link_config(adapter, LINK_AUTOSPEED, LINK_AUTOD);
-	slic_link_event_handler(adapter);
-
-err:
-	return rc;
-}
-
 static void slic_unmap_mmio_space(struct adapter *adapter)
 {
 	if (adapter->slic_regs)
@@ -1565,64 +342,6 @@ static void slic_unmap_mmio_space(struct adapter *adapter)
 	adapter->slic_regs = NULL;
 }
 
-static int slic_adapter_allocresources(struct adapter *adapter)
-{
-	if (!adapter->intrregistered) {
-		int retval;
-
-		spin_unlock_irqrestore(&slic_global.driver_lock.lock,
-					slic_global.driver_lock.flags);
-
-		retval = request_irq(adapter->netdev->irq,
-				     &slic_interrupt,
-				     IRQF_SHARED,
-				     adapter->netdev->name, adapter->netdev);
-
-		spin_lock_irqsave(&slic_global.driver_lock.lock,
-					slic_global.driver_lock.flags);
-
-		if (retval) {
-			dev_err(&adapter->netdev->dev,
-				"request_irq (%s) FAILED [%x]\n",
-				adapter->netdev->name, retval);
-			return retval;
-		}
-		adapter->intrregistered = 1;
-	}
-	return 0;
-}
-
-static void slic_config_pci(struct pci_dev *pcidev)
-{
-	u16 pci_command;
-	u16 new_command;
-
-	pci_read_config_word(pcidev, PCI_COMMAND, &pci_command);
-
-	new_command = pci_command | PCI_COMMAND_MASTER
-	    | PCI_COMMAND_MEMORY
-	    | PCI_COMMAND_INVALIDATE
-	    | PCI_COMMAND_PARITY | PCI_COMMAND_SERR | PCI_COMMAND_FAST_BACK;
-	if (pci_command != new_command)
-		pci_write_config_word(pcidev, PCI_COMMAND, new_command);
-}
-
-static void slic_adapter_freeresources(struct adapter *adapter)
-{
-	slic_init_cleanup(adapter);
-	memset(&adapter->stats, 0, sizeof(struct net_device_stats));
-	adapter->error_interrupts = 0;
-	adapter->rcv_interrupts = 0;
-	adapter->xmit_interrupts = 0;
-	adapter->linkevent_interrupts = 0;
-	adapter->upr_interrupts = 0;
-	adapter->num_isrs = 0;
-	adapter->xmit_completes = 0;
-	adapter->rcv_broadcasts = 0;
-	adapter->rcv_multicasts = 0;
-	adapter->rcv_unicasts = 0;
-}
-
 /*
  *  slic_link_config
  *
@@ -1776,18 +495,6 @@ static void slic_link_config(struct adapter *adapter,
 	}
 }
 
-static void slic_card_cleanup(struct sliccard *card)
-{
-	if (card->loadtimerset) {
-		card->loadtimerset = 0;
-		del_timer(&card->loadtimer);
-	}
-
-	slic_debug_card_destroy(card);
-
-	kfree(card);
-}
-
 static int slic_card_download_gbrcv(struct adapter *adapter)
 {
 	const struct firmware *fw;
@@ -2001,327 +708,72 @@ static void slic_intagg_set(struct adapter *adapter, u32 value)
 	adapter->card->loadlevel_current = value;
 }
 
-static int slic_card_init(struct sliccard *card, struct adapter *adapter)
+static void slic_soft_reset(struct adapter *adapter)
 {
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-	struct slic_eeprom *peeprom;
-	struct oslic_eeprom *pOeeprom;
-	dma_addr_t phys_config;
-	u32 phys_configh;
-	u32 phys_configl;
-	u32 i = 0;
-	struct slic_shmem *pshmem;
-	int status;
-	uint macaddrs = card->card_size;
-	ushort eecodesize;
-	ushort dramsize;
-	ushort ee_chksum;
-	ushort calc_chksum;
-	struct slic_config_mac *pmac;
-	unsigned char fruformat;
-	unsigned char oemfruformat;
-	struct atk_fru *patkfru;
-	union oemfru *poemfru;
-
-	/* Reset everything except PCI configuration space */
-	slic_soft_reset(adapter);
-
-	/* Download the microcode */
-	status = slic_card_download(adapter);
-
-	if (status != 0) {
-		dev_err(&adapter->pcidev->dev,
-			"download failed bus %d slot %d\n",
-			adapter->busnumber, adapter->slotnumber);
-		return status;
-	}
-
-	if (!card->config_set) {
-		peeprom = pci_alloc_consistent(adapter->pcidev,
-					       sizeof(struct slic_eeprom),
-					       &phys_config);
-
-		phys_configl = SLIC_GET_ADDR_LOW(phys_config);
-		phys_configh = SLIC_GET_ADDR_HIGH(phys_config);
-
-		if (!peeprom) {
-			dev_err(&adapter->pcidev->dev,
-				"eeprom read failed to get memory "
-				"bus %d slot %d\n", adapter->busnumber,
-				adapter->slotnumber);
-			return -ENOMEM;
-		} else {
-			memset(peeprom, 0, sizeof(struct slic_eeprom));
-		}
-		slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
+	if (adapter->card->state == CARD_UP) {
+		slic_reg32_write(&adapter->slic_regs->slic_quiesce, 0, FLUSH);
 		mdelay(1);
-		pshmem = (struct slic_shmem *)adapter->phys_shmem;
-
-		spin_lock_irqsave(&adapter->bit64reglock.lock,
-					adapter->bit64reglock.flags);
-		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
-		slic_reg32_write(&slic_regs->slic_isp,
-				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
-		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
-					adapter->bit64reglock.flags);
-
-		slic_config_get(adapter, phys_configl, phys_configh);
-
-		for (;;) {
-			if (adapter->pshmem->isr) {
-				if (adapter->pshmem->isr & ISR_UPC) {
-					adapter->pshmem->isr = 0;
-					slic_reg64_write(adapter,
-						&slic_regs->slic_isp, 0,
-						&slic_regs->slic_addr_upper,
-						0, FLUSH);
-					slic_reg32_write(&slic_regs->slic_isr,
-							 0, FLUSH);
-
-					slic_upr_request_complete(adapter, 0);
-					break;
-				} else {
-					adapter->pshmem->isr = 0;
-					slic_reg32_write(&slic_regs->slic_isr,
-							 0, FLUSH);
-				}
-			} else {
-				mdelay(1);
-				i++;
-				if (i > 5000) {
-					dev_err(&adapter->pcidev->dev,
-						"%d config data fetch timed out!\n",
-						adapter->port);
-					slic_reg64_write(adapter,
-						&slic_regs->slic_isp, 0,
-						&slic_regs->slic_addr_upper,
-						0, FLUSH);
-					return -EINVAL;
-				}
-			}
-		}
-
-		switch (adapter->devid) {
-		/* Oasis card */
-		case SLIC_2GB_DEVICE_ID:
-			/* extract EEPROM data and pointers to EEPROM data */
-			pOeeprom = (struct oslic_eeprom *) peeprom;
-			eecodesize = pOeeprom->EecodeSize;
-			dramsize = pOeeprom->DramSize;
-			pmac = pOeeprom->MacInfo;
-			fruformat = pOeeprom->FruFormat;
-			patkfru = &pOeeprom->AtkFru;
-			oemfruformat = pOeeprom->OemFruFormat;
-			poemfru = &pOeeprom->OemFru;
-			macaddrs = 2;
-			/* Minor kludge for Oasis card
-			     get 2 MAC addresses from the
-			     EEPROM to ensure that function 1
-			     gets the Port 1 MAC address */
-			break;
-		default:
-			/* extract EEPROM data and pointers to EEPROM data */
-			eecodesize = peeprom->EecodeSize;
-			dramsize = peeprom->DramSize;
-			pmac = peeprom->u2.mac.MacInfo;
-			fruformat = peeprom->FruFormat;
-			patkfru = &peeprom->AtkFru;
-			oemfruformat = peeprom->OemFruFormat;
-			poemfru = &peeprom->OemFru;
-			break;
-		}
-
-		card->config.EepromValid = false;
-
-		/*  see if the EEPROM is valid by checking it's checksum */
-		if ((eecodesize <= MAX_EECODE_SIZE) &&
-		    (eecodesize >= MIN_EECODE_SIZE)) {
-
-			ee_chksum =
-			    *(u16 *) ((char *) peeprom + (eecodesize - 2));
-			/*
-			    calculate the EEPROM checksum
-			*/
-			calc_chksum =
-			    ~slic_eeprom_cksum((char *) peeprom,
-					       (eecodesize - 2));
-			/*
-			    if the ucdoe chksum flag bit worked,
-			    we wouldn't need this shit
-			*/
-			if (ee_chksum == calc_chksum)
-				card->config.EepromValid = true;
-		}
-		/*  copy in the DRAM size */
-		card->config.DramSize = dramsize;
-
-		/*  copy in the MAC address(es) */
-		for (i = 0; i < macaddrs; i++) {
-			memcpy(&card->config.MacInfo[i],
-			       &pmac[i], sizeof(struct slic_config_mac));
-		}
-
-		/*  copy the Alacritech FRU information */
-		card->config.FruFormat = fruformat;
-		memcpy(&card->config.AtkFru, patkfru,
-						sizeof(struct atk_fru));
-
-		pci_free_consistent(adapter->pcidev,
-				    sizeof(struct slic_eeprom),
-				    peeprom, phys_config);
-
-		if ((!card->config.EepromValid) &&
-		    (adapter->reg_params.fail_on_bad_eeprom)) {
-			slic_reg64_write(adapter, &slic_regs->slic_isp, 0,
-					 &slic_regs->slic_addr_upper,
-					 0, FLUSH);
-			dev_err(&adapter->pcidev->dev,
-				"unsupported CONFIGURATION EEPROM invalid\n");
-			return -EINVAL;
-		}
-
-		card->config_set = 1;
 	}
 
-	if (slic_card_download_gbrcv(adapter)) {
-		dev_err(&adapter->pcidev->dev,
-			"unable to download GB receive microcode\n");
-		return -EINVAL;
-	}
-
-	if (slic_global.dynamic_intagg)
-		slic_intagg_set(adapter, 0);
-	else
-		slic_intagg_set(adapter, intagg_delay);
-
-	/*
-	 *  Initialize ping status to "ok"
-	 */
-	card->pingstatus = ISR_PINGMASK;
-
-	/*
-	 * Lastly, mark our card state as up and return success
-	 */
-	card->state = CARD_UP;
-	card->reset_in_progress = 0;
-
-	return 0;
+	slic_reg32_write(&adapter->slic_regs->slic_reset, SLIC_RESET_MAGIC,
+			 FLUSH);
+	mdelay(1);
 }
 
-static u32 slic_card_locate(struct adapter *adapter)
+static void slic_mac_address_config(struct adapter *adapter)
 {
-	struct sliccard *card = slic_global.slic_card;
-	struct physcard *physcard = slic_global.phys_card;
-	ushort card_hostid;
-	u16 __iomem *hostid_reg;
-	uint i;
-	uint rdhostid_offset = 0;
-
-	switch (adapter->devid) {
-	case SLIC_2GB_DEVICE_ID:
-		rdhostid_offset = SLIC_RDHOSTID_2GB;
-		break;
-	case SLIC_1GB_DEVICE_ID:
-		rdhostid_offset = SLIC_RDHOSTID_1GB;
-		break;
-	default:
-		ASSERT(0);
-		break;
-	}
+	u32 value;
+	u32 value2;
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 
-	hostid_reg =
-	    (u16 __iomem *) (((u8 __iomem *) (adapter->slic_regs)) +
-	    rdhostid_offset);
+	value = *(u32 *) &adapter->currmacaddr[2];
+	value = ntohl(value);
+	slic_reg32_write(&slic_regs->slic_wraddral, value, FLUSH);
+	slic_reg32_write(&slic_regs->slic_wraddrbl, value, FLUSH);
 
-	/* read the 16 bit hostid from SRAM */
-	card_hostid = (ushort) readw(hostid_reg);
+	value2 = (u32) ((adapter->currmacaddr[0] << 8 |
+			     adapter->currmacaddr[1]) & 0xFFFF);
 
-	/* Initialize a new card structure if need be */
-	if (card_hostid == SLIC_HOSTID_DEFAULT) {
-		card = kzalloc(sizeof(struct sliccard), GFP_KERNEL);
-		if (card == NULL)
-			return -ENOMEM;
+	slic_reg32_write(&slic_regs->slic_wraddrah, value2, FLUSH);
+	slic_reg32_write(&slic_regs->slic_wraddrbh, value2, FLUSH);
 
-		card->next = slic_global.slic_card;
-		slic_global.slic_card = card;
-		card->busnumber = adapter->busnumber;
-		card->slotnumber = adapter->slotnumber;
+	/* Write our multicast mask out to the card.  This is done */
+	/* here in addition to the slic_mcast_addr_set routine     */
+	/* because ALL_MCAST may have been enabled or disabled     */
+	slic_mcast_set_mask(adapter);
+}
 
-		/* Find an available cardnum */
-		for (i = 0; i < SLIC_MAX_CARDS; i++) {
-			if (slic_global.cardnuminuse[i] == 0) {
-				slic_global.cardnuminuse[i] = 1;
-				card->cardnum = i;
-				break;
-			}
-		}
-		slic_global.num_slic_cards++;
+static void slic_mac_config(struct adapter *adapter)
+{
+	u32 value;
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
 
-		slic_debug_card_create(card);
+	/* Setup GMAC gaps */
+	if (adapter->linkspeed == LINK_1000MB) {
+		value = ((GMCR_GAPBB_1000 << GMCR_GAPBB_SHIFT) |
+			 (GMCR_GAPR1_1000 << GMCR_GAPR1_SHIFT) |
+			 (GMCR_GAPR2_1000 << GMCR_GAPR2_SHIFT));
 	} else {
-		/* Card exists, find the card this adapter belongs to */
-		while (card) {
-			if (card->cardnum == card_hostid)
-				break;
-			card = card->next;
-		}
-	}
-
-	ASSERT(card);
-	if (!card)
-		return -ENXIO;
-	/* Put the adapter in the card's adapter list */
-	ASSERT(card->adapter[adapter->port] == NULL);
-	if (!card->adapter[adapter->port]) {
-		card->adapter[adapter->port] = adapter;
-		adapter->card = card;
+		value = ((GMCR_GAPBB_100 << GMCR_GAPBB_SHIFT) |
+			 (GMCR_GAPR1_100 << GMCR_GAPR1_SHIFT) |
+			 (GMCR_GAPR2_100 << GMCR_GAPR2_SHIFT));
 	}
 
-	card->card_size = 1;	/* one port per *logical* card */
-
-	while (physcard) {
-		for (i = 0; i < SLIC_MAX_PORTS; i++) {
-			if (!physcard->adapter[i])
-				continue;
-			else
-				break;
-		}
-		ASSERT(i != SLIC_MAX_PORTS);
-		if (physcard->adapter[i]->slotnumber == adapter->slotnumber)
-			break;
-		physcard = physcard->next;
-	}
-	if (!physcard) {
-		/* no structure allocated for this physical card yet */
-		physcard = kzalloc(sizeof(struct physcard), GFP_ATOMIC);
-		ASSERT(physcard);
+	/* enable GMII */
+	if (adapter->linkspeed == LINK_1000MB)
+		value |= GMCR_GBIT;
 
-		physcard->next = slic_global.phys_card;
-		slic_global.phys_card = physcard;
-		physcard->adapters_allocd = 1;
-	} else {
-		physcard->adapters_allocd++;
+	/* enable fullduplex */
+	if ((adapter->linkduplex == LINK_FULLD)
+	    || (adapter->macopts & MAC_LOOPBACK)) {
+		value |= GMCR_FULLD;
 	}
-	/* Note - this is ZERO relative */
-	adapter->physport = physcard->adapters_allocd - 1;
-
-	ASSERT(physcard->adapter[adapter->physport] == NULL);
-	physcard->adapter[adapter->physport] = adapter;
-	adapter->physcard = physcard;
 
-	return 0;
-}
-
-static void slic_soft_reset(struct adapter *adapter)
-{
-	if (adapter->card->state == CARD_UP) {
-		slic_reg32_write(&adapter->slic_regs->slic_quiesce, 0, FLUSH);
-		mdelay(1);
-	}
+	/* write mac config */
+	slic_reg32_write(&slic_regs->slic_wmcfg, value, FLUSH);
 
-	slic_reg32_write(&adapter->slic_regs->slic_reset, SLIC_RESET_MAGIC,
-			 FLUSH);
-	mdelay(1);
+	/* setup mac addresses */
+	slic_mac_address_config(adapter);
 }
 
 static void slic_config_set(struct adapter *adapter, bool linkchange)
@@ -2405,73 +857,6 @@ static void slic_config_clear(struct adapter *adapter)
 	slic_reg32_write(&slic_regs->slic_wphy, phy_config, FLUSH);
 }
 
-static void slic_config_get(struct adapter *adapter, u32 config,
-							u32 config_h)
-{
-	int status;
-
-	status = slic_upr_request(adapter,
-				  SLIC_UPR_RCONFIG,
-				  (u32) config, (u32) config_h, 0, 0);
-	ASSERT(status == 0);
-}
-
-static void slic_mac_address_config(struct adapter *adapter)
-{
-	u32 value;
-	u32 value2;
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-
-	value = *(u32 *) &adapter->currmacaddr[2];
-	value = ntohl(value);
-	slic_reg32_write(&slic_regs->slic_wraddral, value, FLUSH);
-	slic_reg32_write(&slic_regs->slic_wraddrbl, value, FLUSH);
-
-	value2 = (u32) ((adapter->currmacaddr[0] << 8 |
-			     adapter->currmacaddr[1]) & 0xFFFF);
-
-	slic_reg32_write(&slic_regs->slic_wraddrah, value2, FLUSH);
-	slic_reg32_write(&slic_regs->slic_wraddrbh, value2, FLUSH);
-
-	/* Write our multicast mask out to the card.  This is done */
-	/* here in addition to the slic_mcast_addr_set routine     */
-	/* because ALL_MCAST may have been enabled or disabled     */
-	slic_mcast_set_mask(adapter);
-}
-
-static void slic_mac_config(struct adapter *adapter)
-{
-	u32 value;
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-
-	/* Setup GMAC gaps */
-	if (adapter->linkspeed == LINK_1000MB) {
-		value = ((GMCR_GAPBB_1000 << GMCR_GAPBB_SHIFT) |
-			 (GMCR_GAPR1_1000 << GMCR_GAPR1_SHIFT) |
-			 (GMCR_GAPR2_1000 << GMCR_GAPR2_SHIFT));
-	} else {
-		value = ((GMCR_GAPBB_100 << GMCR_GAPBB_SHIFT) |
-			 (GMCR_GAPR1_100 << GMCR_GAPR1_SHIFT) |
-			 (GMCR_GAPR2_100 << GMCR_GAPR2_SHIFT));
-	}
-
-	/* enable GMII */
-	if (adapter->linkspeed == LINK_1000MB)
-		value |= GMCR_GBIT;
-
-	/* enable fullduplex */
-	if ((adapter->linkduplex == LINK_FULLD)
-	    || (adapter->macopts & MAC_LOOPBACK)) {
-		value |= GMCR_FULLD;
-	}
-
-	/* write mac config */
-	slic_reg32_write(&slic_regs->slic_wmcfg, value, FLUSH);
-
-	/* setup mac addresses */
-	slic_mac_address_config(adapter);
-}
-
 static bool slic_mac_filter(struct adapter *adapter,
 			struct ether_header *ether_frame)
 {
@@ -2599,17 +984,6 @@ static void slic_timer_load_check(ulong cardaddr)
 	add_timer(&card->loadtimer);
 }
 
-static void slic_assert_fail(void)
-{
-	u32 cpuid;
-	u32 curr_pid;
-	cpuid = smp_processor_id();
-	curr_pid = current->pid;
-
-	printk(KERN_ERR "%s CPU # %d ---- PID # %d\n",
-	       __func__, cpuid, curr_pid);
-}
-
 static int slic_upr_queue_request(struct adapter *adapter,
 			   u32 upr_request,
 			   u32 upr_data,
@@ -2642,6 +1016,54 @@ static int slic_upr_queue_request(struct adapter *adapter,
 	return 0;
 }
 
+static void slic_upr_start(struct adapter *adapter)
+{
+	struct slic_upr *upr;
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
+/*
+    char * ptr1;
+    char * ptr2;
+    uint cmdoffset;
+*/
+	upr = adapter->upr_list;
+	if (!upr)
+		return;
+	if (adapter->upr_busy)
+		return;
+	adapter->upr_busy = 1;
+
+	switch (upr->upr_request) {
+	case SLIC_UPR_STATS:
+		if (upr->upr_data_h == 0) {
+			slic_reg32_write(&slic_regs->slic_stats, upr->upr_data,
+					 FLUSH);
+		} else {
+			slic_reg64_write(adapter, &slic_regs->slic_stats64,
+					 upr->upr_data,
+					 &slic_regs->slic_addr_upper,
+					 upr->upr_data_h, FLUSH);
+		}
+		break;
+
+	case SLIC_UPR_RLSR:
+		slic_reg64_write(adapter, &slic_regs->slic_rlsr, upr->upr_data,
+				 &slic_regs->slic_addr_upper, upr->upr_data_h,
+				 FLUSH);
+		break;
+
+	case SLIC_UPR_RCONFIG:
+		slic_reg64_write(adapter, &slic_regs->slic_rconfig,
+				 upr->upr_data, &slic_regs->slic_addr_upper,
+				 upr->upr_data_h, FLUSH);
+		break;
+	case SLIC_UPR_PING:
+		slic_reg32_write(&slic_regs->slic_ping, 1, FLUSH);
+		break;
+	default:
+		ASSERT(0);
+	}
+}
+
 static int slic_upr_request(struct adapter *adapter,
 		     u32 upr_request,
 		     u32 upr_data,
@@ -2665,6 +1087,82 @@ err_unlock_irq:
 	return rc;
 }
 
+static void slic_link_upr_complete(struct adapter *adapter, u32 isr)
+{
+	u32 linkstatus = adapter->pshmem->linkstatus;
+	uint linkup;
+	unsigned char linkspeed;
+	unsigned char linkduplex;
+
+	if ((isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
+		struct slic_shmem *pshmem;
+
+		pshmem = (struct slic_shmem *)adapter->phys_shmem;
+#if defined(CONFIG_X86_64)
+		slic_upr_queue_request(adapter,
+				       SLIC_UPR_RLSR,
+				       SLIC_GET_ADDR_LOW(&pshmem->linkstatus),
+				       SLIC_GET_ADDR_HIGH(&pshmem->linkstatus),
+				       0, 0);
+#elif defined(CONFIG_X86)
+		slic_upr_queue_request(adapter,
+				       SLIC_UPR_RLSR,
+				       (u32) &pshmem->linkstatus,
+				       SLIC_GET_ADDR_HIGH(pshmem), 0, 0);
+#else
+		Stop Compilation;
+#endif
+		return;
+	}
+	if (adapter->state != ADAPT_UP)
+		return;
+
+	ASSERT((adapter->devid == SLIC_1GB_DEVICE_ID)
+	       || (adapter->devid == SLIC_2GB_DEVICE_ID));
+
+	linkup = linkstatus & GIG_LINKUP ? LINK_UP : LINK_DOWN;
+	if (linkstatus & GIG_SPEED_1000)
+		linkspeed = LINK_1000MB;
+	else if (linkstatus & GIG_SPEED_100)
+		linkspeed = LINK_100MB;
+	else
+		linkspeed = LINK_10MB;
+
+	if (linkstatus & GIG_FULLDUPLEX)
+		linkduplex = LINK_FULLD;
+	else
+		linkduplex = LINK_HALFD;
+
+	if ((adapter->linkstate == LINK_DOWN) && (linkup == LINK_DOWN))
+		return;
+
+	/* link up event, but nothing has changed */
+	if ((adapter->linkstate == LINK_UP) &&
+	    (linkup == LINK_UP) &&
+	    (adapter->linkspeed == linkspeed) &&
+	    (adapter->linkduplex == linkduplex))
+		return;
+
+	/* link has changed at this point */
+
+	/* link has gone from up to down */
+	if (linkup == LINK_DOWN) {
+		adapter->linkstate = LINK_DOWN;
+		return;
+	}
+
+	/* link has gone from down to up */
+	adapter->linkspeed = linkspeed;
+	adapter->linkduplex = linkduplex;
+
+	if (adapter->linkstate != LINK_UP) {
+		/* setup the mac */
+		slic_config_set(adapter, true);
+		adapter->linkstate = LINK_UP;
+		netif_start_queue(adapter->netdev);
+	}
+}
+
 static void slic_upr_request_complete(struct adapter *adapter, u32 isr)
 {
 	struct sliccard *card = adapter->card;
@@ -2787,128 +1285,15 @@ static void slic_upr_request_complete(struct adapter *adapter, u32 isr)
 				adapter->upr_lock.flags);
 }
 
-static void slic_upr_start(struct adapter *adapter)
-{
-	struct slic_upr *upr;
-	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
-/*
-    char * ptr1;
-    char * ptr2;
-    uint cmdoffset;
-*/
-	upr = adapter->upr_list;
-	if (!upr)
-		return;
-	if (adapter->upr_busy)
-		return;
-	adapter->upr_busy = 1;
-
-	switch (upr->upr_request) {
-	case SLIC_UPR_STATS:
-		if (upr->upr_data_h == 0) {
-			slic_reg32_write(&slic_regs->slic_stats, upr->upr_data,
-					 FLUSH);
-		} else {
-			slic_reg64_write(adapter, &slic_regs->slic_stats64,
-					 upr->upr_data,
-					 &slic_regs->slic_addr_upper,
-					 upr->upr_data_h, FLUSH);
-		}
-		break;
-
-	case SLIC_UPR_RLSR:
-		slic_reg64_write(adapter, &slic_regs->slic_rlsr, upr->upr_data,
-				 &slic_regs->slic_addr_upper, upr->upr_data_h,
-				 FLUSH);
-		break;
-
-	case SLIC_UPR_RCONFIG:
-		slic_reg64_write(adapter, &slic_regs->slic_rconfig,
-				 upr->upr_data, &slic_regs->slic_addr_upper,
-				 upr->upr_data_h, FLUSH);
-		break;
-	case SLIC_UPR_PING:
-		slic_reg32_write(&slic_regs->slic_ping, 1, FLUSH);
-		break;
-	default:
-		ASSERT(0);
-	}
-}
-
-static void slic_link_upr_complete(struct adapter *adapter, u32 isr)
+static void slic_config_get(struct adapter *adapter, u32 config,
+							u32 config_h)
 {
-	u32 linkstatus = adapter->pshmem->linkstatus;
-	uint linkup;
-	unsigned char linkspeed;
-	unsigned char linkduplex;
-
-	if ((isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
-		struct slic_shmem *pshmem;
-
-		pshmem = (struct slic_shmem *)adapter->phys_shmem;
-#if defined(CONFIG_X86_64)
-		slic_upr_queue_request(adapter,
-				       SLIC_UPR_RLSR,
-				       SLIC_GET_ADDR_LOW(&pshmem->linkstatus),
-				       SLIC_GET_ADDR_HIGH(&pshmem->linkstatus),
-				       0, 0);
-#elif defined(CONFIG_X86)
-		slic_upr_queue_request(adapter,
-				       SLIC_UPR_RLSR,
-				       (u32) &pshmem->linkstatus,
-				       SLIC_GET_ADDR_HIGH(pshmem), 0, 0);
-#else
-		Stop Compilation;
-#endif
-		return;
-	}
-	if (adapter->state != ADAPT_UP)
-		return;
-
-	ASSERT((adapter->devid == SLIC_1GB_DEVICE_ID)
-	       || (adapter->devid == SLIC_2GB_DEVICE_ID));
-
-	linkup = linkstatus & GIG_LINKUP ? LINK_UP : LINK_DOWN;
-	if (linkstatus & GIG_SPEED_1000)
-		linkspeed = LINK_1000MB;
-	else if (linkstatus & GIG_SPEED_100)
-		linkspeed = LINK_100MB;
-	else
-		linkspeed = LINK_10MB;
-
-	if (linkstatus & GIG_FULLDUPLEX)
-		linkduplex = LINK_FULLD;
-	else
-		linkduplex = LINK_HALFD;
-
-	if ((adapter->linkstate == LINK_DOWN) && (linkup == LINK_DOWN))
-		return;
-
-	/* link up event, but nothing has changed */
-	if ((adapter->linkstate == LINK_UP) &&
-	    (linkup == LINK_UP) &&
-	    (adapter->linkspeed == linkspeed) &&
-	    (adapter->linkduplex == linkduplex))
-		return;
-
-	/* link has changed at this point */
-
-	/* link has gone from up to down */
-	if (linkup == LINK_DOWN) {
-		adapter->linkstate = LINK_DOWN;
-		return;
-	}
-
-	/* link has gone from down to up */
-	adapter->linkspeed = linkspeed;
-	adapter->linkduplex = linkduplex;
+	int status;
 
-	if (adapter->linkstate != LINK_UP) {
-		/* setup the mac */
-		slic_config_set(adapter, true);
-		adapter->linkstate = LINK_UP;
-		netif_start_queue(adapter->netdev);
-	}
+	status = slic_upr_request(adapter,
+				  SLIC_UPR_RCONFIG,
+				  (u32) config, (u32) config_h, 0, 0);
+	ASSERT(status == 0);
 }
 
 /*
@@ -3013,6 +1398,24 @@ static ushort slic_eeprom_cksum(char *m, int len)
 	return (ushort) sum;
 }
 
+static void slic_rspqueue_free(struct adapter *adapter)
+{
+	int i;
+	struct slic_rspqueue *rspq = &adapter->rspqueue;
+
+	for (i = 0; i < rspq->num_pages; i++) {
+		if (rspq->vaddr[i]) {
+			pci_free_consistent(adapter->pcidev, PAGE_SIZE,
+					    rspq->vaddr[i], rspq->paddr[i]);
+		}
+		rspq->vaddr[i] = NULL;
+		rspq->paddr[i] = 0;
+	}
+	rspq->offset = 0;
+	rspq->pageindex = 0;
+	rspq->rspbuf = NULL;
+}
+
 static int slic_rspqueue_init(struct adapter *adapter)
 {
 	int i;
@@ -3060,24 +1463,6 @@ static int slic_rspqueue_init(struct adapter *adapter)
 	return 0;
 }
 
-static void slic_rspqueue_free(struct adapter *adapter)
-{
-	int i;
-	struct slic_rspqueue *rspq = &adapter->rspqueue;
-
-	for (i = 0; i < rspq->num_pages; i++) {
-		if (rspq->vaddr[i]) {
-			pci_free_consistent(adapter->pcidev, PAGE_SIZE,
-					    rspq->vaddr[i], rspq->paddr[i]);
-		}
-		rspq->vaddr[i] = NULL;
-		rspq->paddr[i] = 0;
-	}
-	rspq->offset = 0;
-	rspq->pageindex = 0;
-	rspq->rspbuf = NULL;
-}
-
 static struct slic_rspbuf *slic_rspqueue_getnext(struct adapter *adapter)
 {
 	struct slic_rspqueue *rspq = &adapter->rspqueue;
@@ -3160,36 +1545,6 @@ static u32 *slic_cmdqmem_addpage(struct adapter *adapter)
 	return pageaddr;
 }
 
-static int slic_cmdq_init(struct adapter *adapter)
-{
-	int i;
-	u32 *pageaddr;
-
-	ASSERT(adapter->state == ADAPT_DOWN);
-	memset(&adapter->cmdq_all, 0, sizeof(struct slic_cmdqueue));
-	memset(&adapter->cmdq_free, 0, sizeof(struct slic_cmdqueue));
-	memset(&adapter->cmdq_done, 0, sizeof(struct slic_cmdqueue));
-	spin_lock_init(&adapter->cmdq_all.lock.lock);
-	spin_lock_init(&adapter->cmdq_free.lock.lock);
-	spin_lock_init(&adapter->cmdq_done.lock.lock);
-	slic_cmdqmem_init(adapter);
-	adapter->slic_handle_ix = 1;
-	for (i = 0; i < SLIC_CMDQ_INITPAGES; i++) {
-		pageaddr = slic_cmdqmem_addpage(adapter);
-#ifndef CONFIG_X86_64
-		ASSERT(((u32) pageaddr & 0xFFFFF000) == (u32) pageaddr);
-#endif
-		if (!pageaddr) {
-			slic_cmdq_free(adapter);
-			return -ENOMEM;
-		}
-		slic_cmdq_addcmdpage(adapter, pageaddr);
-	}
-	adapter->slic_handle_ix = 1;
-
-	return 0;
-}
-
 static void slic_cmdq_free(struct adapter *adapter)
 {
 	struct slic_hostcmd *cmd;
@@ -3213,53 +1568,6 @@ static void slic_cmdq_free(struct adapter *adapter)
 	slic_cmdqmem_free(adapter);
 }
 
-static void slic_cmdq_reset(struct adapter *adapter)
-{
-	struct slic_hostcmd *hcmd;
-	struct sk_buff *skb;
-	u32 outstanding;
-
-	spin_lock_irqsave(&adapter->cmdq_free.lock.lock,
-			adapter->cmdq_free.lock.flags);
-	spin_lock_irqsave(&adapter->cmdq_done.lock.lock,
-			adapter->cmdq_done.lock.flags);
-	outstanding = adapter->cmdq_all.count - adapter->cmdq_done.count;
-	outstanding -= adapter->cmdq_free.count;
-	hcmd = adapter->cmdq_all.head;
-	while (hcmd) {
-		if (hcmd->busy) {
-			skb = hcmd->skb;
-			ASSERT(skb);
-			hcmd->busy = 0;
-			hcmd->skb = NULL;
-			dev_kfree_skb_irq(skb);
-		}
-		hcmd = hcmd->next_all;
-	}
-	adapter->cmdq_free.count = 0;
-	adapter->cmdq_free.head = NULL;
-	adapter->cmdq_free.tail = NULL;
-	adapter->cmdq_done.count = 0;
-	adapter->cmdq_done.head = NULL;
-	adapter->cmdq_done.tail = NULL;
-	adapter->cmdq_free.head = adapter->cmdq_all.head;
-	hcmd = adapter->cmdq_all.head;
-	while (hcmd) {
-		adapter->cmdq_free.count++;
-		hcmd->next = hcmd->next_all;
-		hcmd = hcmd->next_all;
-	}
-	if (adapter->cmdq_free.count != adapter->cmdq_all.count) {
-		dev_err(&adapter->netdev->dev,
-			"free_count %d != all count %d\n",
-			adapter->cmdq_free.count, adapter->cmdq_all.count);
-	}
-	spin_unlock_irqrestore(&adapter->cmdq_done.lock.lock,
-				adapter->cmdq_done.lock.flags);
-	spin_unlock_irqrestore(&adapter->cmdq_free.lock.lock,
-				adapter->cmdq_free.lock.flags);
-}
-
 static void slic_cmdq_addcmdpage(struct adapter *adapter, u32 *page)
 {
 	struct slic_hostcmd *cmd;
@@ -3325,6 +1633,99 @@ static void slic_cmdq_addcmdpage(struct adapter *adapter, u32 *page)
 	spin_unlock_irqrestore(&cmdq->lock.lock, cmdq->lock.flags);
 }
 
+static int slic_cmdq_init(struct adapter *adapter)
+{
+	int i;
+	u32 *pageaddr;
+
+	ASSERT(adapter->state == ADAPT_DOWN);
+	memset(&adapter->cmdq_all, 0, sizeof(struct slic_cmdqueue));
+	memset(&adapter->cmdq_free, 0, sizeof(struct slic_cmdqueue));
+	memset(&adapter->cmdq_done, 0, sizeof(struct slic_cmdqueue));
+	spin_lock_init(&adapter->cmdq_all.lock.lock);
+	spin_lock_init(&adapter->cmdq_free.lock.lock);
+	spin_lock_init(&adapter->cmdq_done.lock.lock);
+	slic_cmdqmem_init(adapter);
+	adapter->slic_handle_ix = 1;
+	for (i = 0; i < SLIC_CMDQ_INITPAGES; i++) {
+		pageaddr = slic_cmdqmem_addpage(adapter);
+#ifndef CONFIG_X86_64
+		ASSERT(((u32) pageaddr & 0xFFFFF000) == (u32) pageaddr);
+#endif
+		if (!pageaddr) {
+			slic_cmdq_free(adapter);
+			return -ENOMEM;
+		}
+		slic_cmdq_addcmdpage(adapter, pageaddr);
+	}
+	adapter->slic_handle_ix = 1;
+
+	return 0;
+}
+
+static void slic_cmdq_reset(struct adapter *adapter)
+{
+	struct slic_hostcmd *hcmd;
+	struct sk_buff *skb;
+	u32 outstanding;
+
+	spin_lock_irqsave(&adapter->cmdq_free.lock.lock,
+			adapter->cmdq_free.lock.flags);
+	spin_lock_irqsave(&adapter->cmdq_done.lock.lock,
+			adapter->cmdq_done.lock.flags);
+	outstanding = adapter->cmdq_all.count - adapter->cmdq_done.count;
+	outstanding -= adapter->cmdq_free.count;
+	hcmd = adapter->cmdq_all.head;
+	while (hcmd) {
+		if (hcmd->busy) {
+			skb = hcmd->skb;
+			ASSERT(skb);
+			hcmd->busy = 0;
+			hcmd->skb = NULL;
+			dev_kfree_skb_irq(skb);
+		}
+		hcmd = hcmd->next_all;
+	}
+	adapter->cmdq_free.count = 0;
+	adapter->cmdq_free.head = NULL;
+	adapter->cmdq_free.tail = NULL;
+	adapter->cmdq_done.count = 0;
+	adapter->cmdq_done.head = NULL;
+	adapter->cmdq_done.tail = NULL;
+	adapter->cmdq_free.head = adapter->cmdq_all.head;
+	hcmd = adapter->cmdq_all.head;
+	while (hcmd) {
+		adapter->cmdq_free.count++;
+		hcmd->next = hcmd->next_all;
+		hcmd = hcmd->next_all;
+	}
+	if (adapter->cmdq_free.count != adapter->cmdq_all.count) {
+		dev_err(&adapter->netdev->dev,
+			"free_count %d != all count %d\n",
+			adapter->cmdq_free.count, adapter->cmdq_all.count);
+	}
+	spin_unlock_irqrestore(&adapter->cmdq_done.lock.lock,
+				adapter->cmdq_done.lock.flags);
+	spin_unlock_irqrestore(&adapter->cmdq_free.lock.lock,
+				adapter->cmdq_free.lock.flags);
+}
+
+static void slic_cmdq_getdone(struct adapter *adapter)
+{
+	struct slic_cmdqueue *done_cmdq = &adapter->cmdq_done;
+	struct slic_cmdqueue *free_cmdq = &adapter->cmdq_free;
+
+	ASSERT(free_cmdq->head == NULL);
+	spin_lock_irqsave(&done_cmdq->lock.lock, done_cmdq->lock.flags);
+
+	free_cmdq->head = done_cmdq->head;
+	free_cmdq->count = done_cmdq->count;
+	done_cmdq->head = NULL;
+	done_cmdq->tail = NULL;
+	done_cmdq->count = 0;
+	spin_unlock_irqrestore(&done_cmdq->lock.lock, done_cmdq->lock.flags);
+}
+
 static struct slic_hostcmd *slic_cmdq_getfree(struct adapter *adapter)
 {
 	struct slic_cmdqueue *cmdq = &adapter->cmdq_free;
@@ -3358,22 +1759,6 @@ retry:
 	return cmd;
 }
 
-static void slic_cmdq_getdone(struct adapter *adapter)
-{
-	struct slic_cmdqueue *done_cmdq = &adapter->cmdq_done;
-	struct slic_cmdqueue *free_cmdq = &adapter->cmdq_free;
-
-	ASSERT(free_cmdq->head == NULL);
-	spin_lock_irqsave(&done_cmdq->lock.lock, done_cmdq->lock.flags);
-
-	free_cmdq->head = done_cmdq->head;
-	free_cmdq->count = done_cmdq->count;
-	done_cmdq->head = NULL;
-	done_cmdq->tail = NULL;
-	done_cmdq->count = 0;
-	spin_unlock_irqrestore(&done_cmdq->lock.lock, done_cmdq->lock.flags);
-}
-
 static void slic_cmdq_putdone_irq(struct adapter *adapter,
 				struct slic_hostcmd *cmd)
 {
@@ -3389,79 +1774,6 @@ static void slic_cmdq_putdone_irq(struct adapter *adapter,
 	spin_unlock(&cmdq->lock.lock);
 }
 
-static int slic_rcvqueue_init(struct adapter *adapter)
-{
-	int i, count;
-	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
-
-	ASSERT(adapter->state == ADAPT_DOWN);
-	rcvq->tail = NULL;
-	rcvq->head = NULL;
-	rcvq->size = SLIC_RCVQ_ENTRIES;
-	rcvq->errors = 0;
-	rcvq->count = 0;
-	i = (SLIC_RCVQ_ENTRIES / SLIC_RCVQ_FILLENTRIES);
-	count = 0;
-	while (i) {
-		count += slic_rcvqueue_fill(adapter);
-		i--;
-	}
-	if (rcvq->count < SLIC_RCVQ_MINENTRIES) {
-		slic_rcvqueue_free(adapter);
-		return -ENOMEM;
-	}
-	return 0;
-}
-
-static void slic_rcvqueue_free(struct adapter *adapter)
-{
-	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
-	struct sk_buff *skb;
-
-	while (rcvq->head) {
-		skb = rcvq->head;
-		rcvq->head = rcvq->head->next;
-		dev_kfree_skb(skb);
-	}
-	rcvq->tail = NULL;
-	rcvq->head = NULL;
-	rcvq->count = 0;
-}
-
-static struct sk_buff *slic_rcvqueue_getnext(struct adapter *adapter)
-{
-	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
-	struct sk_buff *skb;
-	struct slic_rcvbuf *rcvbuf;
-	int count;
-
-	if (rcvq->count) {
-		skb = rcvq->head;
-		rcvbuf = (struct slic_rcvbuf *)skb->head;
-		ASSERT(rcvbuf);
-
-		if (rcvbuf->status & IRHDDR_SVALID) {
-			rcvq->head = rcvq->head->next;
-			skb->next = NULL;
-			rcvq->count--;
-		} else {
-			skb = NULL;
-		}
-	} else {
-		dev_err(&adapter->netdev->dev,
-			"RcvQ Empty!! rcvq[%p] count[%x]\n", rcvq, rcvq->count);
-		skb = NULL;
-	}
-	while (rcvq->count < SLIC_RCVQ_FILLTHRESH) {
-		count = slic_rcvqueue_fill(adapter);
-		if (!count)
-			break;
-	}
-	if (skb)
-		rcvq->errors = 0;
-	return skb;
-}
-
 static int slic_rcvqueue_fill(struct adapter *adapter)
 {
 	void *paddr;
@@ -3549,6 +1861,79 @@ retry_rcvqfill:
 	return i;
 }
 
+static void slic_rcvqueue_free(struct adapter *adapter)
+{
+	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
+	struct sk_buff *skb;
+
+	while (rcvq->head) {
+		skb = rcvq->head;
+		rcvq->head = rcvq->head->next;
+		dev_kfree_skb(skb);
+	}
+	rcvq->tail = NULL;
+	rcvq->head = NULL;
+	rcvq->count = 0;
+}
+
+static int slic_rcvqueue_init(struct adapter *adapter)
+{
+	int i, count;
+	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
+
+	ASSERT(adapter->state == ADAPT_DOWN);
+	rcvq->tail = NULL;
+	rcvq->head = NULL;
+	rcvq->size = SLIC_RCVQ_ENTRIES;
+	rcvq->errors = 0;
+	rcvq->count = 0;
+	i = (SLIC_RCVQ_ENTRIES / SLIC_RCVQ_FILLENTRIES);
+	count = 0;
+	while (i) {
+		count += slic_rcvqueue_fill(adapter);
+		i--;
+	}
+	if (rcvq->count < SLIC_RCVQ_MINENTRIES) {
+		slic_rcvqueue_free(adapter);
+		return -ENOMEM;
+	}
+	return 0;
+}
+
+static struct sk_buff *slic_rcvqueue_getnext(struct adapter *adapter)
+{
+	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
+	struct sk_buff *skb;
+	struct slic_rcvbuf *rcvbuf;
+	int count;
+
+	if (rcvq->count) {
+		skb = rcvq->head;
+		rcvbuf = (struct slic_rcvbuf *)skb->head;
+		ASSERT(rcvbuf);
+
+		if (rcvbuf->status & IRHDDR_SVALID) {
+			rcvq->head = rcvq->head->next;
+			skb->next = NULL;
+			rcvq->count--;
+		} else {
+			skb = NULL;
+		}
+	} else {
+		dev_err(&adapter->netdev->dev,
+			"RcvQ Empty!! rcvq[%p] count[%x]\n", rcvq, rcvq->count);
+		skb = NULL;
+	}
+	while (rcvq->count < SLIC_RCVQ_FILLTHRESH) {
+		count = slic_rcvqueue_fill(adapter);
+		if (!count)
+			break;
+	}
+	if (skb)
+		rcvq->errors = 0;
+	return skb;
+}
+
 static u32 slic_rcvqueue_reinsert(struct adapter *adapter, struct sk_buff *skb)
 {
 	struct slic_rcvqueue *rcvq = &adapter->rcvqueue;
@@ -4040,9 +2425,1554 @@ static void slic_debug_cleanup(void)
 	}
 }
 
-/******************************************************************************/
-/****************   MODULE INITIATION / TERMINATION FUNCTIONS   ***************/
-/******************************************************************************/
+/*
+ * slic_link_event_handler -
+ *
+ * Initiate a link configuration sequence.  The link configuration begins
+ * by issuing a READ_LINK_STATUS command to the Utility Processor on the
+ * SLIC.  Since the command finishes asynchronously, the slic_upr_comlete
+ * routine will follow it up witha UP configuration write command, which
+ * will also complete asynchronously.
+ *
+ */
+static void slic_link_event_handler(struct adapter *adapter)
+{
+	int status;
+	struct slic_shmem *pshmem;
+
+	if (adapter->state != ADAPT_UP) {
+		/* Adapter is not operational.  Ignore.  */
+		return;
+	}
+
+	pshmem = (struct slic_shmem *)adapter->phys_shmem;
+
+#if defined(CONFIG_X86_64)
+	status = slic_upr_request(adapter,
+				  SLIC_UPR_RLSR,
+				  SLIC_GET_ADDR_LOW(&pshmem->linkstatus),
+				  SLIC_GET_ADDR_HIGH(&pshmem->linkstatus),
+				  0, 0);
+#elif defined(CONFIG_X86)
+	status = slic_upr_request(adapter, SLIC_UPR_RLSR,
+		(u32) &pshmem->linkstatus,	/* no 4GB wrap guaranteed */
+				  0, 0, 0);
+#else
+	Stop compilation;
+#endif
+	ASSERT(status == 0);
+}
+
+static void slic_init_cleanup(struct adapter *adapter)
+{
+	if (adapter->intrregistered) {
+		adapter->intrregistered = 0;
+		free_irq(adapter->netdev->irq, adapter->netdev);
+
+	}
+	if (adapter->pshmem) {
+		pci_free_consistent(adapter->pcidev,
+				    sizeof(struct slic_shmem),
+				    adapter->pshmem, adapter->phys_shmem);
+		adapter->pshmem = NULL;
+		adapter->phys_shmem = (dma_addr_t) NULL;
+	}
+
+	if (adapter->pingtimerset) {
+		adapter->pingtimerset = 0;
+		del_timer(&adapter->pingtimer);
+	}
+
+	slic_rspqueue_free(adapter);
+	slic_cmdq_free(adapter);
+	slic_rcvqueue_free(adapter);
+}
+
+/*
+ *  Allocate a mcast_address structure to hold the multicast address.
+ *  Link it in.
+ */
+static int slic_mcast_add_list(struct adapter *adapter, char *address)
+{
+	struct mcast_address *mcaddr, *mlist;
+
+	/* Check to see if it already exists */
+	mlist = adapter->mcastaddrs;
+	while (mlist) {
+		if (!compare_ether_addr(mlist->address, address))
+			return 0;
+		mlist = mlist->next;
+	}
+
+	/* Doesn't already exist.  Allocate a structure to hold it */
+	mcaddr = kmalloc(sizeof(struct mcast_address), GFP_ATOMIC);
+	if (mcaddr == NULL)
+		return 1;
+
+	memcpy(mcaddr->address, address, 6);
+
+	mcaddr->next = adapter->mcastaddrs;
+	adapter->mcastaddrs = mcaddr;
+
+	return 0;
+}
+
+static void slic_mcast_set_list(struct net_device *dev)
+{
+	struct adapter *adapter = netdev_priv(dev);
+	int status = 0;
+	char *addresses;
+	struct netdev_hw_addr *ha;
+
+	ASSERT(adapter);
+
+	netdev_for_each_mc_addr(ha, dev) {
+		addresses = (char *) &ha->addr;
+		status = slic_mcast_add_list(adapter, addresses);
+		if (status != 0)
+			break;
+		slic_mcast_set_bit(adapter, addresses);
+	}
+
+	if (adapter->devflags_prev != dev->flags) {
+		adapter->macopts = MAC_DIRECTED;
+		if (dev->flags) {
+			if (dev->flags & IFF_BROADCAST)
+				adapter->macopts |= MAC_BCAST;
+			if (dev->flags & IFF_PROMISC)
+				adapter->macopts |= MAC_PROMISC;
+			if (dev->flags & IFF_ALLMULTI)
+				adapter->macopts |= MAC_ALLMCAST;
+			if (dev->flags & IFF_MULTICAST)
+				adapter->macopts |= MAC_MCAST;
+		}
+		adapter->devflags_prev = dev->flags;
+		slic_config_set(adapter, true);
+	} else {
+		if (status == 0)
+			slic_mcast_set_mask(adapter);
+	}
+	return;
+}
+
+#define  XMIT_FAIL_LINK_STATE               1
+#define  XMIT_FAIL_ZERO_LENGTH              2
+#define  XMIT_FAIL_HOSTCMD_FAIL             3
+
+static void slic_xmit_build_request(struct adapter *adapter,
+			     struct slic_hostcmd *hcmd, struct sk_buff *skb)
+{
+	struct slic_host64_cmd *ihcmd;
+	ulong phys_addr;
+
+	ihcmd = &hcmd->cmd64;
+
+	ihcmd->flags = (adapter->port << IHFLG_IFSHFT);
+	ihcmd->command = IHCMD_XMT_REQ;
+	ihcmd->u.slic_buffers.totlen = skb->len;
+	phys_addr = pci_map_single(adapter->pcidev, skb->data, skb->len,
+			PCI_DMA_TODEVICE);
+	ihcmd->u.slic_buffers.bufs[0].paddrl = SLIC_GET_ADDR_LOW(phys_addr);
+	ihcmd->u.slic_buffers.bufs[0].paddrh = SLIC_GET_ADDR_HIGH(phys_addr);
+	ihcmd->u.slic_buffers.bufs[0].length = skb->len;
+#if defined(CONFIG_X86_64)
+	hcmd->cmdsize = (u32) ((((u64)&ihcmd->u.slic_buffers.bufs[1] -
+				     (u64) hcmd) + 31) >> 5);
+#elif defined(CONFIG_X86)
+	hcmd->cmdsize = ((((u32) &ihcmd->u.slic_buffers.bufs[1] -
+			   (u32) hcmd) + 31) >> 5);
+#else
+	Stop Compilation;
+#endif
+}
+
+static void slic_xmit_fail(struct adapter *adapter,
+		    struct sk_buff *skb,
+		    void *cmd, u32 skbtype, u32 status)
+{
+	if (adapter->xmitq_full)
+		netif_stop_queue(adapter->netdev);
+	if ((cmd == NULL) && (status <= XMIT_FAIL_HOSTCMD_FAIL)) {
+		switch (status) {
+		case XMIT_FAIL_LINK_STATE:
+			dev_err(&adapter->netdev->dev,
+				"reject xmit skb[%p: %x] linkstate[%s] "
+				"adapter[%s:%d] card[%s:%d]\n",
+				skb, skb->pkt_type,
+				SLIC_LINKSTATE(adapter->linkstate),
+				SLIC_ADAPTER_STATE(adapter->state),
+				adapter->state,
+				SLIC_CARD_STATE(adapter->card->state),
+				adapter->card->state);
+			break;
+		case XMIT_FAIL_ZERO_LENGTH:
+			dev_err(&adapter->netdev->dev,
+				"xmit_start skb->len == 0 skb[%p] type[%x]\n",
+				skb, skb->pkt_type);
+			break;
+		case XMIT_FAIL_HOSTCMD_FAIL:
+			dev_err(&adapter->netdev->dev,
+				"xmit_start skb[%p] type[%x] No host commands "
+				"available\n", skb, skb->pkt_type);
+			break;
+		default:
+			ASSERT(0);
+		}
+	}
+	dev_kfree_skb(skb);
+	adapter->stats.tx_dropped++;
+}
+
+static void slic_rcv_handle_error(struct adapter *adapter,
+					struct slic_rcvbuf *rcvbuf)
+{
+	struct slic_hddr_wds *hdr = (struct slic_hddr_wds *)rcvbuf->data;
+
+	if (adapter->devid != SLIC_1GB_DEVICE_ID) {
+		if (hdr->frame_status14 & VRHSTAT_802OE)
+			adapter->if_events.oflow802++;
+		if (hdr->frame_status14 & VRHSTAT_TPOFLO)
+			adapter->if_events.Tprtoflow++;
+		if (hdr->frame_status_b14 & VRHSTATB_802UE)
+			adapter->if_events.uflow802++;
+		if (hdr->frame_status_b14 & VRHSTATB_RCVE) {
+			adapter->if_events.rcvearly++;
+			adapter->stats.rx_fifo_errors++;
+		}
+		if (hdr->frame_status_b14 & VRHSTATB_BUFF) {
+			adapter->if_events.Bufov++;
+			adapter->stats.rx_over_errors++;
+		}
+		if (hdr->frame_status_b14 & VRHSTATB_CARRE) {
+			adapter->if_events.Carre++;
+			adapter->stats.tx_carrier_errors++;
+		}
+		if (hdr->frame_status_b14 & VRHSTATB_LONGE)
+			adapter->if_events.Longe++;
+		if (hdr->frame_status_b14 & VRHSTATB_PREA)
+			adapter->if_events.Invp++;
+		if (hdr->frame_status_b14 & VRHSTATB_CRC) {
+			adapter->if_events.Crc++;
+			adapter->stats.rx_crc_errors++;
+		}
+		if (hdr->frame_status_b14 & VRHSTATB_DRBL)
+			adapter->if_events.Drbl++;
+		if (hdr->frame_status_b14 & VRHSTATB_CODE)
+			adapter->if_events.Code++;
+		if (hdr->frame_status_b14 & VRHSTATB_TPCSUM)
+			adapter->if_events.TpCsum++;
+		if (hdr->frame_status_b14 & VRHSTATB_TPHLEN)
+			adapter->if_events.TpHlen++;
+		if (hdr->frame_status_b14 & VRHSTATB_IPCSUM)
+			adapter->if_events.IpCsum++;
+		if (hdr->frame_status_b14 & VRHSTATB_IPLERR)
+			adapter->if_events.IpLen++;
+		if (hdr->frame_status_b14 & VRHSTATB_IPHERR)
+			adapter->if_events.IpHlen++;
+	} else {
+		if (hdr->frame_statusGB & VGBSTAT_XPERR) {
+			u32 xerr = hdr->frame_statusGB >> VGBSTAT_XERRSHFT;
+
+			if (xerr == VGBSTAT_XCSERR)
+				adapter->if_events.TpCsum++;
+			if (xerr == VGBSTAT_XUFLOW)
+				adapter->if_events.Tprtoflow++;
+			if (xerr == VGBSTAT_XHLEN)
+				adapter->if_events.TpHlen++;
+		}
+		if (hdr->frame_statusGB & VGBSTAT_NETERR) {
+			u32 nerr =
+			    (hdr->
+			     frame_statusGB >> VGBSTAT_NERRSHFT) &
+			    VGBSTAT_NERRMSK;
+			if (nerr == VGBSTAT_NCSERR)
+				adapter->if_events.IpCsum++;
+			if (nerr == VGBSTAT_NUFLOW)
+				adapter->if_events.IpLen++;
+			if (nerr == VGBSTAT_NHLEN)
+				adapter->if_events.IpHlen++;
+		}
+		if (hdr->frame_statusGB & VGBSTAT_LNKERR) {
+			u32 lerr = hdr->frame_statusGB & VGBSTAT_LERRMSK;
+
+			if (lerr == VGBSTAT_LDEARLY)
+				adapter->if_events.rcvearly++;
+			if (lerr == VGBSTAT_LBOFLO)
+				adapter->if_events.Bufov++;
+			if (lerr == VGBSTAT_LCODERR)
+				adapter->if_events.Code++;
+			if (lerr == VGBSTAT_LDBLNBL)
+				adapter->if_events.Drbl++;
+			if (lerr == VGBSTAT_LCRCERR)
+				adapter->if_events.Crc++;
+			if (lerr == VGBSTAT_LOFLO)
+				adapter->if_events.oflow802++;
+			if (lerr == VGBSTAT_LUFLO)
+				adapter->if_events.uflow802++;
+		}
+	}
+	return;
+}
+
+#define TCP_OFFLOAD_FRAME_PUSHFLAG  0x10000000
+#define M_FAST_PATH                 0x0040
+
+static void slic_rcv_handler(struct adapter *adapter)
+{
+	struct sk_buff *skb;
+	struct slic_rcvbuf *rcvbuf;
+	u32 frames = 0;
+
+	while ((skb = slic_rcvqueue_getnext(adapter))) {
+		u32 rx_bytes;
+
+		ASSERT(skb->head);
+		rcvbuf = (struct slic_rcvbuf *)skb->head;
+		adapter->card->events++;
+		if (rcvbuf->status & IRHDDR_ERR) {
+			adapter->rx_errors++;
+			slic_rcv_handle_error(adapter, rcvbuf);
+			slic_rcvqueue_reinsert(adapter, skb);
+			continue;
+		}
+
+		if (!slic_mac_filter(adapter, (struct ether_header *)
+					rcvbuf->data)) {
+			slic_rcvqueue_reinsert(adapter, skb);
+			continue;
+		}
+		skb_pull(skb, SLIC_RCVBUF_HEADSIZE);
+		rx_bytes = (rcvbuf->length & IRHDDR_FLEN_MSK);
+		skb_put(skb, rx_bytes);
+		adapter->stats.rx_packets++;
+		adapter->stats.rx_bytes += rx_bytes;
+#if SLIC_OFFLOAD_IP_CHECKSUM
+		skb->ip_summed = CHECKSUM_UNNECESSARY;
+#endif
+
+		skb->dev = adapter->netdev;
+		skb->protocol = eth_type_trans(skb, skb->dev);
+		netif_rx(skb);
+
+		++frames;
+#if SLIC_INTERRUPT_PROCESS_LIMIT
+		if (frames >= SLIC_RCVQ_MAX_PROCESS_ISR) {
+			adapter->rcv_interrupt_yields++;
+			break;
+		}
+#endif
+	}
+	adapter->max_isr_rcvs = max(adapter->max_isr_rcvs, frames);
+}
+
+static void slic_xmit_complete(struct adapter *adapter)
+{
+	struct slic_hostcmd *hcmd;
+	struct slic_rspbuf *rspbuf;
+	u32 frames = 0;
+	struct slic_handle_word slic_handle_word;
+
+	do {
+		rspbuf = slic_rspqueue_getnext(adapter);
+		if (!rspbuf)
+			break;
+		adapter->xmit_completes++;
+		adapter->card->events++;
+		/*
+		 Get the complete host command buffer
+		*/
+		slic_handle_word.handle_token = rspbuf->hosthandle;
+		ASSERT(slic_handle_word.handle_index);
+		ASSERT(slic_handle_word.handle_index <= SLIC_CMDQ_MAXCMDS);
+		hcmd =
+		    (struct slic_hostcmd *)
+			adapter->slic_handles[slic_handle_word.handle_index].
+									address;
+/*      hcmd = (struct slic_hostcmd *) rspbuf->hosthandle; */
+		ASSERT(hcmd);
+		ASSERT(hcmd->pslic_handle ==
+		       &adapter->slic_handles[slic_handle_word.handle_index]);
+		if (hcmd->type == SLIC_CMD_DUMB) {
+			if (hcmd->skb)
+				dev_kfree_skb_irq(hcmd->skb);
+			slic_cmdq_putdone_irq(adapter, hcmd);
+		}
+		rspbuf->status = 0;
+		rspbuf->hosthandle = 0;
+		frames++;
+	} while (1);
+	adapter->max_isr_xmits = max(adapter->max_isr_xmits, frames);
+}
+
+static irqreturn_t slic_interrupt(int irq, void *dev_id)
+{
+	struct net_device *dev = (struct net_device *)dev_id;
+	struct adapter *adapter = netdev_priv(dev);
+	u32 isr;
+
+	if ((adapter->pshmem) && (adapter->pshmem->isr)) {
+		slic_reg32_write(&adapter->slic_regs->slic_icr,
+				 ICR_INT_MASK, FLUSH);
+		isr = adapter->isrcopy = adapter->pshmem->isr;
+		adapter->pshmem->isr = 0;
+		adapter->num_isrs++;
+		switch (adapter->card->state) {
+		case CARD_UP:
+			if (isr & ~ISR_IO) {
+				if (isr & ISR_ERR) {
+					adapter->error_interrupts++;
+					if (isr & ISR_RMISS) {
+						int count;
+						int pre_count;
+						int errors;
+
+						struct slic_rcvqueue *rcvq =
+						    &adapter->rcvqueue;
+
+						adapter->
+						    error_rmiss_interrupts++;
+						if (!rcvq->errors)
+							rcv_count = rcvq->count;
+						pre_count = rcvq->count;
+						errors = rcvq->errors;
+
+						while (rcvq->count <
+						       SLIC_RCVQ_FILLTHRESH) {
+							count =
+							    slic_rcvqueue_fill
+							    (adapter);
+							if (!count)
+								break;
+						}
+					} else if (isr & ISR_XDROP) {
+						dev_err(&dev->dev,
+							"isr & ISR_ERR [%x] "
+							"ISR_XDROP \n", isr);
+					} else {
+						dev_err(&dev->dev,
+							"isr & ISR_ERR [%x]\n",
+							isr);
+					}
+				}
+
+				if (isr & ISR_LEVENT) {
+					adapter->linkevent_interrupts++;
+					slic_link_event_handler(adapter);
+				}
+
+				if ((isr & ISR_UPC) ||
+				    (isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
+					adapter->upr_interrupts++;
+					slic_upr_request_complete(adapter, isr);
+				}
+			}
+
+			if (isr & ISR_RCV) {
+				adapter->rcv_interrupts++;
+				slic_rcv_handler(adapter);
+			}
+
+			if (isr & ISR_CMD) {
+				adapter->xmit_interrupts++;
+				slic_xmit_complete(adapter);
+			}
+			break;
+
+		case CARD_DOWN:
+			if ((isr & ISR_UPC) ||
+			    (isr & ISR_UPCERR) || (isr & ISR_UPCBSY)) {
+				adapter->upr_interrupts++;
+				slic_upr_request_complete(adapter, isr);
+			}
+			break;
+
+		default:
+			break;
+		}
+
+		adapter->isrcopy = 0;
+		adapter->all_reg_writes += 2;
+		adapter->isr_reg_writes++;
+		slic_reg32_write(&adapter->slic_regs->slic_isr, 0, FLUSH);
+	} else {
+		adapter->false_interrupts++;
+	}
+	return IRQ_HANDLED;
+}
+
+#define NORMAL_ETHFRAME     0
+
+static netdev_tx_t slic_xmit_start(struct sk_buff *skb, struct net_device *dev)
+{
+	struct sliccard *card;
+	struct adapter *adapter = netdev_priv(dev);
+	struct slic_hostcmd *hcmd = NULL;
+	u32 status = 0;
+	u32 skbtype = NORMAL_ETHFRAME;
+	void *offloadcmd = NULL;
+
+	card = adapter->card;
+	ASSERT(card);
+	if ((adapter->linkstate != LINK_UP) ||
+	    (adapter->state != ADAPT_UP) || (card->state != CARD_UP)) {
+		status = XMIT_FAIL_LINK_STATE;
+		goto xmit_fail;
+
+	} else if (skb->len == 0) {
+		status = XMIT_FAIL_ZERO_LENGTH;
+		goto xmit_fail;
+	}
+
+	if (skbtype == NORMAL_ETHFRAME) {
+		hcmd = slic_cmdq_getfree(adapter);
+		if (!hcmd) {
+			adapter->xmitq_full = 1;
+			status = XMIT_FAIL_HOSTCMD_FAIL;
+			goto xmit_fail;
+		}
+		ASSERT(hcmd->pslic_handle);
+		ASSERT(hcmd->cmd64.hosthandle ==
+		       hcmd->pslic_handle->token.handle_token);
+		hcmd->skb = skb;
+		hcmd->busy = 1;
+		hcmd->type = SLIC_CMD_DUMB;
+		if (skbtype == NORMAL_ETHFRAME)
+			slic_xmit_build_request(adapter, hcmd, skb);
+	}
+	adapter->stats.tx_packets++;
+	adapter->stats.tx_bytes += skb->len;
+
+#ifdef DEBUG_DUMP
+	if (adapter->kill_card) {
+		struct slic_host64_cmd ihcmd;
+
+		ihcmd = &hcmd->cmd64;
+
+		ihcmd->flags |= 0x40;
+		adapter->kill_card = 0;	/* only do this once */
+	}
+#endif
+	if (hcmd->paddrh == 0) {
+		slic_reg32_write(&adapter->slic_regs->slic_cbar,
+				 (hcmd->paddrl | hcmd->cmdsize), DONT_FLUSH);
+	} else {
+		slic_reg64_write(adapter, &adapter->slic_regs->slic_cbar64,
+				 (hcmd->paddrl | hcmd->cmdsize),
+				 &adapter->slic_regs->slic_addr_upper,
+				 hcmd->paddrh, DONT_FLUSH);
+	}
+xmit_done:
+	return NETDEV_TX_OK;
+xmit_fail:
+	slic_xmit_fail(adapter, skb, offloadcmd, skbtype, status);
+	goto xmit_done;
+}
+
+
+static void slic_adapter_freeresources(struct adapter *adapter)
+{
+	slic_init_cleanup(adapter);
+	memset(&adapter->stats, 0, sizeof(struct net_device_stats));
+	adapter->error_interrupts = 0;
+	adapter->rcv_interrupts = 0;
+	adapter->xmit_interrupts = 0;
+	adapter->linkevent_interrupts = 0;
+	adapter->upr_interrupts = 0;
+	adapter->num_isrs = 0;
+	adapter->xmit_completes = 0;
+	adapter->rcv_broadcasts = 0;
+	adapter->rcv_multicasts = 0;
+	adapter->rcv_unicasts = 0;
+}
+
+static int slic_adapter_allocresources(struct adapter *adapter)
+{
+	if (!adapter->intrregistered) {
+		int retval;
+
+		spin_unlock_irqrestore(&slic_global.driver_lock.lock,
+					slic_global.driver_lock.flags);
+
+		retval = request_irq(adapter->netdev->irq,
+				     &slic_interrupt,
+				     IRQF_SHARED,
+				     adapter->netdev->name, adapter->netdev);
+
+		spin_lock_irqsave(&slic_global.driver_lock.lock,
+					slic_global.driver_lock.flags);
+
+		if (retval) {
+			dev_err(&adapter->netdev->dev,
+				"request_irq (%s) FAILED [%x]\n",
+				adapter->netdev->name, retval);
+			return retval;
+		}
+		adapter->intrregistered = 1;
+	}
+	return 0;
+}
+
+/*
+ *  slic_if_init
+ *
+ *  Perform initialization of our slic interface.
+ *
+ */
+static int slic_if_init(struct adapter *adapter)
+{
+	struct sliccard *card = adapter->card;
+	struct net_device *dev = adapter->netdev;
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
+	struct slic_shmem *pshmem;
+	int rc;
+
+	ASSERT(card);
+
+	/* adapter should be down at this point */
+	if (adapter->state != ADAPT_DOWN) {
+		dev_err(&dev->dev, "%s: adapter->state != ADAPT_DOWN\n",
+			__func__);
+		rc = -EIO;
+		goto err;
+	}
+	ASSERT(adapter->linkstate == LINK_DOWN);
+
+	adapter->devflags_prev = dev->flags;
+	adapter->macopts = MAC_DIRECTED;
+	if (dev->flags) {
+		if (dev->flags & IFF_BROADCAST)
+			adapter->macopts |= MAC_BCAST;
+		if (dev->flags & IFF_PROMISC)
+			adapter->macopts |= MAC_PROMISC;
+		if (dev->flags & IFF_ALLMULTI)
+			adapter->macopts |= MAC_ALLMCAST;
+		if (dev->flags & IFF_MULTICAST)
+			adapter->macopts |= MAC_MCAST;
+	}
+	rc = slic_adapter_allocresources(adapter);
+	if (rc) {
+		dev_err(&dev->dev,
+			"%s: slic_adapter_allocresources FAILED %x\n",
+			__func__, rc);
+		slic_adapter_freeresources(adapter);
+		goto err;
+	}
+
+	if (!adapter->queues_initialized) {
+		if ((rc = slic_rspqueue_init(adapter)))
+			goto err;
+		if ((rc = slic_cmdq_init(adapter)))
+			goto err;
+		if ((rc = slic_rcvqueue_init(adapter)))
+			goto err;
+		adapter->queues_initialized = 1;
+	}
+
+	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
+	mdelay(1);
+
+	if (!adapter->isp_initialized) {
+		pshmem = (struct slic_shmem *)adapter->phys_shmem;
+
+		spin_lock_irqsave(&adapter->bit64reglock.lock,
+					adapter->bit64reglock.flags);
+
+#if defined(CONFIG_X86_64)
+		slic_reg32_write(&slic_regs->slic_addr_upper,
+				 SLIC_GET_ADDR_HIGH(&pshmem->isr), DONT_FLUSH);
+		slic_reg32_write(&slic_regs->slic_isp,
+				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
+#elif defined(CONFIG_X86)
+		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
+		slic_reg32_write(&slic_regs->slic_isp, (u32)&pshmem->isr, FLUSH);
+#else
+		Stop Compilations
+#endif
+		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
+					adapter->bit64reglock.flags);
+		adapter->isp_initialized = 1;
+	}
+
+	adapter->state = ADAPT_UP;
+	if (!card->loadtimerset) {
+		init_timer(&card->loadtimer);
+		card->loadtimer.expires =
+		    jiffies + (SLIC_LOADTIMER_PERIOD * HZ);
+		card->loadtimer.data = (ulong) card;
+		card->loadtimer.function = &slic_timer_load_check;
+		add_timer(&card->loadtimer);
+
+		card->loadtimerset = 1;
+	}
+
+	if (!adapter->pingtimerset) {
+		init_timer(&adapter->pingtimer);
+		adapter->pingtimer.expires =
+		    jiffies + (PING_TIMER_INTERVAL * HZ);
+		adapter->pingtimer.data = (ulong) dev;
+		adapter->pingtimer.function = &slic_timer_ping;
+		add_timer(&adapter->pingtimer);
+		adapter->pingtimerset = 1;
+		adapter->card->pingstatus = ISR_PINGMASK;
+	}
+
+	/*
+	 *    clear any pending events, then enable interrupts
+	 */
+	adapter->isrcopy = 0;
+	adapter->pshmem->isr = 0;
+	slic_reg32_write(&slic_regs->slic_isr, 0, FLUSH);
+	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_ON, FLUSH);
+
+	slic_link_config(adapter, LINK_AUTOSPEED, LINK_AUTOD);
+	slic_link_event_handler(adapter);
+
+err:
+	return rc;
+}
+
+static int slic_entry_open(struct net_device *dev)
+{
+	struct adapter *adapter = netdev_priv(dev);
+	struct sliccard *card = adapter->card;
+	u32 locked = 0;
+	int status;
+
+	ASSERT(adapter);
+	ASSERT(card);
+
+	netif_stop_queue(adapter->netdev);
+
+	spin_lock_irqsave(&slic_global.driver_lock.lock,
+				slic_global.driver_lock.flags);
+	locked = 1;
+	if (!adapter->activated) {
+		card->adapters_activated++;
+		slic_global.num_slic_ports_active++;
+		adapter->activated = 1;
+	}
+	status = slic_if_init(adapter);
+
+	if (status != 0) {
+		if (adapter->activated) {
+			card->adapters_activated--;
+			slic_global.num_slic_ports_active--;
+			adapter->activated = 0;
+		}
+		if (locked) {
+			spin_unlock_irqrestore(&slic_global.driver_lock.lock,
+						slic_global.driver_lock.flags);
+			locked = 0;
+		}
+		return status;
+	}
+	if (!card->master)
+		card->master = adapter;
+
+	if (locked) {
+		spin_unlock_irqrestore(&slic_global.driver_lock.lock,
+					slic_global.driver_lock.flags);
+		locked = 0;
+	}
+
+	return 0;
+}
+
+static void slic_card_cleanup(struct sliccard *card)
+{
+	if (card->loadtimerset) {
+		card->loadtimerset = 0;
+		del_timer(&card->loadtimer);
+	}
+
+	slic_debug_card_destroy(card);
+
+	kfree(card);
+}
+
+static void __devexit slic_entry_remove(struct pci_dev *pcidev)
+{
+	struct net_device *dev = pci_get_drvdata(pcidev);
+	u32 mmio_start = 0;
+	uint mmio_len = 0;
+	struct adapter *adapter = netdev_priv(dev);
+	struct sliccard *card;
+	struct mcast_address *mcaddr, *mlist;
+
+	ASSERT(adapter);
+	slic_adapter_freeresources(adapter);
+	slic_unmap_mmio_space(adapter);
+	unregister_netdev(dev);
+
+	mmio_start = pci_resource_start(pcidev, 0);
+	mmio_len = pci_resource_len(pcidev, 0);
+
+	release_mem_region(mmio_start, mmio_len);
+
+	iounmap((void __iomem *)dev->base_addr);
+	/* free multicast addresses */
+	mlist = adapter->mcastaddrs;
+	while (mlist) {
+		mcaddr = mlist;
+		mlist = mlist->next;
+		kfree(mcaddr);
+	}
+	ASSERT(adapter->card);
+	card = adapter->card;
+	ASSERT(card->adapters_allocated);
+	card->adapters_allocated--;
+	adapter->allocated = 0;
+	if (!card->adapters_allocated) {
+		struct sliccard *curr_card = slic_global.slic_card;
+		if (curr_card == card) {
+			slic_global.slic_card = card->next;
+		} else {
+			while (curr_card->next != card)
+				curr_card = curr_card->next;
+			ASSERT(curr_card);
+			curr_card->next = card->next;
+		}
+		ASSERT(slic_global.num_slic_cards);
+		slic_global.num_slic_cards--;
+		slic_card_cleanup(card);
+	}
+	kfree(dev);
+	pci_release_regions(pcidev);
+}
+
+static int slic_entry_halt(struct net_device *dev)
+{
+	struct adapter *adapter = netdev_priv(dev);
+	struct sliccard *card = adapter->card;
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
+
+	spin_lock_irqsave(&slic_global.driver_lock.lock,
+				slic_global.driver_lock.flags);
+	ASSERT(card);
+	netif_stop_queue(adapter->netdev);
+	adapter->state = ADAPT_DOWN;
+	adapter->linkstate = LINK_DOWN;
+	adapter->upr_list = NULL;
+	adapter->upr_busy = 0;
+	adapter->devflags_prev = 0;
+	ASSERT(card->adapter[adapter->cardindex] == adapter);
+	slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
+	adapter->all_reg_writes++;
+	adapter->icr_reg_writes++;
+	slic_config_clear(adapter);
+	if (adapter->activated) {
+		card->adapters_activated--;
+		slic_global.num_slic_ports_active--;
+		adapter->activated = 0;
+	}
+#ifdef AUTOMATIC_RESET
+	slic_reg32_write(&slic_regs->slic_reset_iface, 0, FLUSH);
+#endif
+	/*
+	 *  Reset the adapter's cmd queues
+	 */
+	slic_cmdq_reset(adapter);
+
+#ifdef AUTOMATIC_RESET
+	if (!card->adapters_activated)
+		slic_card_init(card, adapter);
+#endif
+
+	spin_unlock_irqrestore(&slic_global.driver_lock.lock,
+				slic_global.driver_lock.flags);
+	return 0;
+}
+
+static struct net_device_stats *slic_get_stats(struct net_device *dev)
+{
+	struct adapter *adapter = netdev_priv(dev);
+
+	ASSERT(adapter);
+	dev->stats.collisions = adapter->slic_stats.iface.xmit_collisions;
+	dev->stats.rx_errors = adapter->slic_stats.iface.rcv_errors;
+	dev->stats.tx_errors = adapter->slic_stats.iface.xmt_errors;
+	dev->stats.rx_missed_errors = adapter->slic_stats.iface.rcv_discards;
+	dev->stats.tx_heartbeat_errors = 0;
+	dev->stats.tx_aborted_errors = 0;
+	dev->stats.tx_window_errors = 0;
+	dev->stats.tx_fifo_errors = 0;
+	dev->stats.rx_frame_errors = 0;
+	dev->stats.rx_length_errors = 0;
+
+	return &dev->stats;
+}
+
+static int slic_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
+{
+	struct adapter *adapter = netdev_priv(dev);
+	struct ethtool_cmd edata;
+	struct ethtool_cmd ecmd;
+	u32 data[7];
+	u32 intagg;
+
+	ASSERT(rq);
+	switch (cmd) {
+	case SIOCSLICSETINTAGG:
+		if (copy_from_user(data, rq->ifr_data, 28))
+			return -EFAULT;
+		intagg = data[0];
+		dev_err(&dev->dev, "%s: set interrupt aggregation to %d\n",
+			__func__, intagg);
+		slic_intagg_set(adapter, intagg);
+		return 0;
+
+#ifdef SLIC_TRACE_DUMP_ENABLED
+	case SIOCSLICTRACEDUMP:
+		{
+			u32 value;
+			DBG_IOCTL("slic_ioctl  SIOCSLIC_TRACE_DUMP\n");
+
+			if (copy_from_user(data, rq->ifr_data, 28)) {
+				PRINT_ERROR
+				    ("slic: copy_from_user FAILED getting initial simba param\n");
+				return -EFAULT;
+			}
+
+			value = data[0];
+			if (tracemon_request == SLIC_DUMP_DONE) {
+				PRINT_ERROR
+				    ("ATK Diagnostic Trace Dump Requested\n");
+				tracemon_request = SLIC_DUMP_REQUESTED;
+				tracemon_request_type = value;
+				tracemon_timestamp = jiffies;
+			} else if ((tracemon_request == SLIC_DUMP_REQUESTED) ||
+				   (tracemon_request ==
+				    SLIC_DUMP_IN_PROGRESS)) {
+				PRINT_ERROR
+				    ("ATK Diagnostic Trace Dump Requested but already in progress... ignore\n");
+			} else {
+				PRINT_ERROR
+				    ("ATK Diagnostic Trace Dump Requested\n");
+				tracemon_request = SLIC_DUMP_REQUESTED;
+				tracemon_request_type = value;
+				tracemon_timestamp = jiffies;
+			}
+			return 0;
+		}
+#endif
+	case SIOCETHTOOL:
+		ASSERT(adapter);
+		if (copy_from_user(&ecmd, rq->ifr_data, sizeof(ecmd)))
+			return -EFAULT;
+
+		if (ecmd.cmd == ETHTOOL_GSET) {
+			edata.supported = (SUPPORTED_10baseT_Half |
+					   SUPPORTED_10baseT_Full |
+					   SUPPORTED_100baseT_Half |
+					   SUPPORTED_100baseT_Full |
+					   SUPPORTED_Autoneg | SUPPORTED_MII);
+			edata.port = PORT_MII;
+			edata.transceiver = XCVR_INTERNAL;
+			edata.phy_address = 0;
+			if (adapter->linkspeed == LINK_100MB)
+				edata.speed = SPEED_100;
+			else if (adapter->linkspeed == LINK_10MB)
+				edata.speed = SPEED_10;
+			else
+				edata.speed = 0;
+
+			if (adapter->linkduplex == LINK_FULLD)
+				edata.duplex = DUPLEX_FULL;
+			else
+				edata.duplex = DUPLEX_HALF;
+
+			edata.autoneg = AUTONEG_ENABLE;
+			edata.maxtxpkt = 1;
+			edata.maxrxpkt = 1;
+			if (copy_to_user(rq->ifr_data, &edata, sizeof(edata)))
+				return -EFAULT;
+
+		} else if (ecmd.cmd == ETHTOOL_SSET) {
+			if (!capable(CAP_NET_ADMIN))
+				return -EPERM;
+
+			if (adapter->linkspeed == LINK_100MB)
+				edata.speed = SPEED_100;
+			else if (adapter->linkspeed == LINK_10MB)
+				edata.speed = SPEED_10;
+			else
+				edata.speed = 0;
+
+			if (adapter->linkduplex == LINK_FULLD)
+				edata.duplex = DUPLEX_FULL;
+			else
+				edata.duplex = DUPLEX_HALF;
+
+			edata.autoneg = AUTONEG_ENABLE;
+			edata.maxtxpkt = 1;
+			edata.maxrxpkt = 1;
+			if ((ecmd.speed != edata.speed) ||
+			    (ecmd.duplex != edata.duplex)) {
+				u32 speed;
+				u32 duplex;
+
+				if (ecmd.speed == SPEED_10)
+					speed = 0;
+				else
+					speed = PCR_SPEED_100;
+				if (ecmd.duplex == DUPLEX_FULL)
+					duplex = PCR_DUPLEX_FULL;
+				else
+					duplex = 0;
+				slic_link_config(adapter, speed, duplex);
+				slic_link_event_handler(adapter);
+			}
+		}
+		return 0;
+	default:
+		return -EOPNOTSUPP;
+	}
+}
+
+static void slic_config_pci(struct pci_dev *pcidev)
+{
+	u16 pci_command;
+	u16 new_command;
+
+	pci_read_config_word(pcidev, PCI_COMMAND, &pci_command);
+
+	new_command = pci_command | PCI_COMMAND_MASTER
+	    | PCI_COMMAND_MEMORY
+	    | PCI_COMMAND_INVALIDATE
+	    | PCI_COMMAND_PARITY | PCI_COMMAND_SERR | PCI_COMMAND_FAST_BACK;
+	if (pci_command != new_command)
+		pci_write_config_word(pcidev, PCI_COMMAND, new_command);
+}
+
+static int slic_card_init(struct sliccard *card, struct adapter *adapter)
+{
+	__iomem struct slic_regs *slic_regs = adapter->slic_regs;
+	struct slic_eeprom *peeprom;
+	struct oslic_eeprom *pOeeprom;
+	dma_addr_t phys_config;
+	u32 phys_configh;
+	u32 phys_configl;
+	u32 i = 0;
+	struct slic_shmem *pshmem;
+	int status;
+	uint macaddrs = card->card_size;
+	ushort eecodesize;
+	ushort dramsize;
+	ushort ee_chksum;
+	ushort calc_chksum;
+	struct slic_config_mac *pmac;
+	unsigned char fruformat;
+	unsigned char oemfruformat;
+	struct atk_fru *patkfru;
+	union oemfru *poemfru;
+
+	/* Reset everything except PCI configuration space */
+	slic_soft_reset(adapter);
+
+	/* Download the microcode */
+	status = slic_card_download(adapter);
+
+	if (status != 0) {
+		dev_err(&adapter->pcidev->dev,
+			"download failed bus %d slot %d\n",
+			adapter->busnumber, adapter->slotnumber);
+		return status;
+	}
+
+	if (!card->config_set) {
+		peeprom = pci_alloc_consistent(adapter->pcidev,
+					       sizeof(struct slic_eeprom),
+					       &phys_config);
+
+		phys_configl = SLIC_GET_ADDR_LOW(phys_config);
+		phys_configh = SLIC_GET_ADDR_HIGH(phys_config);
+
+		if (!peeprom) {
+			dev_err(&adapter->pcidev->dev,
+				"eeprom read failed to get memory "
+				"bus %d slot %d\n", adapter->busnumber,
+				adapter->slotnumber);
+			return -ENOMEM;
+		} else {
+			memset(peeprom, 0, sizeof(struct slic_eeprom));
+		}
+		slic_reg32_write(&slic_regs->slic_icr, ICR_INT_OFF, FLUSH);
+		mdelay(1);
+		pshmem = (struct slic_shmem *)adapter->phys_shmem;
+
+		spin_lock_irqsave(&adapter->bit64reglock.lock,
+					adapter->bit64reglock.flags);
+		slic_reg32_write(&slic_regs->slic_addr_upper, 0, DONT_FLUSH);
+		slic_reg32_write(&slic_regs->slic_isp,
+				 SLIC_GET_ADDR_LOW(&pshmem->isr), FLUSH);
+		spin_unlock_irqrestore(&adapter->bit64reglock.lock,
+					adapter->bit64reglock.flags);
+
+		slic_config_get(adapter, phys_configl, phys_configh);
+
+		for (;;) {
+			if (adapter->pshmem->isr) {
+				if (adapter->pshmem->isr & ISR_UPC) {
+					adapter->pshmem->isr = 0;
+					slic_reg64_write(adapter,
+						&slic_regs->slic_isp, 0,
+						&slic_regs->slic_addr_upper,
+						0, FLUSH);
+					slic_reg32_write(&slic_regs->slic_isr,
+							 0, FLUSH);
+
+					slic_upr_request_complete(adapter, 0);
+					break;
+				} else {
+					adapter->pshmem->isr = 0;
+					slic_reg32_write(&slic_regs->slic_isr,
+							 0, FLUSH);
+				}
+			} else {
+				mdelay(1);
+				i++;
+				if (i > 5000) {
+					dev_err(&adapter->pcidev->dev,
+						"%d config data fetch timed out!\n",
+						adapter->port);
+					slic_reg64_write(adapter,
+						&slic_regs->slic_isp, 0,
+						&slic_regs->slic_addr_upper,
+						0, FLUSH);
+					return -EINVAL;
+				}
+			}
+		}
+
+		switch (adapter->devid) {
+		/* Oasis card */
+		case SLIC_2GB_DEVICE_ID:
+			/* extract EEPROM data and pointers to EEPROM data */
+			pOeeprom = (struct oslic_eeprom *) peeprom;
+			eecodesize = pOeeprom->EecodeSize;
+			dramsize = pOeeprom->DramSize;
+			pmac = pOeeprom->MacInfo;
+			fruformat = pOeeprom->FruFormat;
+			patkfru = &pOeeprom->AtkFru;
+			oemfruformat = pOeeprom->OemFruFormat;
+			poemfru = &pOeeprom->OemFru;
+			macaddrs = 2;
+			/* Minor kludge for Oasis card
+			     get 2 MAC addresses from the
+			     EEPROM to ensure that function 1
+			     gets the Port 1 MAC address */
+			break;
+		default:
+			/* extract EEPROM data and pointers to EEPROM data */
+			eecodesize = peeprom->EecodeSize;
+			dramsize = peeprom->DramSize;
+			pmac = peeprom->u2.mac.MacInfo;
+			fruformat = peeprom->FruFormat;
+			patkfru = &peeprom->AtkFru;
+			oemfruformat = peeprom->OemFruFormat;
+			poemfru = &peeprom->OemFru;
+			break;
+		}
+
+		card->config.EepromValid = false;
+
+		/*  see if the EEPROM is valid by checking it's checksum */
+		if ((eecodesize <= MAX_EECODE_SIZE) &&
+		    (eecodesize >= MIN_EECODE_SIZE)) {
+
+			ee_chksum =
+			    *(u16 *) ((char *) peeprom + (eecodesize - 2));
+			/*
+			    calculate the EEPROM checksum
+			*/
+			calc_chksum =
+			    ~slic_eeprom_cksum((char *) peeprom,
+					       (eecodesize - 2));
+			/*
+			    if the ucdoe chksum flag bit worked,
+			    we wouldn't need this shit
+			*/
+			if (ee_chksum == calc_chksum)
+				card->config.EepromValid = true;
+		}
+		/*  copy in the DRAM size */
+		card->config.DramSize = dramsize;
+
+		/*  copy in the MAC address(es) */
+		for (i = 0; i < macaddrs; i++) {
+			memcpy(&card->config.MacInfo[i],
+			       &pmac[i], sizeof(struct slic_config_mac));
+		}
+
+		/*  copy the Alacritech FRU information */
+		card->config.FruFormat = fruformat;
+		memcpy(&card->config.AtkFru, patkfru,
+						sizeof(struct atk_fru));
+
+		pci_free_consistent(adapter->pcidev,
+				    sizeof(struct slic_eeprom),
+				    peeprom, phys_config);
+
+		if ((!card->config.EepromValid) &&
+		    (adapter->reg_params.fail_on_bad_eeprom)) {
+			slic_reg64_write(adapter, &slic_regs->slic_isp, 0,
+					 &slic_regs->slic_addr_upper,
+					 0, FLUSH);
+			dev_err(&adapter->pcidev->dev,
+				"unsupported CONFIGURATION EEPROM invalid\n");
+			return -EINVAL;
+		}
+
+		card->config_set = 1;
+	}
+
+	if (slic_card_download_gbrcv(adapter)) {
+		dev_err(&adapter->pcidev->dev,
+			"unable to download GB receive microcode\n");
+		return -EINVAL;
+	}
+
+	if (slic_global.dynamic_intagg)
+		slic_intagg_set(adapter, 0);
+	else
+		slic_intagg_set(adapter, intagg_delay);
+
+	/*
+	 *  Initialize ping status to "ok"
+	 */
+	card->pingstatus = ISR_PINGMASK;
+
+	/*
+	 * Lastly, mark our card state as up and return success
+	 */
+	card->state = CARD_UP;
+	card->reset_in_progress = 0;
+
+	return 0;
+}
+
+static void slic_init_driver(void)
+{
+	if (slic_first_init) {
+		slic_first_init = 0;
+		spin_lock_init(&slic_global.driver_lock.lock);
+		slic_debug_init();
+	}
+}
+
+static void slic_init_adapter(struct net_device *netdev,
+			      struct pci_dev *pcidev,
+			      const struct pci_device_id *pci_tbl_entry,
+			      void __iomem *memaddr, int chip_idx)
+{
+	ushort index;
+	struct slic_handle *pslic_handle;
+	struct adapter *adapter = netdev_priv(netdev);
+
+/*	adapter->pcidev = pcidev;*/
+	adapter->vendid = pci_tbl_entry->vendor;
+	adapter->devid = pci_tbl_entry->device;
+	adapter->subsysid = pci_tbl_entry->subdevice;
+	adapter->busnumber = pcidev->bus->number;
+	adapter->slotnumber = ((pcidev->devfn >> 3) & 0x1F);
+	adapter->functionnumber = (pcidev->devfn & 0x7);
+	adapter->memorylength = pci_resource_len(pcidev, 0);
+	adapter->slic_regs = (__iomem struct slic_regs *)memaddr;
+	adapter->irq = pcidev->irq;
+/*	adapter->netdev = netdev;*/
+	adapter->next_netdevice = head_netdevice;
+	head_netdevice = netdev;
+	adapter->chipid = chip_idx;
+	adapter->port = 0;	/*adapter->functionnumber;*/
+	adapter->cardindex = adapter->port;
+	adapter->memorybase = memaddr;
+	spin_lock_init(&adapter->upr_lock.lock);
+	spin_lock_init(&adapter->bit64reglock.lock);
+	spin_lock_init(&adapter->adapter_lock.lock);
+	spin_lock_init(&adapter->reset_lock.lock);
+	spin_lock_init(&adapter->handle_lock.lock);
+
+	adapter->card_size = 1;
+	/*
+	  Initialize slic_handle array
+	*/
+	ASSERT(SLIC_CMDQ_MAXCMDS <= 0xFFFF);
+	/*
+	 Start with 1.  0 is an invalid host handle.
+	*/
+	for (index = 1, pslic_handle = &adapter->slic_handles[1];
+	     index < SLIC_CMDQ_MAXCMDS; index++, pslic_handle++) {
+
+		pslic_handle->token.handle_index = index;
+		pslic_handle->type = SLIC_HANDLE_FREE;
+		pslic_handle->next = adapter->pfree_slic_handles;
+		adapter->pfree_slic_handles = pslic_handle;
+	}
+	adapter->pshmem = (struct slic_shmem *)
+					pci_alloc_consistent(adapter->pcidev,
+					sizeof(struct slic_shmem),
+					&adapter->
+					phys_shmem);
+	ASSERT(adapter->pshmem);
+
+	memset(adapter->pshmem, 0, sizeof(struct slic_shmem));
+
+	return;
+}
+
+static const struct net_device_ops slic_netdev_ops = {
+	.ndo_open		= slic_entry_open,
+	.ndo_stop		= slic_entry_halt,
+	.ndo_start_xmit		= slic_xmit_start,
+	.ndo_do_ioctl		= slic_ioctl,
+	.ndo_set_mac_address	= slic_mac_set_address,
+	.ndo_get_stats		= slic_get_stats,
+	.ndo_set_multicast_list	= slic_mcast_set_list,
+	.ndo_validate_addr	= eth_validate_addr,
+	.ndo_change_mtu		= eth_change_mtu,
+};
+
+static u32 slic_card_locate(struct adapter *adapter)
+{
+	struct sliccard *card = slic_global.slic_card;
+	struct physcard *physcard = slic_global.phys_card;
+	ushort card_hostid;
+	u16 __iomem *hostid_reg;
+	uint i;
+	uint rdhostid_offset = 0;
+
+	switch (adapter->devid) {
+	case SLIC_2GB_DEVICE_ID:
+		rdhostid_offset = SLIC_RDHOSTID_2GB;
+		break;
+	case SLIC_1GB_DEVICE_ID:
+		rdhostid_offset = SLIC_RDHOSTID_1GB;
+		break;
+	default:
+		ASSERT(0);
+		break;
+	}
+
+	hostid_reg =
+	    (u16 __iomem *) (((u8 __iomem *) (adapter->slic_regs)) +
+	    rdhostid_offset);
+
+	/* read the 16 bit hostid from SRAM */
+	card_hostid = (ushort) readw(hostid_reg);
+
+	/* Initialize a new card structure if need be */
+	if (card_hostid == SLIC_HOSTID_DEFAULT) {
+		card = kzalloc(sizeof(struct sliccard), GFP_KERNEL);
+		if (card == NULL)
+			return -ENOMEM;
+
+		card->next = slic_global.slic_card;
+		slic_global.slic_card = card;
+		card->busnumber = adapter->busnumber;
+		card->slotnumber = adapter->slotnumber;
+
+		/* Find an available cardnum */
+		for (i = 0; i < SLIC_MAX_CARDS; i++) {
+			if (slic_global.cardnuminuse[i] == 0) {
+				slic_global.cardnuminuse[i] = 1;
+				card->cardnum = i;
+				break;
+			}
+		}
+		slic_global.num_slic_cards++;
+
+		slic_debug_card_create(card);
+	} else {
+		/* Card exists, find the card this adapter belongs to */
+		while (card) {
+			if (card->cardnum == card_hostid)
+				break;
+			card = card->next;
+		}
+	}
+
+	ASSERT(card);
+	if (!card)
+		return -ENXIO;
+	/* Put the adapter in the card's adapter list */
+	ASSERT(card->adapter[adapter->port] == NULL);
+	if (!card->adapter[adapter->port]) {
+		card->adapter[adapter->port] = adapter;
+		adapter->card = card;
+	}
+
+	card->card_size = 1;	/* one port per *logical* card */
+
+	while (physcard) {
+		for (i = 0; i < SLIC_MAX_PORTS; i++) {
+			if (!physcard->adapter[i])
+				continue;
+			else
+				break;
+		}
+		ASSERT(i != SLIC_MAX_PORTS);
+		if (physcard->adapter[i]->slotnumber == adapter->slotnumber)
+			break;
+		physcard = physcard->next;
+	}
+	if (!physcard) {
+		/* no structure allocated for this physical card yet */
+		physcard = kzalloc(sizeof(struct physcard), GFP_ATOMIC);
+		ASSERT(physcard);
+
+		physcard->next = slic_global.phys_card;
+		slic_global.phys_card = physcard;
+		physcard->adapters_allocd = 1;
+	} else {
+		physcard->adapters_allocd++;
+	}
+	/* Note - this is ZERO relative */
+	adapter->physport = physcard->adapters_allocd - 1;
+
+	ASSERT(physcard->adapter[adapter->physport] == NULL);
+	physcard->adapter[adapter->physport] = adapter;
+	adapter->physcard = physcard;
+
+	return 0;
+}
+
+static int __devinit slic_entry_probe(struct pci_dev *pcidev,
+			       const struct pci_device_id *pci_tbl_entry)
+{
+	static int cards_found;
+	static int did_version;
+	int err = -ENODEV;
+	struct net_device *netdev;
+	struct adapter *adapter;
+	void __iomem *memmapped_ioaddr = NULL;
+	u32 status = 0;
+	ulong mmio_start = 0;
+	ulong mmio_len = 0;
+	struct sliccard *card = NULL;
+	int pci_using_dac = 0;
+
+	slic_global.dynamic_intagg = dynamic_intagg;
+
+	err = pci_enable_device(pcidev);
+
+	if (err)
+		return err;
+
+	if (slic_debug > 0 && did_version++ == 0) {
+		printk(KERN_DEBUG "%s\n", slic_banner);
+		printk(KERN_DEBUG "%s\n", slic_proc_version);
+	}
+
+	if (!pci_set_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+		pci_using_dac = 1;
+		if (pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(64))) {
+			dev_err(&pcidev->dev, "unable to obtain 64-bit DMA for "
+					"consistent allocations\n");
+			goto err_out_disable_pci;
+		}
+	} else if (pci_set_dma_mask(pcidev, DMA_BIT_MASK(32))) {
+		pci_using_dac = 0;
+		pci_set_consistent_dma_mask(pcidev, DMA_BIT_MASK(32));
+	} else {
+		dev_err(&pcidev->dev, "no usable DMA configuration\n");
+		goto err_out_disable_pci;
+	}
+
+	err = pci_request_regions(pcidev, DRV_NAME);
+	if (err) {
+		dev_err(&pcidev->dev, "can't obtain PCI resources\n");
+		goto err_out_disable_pci;
+	}
+
+	pci_set_master(pcidev);
+
+	netdev = alloc_etherdev(sizeof(struct adapter));
+	if (!netdev) {
+		err = -ENOMEM;
+		goto err_out_exit_slic_probe;
+	}
+
+	SET_NETDEV_DEV(netdev, &pcidev->dev);
+
+	pci_set_drvdata(pcidev, netdev);
+	adapter = netdev_priv(netdev);
+	adapter->netdev = netdev;
+	adapter->pcidev = pcidev;
+	if (pci_using_dac)
+		netdev->features |= NETIF_F_HIGHDMA;
+
+	mmio_start = pci_resource_start(pcidev, 0);
+	mmio_len = pci_resource_len(pcidev, 0);
+
+
+/*	memmapped_ioaddr =  (u32)ioremap_nocache(mmio_start, mmio_len);*/
+	memmapped_ioaddr = ioremap(mmio_start, mmio_len);
+	if (!memmapped_ioaddr) {
+		dev_err(&pcidev->dev, "cannot remap MMIO region %lx @ %lx\n",
+			mmio_len, mmio_start);
+		goto err_out_free_netdev;
+	}
+
+	slic_config_pci(pcidev);
+
+	slic_init_driver();
+
+	slic_init_adapter(netdev,
+			  pcidev, pci_tbl_entry, memmapped_ioaddr, cards_found);
+
+	status = slic_card_locate(adapter);
+	if (status) {
+		dev_err(&pcidev->dev, "cannot locate card\n");
+		goto err_out_free_mmio_region;
+	}
+
+	card = adapter->card;
+
+	if (!adapter->allocated) {
+		card->adapters_allocated++;
+		adapter->allocated = 1;
+	}
+
+	status = slic_card_init(card, adapter);
+
+	if (status != 0) {
+		card->state = CARD_FAIL;
+		adapter->state = ADAPT_FAIL;
+		adapter->linkstate = LINK_DOWN;
+		dev_err(&pcidev->dev, "FAILED status[%x]\n", status);
+	} else {
+		slic_adapter_set_hwaddr(adapter);
+	}
+
+	netdev->base_addr = (unsigned long)adapter->memorybase;
+	netdev->irq = adapter->irq;
+	netdev->netdev_ops = &slic_netdev_ops;
+
+	slic_debug_adapter_create(adapter);
+
+	strcpy(netdev->name, "eth%d");
+	err = register_netdev(netdev);
+	if (err) {
+		dev_err(&pcidev->dev, "Cannot register net device, aborting.\n");
+		goto err_out_unmap;
+	}
+
+	cards_found++;
+
+	return status;
+
+err_out_unmap:
+	iounmap(memmapped_ioaddr);
+err_out_free_mmio_region:
+	release_mem_region(mmio_start, mmio_len);
+err_out_free_netdev:
+	free_netdev(netdev);
+err_out_exit_slic_probe:
+	pci_release_regions(pcidev);
+err_out_disable_pci:
+	pci_disable_device(pcidev);
+	return err;
+}
 
 static struct pci_driver slic_driver = {
 	.name = DRV_NAME,
