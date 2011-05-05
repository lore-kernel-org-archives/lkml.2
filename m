Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754896Ab1EEPJL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 11:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14807 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510Ab1EEPJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 11:09:07 -0400
Date: Thu, 5 May 2011 18:08:04 +0300
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
Subject: [PATCH 1/3] virtio: fix avail event support
Message-ID: <1d1d5b1a8d5326dae23685587e6ab84fc6b7177e.1304605816.git.mst@redhat.com>
References: <cover.1304605816.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1304605816.git.mst@redhat.com>
X-Mutt-Fcc: =sent
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make valid flag false, not true, on overrun

Reported-by: Tom Lendacky <tahm@linux.vnet.ibm.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/virtio/virtio_ring.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
index 57bf9d5..0ea0781 100644
--- a/drivers/virtio/virtio_ring.c
+++ b/drivers/virtio/virtio_ring.c
@@ -242,7 +242,7 @@ add_head:
 	 * kicked_avail index we stored. TODO: make sure all drivers
 	 * kick at least once in 2^16 and remove this. */
 	if (unlikely(vq->vring.avail->idx == vq->kicked_avail))
-		vq->kicked_avail_valid = true;
+		vq->kicked_avail_valid = false;
 
 	pr_debug("Added buffer head %i to %p\n", head, vq);
 	END_USE(vq);
-- 
1.7.5.53.gc233e

