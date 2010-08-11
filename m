Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759380Ab0HLAC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 20:02:56 -0400
Received: from kroah.org ([198.145.64.141]:43739 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759327Ab0HKX7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 19:59:31 -0400
X-Mailbox-Line: From gregkh@clark.site Wed Aug 11 16:55:05 2010
Message-Id: <20100811235505.182701792@clark.site>
User-Agent: quilt/0.48-11.2
Date: Wed, 11 Aug 2010 16:55:25 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jan Kara <jack@suse.cz>, Joel Becker <joel.becker@oracle.com>,
        Mark Fasheh <mfasheh@suse.com>
Subject: [104/111] ocfs2: Set MS_POSIXACL on remount
In-Reply-To: <20100811235623.GA24440@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Kara <jack@suse.cz>

commit 57b09bb5e492c37c1e4273fe4e435ffd1d2ddbe0 upstream.

We have to set MS_POSIXACL on remount as well. Otherwise VFS
would not know we started supporting ACLs after remount and
thus ACLs would not work.

Signed-off-by: Jan Kara <jack@suse.cz>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Mark Fasheh <mfasheh@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/super.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/fs/ocfs2/super.c
+++ b/fs/ocfs2/super.c
@@ -701,6 +701,10 @@ unlock_osb:
 
 		if (!ocfs2_is_hard_readonly(osb))
 			ocfs2_set_journal_params(osb);
+
+		sb->s_flags = (sb->s_flags & ~MS_POSIXACL) |
+			((osb->s_mount_opt & OCFS2_MOUNT_POSIX_ACL) ?
+							MS_POSIXACL : 0);
 	}
 out:
 	unlock_kernel();


