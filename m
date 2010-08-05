Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934413Ab0HEUbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 16:31:38 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:64561 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934344Ab0HEUb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 16:31:28 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.55,324,1278288000"; 
   d="scan'208";a="349662121"
From: Roland Dreier <rdreier@cisco.com>
To: Julia Lawall <julia@diku.dk>
Cc: Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 4/42] drivers/infiniband/hw/nes: Adjust confusing if indentation
References: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
X-Message-Flag: Warning: May contain useful information
Date: Thu, 05 Aug 2010 13:31:24 -0700
In-Reply-To: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk> (Julia Lawall's
	message of "Thu, 5 Aug 2010 22:18:01 +0200 (CEST)")
Message-ID: <adaiq3o4x9f.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > It is not clear whether the assignment should be part of the if branch
 > suggested by its indentation.  The patch preserves the current semantics.

Thanks.  Chien/Faisal -- are the current semantics correct or should we
add braces { } to match the indentation?  From a quick look at the code,
I think the patch we actually want is:

 drivers/infiniband/hw/nes/nes_hw.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 07c4004..f8233c8 100644
--- a/drivers/infiniband/hw/nes/nes_hw.c
+++ b/drivers/infiniband/hw/nes/nes_hw.c
@@ -2737,9 +2737,9 @@ void nes_nic_ce_handler(struct nes_device *nesdev, struct nes_hw_nic_cq *cq)
 				nesnic->sq_tail &= nesnic->sq_size-1;
 				if (sq_cqes > 128) {
 					barrier();
-				/* restart the queue if it had been stopped */
-				if (netif_queue_stopped(nesvnic->netdev))
-					netif_wake_queue(nesvnic->netdev);
+					/* restart the queue if it had been stopped */
+					if (netif_queue_stopped(nesvnic->netdev))
+						netif_wake_queue(nesvnic->netdev);
 					sq_cqes = 0;
 				}
 			} else {

-- 
Roland Dreier <rolandd@cisco.com> || For corporate legal information go to:
http://www.cisco.com/web/about/doing_business/legal/cri/index.html
