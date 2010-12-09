Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757155Ab0LIUEW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 15:04:22 -0500
Received: from mail.perches.com ([173.55.12.10]:2404 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878Ab0LIUEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 15:04:13 -0500
From: Joe Perches <joe@perches.com>
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>
Cc: Jiri Kosina <trivial@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>, osd-dev@open-osd.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/15] osd: Remove duplicate unlikely from IS_ERR
Date: Thu,  9 Dec 2010 12:03:58 -0800
Message-Id: <786f4b066afe0eb7303f991f936b2643bcfc2d86.1291923889.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.464.gf80b6
In-Reply-To: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
References: <1291906801-1389-2-git-send-email-tklauser@distanz.ch>
In-Reply-To: <cover.1291923888.git.joe@perches.com>
References: <cover.1291923888.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

IS_ERR already uses unlikely, remove unlikely from the call sites.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/scsi/osd/osd_initiator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index b798919..b37c8a3 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -951,7 +951,7 @@ static int _osd_req_finalize_cdb_cont(struct osd_request *or, const u8 *cap_key)
 	/* create a bio for continuation segment */
 	bio = bio_map_kern(req_q, or->cdb_cont.buff, or->cdb_cont.total_bytes,
 			   GFP_KERNEL);
-	if (unlikely(IS_ERR(bio)))
+	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
 	bio->bi_rw |= REQ_WRITE;
-- 
1.7.3.3.464.gf80b6

