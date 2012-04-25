Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758701Ab2DYL0d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:26:33 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32866 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758671Ab2DYL0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:26:30 -0400
Subject: [PATCH 1/4] compiler.h: introduce unused_expression() macro
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Apr 2012 15:26:23 +0400
Message-ID: <20120425112623.26927.43229.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes we want to check some expressions correctness in compile-time without
generating extra code. "(void)(e)" does not work if expression has side-effects.
This patch introduces macro unused_expression() which helps in this situation.

Cast to "long" required because sizeof does not work for bit-fields.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/compiler.h |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/compiler.h b/include/linux/compiler.h
index 923d093..46fbda3 100644
--- a/include/linux/compiler.h
+++ b/include/linux/compiler.h
@@ -310,4 +310,6 @@ void ftrace_likely_update(struct ftrace_branch_data *f, int val, int expect);
  */
 #define ACCESS_ONCE(x) (*(volatile typeof(x) *)&(x))
 
+#define unused_expression(e) ((void)(sizeof((__force long)(e))))
+
 #endif /* __LINUX_COMPILER_H */

