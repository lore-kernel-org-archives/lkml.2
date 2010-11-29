Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753230Ab0K2FrU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 00:47:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17747 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752107Ab0K2FrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 00:47:18 -0500
Subject: [PATCH] vhost: fix typos in comment
To: virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org, mst@redhat.com
From: Jason Wang <jasowang@redhat.com>
Date: Mon, 29 Nov 2010 13:48:40 +0800
Message-ID: <20101129054840.24951.29849.stgit@dhcp-91-7.nay.redhat.com.englab.nay.redhat.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Jason Wang <jasowang@redhat.com>
---
 drivers/vhost/net.c   |    2 +-
 drivers/vhost/vhost.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index d10da28..14fc189 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -452,7 +452,7 @@ static void handle_rx_mergeable(struct vhost_net *net)
 			move_iovec_hdr(vq->iov, vq->hdr, vhost_hlen, in);
 		else
 			/* Copy the header for use in VIRTIO_NET_F_MRG_RXBUF:
-			 * needed because sendmsg can modify msg_iov. */
+			 * needed because recvmsg can modify msg_iov. */
 			copy_iovec_hdr(vq->iov, vq->hdr, sock_hlen, in);
 		msg.msg_iovlen = in;
 		err = sock->ops->recvmsg(NULL, sock, &msg,
diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
index 073d06a..2af44b7 100644
--- a/drivers/vhost/vhost.h
+++ b/drivers/vhost/vhost.h
@@ -102,7 +102,7 @@ struct vhost_virtqueue {
 	 * flush the vhost_work instead of synchronize_rcu. Therefore readers do
 	 * not need to call rcu_read_lock/rcu_read_unlock: the beginning of
 	 * vhost_work execution acts instead of rcu_read_lock() and the end of
-	 * vhost_work execution acts instead of rcu_read_lock().
+	 * vhost_work execution acts instead of rcu_read_unlock().
 	 * Writers use virtqueue mutex. */
 	void __rcu *private_data;
 	/* Log write descriptors */

