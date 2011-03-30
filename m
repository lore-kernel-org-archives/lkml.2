Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965419Ab1C3Vq7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 17:46:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:23361 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964843Ab1C3VHo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 17:07:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,270,1299484800"; 
   d="scan'208";a="621237197"
From: Andi Kleen <andi@firstfloor.org>
References: <20110330203.501921634@firstfloor.org>
In-Reply-To: <20110330203.501921634@firstfloor.org>
To: dann.frazier@canonical.com, joel.becker@oracle.com, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org,
        tim.bird@am.sony.com
Subject: [PATCH] [114/275] ocfs2_connection_find() returns pointer to bad structure
Message-Id: <20110330210553.B12413E1A05@tassilo.jf.intel.com>
Date: Wed, 30 Mar 2011 14:05:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ocfs2/stack_user.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.35.y/fs/ocfs2/stack_user.c
===================================================================
--- linux-2.6.35.y.orig/fs/ocfs2/stack_user.c	2011-03-29 22:51:23.042133577 -0700
+++ linux-2.6.35.y/fs/ocfs2/stack_user.c	2011-03-29 23:03:00.557285910 -0700
@@ -191,7 +191,7 @@
 			return c;
 	}
 
-	return c;
+	return NULL;
 }
 
 /*
