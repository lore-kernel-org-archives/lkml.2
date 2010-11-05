Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754088Ab0KEDLU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 23:11:20 -0400
Received: from mail.perches.com ([173.55.12.10]:4186 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab0KEDJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 23:09:08 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 43/49] kernel: Use vzalloc
Date: Thu,  4 Nov 2010 20:08:07 -0700
Message-Id: <a9a448feb3faf528a004be8e7ffcfca267448805.1288925425.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <alpine.DEB.2.00.1011031108260.11625@router.home>
References: <alpine.DEB.2.00.1011031108260.11625@router.home>
In-Reply-To: <cover.1288925424.git.joe@perches.com>
References: <cover.1288925424.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/profile.c |    6 ++----
 kernel/relay.c   |    4 +---
 2 files changed, 3 insertions(+), 7 deletions(-)

diff --git a/kernel/profile.c b/kernel/profile.c
index 66f841b..14c9f87 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -126,11 +126,9 @@ int __ref profile_init(void)
 	if (prof_buffer)
 		return 0;
 
-	prof_buffer = vmalloc(buffer_bytes);
-	if (prof_buffer) {
-		memset(prof_buffer, 0, buffer_bytes);
+	prof_buffer = vzalloc(buffer_bytes);
+	if (prof_buffer)
 		return 0;
-	}
 
 	free_cpumask_var(prof_cpu_mask);
 	return -ENOMEM;
diff --git a/kernel/relay.c b/kernel/relay.c
index c7cf397..11fbe89 100644
--- a/kernel/relay.c
+++ b/kernel/relay.c
@@ -74,9 +74,7 @@ static struct page **relay_alloc_page_array(unsigned int n_pages)
 	size_t pa_size = n_pages * sizeof(struct page *);
 
 	if (pa_size > PAGE_SIZE) {
-		array = vmalloc(pa_size);
-		if (array)
-			memset(array, 0, pa_size);
+		array = vzalloc(pa_size);
 	} else {
 		array = kzalloc(pa_size, GFP_KERNEL);
 	}
-- 
1.7.3.1.g432b3.dirty

