Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753896Ab0LEJvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 04:51:09 -0500
Received: from gerard.telenet-ops.be ([195.130.132.48]:39763 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752017Ab0LEJvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 04:51:07 -0500
Date: Sun, 5 Dec 2010 10:50:56 +0100 (CET)
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Michal Marek <mmarek@suse.cz>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
        Linux Kernel Development <linux-kernel@vger.kernel.org>
Subject: [PATCH/resend] checksyscalls: Fix stand-alone usage
Message-ID: <alpine.DEB.2.00.1012051047510.17705@ayla.of.borg>
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
Acked-by: Sam Ravnborg <sam@ravnborg.org>
---
Sent before on 2010-08-25.

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
