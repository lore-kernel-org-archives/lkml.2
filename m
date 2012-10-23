Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757353Ab2JWSVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 14:21:52 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:35140 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756746Ab2JWSVu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 14:21:50 -0400
Date: Tue, 23 Oct 2012 11:21:46 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk, arnd@arndb.de, tytso@mit.edu,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: [PATCH 1/3] f2fs: gc.h: make should_do_checkpoint() inline
Message-ID: <20121023182146.GB6096@kroah.com>
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com>
 <20121023182055.GA6096@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023182055.GA6096@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should be an inline function, not a "real" function.  Now other
files can properly include gc.h.

Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/f2fs/gc.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/f2fs/gc.h
+++ b/fs/f2fs/gc.h
@@ -191,7 +191,7 @@ static inline int is_idle(struct f2fs_sb
 	return !(rl->count[BLK_RW_SYNC]) && !(rl->count[BLK_RW_ASYNC]);
 }
 
-static bool should_do_checkpoint(struct f2fs_sb_info *sbi)
+static inline bool should_do_checkpoint(struct f2fs_sb_info *sbi)
 {
 	unsigned int pages_per_sec = sbi->segs_per_sec *
 					(1 << sbi->log_blocks_per_seg);
