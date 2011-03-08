Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754109Ab1CHJoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:44:16 -0500
Received: from mms2.broadcom.com ([216.31.210.18]:3242 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754046Ab1CHJoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:44:14 -0500
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
Subject: Re: linux-next: manual merge of the net tree with the
 net-current tree
From: "Dmitry Kravkov" <dmitry@broadcom.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
cc: "David Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Eilon Greenstein" <eilong@broadcom.com>,
        "Vladislav Zolotarov" <vladz@broadcom.com>
In-Reply-To: <20110308140957.8a894312.sfr@canb.auug.org.au>
References: <20110308140957.8a894312.sfr@canb.auug.org.au>
Date: Tue, 8 Mar 2011 11:44:33 +0200
Message-ID: <1299577473.17233.41.camel@lb-tlvb-dmitry>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3
X-WSS-ID: 616B25613EW4192831-01-01
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 19:09 -0800, Stephen Rothwell wrote:
> Just overlapping additions (I think).  I have fixed it up (see below) and
> can carry the fix as necessary.
You are correct it's just an addition and it does not really matter
where to do this. But the merge pushed new code in the middle
of MAC configuration between MAC and multicast list.
It's clearer to put it at the end of MAC/ML/UL block:
---
 drivers/net/bnx2x/bnx2x_cmn.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/drivers/net/bnx2x/bnx2x_cmn.c b/drivers/net/bnx2x/bnx2x_cmn.c
index b01b622..9e37675 100644
--- a/drivers/net/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/bnx2x/bnx2x_cmn.c
@@ -1498,6 +1498,11 @@ int bnx2x_nic_load(struct bnx2x *bp, int load_mode)
 	/* Clear UC lists configuration */
 	bnx2x_invalidate_uc_list(bp);
 
+	if (bp->pending_max) {
+		bnx2x_update_max_mf_config(bp, bp->pending_max);
+		bp->pending_max = 0;
+	}
+
 	if (bp->port.pmf)
 		bnx2x_initial_phy_init(bp, load_mode);
 
-- 
1.7.2.2




