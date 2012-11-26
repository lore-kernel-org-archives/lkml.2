Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934071Ab2KZRZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:25:34 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48176 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933941Ab2KZROr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:14:47 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 238/270] vhost: fix mergeable bufs on BE hosts
Date: Mon, 26 Nov 2012 14:58:48 -0200
Message-Id: <1353949160-26803-239-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Michael S. Tsirkin" <mst@redhat.com>

commit 910a578f7e9400a78a3b13aba0b4d2df16a2cb05 upstream.

We copy head count to a 16 bit field, this works by chance on LE but on
BE guest gets 0. Fix it up.

Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Tested-by: Alexander Graf <agraf@suse.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/vhost/net.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index f82a739..3c4dcc3d9 100644
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
-- 
1.7.9.5

