Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756355Ab3AHNmS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 08:42:18 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:41352 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755794Ab3AHNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 08:42:17 -0500
Date: Tue, 8 Jan 2013 16:42:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Eilon Greenstein <eilong@broadcom.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [patch] bnx2x: NULL dereference on error in debug code
Message-ID: <20130108134213.GA23742@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"vfop" is NULL here.  I've changed the debugging to not use it.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
---
Only needed in linux-next.

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
index 71fcef0..3eef972 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_sriov.c
@@ -463,8 +463,7 @@ static int bnx2x_vfop_qdtor_cmd(struct bnx2x *bp,
 		return bnx2x_vfop_transition(bp, vf, bnx2x_vfop_qdtor,
 					     cmd->block);
 	}
-	DP(BNX2X_MSG_IOV, "VF[%d] failed to add a vfop. rc %d\n",
-	   vf->abs_vfid, vfop->rc);
+	DP(BNX2X_MSG_IOV, "VF[%d] failed to add a vfop.\n", vf->abs_vfid);
 	return -ENOMEM;
 }
 
