Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753317Ab0HYKWq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:22:46 -0400
Received: from brigitte.telenet-ops.be ([195.130.137.66]:46248 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752735Ab0HYKWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:22:43 -0400
Date: Wed, 25 Aug 2010 12:22:40 +0200 (CEST)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
cc: linux-kbuild@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH] checksyscalls: Fix stand-alone usage
Message-ID: <alpine.DEB.2.00.1008251221270.22455@ayla.of.borg>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The usage help in the comments
  - refers to the wrong script name,
  - doesn't mention that $srctree must be set.

Hence correct the script name, and derive the source tree path from the script
path, so we no longer need to rely on $srctree being set by the caller.

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 scripts/checksyscalls.sh |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
index 6bb42e7..3ab316e 100755
--- a/scripts/checksyscalls.sh
+++ b/scripts/checksyscalls.sh
@@ -6,7 +6,7 @@
 # and listed below so they are ignored.
 #
 # Usage:
-# syscallchk gcc gcc-options
+# checksyscalls.sh gcc gcc-options
 #
 
 ignore_list() {
@@ -204,5 +204,5 @@ sed -n -e '/^\#define/ s/[^_]*__NR_\([^[:space:]]*\).*/\
 \#endif/p' $1
 }
 
-(ignore_list && syscall_list ${srctree}/arch/x86/include/asm/unistd_32.h) | \
+(ignore_list && syscall_list $(dirname $0)/../arch/x86/include/asm/unistd_32.h) | \
 $* -E -x c - > /dev/null
-- 
1.7.0.4

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
