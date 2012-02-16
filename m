Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751281Ab2BPLY2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 06:24:28 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:2175 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2BPLY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 06:24:27 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: linux-next: manual merge of the net-next tree with the net
 tree
From: "Yuval Mintz" <yuvalmin@broadcom.com>
To: sfr@canb.auug.org.au, davem@davemloft.net, netdev@vger.kernel.org
cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        eilong@broadcom.com, eric.dumazet@gmail.com
In-Reply-To: <20120216123803.8efe3d23eee5c3a80aceef61@canb.auug.org.au>
References: <20120216123803.8efe3d23eee5c3a80aceef61@canb.auug.org.au>
Organization: Broadcom
Date: Thu, 16 Feb 2012 13:24:10 +0200
Message-ID: <1329391450.16698.27.camel@lb-tlvb-eilong.il.broadcom.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.28.3
X-WSS-ID: 632236023GG28906048-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 17:38 -0800, Stephen Rothwell wrote:
> Hi all,
> 
> Today's linux-next merge of the net-next tree got a conflict in
> drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c between commit
> 66d885cba670 ("bnx2x: fix bnx2x_storm_stats_update() on big endian") from
> the net tree and commit 1355b704b9ba ("bnx2x: consistent statistics after
> internal driver reload") from the net-next tree.
> 
> I fixed it up (see below) but suspect that there may be more needed.

Hey Stephen,

I don't fully understand your merge - it seems to create a mash between
the "bnx2x: fix bnx2x_storm_stats_update() on big endian" patch in net,
and the "bnx2x: consistent statistics after internal driver reload"
patch in net-next.

If the purpose of this merge is simply to update net-next tree with the
changes from "bnx2x: fix bnx2x_storm_stats_update() on big endian", you
might consider the following patch:

Subject: [PATCH 1/1] bnx2x: merge net --> net-next
From: Mintz Yuval <yuvalmin@broadcom.com>

This patch applies the changes made in the patch
"bnx2x: fix bnx2x_storm_stats_update() on big endian" to net into net-next.

Signed-off-by: Mintz Yuval <yuvalmin@broadcom.com>
Signed-off-by: Eilon Greenstein <eilong@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
index abd310d..14c961b 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c
@@ -1006,14 +1006,14 @@ static int bnx2x_storm_stats_update(struct bnx2x *bp)
 	       estats->rx_stat_ifhcinbadoctets_lo);
 
 	ADD_64(estats->total_bytes_received_hi,
-	       tfunc->rcv_error_bytes.hi,
+	       le32_to_cpu(tfunc->rcv_error_bytes.hi),
 	       estats->total_bytes_received_lo,
-	       tfunc->rcv_error_bytes.lo);
+	       le32_to_cpu(tfunc->rcv_error_bytes.lo));
 
 	ADD_64(estats->error_bytes_received_hi,
-	       tfunc->rcv_error_bytes.hi,
+	       le32_to_cpu(tfunc->rcv_error_bytes.hi),
 	       estats->error_bytes_received_lo,
-	       tfunc->rcv_error_bytes.lo);
+	       le32_to_cpu(tfunc->rcv_error_bytes.lo));
 
 	UPDATE_ESTAT(etherstatsoverrsizepkts, rx_stat_dot3statsframestoolong);
 
-- 
1.7.9.rc2



