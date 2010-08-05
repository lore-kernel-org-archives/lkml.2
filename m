Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933131Ab0HEXtO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 19:49:14 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38429 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab0HEXtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 19:49:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=xFCPBTzR3d7F9v1jA2/BMuhFb5jXEWfqM5P/ZwN0cQPBlqRJDnVxfiUXNoSacXXKdK
         YNYCTNTqZYsLIATuOcGcePIsQZWTclBCTjOIlQi8WIbzxgcglVCB/sc8Xg7Aoo/Gv8sN
         s4yrqhKIFo2PdeNaFa9PeaIZc8Vd+dync2cSk=
Date: Fri, 6 Aug 2010 01:48:32 +0200
From: Dan Carpenter <error27@gmail.com>
To: Julia Lawall <julia@diku.dk>
Cc: Faisal Latif <faisal.latif@intel.com>,
        Chien Tung <chien.tin.tung@intel.com>,
        Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 4/42 v2] drivers/infiniband/hw/nes: Adjust confusing if
	indentation
Message-ID: <20100805234831.GK9031@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Julia Lawall <julia@diku.dk>, Faisal Latif <faisal.latif@intel.com>,
	Chien Tung <chien.tin.tung@intel.com>,
	Roland Dreier <rolandd@cisco.com>,
	Sean Hefty <sean.hefty@intel.com>,
	Hal Rosenstock <hal.rosenstock@gmail.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
References: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1008052217430.31692@ask.diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think the white space is meant to look like this.  I did look at
whether the "sq_cqes = 0;" should only be done if netif_queue_stopped().
In the end I decided this was what was intended, but it would be
better if someone more familiar with the code reviewed it.

Reported-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Dan Carpenter <error27@gmail.com>
---
v2: changed different indents

diff --git a/drivers/infiniband/hw/nes/nes_hw.c b/drivers/infiniband/hw/nes/nes_hw.c
index 57874a1..293977b 100644
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
