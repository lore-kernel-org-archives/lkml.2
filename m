Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758820Ab2DYL0k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:26:40 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:32866 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758739Ab2DYL0h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:26:37 -0400
Subject: [PATCH 3/4] bug: completely remove code of disabled BUG_ON()
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Apr 2012 15:26:33 +0400
Message-ID: <20120425112633.26927.71303.stgit@zurg>
In-Reply-To: <20120425112623.26927.43229.stgit@zurg>
References: <20120425112623.26927.43229.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if CONFIG_BUG=n gcc generates code for some BUG_ON()

bloat-o-meter: add/remove: 2/9 grow/shrink: 25/229 up/down: 1053/-5019 (-3966)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/asm-generic/bug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/asm-generic/bug.h b/include/asm-generic/bug.h
index 2520a6e..aadb6fc 100644
--- a/include/asm-generic/bug.h
+++ b/include/asm-generic/bug.h
@@ -112,7 +112,7 @@ extern void warn_slowpath_null(const char *file, const int line);
 #endif
 
 #ifndef HAVE_ARCH_BUG_ON
-#define BUG_ON(condition) do { if (condition) ; } while(0)
+#define BUG_ON(condition) unused_expression(condition)
 #endif
 
 #ifndef HAVE_ARCH_WARN_ON

