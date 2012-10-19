Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965030Ab2JSCt1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:49:27 -0400
Received: from mail.kernel.org ([198.145.19.201]:52415 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965013Ab2JSCtU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:49:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sasha Levin <sasha.levin@oracle.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Dave Jones <davej@redhat.com>
Subject: [ 56/76] fs: prevent use after free in auditing when symlink following was denied
Date: Thu, 18 Oct 2012 19:47:20 -0700
Message-Id: <20121019024359.134989256@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121019024350.087156547@linuxfoundation.org>
References: <20121019024350.087156547@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <sasha.levin@oracle.com>

commit ffd8d101a3a7d3f2e79deee1e342801703b6dc70 upstream.

Commit "fs: add link restriction audit reporting" has added auditing of failed
attempts to follow symlinks. Unfortunately, the auditing was being done after
the struct path structure was released earlier.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Cc: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/namei.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -692,9 +692,9 @@ static inline int may_follow_link(struct
 	if (parent->i_uid == inode->i_uid)
 		return 0;
 
+	audit_log_link_denied("follow_link", link);
 	path_put_conditional(link, nd);
 	path_put(&nd->path);
-	audit_log_link_denied("follow_link", link);
 	return -EACCES;
 }
 


