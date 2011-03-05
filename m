Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760623Ab1CEBHq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:07:46 -0500
Received: from kroah.org ([198.145.64.141]:47704 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760604Ab1CEBFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:05:04 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 17:03:52 2011
Message-Id: <20110305010352.690887944@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 17:03:03 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>, maximilian attems <max@stro.at>
Subject: [09/18] virtio: set pci bus master enable bit
In-Reply-To: <20110305010410.GA18668@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


