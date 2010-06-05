Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab0FEXOs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:14:48 -0400
Received: from smtp-02.mandic.com.br ([200.225.81.133]:57673 "EHLO
	smtp-02.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933511Ab0FEXOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:14:45 -0400
From: Cesar Eduardo Barros <cesarb@cesarb.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
       Avi Kivity <avi@redhat.com>, Nick Piggin <npiggin@suse.de>,
       Minchan Kim <minchan.kim@gmail.com>, Jens Axboe <jens.axboe@oracle.com>,
       Hugh Dickins <hughd@google.com>,
       Cesar Eduardo Barros <cesarb@cesarb.net>
Subject: [PATCH v2 1/3] mm/swapfile.c: better messages for swap_info_get
Date: Sat,  5 Jun 2010 20:14:34 -0300
Message-Id: <1275779676-19120-1-git-send-email-cesarb@cesarb.net>
X-Mailer: git-send-email 1.6.6.1
In-Reply-To: <4C0ADA44.4020406@cesarb.net>
References: <4C0ADA44.4020406@cesarb.net>
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
index 03aa2d5..68765c9 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -525,16 +525,16 @@ static struct swap_info_struct *swap_info_get(swp_entry_t entry)
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

