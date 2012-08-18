Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754660Ab2HRJte (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:49:34 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50371 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab2HRJta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:49:30 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: fengguang.wu@intel.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 2/3] writeback: fix incorrect return value type of bdi_dirty_limit
Date: Sat, 18 Aug 2012 05:49:21 -0400
Message-Id: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)

Above function return type is unsigned long, but return value is
kept in "u64 bdi_dirty".
It can return incorrect value by type casting.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 mm/page-writeback.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 49133b6..73a7a06 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -546,7 +546,7 @@ static unsigned long hard_dirty_limit(unsigned long thresh)
  */
 unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long dirty)
 {
-	u64 bdi_dirty;
+	unsigned long bdi_dirty;
 	long numerator, denominator;
 
 	/*
-- 
1.7.9.5

