Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1B1Qg4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 11:36:56 -0500
Received: from kroah.org ([198.145.64.141]:41170 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755143Ab1B1Qgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 11:36:53 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Feb 28 08:24:06 2011
Message-Id: <20110228162406.171285427@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Mon, 28 Feb 2011 08:22:26 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        dann frazier <dann.frazier@canonical.com>,
        Joel Becker <joel.becker@oracle.com>
Subject: [05/68] ocfs2_connection_find() returns pointer to bad structure
In-Reply-To: <20110228163502.GA27221@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

------------------

From: dann frazier <dann.frazier@canonical.com>

commit 226291aa4641fa13cb5dec3bcb3379faa83009e2 upstream.

If ocfs2_live_connection_list is empty, ocfs2_connection_find() will return
a pointer to the LIST_HEAD, cast as a ocfs2_live_connection. This can cause
an oops when ocfs2_control_send_down() dereferences c->oc_conn:

Call Trace:
  [<ffffffffa00c2a3c>] ocfs2_control_message+0x28c/0x2b0 [ocfs2_stack_user]
  [<ffffffffa00c2a95>] ocfs2_control_write+0x35/0xb0 [ocfs2_stack_user]
  [<ffffffff81143a88>] vfs_write+0xb8/0x1a0
  [<ffffffff8155cc13>] ? do_page_fault+0x153/0x3b0
  [<ffffffff811442f1>] sys_write+0x51/0x80
  [<ffffffff810121b2>] system_call_fastpath+0x16/0x1b

Fix by explicitly returning NULL if no match is found.

Signed-off-by: dann frazier <dann.frazier@canonical.com>
Signed-off-by: Joel Becker <joel.becker@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ocfs2/stack_user.c
+++ b/fs/ocfs2/stack_user.c
@@ -191,7 +191,7 @@ static struct ocfs2_live_connection *ocf
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*


