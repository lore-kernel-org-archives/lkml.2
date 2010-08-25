Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab0HYU7M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 16:59:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:54325 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754239Ab0HYU7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 16:59:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=YQ+yvKN/Yxz0SfBCPqU03cOCUh4u7+SgCQSn1xwV4+n2tx1rnRPUFdI9T9QppNqGKr
         h8iaG3nQzGTGGVOUMX7w117kChuQwbU8B4alLI6Wftu0SrTEZxifOF4wzubZv1JVon/T
         ZLDjh5oyCz0p8vFS/+4w/YnLhM5nKAw6bRadQ=
From: Rotari Razvan-Gabriel <razvanrotari@gmail.com>
To: clemens@ladisch.de
Cc: stefanr@s5r6.in-berlin.de, gregkh@suse.de, tj@kernel.org,
        dbrownell@users.sourceforge.net, andre.goddard@gmail.com,
        jkosina@suse.cz, davem@davemloft.net, shemminger@vyatta.com,
        eric.dumazet@gmail.com, martin.petersen@oracle.com,
        jens.axboe@oracle.com, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Rotari Razvan-Gabriel <razvanrotari@gmail.com>
Subject: [PATCH] Drivers: firewire: Fixed coding style for all the files in the directory
Date: Wed, 25 Aug 2010 23:59:00 +0300
Message-Id: <1282769940-18492-1-git-send-email-razvanrotari@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style for all the filles in the directory

Signed-off-by: Rotari Razvan-Gabriel <razvanrotari@gmail.com>
---
 drivers/firewire/core-card.c        |   12 ++++----
 drivers/firewire/core-cdev.c        |   52 +++++++++++++++++++++++-----------
 drivers/firewire/core-device.c      |   32 +++++++++++++--------
 drivers/firewire/core-iso.c         |    4 +-
 drivers/firewire/core-topology.c    |    6 ++--
 drivers/firewire/core-transaction.c |   30 ++++++++++----------
 drivers/firewire/net.c              |   26 +++++++++---------
 drivers/firewire/ohci.c             |   26 +++++++++---------
 drivers/firewire/sbp2.c             |   30 ++++++++++----------
 9 files changed, 122 insertions(+), 96 deletions(-)

diff --git a/drivers/firewire/core-card.c b/drivers/firewire/core-card.c
index be04923..4f0312c 100644
--- a/drivers/firewire/core-card.c
+++ b/drivers/firewire/core-card.c
@@ -107,7 +107,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 	j = 7 + descriptor_count;

 	/* Generate root directory entries for descriptors. */
