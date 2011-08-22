Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1HVOAq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:00:46 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:48312 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751769Ab1HVOAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:00:43 -0400
From: Julia Lawall <julia@diku.dk>
To: Robert Love <robert.w.love@intel.com>
Cc: kernel-janitors@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>, devel@open-fcoe.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] drivers/scsi/fcoe/fcoe.c: add missing test
Date: Mon, 22 Aug 2011 16:00:34 +0200
Message-Id: <1314021636-11528-2-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

The initializations of both fcoe_nport_scsi_transport and
fcoe_vport_scsi_transport can fail, so test both of them.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@r@
identifier x,y,f!={PTR_ERR,ERR_PTR,ERR_CAST};
statement S;
@@

x = f(...);
(
if (\(x == NULL\|IS_ERR(x)\)) S
|
*if (\(y == NULL\|IS_ERR(y)\))
 { ... when != x
   return ...; }
)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/fcoe/fcoe.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/fcoe/fcoe.c b/drivers/scsi/fcoe/fcoe.c
index ba710e3..921b636 100644
--- a/drivers/scsi/fcoe/fcoe.c
+++ b/drivers/scsi/fcoe/fcoe.c
@@ -1096,7 +1096,7 @@ static int __init fcoe_if_init(void)
 	fcoe_vport_scsi_transport =
 		fc_attach_transport(&fcoe_vport_fc_functions);
 
-	if (!fcoe_nport_scsi_transport) {
+	if (!fcoe_nport_scsi_transport || !fcoe_vport_scsi_transport) {
 		printk(KERN_ERR "fcoe: Failed to attach to the FC transport\n");
 		return -ENODEV;
 	}

