Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758638Ab2CGMwX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 07:52:23 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34673 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757715Ab2CGMwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 07:52:21 -0500
Date: Wed, 7 Mar 2012 16:52:17 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        Pavel Emelyanov <xemul@parallels.com>, Tejun Heo <tj@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATCH] prctl: Use CAP_SYS_RESOUCE for PR_SET_MM option
Message-ID: <20120307125217.GC20558@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CAP_SYS_ADMIN is already overloaded left and right,
so to have more finegrained access control use
CAP_SYS_RESOUCE here.

The CAP_SYS_RESOUCE is chosen because this prctl
option allows a current process to adjust some
fields of memory map descriptor which rather
represent what the process owns: pointers to
code, data, stack segments, command line,
auxilary vector data and etc.

Suggested-by: Michael Kerrisk <mtk.manpages@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Emelyanov <xemul@parallels.com>
CC: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Kees Cook <keescook@chromium.org>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---
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
