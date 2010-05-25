Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933715Ab0EYSUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 14:20:54 -0400
Received: from kroah.org ([198.145.64.141]:44354 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933356Ab0EYSR1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 14:17:27 -0400
X-Mailbox-Line: From gregkh@clark.site Tue May 25 11:12:13 2010
Message-Id: <20100525181212.973814409@clark.site>
User-Agent: quilt/0.48-8.10
Date: Tue, 25 May 2010 11:09:07 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       linux-fsdevel@vger.kernel.org,
       Ext4 Developers List <linux-ext4@vger.kernel.org>,
       "Theodore Tso" <tytso@mit.edu>, "Jayson R. King" <dev@jaysonking.com>,
       "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [09/25] vfs: Remove the range_cont writeback mode.
In-Reply-To: <20100525181259.GA18630@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

commit 74baaaaec8b4f22e1ae279f5ecca4ff705b28912 upstream.

Ext4 was the only user of range_cont writeback mode and ext4 switched
to a different method. So remove the range_cont mode which is not used
in the kernel.

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-fsdevel@vger.kernel.org
Signed-off-by: Jayson R. King <dev@jaysonking.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/writeback.h |    1 -
 mm/page-writeback.c       |    2 --
 2 files changed, 3 deletions(-)

--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -62,7 +62,6 @@ struct writeback_control {
 	unsigned for_writepages:1;	/* This is a writepages() call */
 	unsigned range_cyclic:1;	/* range_start is cyclic */
 	unsigned more_io:1;		/* more io to be dispatched */
-	unsigned range_cont:1;
 };
 
 /*
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -1027,8 +1027,6 @@ continue_unlock:
 	if (wbc->range_cyclic || (range_whole && wbc->nr_to_write > 0))
 		mapping->writeback_index = done_index;
 
-	if (wbc->range_cont)
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
 	return ret;
 }
 EXPORT_SYMBOL(write_cache_pages);


