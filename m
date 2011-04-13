Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab1DMMmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 08:42:08 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:60527 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750752Ab1DMMmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 08:42:06 -0400
From: Richard Weinberger <richard@nod.at>
To: akpm@linux-foundation.com
Cc: slyich@gmail.com, linux-kernel@vger.kernel.org, jdike@addtoit.com,
        user-mode-linux-devel@lists.sourceforge.net,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 1/2] um: Fix call tracer and bug handler
Date: Wed, 13 Apr 2011 14:41:51 +0200
Message-Id: <1302698512-11979-1-git-send-email-richard@nod.at>
X-Mailer: git-send-email 1.6.6.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 1de1502c (x86, um: now we can get rid of trivial uml headers)
removed accidentally bug.h which broke UML's call tracer and
bug handler.
Without asm-generic/bug.h UML uses BUG() from arch/x86/
which makes use of ud2.
UML cannot use ud2, it raises SIGILL in user mode.
As UML has a different stack for handling signals the call trace
will be cut off.

Reported-by: Sergei Trofimovich <slyich@gmail.com>
Tested-by: Sergei Trofimovich <slyich@gmail.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 arch/um/include/asm/bug.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)
 create mode 100644 arch/um/include/asm/bug.h

diff --git a/arch/um/include/asm/bug.h b/arch/um/include/asm/bug.h
new file mode 100644
index 0000000..9e33b86
--- /dev/null
+++ b/arch/um/include/asm/bug.h
@@ -0,0 +1,6 @@
+#ifndef __UM_BUG_H
+#define __UM_BUG_H
+
+#include <asm-generic/bug.h>
+
+#endif
-- 
1.6.6.1

