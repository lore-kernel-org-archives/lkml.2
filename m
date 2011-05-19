Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933654Ab1ESXMA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:12:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64802 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933242Ab1ESXL4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:11:56 -0400
Date: Fri, 20 May 2011 02:11:23 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Rusty Russell <rusty@rustcorp.com.au>, Carsten Otte <cotte@de.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>, linux390@de.ibm.com,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Shirley Ma <xma@us.ibm.com>, lguest@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, kvm@vger.kernel.org,
        Krishna Kumar <krkumar2@in.ibm.com>,
        Tom Lendacky <tahm@linux.vnet.ibm.com>, steved@us.ibm.com,
        habanero@linux.vnet.ibm.com
Subject: [PATCHv2 07/14] virtio_net: delay TX callbacks
Message-ID: <f45a523e3950699ea1dcb918b558ad8fc389f3c7.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ask for delayed callbacks on TX ring full, to give the
other side more of a chance to make progress.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/net/virtio_net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 0cb0b06..f685324 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -609,7 +609,7 @@ static netdev_tx_t start_xmit(struct sk_buff *skb, struct net_device *dev)
 	 * before it gets out of hand.  Naturally, this wastes entries. */
 	if (capacity < 2+MAX_SKB_FRAGS) {
 		netif_stop_queue(dev);
-		if (unlikely(!virtqueue_enable_cb(vi->svq))) {
+		if (unlikely(!virtqueue_enable_cb_delayed(vi->svq))) {
 			/* More just got used, free them then recheck. */
 			capacity += free_old_xmit_skbs(vi);
 			if (capacity >= 2+MAX_SKB_FRAGS) {
-- 
1.7.5.53.gc233e

