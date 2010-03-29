Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713Ab0C2ScG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:32:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52536 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751441Ab0C2ScD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:32:03 -0400
Subject: [PATCH next-next-2.6] virtio_net: missing sg_init_table
From: Shirley Ma <mashirle@us.ibm.com>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Thomas =?ISO-8859-1?Q?M=FCller?= <thomas@mathtm.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 29 Mar 2010 11:31:58 -0700
Message-ID: <1269887518.13277.13.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add missing sg_init_table for sg_set_buf in virtio_net.

Reported-by: Thomas Müller <thomas@mathtm.de>
Signed-off-by: Shirley Ma <xma@us.ibm.com>

---
 drivers/net/virtio_net.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
index 25dc77c..3f5be35 100644
--- a/drivers/net/virtio_net.c
+++ b/drivers/net/virtio_net.c
@@ -326,6 +326,7 @@ static int add_recvbuf_small(struct virtnet_info *vi, gfp_t gfp)
 	struct scatterlist sg[2];
 	int err;
 
+	sg_init_table(sg, 2);
 	skb = netdev_alloc_skb_ip_align(vi->dev, MAX_PACKET_LEN);
 	if (unlikely(!skb))
 		return -ENOMEM;
@@ -351,6 +352,7 @@ static int add_recvbuf_big(struct virtnet_info *vi, gfp_t gfp)
 	char *p;
 	int i, err, offset;
 
+	sg_init_table(sg, MAX_SKB_FRAGS + 2);
 	/* page in sg[MAX_SKB_FRAGS + 1] is list tail */
 	for (i = MAX_SKB_FRAGS + 1; i > 1; --i) {
 		first = get_a_page(vi, gfp);


