Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab2BJVGN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 16:06:13 -0500
Received: from caiajhbdccac.dreamhost.com ([208.97.132.202]:44304 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1760158Ab2BJVGL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 16:06:11 -0500
Subject: [PATCH] locks: export device name
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 10 Feb 2012 22:06:07 +0100
Message-ID: <1328907967.3138.1.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

The lslk(8) program has not been maintained for over a decade and has recently been rewritten as lslocks(8).
It will be available for the next 2.22 release, in a couple of months. This is a good opportunity to delete
that nasty WE_CAN_BREAK_LSLK_NOW and start exporting the device name instead of the maj:min numbers.

For backward compatibility the new version can be in charge of checking older kernel versions and parsing the old
output if necessary.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 fs/locks.c |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 637694b..2b01907 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -2199,15 +2199,8 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 			       : (fl->fl_type & F_WRLCK) ? "WRITE" : "READ ");
 	}
 	if (inode) {
-#ifdef WE_CAN_BREAK_LSLK_NOW
 		seq_printf(f, "%d %s:%ld ", fl_pid,
 				inode->i_sb->s_id, inode->i_ino);
-#else
-		/* userspace relies on this representation of dev_t ;-( */
-		seq_printf(f, "%d %02x:%02x:%ld ", fl_pid,
-				MAJOR(inode->i_sb->s_dev),
-				MINOR(inode->i_sb->s_dev), inode->i_ino);
-#endif
 	} else {
 		seq_printf(f, "%d <none>:0 ", fl_pid);
 	}
-- 
1.7.4.1



