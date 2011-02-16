Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757250Ab1BPAV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:21:28 -0500
Received: from kroah.org ([198.145.64.141]:39272 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757220Ab1BPAVW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:21:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:36 2011
Message-Id: <20110216001436.767793923@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:12:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Steve Wise <swise@opengridcomputing.com>,
        Roland Dreier <roland@purestorage.com>
Subject: [117/272] RDMA/cxgb4: Limit MAXBURST EQ context field to 256B
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Steve Wise <swise@opengridcomputing.com>

commit 6a09a9d6946dd516d243d072bee83fae3c683471 upstream.

MAXBURST cannot exceed 256B for on-chip queues.  With a 512B MAXBURST,
we can lock up the chip.

Signed-off-by: Steve Wise <swise@opengridcomputing.com>
Signed-off-by: Roland Dreier <roland@purestorage.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/infiniband/hw/cxgb4/qp.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -220,7 +220,7 @@ static int create_qp(struct c4iw_rdev *r
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
 		V_FW_RI_RES_WR_FBMIN(2) |
-		V_FW_RI_RES_WR_FBMAX(3) |
+		V_FW_RI_RES_WR_FBMAX(2) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
 		V_FW_RI_RES_WR_EQSIZE(eqsize));
@@ -243,7 +243,7 @@ static int create_qp(struct c4iw_rdev *r
 		V_FW_RI_RES_WR_DCAEN(0) |
 		V_FW_RI_RES_WR_DCACPU(0) |
 		V_FW_RI_RES_WR_FBMIN(2) |
-		V_FW_RI_RES_WR_FBMAX(3) |
+		V_FW_RI_RES_WR_FBMAX(2) |
 		V_FW_RI_RES_WR_CIDXFTHRESHO(0) |
 		V_FW_RI_RES_WR_CIDXFTHRESH(0) |
 		V_FW_RI_RES_WR_EQSIZE(eqsize));


