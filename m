Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756385Ab1DYUXq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:23:46 -0400
Received: from 1wt.eu ([62.212.114.60]:33804 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756242Ab1DYUXo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:23:44 -0400
Message-Id: <20110425200234.514733428@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:03:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: dann frazier <dann.frazier@canonical.com>,
        Joel Becker <joel.becker@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 035/173] ocfs2_connection_find() returns pointer to bad structure
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

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


