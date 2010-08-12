Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597Ab0HLMbQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 08:31:16 -0400
Received: from mail.pripojeni.net ([217.66.174.14]:55217 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S933152Ab0HLMbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 08:31:14 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: akpm@linux-foundation.org
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
        jirislaby@gmail.com, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>,
        "James E.J. Bottomley" <James.Bottomley@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH v2] SCSI: fix bio.bi_rw handling
Date: Thu, 12 Aug 2010 14:31:05 +0200
Message-Id: <1281616266-4709-2-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
References: <1281616266-4709-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return of the bi_rw tests is no longer bool after commit 74450be1. So
testing against constants doesn't make sense anymore. Fix this bug in
osd_req_read by removing "== 1" in test.

This is not a problem now, where REQ_WRITE is 1, but this can change
in the future and we don't want to rely on that.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
Cc: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/osd/osd_initiator.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
index fda4de3..e88bbdd 100644
--- a/drivers/scsi/osd/osd_initiator.c
+++ b/drivers/scsi/osd/osd_initiator.c
@@ -865,7 +865,7 @@ void osd_req_read(struct osd_request *or,
 {
 	_osd_req_encode_common(or, OSD_ACT_READ, obj, offset, len);
 	WARN_ON(or->in.bio || or->in.total_bytes);
-	WARN_ON(1 == (bio->bi_rw & REQ_WRITE));
+	WARN_ON(bio->bi_rw & REQ_WRITE);
 	or->in.bio = bio;
 	or->in.total_bytes = len;
 }
-- 
1.7.2.1


