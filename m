Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933477Ab1FWRhB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 13:37:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:34727 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933453Ab1FWRg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 13:36:58 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Stanislaw Gruszka <stf_xl@pop3.wp.pl>,
        Stanislaw Gruszka <stf_xl@wp.pl>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 109/247] PM / Hibernate: Return error code when alloc_image_page() fails
Date: Thu, 23 Jun 2011 13:32:57 -0400
Message-Id: <1308850515-15242-50-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stanislaw Gruszka <stf_xl@pop3.wp.pl>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 2e725a065b0153f0c449318da1923a120477633d upstream.

Currently we return 0 in swsusp_alloc() when alloc_image_page() fails.
Fix that.  Also remove unneeded "error" variable since the only
useful value of error is -ENOMEM.

[rjw: Fixed up the changelog and changed subject.]

Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 kernel/power/snapshot.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index be861c2..0652dcc 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1467,11 +1467,8 @@ static int
 swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 		unsigned int nr_pages, unsigned int nr_highmem)
 {
-	int error = 0;
-
 	if (nr_highmem > 0) {
-		error = get_highmem_buffer(PG_ANY);
-		if (error)
+		if (get_highmem_buffer(PG_ANY))
 			goto err_out;
 		if (nr_highmem > alloc_highmem) {
 			nr_highmem -= alloc_highmem;
@@ -1494,7 +1491,7 @@ swsusp_alloc(struct memory_bitmap *orig_bm, struct memory_bitmap *copy_bm,
 
  err_out:
 	swsusp_free();
-	return error;
+	return -ENOMEM;
 }
 
 asmlinkage int swsusp_save(void)
-- 
1.7.4.4

