Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab2LCR3G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 12:29:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:7765 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab2LCR3D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 12:29:03 -0500
Date: Mon, 3 Dec 2012 19:31:51 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: davem@davemloft.net
Cc: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-net: initialize zcopy packet counters
Message-ID: <20121203173151.GA30949@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These packet counters are used to drive the zercopy
selection heuristic so nothing too bad happens if they are off a bit -
and they are also reset once in a while.
But it's cleaner to clear them when backend is set so that
we start in a known state.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 67898fa..ff6c9199 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -823,6 +823,9 @@ static long vhost_net_set_backend(struct vhost_net *n, unsigned index, int fd)
 		r = vhost_init_used(vq);
 		if (r)
 			goto err_vq;
+
+		n->tx_packets = 0;
+		n->tx_zcopy_err = 0;
 	}
 
 	mutex_unlock(&vq->mutex);
-- 
MST
