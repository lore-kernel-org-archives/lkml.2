Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755145Ab2FON4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 09:56:53 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:45596 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751375Ab2FON4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 09:56:52 -0400
Date: Fri, 15 Jun 2012 17:56:47 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>,
        Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH] c/r: prctl: Move PR_GET_TID_ADDRESS to a proper place
Message-ID: <20120615135647.GC2464@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During merging of PR_GET_TID_ADDRESS patch the code
has been misplaced (it happened to appear under PR_MCE_KILL)
in result noone can use this option.

Fix it by moving code snippet to a proper place.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: Kees Cook <keescook@chromium.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@parallels.com>
Cc: Andrey Vagin <avagin@openvz.org>
Cc: Serge Hallyn <serge.hallyn@canonical.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---

Andrew, I think it get misplaced during merging (the former
patch I sent has this snippet at the proper place). I noticed
this problem only when found that our test suite swears at me
with futex test case.

Anyway, there is nothing critical in this issue, it behaves like
someone has disabled PR_GET_TID_ADDRESS.

The patch is on top of v3.5-rc2

 kernel/sys.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux-2.6.git/kernel/sys.c
===================================================================
--- linux-2.6.git.orig/kernel/sys.c
+++ linux-2.6.git/kernel/sys.c
@@ -2127,9 +2127,6 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 				else
 					return -EINVAL;
 				break;
-		case PR_GET_TID_ADDRESS:
-			error = prctl_get_tid_address(me, (int __user **)arg2);
-			break;
 			default:
 				return -EINVAL;
 			}
@@ -2147,6 +2144,9 @@ SYSCALL_DEFINE5(prctl, int, option, unsi
 		case PR_SET_MM:
 			error = prctl_set_mm(arg2, arg3, arg4, arg5);
 			break;
+		case PR_GET_TID_ADDRESS:
+			error = prctl_get_tid_address(me, (int __user **)arg2);
+			break;
 		case PR_SET_CHILD_SUBREAPER:
 			me->signal->is_child_subreaper = !!arg2;
 			error = 0;
