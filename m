Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab2GWBtN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:49:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54440 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753565Ab2GWBnk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:40 -0400
Message-Id: <20120723010657.383663220@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:30 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk,
        Luis Henriques <luis.henriques@canonical.com>,
        Bret Towe <magnade@gmail.com>,
        Sunil Mushran <sunil.mushran@oracle.com>,
        Joel Becker <jlbec@evilplan.org>, Mark Fasheh <mfasheh@suse.com>
Subject: [ 039/108] ocfs2: fix NULL pointer dereference in __ocfs2_change_file_space()
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Luis Henriques <luis.henriques@canonical.com>

commit a4e08d001f2e50bb8b3c4eebadcf08e5535f02ee upstream.

As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
as the first parameter (file), it may trigger a NULL pointer dereferrence
due to a missing check.

Addresses http://bugs.launchpad.net/bugs/1006012

Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
Reported-by: Bret Towe <magnade@gmail.com>
Tested-by: Bret Towe <magnade@gmail.com>
Cc: Sunil Mushran <sunil.mushran@oracle.com>
Acked-by: Joel Becker <jlbec@evilplan.org>
Acked-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ocfs2/file.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index 98513c8..7602783 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -1950,7 +1950,7 @@ static int __ocfs2_change_file_space(struct file *file, struct inode *inode,
 	if (ret < 0)
 		mlog_errno(ret);
 
-	if (file->f_flags & O_SYNC)
+	if (file && (file->f_flags & O_SYNC))
 		handle->h_sync = 1;
 
 	ocfs2_commit_trans(osb, handle);


