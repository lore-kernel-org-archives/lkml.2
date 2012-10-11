Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758118Ab2JKJQ3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:16:29 -0400
Received: from multi.imgtec.com ([194.200.65.239]:25368 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757748Ab2JKJQY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:16:24 -0400
X-Greylist: delayed 892 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Oct 2012 05:16:23 EDT
From: James Hogan <james.hogan@imgtec.com>
To: "James E.J. Bottomley" <JBottomley@parallels.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>
Subject: [RESEND PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Date: Thu, 11 Oct 2012 10:15:33 +0100
Message-ID: <1349946933-30314-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.7.7.6
X-OriginalArrivalTime: 11 Oct 2012 09:15:50.0924 (UTC) FILETIME=[01FFA4C0:01CDA791]
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2012_10_11_10_15_52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The struct scsi_varlen_cdb_hdr is expected to be exactly 10 bytes when
used in struct osd_cdb_head, but it isn't marked as packed. Some
architectures will round the struct size up which triggers BUILD_BUG_ON
compile errors in osd_initiator.c when the outer structs are unexpected
sizes. This is fixed by marking struct scsi_varlen_cdb_hdr as __packed.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
---
 include/scsi/scsi.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 66216c1..3beaef3 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -198,7 +198,7 @@ struct scsi_varlen_cdb_hdr {
 	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
-};
+} __packed;
 
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
-- 
1.7.7.6


