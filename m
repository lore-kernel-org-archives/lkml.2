Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1AZS3d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 13:29:33 -0500
Received: from [123.122.106.155] ([123.122.106.155]:38823 "EHLO enigma.site"
	rhost-flags-FAIL-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754051Ab1AZS3J (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 13:29:09 -0500
From: Coly Li <bosong.ly@taobao.com>
To: linux-kernel@vger.kernel.org
Cc: Coly Li <bosong.ly@taobao.com>, David Howells <dhowells@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] mm: use BUG_ON correctly in nommu.c
Date: Thu, 27 Jan 2011 02:54:50 +0800
Message-Id: <1296068095-16988-2-git-send-email-bosong.ly@taobao.com>
X-Mailer: git-send-email 1.7.3.2
In-Reply-To: <1296068095-16988-1-git-send-email-bosong.ly@taobao.com>
References: <1296068095-16988-1-git-send-email-bosong.ly@taobao.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch makes BUG_ON() usage correct in mm/nommu.c. Since there
are 2 lines even before 2.6.12, I am not able to find out the original
author, Cc Andrew as well.

Signed-off-by: Coly Li <bosong.ly@taobao.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 mm/nommu.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index f59e142..eccff36 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -534,16 +534,16 @@ static noinline void validate_nommu_regions(void)
 		return;
 
 	last = rb_entry(lastp, struct vm_region, vm_rb);
-	BUG_ON(unlikely(last->vm_end <= last->vm_start));
-	BUG_ON(unlikely(last->vm_top < last->vm_end));
+	BUG_ON(last->vm_end <= last->vm_start);
+	BUG_ON(last->vm_top < last->vm_end);
 
 	while ((p = rb_next(lastp))) {
 		region = rb_entry(p, struct vm_region, vm_rb);
 		last = rb_entry(lastp, struct vm_region, vm_rb);
 
-		BUG_ON(unlikely(region->vm_end <= region->vm_start));
-		BUG_ON(unlikely(region->vm_top < region->vm_end));
-		BUG_ON(unlikely(region->vm_start < last->vm_top));
+		BUG_ON(region->vm_end <= region->vm_start);
+		BUG_ON(region->vm_top < region->vm_end);
+		BUG_ON(region->vm_start < last->vm_top);
 
 		lastp = p;
 	}
-- 
1.7.3.2

