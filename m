Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758607Ab2DJM4v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 08:56:51 -0400
Received: from multi.imgtec.com ([194.200.65.239]:46165 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753884Ab2DJM4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 08:56:50 -0400
X-Greylist: delayed 974 seconds by postgrey-1.27 at vger.kernel.org; Tue, 10 Apr 2012 08:56:49 EDT
Message-ID: <4F8429DD.3010700@imgtec.com>
Date: Tue, 10 Apr 2012 13:38:53 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: "James E.J. Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] scsi: make struct scsi_varlen_cdb_hdr packed
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Apr 2012 12:38:54.0035 (UTC) FILETIME=[E3B0DA30:01CD1716]
X-SEF-Processed: 7_3_0_01181__2012_04_10_13_40_30
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
index f34a5a8..c75c8c8 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -196,7 +196,7 @@ struct scsi_varlen_cdb_hdr {
 	__u8 additional_cdb_length;         /* total cdb length - 8 */
 	__be16 service_action;
 	/* service specific data follows */
-};
+} __packed;
 
 static inline unsigned
 scsi_varlen_cdb_length(const void *hdr)
-- 
1.7.7.6


