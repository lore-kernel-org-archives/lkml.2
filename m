Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755412Ab1DSVJ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 17:09:56 -0400
Received: from kroah.org ([198.145.64.141]:39331 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754551Ab1DSVEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 17:04:15 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 14:03:22 2011
Message-Id: <20110419210322.571399847@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 14:02:19 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Vasiliy Kulikov <segoon@openwall.com>,
        Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Subject: [03/26] UBIFS: restrict world-writable debugfs files
In-Reply-To: <20110419210333.GA17417@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: Vasiliy Kulikov <segoon@openwall.com>

commit 8c559d30b4e59cf6994215ada1fe744928f494bf upstream.

Don't allow everybody to dump sensitive information about filesystems.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
Signed-off-by: Artem Bityutskiy <Artem.Bityutskiy@nokia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ubifs/debug.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -2686,19 +2686,19 @@ int dbg_debugfs_init_fs(struct ubifs_inf
 	}
 
 	fname = "dump_lprops";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_lprops = dent;
 
 	fname = "dump_budg";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_budg = dent;
 
 	fname = "dump_tnc";
-	dent = debugfs_create_file(fname, S_IWUGO, d->dfs_dir, c, &dfs_fops);
+	dent = debugfs_create_file(fname, S_IWUSR, d->dfs_dir, c, &dfs_fops);
 	if (IS_ERR(dent))
 		goto out_remove;
 	d->dfs_dump_tnc = dent;


