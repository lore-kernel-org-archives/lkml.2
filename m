Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933198Ab1DMQtL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:49:11 -0400
Received: from nspiron-3.llnl.gov ([128.115.41.83]:34038 "EHLO smtp.llnl.gov"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932549Ab1DMQtK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:49:10 -0400
X-Greylist: delayed 574 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Apr 2011 12:49:10 EDT
X-Attachments: None
Date: Wed, 13 Apr 2011 09:45:01 -0700
From: Ira Weiny <weiny2@llnl.gov>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] infiniband-diags: saquery, properly free mad in
 get_and_dump_any_records
Message-Id: <20110413094501.445b7065.weiny2@llnl.gov>
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.4; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Subject: [PATCH] infiniband-diags: saquery, properly free mad in get_and_dump_any_records

Signed-off-by: Ira Weiny <weiny2@llnl.gov>
---
 src/saquery.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/saquery.c b/src/saquery.c
index 03869e3..b8f2e41 100644
--- a/src/saquery.c
+++ b/src/saquery.c
@@ -877,7 +877,7 @@ static int get_and_dump_any_records(bind_handle_t h, uint16_t attr_id,
 		return ret;
 
 	dump_results(&result, dump_func);
-
+	return_mad();
 	return 0;
 }
 
-- 
1.7.1

