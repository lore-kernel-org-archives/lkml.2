Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757160Ab0IRTQJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:16:09 -0400
Received: from kroah.org ([198.145.64.141]:43772 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757095Ab0IRTQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:16:06 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:05 2010
Message-Id: <20100918191305.735125567@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:13:16 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <rolandd@cisco.com>
Subject: [098/129] RDMA/cxgb3: Dont exceed the max HW CQ depth
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit dc4e96ce2dceb649224ee84f83592aac8c54c9b7 upstream.

The max depth supported by T3 is 64K entries.  This fixes a bug
introduced in commit 9918b28d ("RDMA/cxgb3: Increase the max CQ
depth") that causes stalls and possibly crashes in large MPI clusters.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/cxgb3/cxio_hal.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/infiniband/hw/cxgb3/cxio_hal.h
+++ b/drivers/infiniband/hw/cxgb3/cxio_hal.h
@@ -53,7 +53,7 @@
 #define T3_MAX_PBL_SIZE 256
 #define T3_MAX_RQ_SIZE 1024
 #define T3_MAX_QP_DEPTH (T3_MAX_RQ_SIZE-1)
-#define T3_MAX_CQ_DEPTH 262144
+#define T3_MAX_CQ_DEPTH 65536
 #define T3_MAX_NUM_STAG (1<<15)
 #define T3_MAX_MR_SIZE 0x100000000ULL
 #define T3_PAGESIZE_MASK 0xffff000  /* 4KB-128MB */


