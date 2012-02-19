Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2BSO3R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 09:29:17 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:56389 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911Ab2BSO3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 09:29:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of koct9i@gmail.com designates 10.205.133.196 as permitted sender) smtp.mail=koct9i@gmail.com; dkim=pass header.i=koct9i@gmail.com
Subject: [PATCH] percpu: fix generic definition of __this_cpu_add_and_return()
To: Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux-foundation.org>
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 19 Feb 2012 18:29:11 +0400
Message-ID: <20120219142911.12300.7497.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds missed "__" into function prefix.
Otherwise on all archectures (except x86) it expands to irq/preemtion-safe
variant: _this_cpu_generic_add_return(), which do extra irq-save/irq-restore.
Optimal generic implementation is __this_cpu_generic_add_return().

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/percpu.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 32cd1f6..3b609eb 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -718,7 +718,8 @@ do {									\
 # ifndef __this_cpu_add_return_8
 #  define __this_cpu_add_return_8(pcp, val)	__this_cpu_generic_add_return(pcp, val)
 # endif
-# define __this_cpu_add_return(pcp, val)	__pcpu_size_call_return2(this_cpu_add_return_, pcp, val)
+# define __this_cpu_add_return(pcp, val)	\
+	__pcpu_size_call_return2(__this_cpu_add_return_, pcp, val)
 #endif
 
 #define __this_cpu_sub_return(pcp, val)	this_cpu_add_return(pcp, -(val))

