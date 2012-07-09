Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab2GIOOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 10:14:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4175 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab2GIOO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 10:14:29 -0400
Date: Mon, 9 Jul 2012 10:14:16 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: "Chauhan, Vijay" <Vijay.Chauhan@netapp.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "Moger, Babu" <Babu.Moger@netapp.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Stankey, Robert" <Robert.Stankey@netapp.com>, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: [PATCH] block: do not artificially constrain max_sectors for
 stacking drivers
Message-ID: <20120709141416.GB30633@redhat.com>
References: <F200AD42A082BC4088B232D13A916A8907E5DD64@SACEXCMBX02-PRD.hq.netapp.com>
 <20120709130052.GC30048@redhat.com>
 <20120709131611.GD30048@redhat.com>
 <20120709134041.GA30633@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120709134041.GA30633@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

blk_set_stacking_limits is intended to allow stacking drivers to build
up the limits of the stacked device based on the underlying devices'
limits.  But in the case of 'max_sectors' the default of
BLK_DEF_MAX_SECTORS (1024) doesn't allow the stacking driver to inherit
a max_sectors larger than 1024.

It is now clear that this artificial limit is getting in the way so
change blk_set_stacking_limits's max_sectors to UINT_MAX (which allows
stacking drivers like dm-multipath to inherit 'max_sectors' from the
underlying paths).

Reported-by: Vijay Chauhan <vijay.chauhan@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-settings.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..565a678 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -143,8 +143,7 @@ void blk_set_stacking_limits(struct queue_limits *lim)
 	lim->discard_zeroes_data = 1;
 	lim->max_segments = USHRT_MAX;
 	lim->max_hw_sectors = UINT_MAX;
-
-	lim->max_sectors = BLK_DEF_MAX_SECTORS;
+	lim->max_sectors = UINT_MAX;
 }
 EXPORT_SYMBOL(blk_set_stacking_limits);
 