-	list_for_each_entry (desc, &descriptor_list, link) {
+	list_for_each_entry(desc, &descriptor_list, link) {
 		if (desc->immediate > 0)
 			config_rom[i++] = cpu_to_be32(desc->immediate);
 		config_rom[i] = cpu_to_be32(desc->key | (j - i));
@@ -119,7 +119,7 @@ static void generate_config_rom(struct fw_card *card, __be32 *config_rom)
 	config_rom[5] = cpu_to_be32((i - 5 - 1) << 16);

 	/* End of root directory, now copy in descriptors. */
-	list_for_each_entry (desc, &descriptor_list, link) {
+	list_for_each_entry(desc, &descriptor_list, link) {
 		for (k = 0; k < desc->length; k++)
 			config_rom[i + k] = cpu_to_be32(desc->data[k]);
 		i += desc->length;
@@ -139,7 +139,7 @@ static void update_config_roms(void)
 {
 	struct fw_card *card;

-	list_for_each_entry (card, &card_list, link) {
+	list_for_each_entry(card, &card_list, link) {
 		generate_config_rom(card, tmp_config_rom);
 		card->driver->set_config_rom(card, tmp_config_rom,
 					     config_rom_length);
@@ -439,7 +439,7 @@ static void bm_work(struct work_struct *work)
 		new_root_id = local_id;
 	}

- pick_me:
+pick_me:
 	/*
 	 * Pick a gap count from 1394a table E-1.  The table doesn't cover
 	 * the typically much larger 1394b beta repeater delays though.
@@ -487,9 +487,9 @@ static void bm_work(struct work_struct *work)
 	if (local_id == irm_id)
 		allocate_broadcast_channel(card, generation);

- out:
+out:
 	fw_node_put(root_node);
- out_put_card:
+didir-out_put_card:
 	fw_card_put(card);
 }

diff --git a/drivers/firewire/core-cdev.c b/drivers/firewire/core-cdev.c
index 14bb7b7..290c0c4 100644
--- a/drivers/firewire/core-cdev.c
+++ b/drivers/firewire/core-cdev.c
@@ -316,7 +316,7 @@ static int dequeue_event(struct client *client,
 	}
 	ret = total;

- out:
+out:
 	kfree(event);

 	return ret;
@@ -467,7 +467,7 @@ static int add_client_resource(struct client *client,
 	unsigned long flags;
 	int ret;

- retry:
+retry:
 	if (idr_pre_get(&client->resource_idr, gfp_mask) == 0)
 		return -ENOMEM;

@@ -623,7 +623,7 @@ static int init_request(struct client *client,
 			request->length, complete_transaction, e);
 	return 0;

- failed:
+failed:
 	kfree(e);

 	return ret;
@@ -748,7 +748,7 @@ static void handle_request(struct fw_card *card, struct fw_request *request,
 		    &e->req, event_size0, r->data, length);
 	return;

- failed:
+failed:
 	kfree(r);
 	kfree(e);
 	kfree(fcp_frame);
@@ -843,7 +843,7 @@ static int ioctl_send_response(struct client *client, union ioctl_arg *arg)
 		goto out;
 	}
 	fw_send_response(r->card, r->request, a->rcode);
- out:
+out:
 	fw_card_put(r->card);
 	kfree(r);

@@ -907,7 +907,7 @@ static int ioctl_add_descriptor(struct client *client, union ioctl_arg *arg)
 	a->handle = r->resource.handle;

 	return 0;
- failed:
+failed:
 	kfree(r);

 	return ret;
@@ -1179,9 +1179,15 @@ static int ioctl_get_cycle_timer2(struct client *client, union ioctl_arg *arg)
 	cycle_time = card->driver->read_csr(card, CSR_CYCLE_TIME);

 	switch (a->clk_id) {
-	case CLOCK_REALTIME:      getnstimeofday(&ts);                   break;
-	case CLOCK_MONOTONIC:     do_posix_clock_monotonic_gettime(&ts); break;
-	case CLOCK_MONOTONIC_RAW: getrawmonotonic(&ts);                  break;
+	case CLOCK_REALTIME:
+		getnstimeofday(&ts);
+		break;
+	case CLOCK_MONOTONIC:
+		do_posix_clock_monotonic_gettime(&ts);
+		break;
+	case CLOCK_MONOTONIC_RAW:
+		getrawmonotonic(&ts);
+		break;
 	default:
 		ret = -EINVAL;
 	}
@@ -1305,7 +1311,7 @@ static void iso_resource_work(struct work_struct *work)
 		kfree(r->e_dealloc);
 		kfree(r);
 	}
- out:
+out:
 	client_put(client);
 }

@@ -1368,7 +1374,7 @@ static int init_iso_resource(struct client *client,
 	request->handle = r->resource.handle;

 	return 0;
- fail:
+fail:
 	kfree(r);
 	kfree(e1);
 	kfree(e2);
@@ -1465,16 +1471,28 @@ static void outbound_phy_packet_callback(struct fw_packet *packet,

 	switch (status) {
 	/* expected: */
-	case ACK_COMPLETE:	e->phy_packet.rcode = RCODE_COMPLETE;	break;
+	case ACK_COMPLETE:
+		e->phy_packet.rcode = RCODE_COMPLETE;
+		break;
 	/* should never happen with PHY packets: */
-	case ACK_PENDING:	e->phy_packet.rcode = RCODE_COMPLETE;	break;
+	case ACK_PENDING:
+		e->phy_packet.rcode = RCODE_COMPLETE;
+		break;
 	case ACK_BUSY_X:
 	case ACK_BUSY_A:
-	case ACK_BUSY_B:	e->phy_packet.rcode = RCODE_BUSY;	break;
-	case ACK_DATA_ERROR:	e->phy_packet.rcode = RCODE_DATA_ERROR;	break;
-	case ACK_TYPE_ERROR:	e->phy_packet.rcode = RCODE_TYPE_ERROR;	break;
+	case ACK_BUSY_B:
+		e->phy_packet.rcode = RCODE_BUSY;
+		break;
+	case ACK_DATA_ERROR:
+		e->phy_packet.rcode = RCODE_DATA_ERROR;
+		break;
+	case ACK_TYPE_ERROR:
+		e->phy_packet.rcode = RCODE_TYPE_ERROR;
+		break;
 	/* stale generation; cancelled; on certain controllers: no ack */
-	default:		e->phy_packet.rcode = status;		break;
+	default:
+		e->phy_packet.rcode = status;
+		break;
 	}
 	e->phy_packet.data[0] = packet->timestamp;

diff --git a/drivers/firewire/core-device.c b/drivers/firewire/core-device.c
index 6113b89..5506749 100644
--- a/drivers/firewire/core-device.c
+++ b/drivers/firewire/core-device.c
@@ -135,10 +135,18 @@ static void get_ids(const u32 *directory, int *id)
 	fw_csr_iterator_init(&ci, directory);
 	while (fw_csr_iterator_next(&ci, &key, &value)) {
 		switch (key) {
-		case CSR_VENDOR:	id[0] = value; break;
-		case CSR_MODEL:		id[1] = value; break;
-		case CSR_SPECIFIER_ID:	id[2] = value; break;
-		case CSR_VERSION:	id[3] = value; break;
+		case CSR_VENDOR:
+			id[0] = value;
+			break;
+		case CSR_MODEL:
+			id[1] = value;
+			break;
+		case CSR_SPECIFIER_ID:
+			id[2] = value;
+			break;
+		case CSR_VERSION:
+			id[3] = value;
+			break;
 		}
 	}
 }
@@ -626,7 +634,7 @@ static int read_config_rom(struct fw_device *device, int generation)
 	device->max_rec	= rom[2] >> 12 & 0xf;
 	device->cmc	= rom[2] >> 30 & 1;
 	device->irmc	= rom[2] >> 31 & 1;
- out:
+out:
 	kfree(rom);

 	return ret;
@@ -689,7 +697,7 @@ static void create_units(struct fw_device *device)

 		continue;

-	skip_unit:
+skip_unit:
 		kfree(unit);
 	}
 }
@@ -1047,11 +1055,11 @@ static void fw_device_init(struct work_struct *work)

 	return;

- error_with_cdev:
+error_with_cdev:
 	down_write(&fw_device_rwsem);
 	idr_remove(&fw_device_idr, minor);
 	up_write(&fw_device_rwsem);
- error:
+error:
 	fw_device_put(device);		/* fw_device_idr's reference */

 	put_device(&device->device);	/* our reference */
@@ -1151,13 +1159,13 @@ static void fw_device_refresh(struct work_struct *work)
 	device->config_rom_retries = 0;
 	goto out;

- give_up:
+give_up:
 	fw_notify("giving up on refresh of device %s\n", dev_name(&device->device));
- gone:
+gone:
 	atomic_set(&device->state, FW_DEVICE_GONE);
 	PREPARE_DELAYED_WORK(&device->work, fw_device_shutdown);
 	schedule_delayed_work(&device->work, SHUTDOWN_DELAY);
- out:
+out:
 	if (node_id == card->root_node->node_id)
 		fw_schedule_bm_work(card, 0);
 }
@@ -1171,7 +1179,7 @@ void fw_node_event(struct fw_card *card, struct fw_node *node, int event)
 	case FW_NODE_LINK_ON:
 		if (!node->link_on)
 			break;
- create:
+create:
 		device = kzalloc(sizeof(*device), GFP_ATOMIC);
 		if (device == NULL)
 			break;
diff --git a/drivers/firewire/core-iso.c b/drivers/firewire/core-iso.c
index c003fa4..c2296b2 100644
--- a/drivers/firewire/core-iso.c
+++ b/drivers/firewire/core-iso.c
@@ -68,7 +68,7 @@ int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,

 	return 0;

- out_pages:
+out_pages:
 	for (j = 0; j < i; j++) {
 		address = page_private(buffer->pages[j]);
 		dma_unmap_page(card->device, address,
@@ -76,7 +76,7 @@ int fw_iso_buffer_init(struct fw_iso_buffer *buffer, struct fw_card *card,
 		__free_page(buffer->pages[j]);
 	}
 	kfree(buffer->pages);
- out:
+out:
 	buffer->pages = NULL;

 	return -ENOMEM;
diff --git a/drivers/firewire/core-topology.c b/drivers/firewire/core-topology.c
index 09be1a6..7649ab4 100644
--- a/drivers/firewire/core-topology.c
+++ b/drivers/firewire/core-topology.c
@@ -319,9 +319,9 @@ static struct fw_node *build_tree(struct fw_card *card,
 	return local_node;
 }

-typedef void (*fw_node_callback_t)(struct fw_card * card,
-				   struct fw_node * node,
-				   struct fw_node * parent);
+typedef void (*fw_node_callback_t)(struct fw_card *card,
+				   struct fw_node *node,
+				   struct fw_node *parent);

 static void for_each_fw_node(struct fw_card *card, struct fw_node *root,
 			     fw_node_callback_t callback)
diff --git a/drivers/firewire/core-transaction.c b/drivers/firewire/core-transaction.c
index ca7ca56..311f1d6 100644
--- a/drivers/firewire/core-transaction.c
+++ b/drivers/firewire/core-transaction.c
@@ -248,7 +248,7 @@ static void fw_fill_request(struct fw_packet *packet, int tcode, int tlabel,
 	default:
 		WARN(1, "wrong tcode %d", tcode);
 	}
- common:
+common:
 	packet->speed = speed;
 	packet->generation = generation;
 	packet->ack = 0;
@@ -495,20 +495,20 @@ static struct fw_address_handler *lookup_enclosing_address_handler(
 static DEFINE_SPINLOCK(address_handler_lock);
 static LIST_HEAD(address_handler_list);

-const struct fw_address_region fw_high_memory_region =
-	{ .start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
+const struct fw_address_region fw_high_memory_region = {
+	.start = 0x000100000000ULL, .end = 0xffffe0000000ULL,  };
 EXPORT_SYMBOL(fw_high_memory_region);

 #if 0
-const struct fw_address_region fw_low_memory_region =
-	{ .start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
-const struct fw_address_region fw_private_region =
-	{ .start = 0xffffe0000000ULL, .end = 0xfffff0000000ULL,  };
-const struct fw_address_region fw_csr_region =
-	{ .start = CSR_REGISTER_BASE,
+const struct fw_address_region fw_low_memory_region = {
+	.start = 0x000000000000ULL, .end = 0x000100000000ULL,  };
+const struct fw_address_region fw_private_region = {
+	.start = 0xffffe0000000ULL, .end = 0xfffff0000000ULL,  };
+const struct fw_address_region fw_csr_region = {
+	.start = CSR_REGISTER_BASE,
 	  .end   = CSR_REGISTER_BASE | CSR_CONFIG_ROM_END,  };
-const struct fw_address_region fw_unit_space_region =
-	{ .start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
+const struct fw_address_region fw_unit_space_region = {
+	.start = 0xfffff0000900ULL, .end = 0x1000000000000ULL, };
 #endif  /*  0  */

 static bool is_in_fcp_region(u64 offset, size_t length)
@@ -975,8 +975,8 @@ void fw_core_handle_response(struct fw_card *card, struct fw_packet *p)
 }
 EXPORT_SYMBOL(fw_core_handle_response);

-static const struct fw_address_region topology_map_region =
-	{ .start = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP,
+static const struct fw_address_region topology_map_region = {
+	.start = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP,
 	  .end   = CSR_REGISTER_BASE | CSR_TOPOLOGY_MAP_END, };

 static void handle_topology_map(struct fw_card *card, struct fw_request *request,
@@ -1007,8 +1007,8 @@ static struct fw_address_handler topology_map = {
 	.address_callback	= handle_topology_map,
 };

-static const struct fw_address_region registers_region =
-	{ .start = CSR_REGISTER_BASE,
+static const struct fw_address_region registers_region = {
+	  .start = CSR_REGISTER_BASE,
 	  .end   = CSR_REGISTER_BASE | CSR_CONFIG_ROM, };

 static void update_split_timeout(struct fw_card *card)
diff --git a/drivers/firewire/net.c b/drivers/firewire/net.c
index da17d40..30d0caf 100644
--- a/drivers/firewire/net.c
+++ b/drivers/firewire/net.c
@@ -656,7 +656,7 @@ static int fwnet_finish_incoming_packet(struct net_device *net,

 	return 0;

- failed_proto:
+failed_proto:
 	net->stats.rx_errors++;
 	net->stats.rx_dropped++;

@@ -795,7 +795,7 @@ static int fwnet_incoming_packet(struct fwnet_device *dev, __be32 *buf, int len,

 	return 0;

- bad_proto:
+bad_proto:
 	spin_unlock_irqrestore(&dev->lock, flags);

 	if (netif_queue_stopped(net))
@@ -1011,7 +1011,7 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)

 	default:
 		BUG();
-	}
+}
 	if (ptask->dest_node == IEEE1394_ALL_NODES) {
 		u8 *p;
 		int generation;
@@ -1062,7 +1062,7 @@ static int fwnet_send_packet(struct fwnet_packet_task *ptask)
 	spin_unlock_irqrestore(&dev->lock, flags);

 	dev->netdev->trans_start = jiffies;
- out:
+out:
 	if (free)
 		fwnet_free_ptask(ptask);

@@ -1168,17 +1168,17 @@ static int fwnet_broadcast_start(struct fwnet_device *dev)

 	return 0;

- failed_rcv_queue:
+failed_rcv_queue:
 	kfree(dev->broadcast_rcv_buffer_ptrs);
 	dev->broadcast_rcv_buffer_ptrs = NULL;
- failed_ptrs_alloc:
+failed_ptrs_alloc:
 	fw_iso_buffer_destroy(&dev->broadcast_rcv_buffer, dev->card);
- failed_buffer_init:
+failed_buffer_init:
 	fw_iso_context_destroy(context);
 	dev->broadcast_rcv_context = NULL;
- failed_context_create:
+failed_context_create:
 	fw_core_remove_address_handler(&dev->handler);
- failed_initial:
+failed_initial:
 	dev->local_fifo = FWNET_NO_FIFO_ADDR;

 	return retval;
@@ -1328,9 +1328,9 @@ static netdev_tx_t fwnet_tx(struct sk_buff *skb, struct net_device *net)

 	return NETDEV_TX_OK;

- fail_unlock:
+fail_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
- fail:
+fail:
 	if (ptask)
 		kmem_cache_free(fwnet_packet_task_cache, ptask);

@@ -1499,13 +1499,13 @@ static int fwnet_probe(struct device *_dev)
 	list_add_tail(&dev->dev_link, &fwnet_device_list);
 	fw_notify("%s: IPv4 over FireWire on device %016llx\n",
 		  net->name, (unsigned long long)card->guid);
- have_dev:
+have_dev:
 	ret = fwnet_add_peer(dev, unit, device);
 	if (ret && allocated_netdev) {
 		unregister_netdev(net);
 		list_del(&dev->dev_link);
 	}
- out:
+out:
 	if (ret && allocated_netdev)
 		free_netdev(net);

diff --git a/drivers/firewire/ohci.c b/drivers/firewire/ohci.c
index 7f03540..e53bf6a 100644
--- a/drivers/firewire/ohci.c
+++ b/drivers/firewire/ohci.c
@@ -328,7 +328,7 @@ static void log_irqs(u32 evt)
 }

 static const char *speed[] = {
-	[0] = "S100", [1] = "S200", [2] = "S400",    [3] = "beta",
+	[0] = "S100", [1] = "S200", [2] = "S400", [3] = "beta",
 };
 static const char *power[] = {
 	[0] = "+0W",  [1] = "+15W", [2] = "+30W",    [3] = "+45W",
@@ -651,7 +651,7 @@ static __le32 *handle_ar_packet(struct ar_context *ctx, __le32 *buffer)
 		p.payload_length = 0;
 		break;

-	case TCODE_READ_BLOCK_REQUEST :
+	case TCODE_READ_BLOCK_REQUEST:
 		p.header[3] = cond_le32_to_cpu(buffer[3]);
 		p.header_length = 16;
 		p.payload_length = 0;
@@ -1297,7 +1297,7 @@ static void handle_local_lock(struct fw_ohci *ohci,
 	fw_error("swap not done (CSR lock timeout)\n");
 	fw_fill_response(&response, packet->header, RCODE_BUSY, NULL, 0);

- out:
+out:
 	fw_core_handle_response(&ohci->card, &response);
 }

@@ -2013,7 +2013,7 @@ static int ohci_cancel_packet(struct fw_card *card, struct fw_packet *packet)
 	packet->ack = RCODE_CANCELLED;
 	packet->callback(packet, &ohci->card, packet->ack);
 	ret = 0;
- out:
+out:
 	tasklet_enable(&ctx->tasklet);

 	return ret;
@@ -2053,7 +2053,7 @@ static int ohci_enable_phys_dma(struct fw_card *card,
 		reg_write(ohci, OHCI1394_PhyReqFilterHiSet, 1 << (n - 32));

 	flush_writes(ohci);
- out:
+out:
 	spin_unlock_irqrestore(&ohci->lock, flags);

 	return ret;
@@ -2370,9 +2370,9 @@ static struct fw_iso_context *ohci_allocate_iso_context(struct fw_card *card,

 	return &ctx->base;

- out_with_header:
+out_with_header:
 	free_page((unsigned long)ctx->header);
- out:
+out:
 	spin_lock_irqsave(&ohci->lock, flags);

 	switch (type) {
@@ -2962,10 +2962,10 @@ static int __devinit pci_probe(struct pci_dev *dev,

 	return 0;

- fail_self_id:
+fail_self_id:
 	dma_free_coherent(ohci->card.device, SELF_ID_BUF_SIZE,
 			  ohci->self_id_cpu, ohci->self_id_bus);
- fail_contexts:
+fail_contexts:
 	kfree(ohci->ir_context_list);
 	kfree(ohci->it_context_list);
 	context_release(&ohci->at_response_ctx);
@@ -2973,14 +2973,14 @@ static int __devinit pci_probe(struct pci_dev *dev,
 	ar_context_release(&ohci->ar_response_ctx);
 	ar_context_release(&ohci->ar_request_ctx);
 	pci_iounmap(dev, ohci->registers);
- fail_iomem:
+fail_iomem:
 	pci_release_region(dev, 0);
- fail_disable:
+fail_disable:
 	pci_disable_device(dev);
- fail_free:
+fail_free:
 	kfree(&ohci->card);
 	pmac_ohci_off(dev);
- fail:
+fail:
 	if (err == -ENOMEM)
 		fw_error("Out of memory\n");

diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 9f76171..657f6a0 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -262,7 +262,7 @@ struct sbp2_orb {
 	dma_addr_t request_bus;
 	int rcode;
 	struct sbp2_pointer pointer;
-	void (*callback)(struct sbp2_orb * orb, struct sbp2_status * status);
+	void (*callback)(struct sbp2_orb *orb, struct sbp2_status *status);
 	struct list_head link;
 };

@@ -321,7 +321,7 @@ struct sbp2_command_orb {
 	dma_addr_t page_table_bus;
 };

-#define SBP2_ROM_VALUE_WILDCARD ~0         /* match all */
+#define SBP2_ROM_VALUE_WILDCARD (~0)       /* match all */
 #define SBP2_ROM_VALUE_MISSING  0xff000000 /* not present in the unit dir. */

 /*
@@ -630,13 +630,13 @@ static int sbp2_send_management_orb(struct sbp2_logical_unit *lu, int node_id,
 	}

 	retval = 0;
- out:
+out:
 	dma_unmap_single(device->card->device, orb->base.request_bus,
 			 sizeof(orb->request), DMA_TO_DEVICE);
- fail_mapping_request:
+fail_mapping_request:
 	dma_unmap_single(device->card->device, orb->response_bus,
 			 sizeof(orb->response), DMA_FROM_DEVICE);
- fail_mapping_response:
+fail_mapping_response:
 	if (response)
 		memcpy(response, orb->response, sizeof(orb->response));
 	kref_put(&orb->base.kref, free_orb);
@@ -963,7 +963,7 @@ static void sbp2_login(struct work_struct *work)
 	sbp2_allow_block(lu);
 	goto out;

- out_logout_login:
+out_logout_login:
 	smp_rmb(); /* generation may have changed */
 	generation = device->generation;
 	smp_rmb(); /* node_id must not be older than generation */
@@ -975,7 +975,7 @@ static void sbp2_login(struct work_struct *work)
 	 * lu->work already.  Reset the work from reconnect to login.
 	 */
 	PREPARE_DELAYED_WORK(&lu->work, sbp2_login);
- out:
+out:
 	sbp2_target_put(tgt);
 }

@@ -1115,7 +1115,7 @@ static void sbp2_init_workarounds(struct sbp2_target *tgt, u32 model,
 		w |= sbp2_workarounds_table[i].workarounds;
 		break;
 	}
- out:
+out:
 	if (w)
 		fw_notify("Workarounds for %s: 0x%x "
 			  "(firmware_revision 0x%06x, model_id 0x%06x)\n",
@@ -1189,11 +1189,11 @@ static int sbp2_probe(struct device *dev)
 		sbp2_queue_work(lu, DIV_ROUND_UP(HZ, 5));
 	return 0;

- fail_tgt_put:
+fail_tgt_put:
 	sbp2_target_put(tgt);
 	return -ENOMEM;

- fail_shost_put:
+fail_shost_put:
 	scsi_host_put(shost);
 	return -ENOMEM;
 }
@@ -1255,7 +1255,7 @@ static void sbp2_reconnect(struct work_struct *work)
 	sbp2_agent_reset(lu);
 	sbp2_cancel_orbs(lu);
 	sbp2_conditionally_unblock(lu);
- out:
+out:
 	sbp2_target_put(tgt);
 }

@@ -1380,7 +1380,7 @@ static void complete_command_orb(struct sbp2_orb *base_orb,

 		if (result == DID_OK << 16 && STATUS_GET_LEN(*status) > 1)
 			result = sbp2_status_to_sense_data(STATUS_GET_DATA(*status),
-							   orb->cmd->sense_buffer);
+						orb->cmd->sense_buffer);
 	} else {
 		/*
 		 * If the orb completes with status == NULL, something
@@ -1452,10 +1452,10 @@ static int sbp2_map_scatterlist(struct sbp2_command_orb *orb,

 	return 0;

- fail_page_table:
+fail_page_table:
 	dma_unmap_sg(device->card->device, scsi_sglist(orb->cmd),
 		     scsi_sg_count(orb->cmd), orb->cmd->sc_data_direction);
- fail:
+fail:
 	return -ENOMEM;
 }

@@ -1522,7 +1522,7 @@ static int sbp2_scsi_queuecommand(struct scsi_cmnd *cmd, scsi_done_fn_t done)
 	sbp2_send_orb(&orb->base, lu, lu->tgt->node_id, generation,
 		      lu->command_block_agent_address + SBP2_ORB_POINTER);
 	retval = 0;
- out:
+out:
 	kref_put(&orb->base.kref, free_orb);
 	return retval;
 }
--
1.7.0.4

