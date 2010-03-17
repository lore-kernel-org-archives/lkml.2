Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755011Ab0CQOt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753606Ab0CQOtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:49:55 -0400
Date: Wed, 17 Mar 2010 16:43:50 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, Juan Quintela <quintela@redhat.com>,
       Unai Uribarri <unai.uribarri@optenet.com>, kvm@vger.kernel.org,
       virtualization@lists.osdl.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH] vhost: fix interrupt mitigation with raw sockets
Message-ID: <20100317144350.GB3984@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A thinko in code means we never trigger interrupt
mitigation. Fix this.

Reported-by: Juan Quintela <quintela@redhat.com>
Reported-by: Unai Uribarri <unai.uribarri@optenet.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---
 drivers/vhost/net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index fcafb6b..a6a88df 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -125,7 +125,7 @@ static void handle_tx(struct vhost_net *net)
 	mutex_lock(&vq->mutex);
 	vhost_disable_notify(vq);
 
-	if (wmem < sock->sk->sk_sndbuf * 2)
+	if (wmem < sock->sk->sk_sndbuf / 2)
 		tx_poll_stop(net);
 	hdr_size = vq->hdr_size;
 
-- 
1.7.0.18.g0d53a5
