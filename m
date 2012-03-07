Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754647Ab2CGVW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:22:27 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56168 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab2CGVW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:22:26 -0500
Date: Thu, 8 Mar 2012 01:22:21 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Kees Cook <keescook@chromium.org>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>, Paul Bolle <pebolle@tiscali.nl>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm] prctl: Use CAP_SYS_RESOURCE for PR_SET_MM option
Message-ID: <20120307212221.GD6215@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAP_SYS_ADMIN is already overloaded left and right,
so to have more fine-grained access control use
CAP_SYS_RESOURCE here.

The CAP_SYS_RESOUCE is chosen because this prctl
option allows a current process to adjust some
fields of memory map descriptor which rather
represents what the process owns: pointers to
code, data, stack segments, command line,
auxiliary vector data and etc.

Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
Acked-by: Kees Cook <keescook@chromium.org>
Acked-by: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: Paul Bolle <pebolle@tiscali.nl>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Typo is fixed.

 kernel/sys.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -1712,7 +1712,7 @@ static int prctl_set_mm(int opt, unsigne
 	if (arg5 || (arg4 && opt != PR_SET_MM_AUXV))
 		return -EINVAL;
 
-	if (!capable(CAP_SYS_ADMIN))
+	if (!capable(CAP_SYS_RESOURCE))
 		return -EPERM;
 
 	if (addr >= TASK_SIZE)
