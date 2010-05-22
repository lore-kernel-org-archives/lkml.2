Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0EVSJD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 14:09:03 -0400
Received: from smtp-03.mandic.com.br ([200.225.81.143]:40021 "EHLO
	smtp-03.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab0EVSJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 14:09:00 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH 1/3] mm/swapfile.c: better messages for swap_info_get
Date: Sat, 22 May 2010 15:08:49 -0300
Message-Id: <1274551731-4534-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <4BF81D87.6010506@cesarb.net>
References: <4BF81D87.6010506@cesarb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

swap_info_get() is used for more than swap_free().

Use "swap_info_get:" instead of "swap_free:" in the error messages.

Signed-off-by: Cesar Eduardo Barros <cesarb@cesarb.net>
---
 mm/swapfile.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 6cd0a8f..af7d499 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -522,16 +522,16 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
 	return p;
 
 bad_free:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_offset, entry.val);
+	printk(KERN_ERR "swap_info_get: %s%08lx\n", Unused_offset, entry.val);
 	goto out;
 bad_offset:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_offset, entry.val);
+	printk(KERN_ERR "swap_info_get: %s%08lx\n", Bad_offset, entry.val);
 	goto out;
 bad_device:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Unused_file, entry.val);
+	printk(KERN_ERR "swap_info_get: %s%08lx\n", Unused_file, entry.val);
 	goto out;
 bad_nofile:
-	printk(KERN_ERR "swap_free: %s%08lx\n", Bad_file, entry.val);
+	printk(KERN_ERR "swap_info_get: %s%08lx\n", Bad_file, entry.val);
 out:
 	return NULL;
 }
-- 
1.6.6.1

