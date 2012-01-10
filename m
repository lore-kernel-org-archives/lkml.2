Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933770Ab2AJXY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 18:24:28 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52202 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933734Ab2AJW7D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 17:59:03 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan 10 13:46:19 2012
Message-Id: <20120110214619.418388994@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 10 Jan 2012 13:45:27 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, reiserfs-devel@vger.kernel.org,
        Jan Kara <jack@suse.cz>
Subject: [14/40] reiserfs: Fix quota mount option parsing
In-Reply-To: <20120110214630.GA14384@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1164,7 +1164,8 @@ static void handle_quota_files(struct su
 			kfree(REISERFS_SB(s)->s_qf_names[i]);
 		REISERFS_SB(s)->s_qf_names[i] = qf_names[i];
 	}
-	REISERFS_SB(s)->s_jquota_fmt = *qfmt;
+	if (*qfmt)
+		REISERFS_SB(s)->s_jquota_fmt = *qfmt;
 }
 #endif
 


