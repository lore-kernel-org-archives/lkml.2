Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756678Ab2J1Xn5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:43:57 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41958 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756327Ab2J1X1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:30 -0400
Message-Id: <20121028231601.505603893@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:16:55 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        "Michael S. Tsirkin" <mst@redhat.com>, Alexander Graf <agraf@suse.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [ 079/105] vhost: fix mergeable bufs on BE hosts
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 910a578f7e9400a78a3b13aba0b4d2df16a2cb05 upstream.

We copy head count to a 16 bit field, this works by chance on LE but on
BE guest gets 0. Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 072cbba..7f93f34 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -379,7 +379,8 @@ static void handle_rx(struct vhost_net *net)
 		.hdr.gso_type = VIRTIO_NET_HDR_GSO_NONE
 	};
 	size_t total_len = 0;
-	int err, headcount, mergeable;
+	int err, mergeable;
+	s16 headcount;
 	size_t vhost_hlen, sock_hlen;
 	size_t vhost_len, sock_len;
 	/* TODO: check that we are running from vhost_worker? */


