Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab2BBUkM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 15:40:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:11000 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754938Ab2BBUkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:40:10 -0500
From: Matthew Garrett <mjg@redhat.com>
To: linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Matthew Garrett <mjg@redhat.com>
Subject: [PATCH V2 1/2] hfsplus: Change finder_info to u32
Date: Thu,  2 Feb 2012 15:39:50 -0500
Message-Id: <1328215191-4201-1-git-send-email-mjg@redhat.com>
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 209.6.41.104
X-SA-Exim-Mail-From: mjg@redhat.com
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The finder_info block in the hfsplus volume header is currently defined as
an array of 8 bit values, but TN1150 defines it as being an array of 32 bit
values. Fix for convenience.

Signed-off-by: Matthew Garrett <mjg@redhat.com>
---
 fs/hfsplus/hfsplus_raw.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/fs/hfsplus/hfsplus_raw.h b/fs/hfsplus/hfsplus_raw.h
index 927cdd6..921967e 100644
--- a/fs/hfsplus/hfsplus_raw.h
+++ b/fs/hfsplus/hfsplus_raw.h
@@ -117,7 +117,7 @@ struct hfsplus_vh {
 	__be32 write_count;
 	__be64 encodings_bmp;
 
-	u8 finder_info[32];
+	u32 finder_info[8];
 
 	struct hfsplus_fork_raw alloc_file;
 	struct hfsplus_fork_raw ext_file;
-- 
1.7.7.1

