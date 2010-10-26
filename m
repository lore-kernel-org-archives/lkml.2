Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759436Ab0JZKSU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 06:18:20 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:60747 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752695Ab0JZKSS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 06:18:18 -0400
From: Julia Lawall <julia@diku.dk>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: kernel-janitors@vger.kernel.org, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/14] drivers/vhost/vhost.c: delete double assignment
Date: Tue, 26 Oct 2010 12:25:32 +0200
Message-Id: <1288088743-3725-4-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1288088743-3725-1-git-send-email-julia@diku.dk>
References: <1288088743-3725-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Delete successive assignments to the same location.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
expression i;
@@

*i = ...;
 i = ...;
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/vhost/vhost.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 94701ff..ed27727 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -157,7 +157,6 @@ static void vhost_vq_reset(struct vhost_dev *dev,
 	vq->avail_idx = 0;
 	vq->last_used_idx = 0;
 	vq->used_flags = 0;
-	vq->used_flags = 0;
 	vq->log_used = false;
 	vq->log_addr = -1ull;
 	vq->vhost_hlen = 0;

