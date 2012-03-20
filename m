Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760420Ab2CTOoU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:44:20 -0400
Received: from mga01.intel.com ([192.55.52.88]:38372 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760229Ab2CTOli (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:41:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="141907382"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ted Tso <tytso@mit.edu>
Cc: Ext4 Mailing List <linux-ext4@vger.kernel.org>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: [PATCH v1 4/9] mm: export dirty_writeback_interval
Date: Tue, 20 Mar 2012 16:41:24 +0200
Message-Id: <1332254489-2300-5-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
References: <1332254489-2300-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

Export 'dirty_writeback_interval' to make it visible to file-systems. We are
going to push superblock management down to file-systems and get rid of the
'sync_supers' kernel thread completly.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>
---
 mm/page-writeback.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 363ba70..5e39858 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -95,6 +95,8 @@ unsigned long vm_dirty_bytes;
  */
 unsigned int dirty_writeback_interval = 5 * 100; /* centiseconds */
 
+EXPORT_SYMBOL_GPL(dirty_writeback_interval);
+
 /*
  * The longest time for which data is allowed to remain dirty
  */
-- 
1.7.7.6

