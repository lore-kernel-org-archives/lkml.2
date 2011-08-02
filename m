Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab1HBKhg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 06:37:36 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:59090 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab1HBKfM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 06:35:12 -0400
From: Julia Lawall <julia@diku.dk>
To: Eric Moore <Eric.Moore@lsi.com>, trivial@kernel.org
Cc: kernel-janitors@vger.kernel.org, support@lsi.com,
        DL-MPTFusionLinux@lsi.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/11] drivers/message/fusion/mptsas.c: trivial: use BUG_ON
Date: Tue,  2 Aug 2011 12:34:55 +0200
Message-Id: <1312281304-11847-3-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1312281304-11847-1-git-send-email-julia@diku.dk>
References: <1312281304-11847-1-git-send-email-julia@diku.dk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use BUG_ON(x) rather than if(x) BUG();

The semantic patch that fixes this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@ identifier x; @@
-if (x) BUG();
+BUG_ON(x);

@@ identifier x; @@
-if (!x) BUG();
+BUG_ON(!x);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/message/fusion/mptsas.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff -u -p a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -3410,8 +3410,7 @@ mptsas_expander_event_add(MPT_ADAPTER *i
 	__le64 sas_address;
 
 	port_info = kzalloc(sizeof(struct mptsas_portinfo), GFP_KERNEL);
-	if (!port_info)
-		BUG();
+	BUG_ON(!port_info);
 	port_info->num_phys = (expander_data->NumPhys) ?
 	    expander_data->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,

