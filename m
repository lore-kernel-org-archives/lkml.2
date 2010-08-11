Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759133Ab0HKX6r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 19:58:47 -0400
Received: from kroah.org ([198.145.64.141]:43397 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759026Ab0HKX6c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:58:32 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:00 2010
Message-Id: <20100811235500.874771284@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:54:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Matthew Wilcox <willy@linux.intel.com>,
        Chris Mason <chris.mason@oracle.com>, Jeff Mahoney <jeffm@suse.com>
Subject: [058/111] Btrfs: Show discard option in /proc/mounts
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Matthew Wilcox <matthew@wil.cx>

commit 20a5239a5d0f340e29827a6a2d28a138001c44b8 upstream.

Christoph's patch e244a0aeb6a599c19a7c802cda6e2d67c847b154 doesn't display
the discard option in /proc/mounts, leading to some confusion for me.
Here's the missing bit.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
Signed-off-by: Chris Mason <chris.mason@oracle.com>
Acked-by: Jeff Mahoney <jeffm@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>


---
 fs/btrfs/super.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -457,6 +457,8 @@ static int btrfs_show_options(struct seq
 		seq_puts(seq, ",notreelog");
 	if (btrfs_test_opt(root, FLUSHONCOMMIT))
 		seq_puts(seq, ",flushoncommit");
+	if (btrfs_test_opt(root, DISCARD))
+		seq_puts(seq, ",discard");
 	if (!(root->fs_info->sb->s_flags & MS_POSIXACL))
 		seq_puts(seq, ",noacl");
 	return 0;


