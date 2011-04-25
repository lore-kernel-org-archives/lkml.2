Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1DYUYa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:24:30 -0400
Received: from 1wt.eu ([62.212.114.60]:34087 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185Ab1DYUY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:24:27 -0400
Message-Id: <20110425200235.861135871@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:38 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: "Michael S. Tsirkin" <mst@redhat.com>, maximilian attems <max@stro.at>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 066/173] virtio: set pci bus master enable bit
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Michael S. Tsirkin <mst@redhat.com>

commit bc505f373979692d51a86d40925f77a8b09d17b9 upstream.

As all virtio devices perform DMA, we
must enable bus mastering for them to be
spec compliant.

This patch fixes hotplug of virtio devices
with Linux guests and qemu 0.11-0.12.

Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Cc: maximilian attems <max@stro.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/virtio/virtio_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/virtio/virtio_pci.c
+++ b/drivers/virtio/virtio_pci.c
@@ -647,6 +647,7 @@ static int __devinit virtio_pci_probe(st
 		goto out_req_regions;
 
 	pci_set_drvdata(pci_dev, vp_dev);
+	pci_set_master(pci_dev);
 
 	/* we use the subsystem vendor/device id as the virtio vendor/device
 	 * id.  this allows us to use the same PCI vendor/device id for all


