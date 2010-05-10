Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab0EJXSw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:18:52 -0400
Received: from kroah.org ([198.145.64.141]:51657 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932847Ab0EJW5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:57:45 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:36 2010
Message-Id: <20100510223536.669838721@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:34:37 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Jerome Marchand <jmarchan@redhat.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>,
       Miklos Szeredi <mszeredi@suse.cz>,
       Alexey Dobriyan <adobriyan@gmail.com>
Subject: [25/98] procfs: fix tid fdinfo
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jerome Marchand <jmarchan@redhat.com>

commit 3835541dd481091c4dbf5ef83c08aed12e50fd61 upstream.

Correct the file_operations struct in fdinfo entry of tid_base_stuff[].

Presently /proc/*/task/*/fdinfo contains symlinks to opened files like
/proc/*/fd/.

Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@suse.cz>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/proc/base.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2844,7 +2844,7 @@ out_no_task:
  */
 static const struct pid_entry tid_base_stuff[] = {
 	DIR("fd",        S_IRUSR|S_IXUSR, proc_fd_inode_operations, proc_fd_operations),
-	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fd_operations),
+	DIR("fdinfo",    S_IRUSR|S_IXUSR, proc_fdinfo_inode_operations, proc_fdinfo_operations),
 	REG("environ",   S_IRUSR, proc_environ_operations),
 	INF("auxv",      S_IRUSR, proc_pid_auxv),
 	ONE("status",    S_IRUGO, proc_pid_status),


