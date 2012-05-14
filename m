Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757349Ab2ENRTf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 13:19:35 -0400
Received: from smtp.outflux.net ([198.145.64.163]:46903 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757146Ab2ENRTe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 13:19:34 -0400
Date: Mon, 14 May 2012 10:19:28 -0700
From: Kees Cook <keescook@chromium.org>
To: James Morris <james.l.morris@oracle.com>
Cc: linux-security-module@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        John Johansen <john.johansen@canonical.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Yama: replace capable() with ns_capable()
Message-ID: <20120514171928.GA21943@www.outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When checking capabilities, the question we want to be asking is "does
current() have the capability in the child's namespace?"

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 security/yama/yama_lsm.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index afb04cb..7ba673b 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -264,11 +264,11 @@ static int yama_ptrace_access_check(struct task_struct *child,
 		case YAMA_SCOPE_RELATIONAL:
 			if (!task_is_descendant(current, child) &&
 			    !ptracer_exception_found(current, child) &&
-			    !capable(CAP_SYS_PTRACE))
+			    !ns_capable(task_user_ns(child), CAP_SYS_PTRACE))
 				rc = -EPERM;
 			break;
 		case YAMA_SCOPE_CAPABILITY:
-			if (!capable(CAP_SYS_PTRACE))
+			if (!ns_capable(task_user_ns(child), CAP_SYS_PTRACE))
 				rc = -EPERM;
 			break;
 		case YAMA_SCOPE_NO_ATTACH:
-- 
1.7.0.4

-- 
Kees Cook
Chrome OS Security
