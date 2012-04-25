Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759342Ab2DYO0J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 10:26:09 -0400
Received: from anchor-post-3.mail.demon.net ([195.173.77.134]:56983 "EHLO
	anchor-post-3.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757973Ab2DYO0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 10:26:07 -0400
X-Greylist: delayed 1979 seconds by postgrey-1.27 at vger.kernel.org; Wed, 25 Apr 2012 10:26:07 EDT
Message-ID: <1335361985.1885.16.camel@castor.rsk>
Subject: [PATCH] fs: remove 8 bytes of padding from struct writeback_control
 on 64 bit builds
From: Richard Kennedy <richard@rsk.demon.co.uk>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>, Jan Kara <jack@suse.cz>
Date: Wed, 25 Apr 2012 14:53:05 +0100
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reorder structure writeback_control to remove 8 bytes of padding on 64
bit builds, this shrinks its size from 48 to 40 bytes.

This structure is always on the stack and uses C99 named initialisation,
so should be safe and have a small impact on stack usage.
    
Signed-off-by: Richard Kennedy <richard@rsk.demon.co.uk>

--

patch against v3.4-rc4
compiled and tested on x86_64

I've been running my desktop with this patch applied for several days
and have not seen any problems.
regards
Richard





diff --git a/include/linux/writeback.h b/include/linux/writeback.h
index a2b84f5..3309736 100644
--- a/include/linux/writeback.h
+++ b/include/linux/writeback.h
@@ -58,7 +58,6 @@ extern const char *wb_reason_name[];
  * in a manner such that unspecified fields are set to zero.
  */
 struct writeback_control {
-	enum writeback_sync_modes sync_mode;
 	long nr_to_write;		/* Write this many pages, and decrement
 					   this for each page written */
 	long pages_skipped;		/* Pages which were not written */
@@ -71,6 +70,8 @@ struct writeback_control {
 	loff_t range_start;
 	loff_t range_end;
 
+	enum writeback_sync_modes sync_mode;
+
 	unsigned for_kupdate:1;		/* A kupdate writeback */
 	unsigned for_background:1;	/* A background writeback */
 	unsigned tagged_writepages:1;	/* tag-and-write to avoid livelock */


