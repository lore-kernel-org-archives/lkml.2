Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754121Ab1HAX1U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 19:27:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:38804 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754095Ab1HAX1G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 19:27:06 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Aug  1 16:20:56 2011
Message-Id: <20110801232056.337335871@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 01 Aug 2011 16:19:12 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Amir Goldstein <amir73il@users.sf.net>, Jan Kara <jack@suse.cz>,
        "Theodore Tso" <tytso@mit.edu>, Chris Dunlop <chris@onthe.net.au>
Subject: [57/70] ext4: fix oops in ext4_quota_off()
In-Reply-To: <20110801232124.GA15313@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Amir Goldstein <amir73il@gmail.com>

commit 0b26859027ce0005ef89520af20351360e51ad76 upstream.

If quota is not enabled when ext4_quota_off() is called, we must not
dereference quota file inode since it is NULL.  Check properly for
this.

This fixes a bug in commit 21f976975cbe (ext4: remove unnecessary
[cm]time update of quota file), which was merged for 2.6.39-rc3.

Reported-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Amir Goldstein <amir73il@users.sf.net>
Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
Cc: Chris Dunlop <chris@onthe.net.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ext4/super.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -4635,6 +4635,9 @@ static int ext4_quota_off(struct super_b
 	if (test_opt(sb, DELALLOC))
 		sync_filesystem(sb);
 
+	if (!inode)
+		goto out;
+
 	/* Update modification times of quota files when userspace can
 	 * start looking at them */
 	handle = ext4_journal_start(inode, 1);


