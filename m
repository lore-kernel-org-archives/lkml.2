Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966432Ab0CPOtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:49:33 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:38323 "EHLO
	mail.jetsystems.cz" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S966380Ab0CPOt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:49:27 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: rolandd@cisco.com
Cc: linux-kernel@vger.kernel.org, jirislaby@gmail.com,
       Or Gerlitz <ogerlitz@voltaire.com>
Subject: [PATCH 1/1] infiniband: ulp/iser, fix error retval in iser_create_ib_conn_res
Date: Tue, 16 Mar 2010 15:49:22 +0100
Message-Id: <1268750962-13547-1-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.0.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stanse foudn unreachable code in iser_create_ib_conn_res. Namely there
is switched goto and ret assignment. Switch them to make sense and
return ENOMEM in case of error.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: Or Gerlitz <ogerlitz@voltaire.com>
Cc: Roland Dreier <rolandd@cisco.com>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 308d17b..6d4ba35 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -149,8 +149,8 @@ static int iser_create_ib_conn_res(struct iser_conn *ib_conn)
 
 	ib_conn->login_buf = kmalloc(ISER_RX_LOGIN_SIZE, GFP_KERNEL);
 	if (!ib_conn->login_buf) {
-		goto alloc_err;
 		ret = -ENOMEM;
+		goto alloc_err;
 	}
 
 	ib_conn->login_dma = ib_dma_map_single(ib_conn->device->ib_device,
-- 
1.7.0.1


