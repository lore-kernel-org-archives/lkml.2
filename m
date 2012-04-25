Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758741Ab2DYL0f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:26:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50237 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758690Ab2DYL0d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:26:33 -0400
Subject: [PATCH 2/4] bug: completely remove code of disabled VM_BUG_ON()
To: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-arch@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 25 Apr 2012 15:26:29 +0400
Message-ID: <20120425112629.26927.21609.stgit@zurg>
In-Reply-To: <20120425112623.26927.43229.stgit@zurg>
References: <20120425112623.26927.43229.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Even if CONFIG_DEBUG_VM=n gcc genereates code for some VM_BUG_ON()

bloat-o-meter: add/remove: 0/1 grow/shrink: 10/120 up/down: 185/-1889 (-1704)

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 include/linux/mmdebug.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mmdebug.h b/include/linux/mmdebug.h
index c04ecfe..9c9a2a0 100644
--- a/include/linux/mmdebug.h
+++ b/include/linux/mmdebug.h
@@ -4,7 +4,7 @@
 #ifdef CONFIG_DEBUG_VM
 #define VM_BUG_ON(cond) BUG_ON(cond)
 #else
-#define VM_BUG_ON(cond) do { (void)(cond); } while (0)
+#define VM_BUG_ON(cond) unused_expression(cond)
 #endif
 
 #ifdef CONFIG_DEBUG_VIRTUAL

