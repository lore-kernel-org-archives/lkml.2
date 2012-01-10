Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2AJULc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 15:11:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45891 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756991Ab2AJUL0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 15:11:26 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 12:08:50 2012
Message-Id: <20120110200850.368987282@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 12:06:58 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, reiserfs-devel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [07/20] reiserfs: Fix quota mount option parsing
In-Reply-To: <20120110200902.GA5674@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Jan Kara <jack@suse.cz>

commit a06d789b424190e9f59da391681f908486db2554 upstream.

When jqfmt mount option is not specified on remount, we mistakenly clear
s_jquota_fmt value stored in superblock. Fix the problem.

CC: reiserfs-devel@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/reiserfs/super.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/reiserfs/super.c
+++ b/fs/reiserfs/super.c
@@ -1149,7 +1149,8 @@ static void handle_quota_files(struct su
 			kfree(REISERFS_SB(s)->s_qf_names[i]);
 		REISERFS_SB(s)->s_qf_names[i] = qf_names[i];
 	}
-	REISERFS_SB(s)->s_jquota_fmt = *qfmt;
+	if (*qfmt)
+		REISERFS_SB(s)->s_jquota_fmt = *qfmt;
 }
 #endif
 


