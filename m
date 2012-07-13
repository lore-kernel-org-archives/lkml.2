Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2GMTio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 15:38:44 -0400
Received: from juliette.telenet-ops.be ([195.130.137.74]:56304 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752645Ab2GMTin (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 15:38:43 -0400
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Tony Breeds <tony@bakeyournoodle.com>, linux-am33-list@redhat.com,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] mn10300: Only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
Date: Fri, 13 Jul 2012 21:38:33 +0200
Message-Id: <1342208313-28926-1-git-send-email-geert@linux-m68k.org>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the current (gcc 4.6.3) no longer provides this so make it
conditional.

As reported by Tony before, the mn10300 architecture cross-compiles with
gcc-4.6.3 if -mmem-funcs is not added to KBUILD_CFLAGS.

Reported-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
Only compile-tested, not run-tested due to lack of hardware.

Is this -mmem-funcs option mandatory to get a bootable kernel?
If no, please take/ack this patch so we can get one more architecture
green.
If yes, we need support for it in upstream gcc. But even in that case,
it would be nice to take/ack it so we can detect future build regressions.

 arch/mn10300/Makefile |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/mn10300/Makefile b/arch/mn10300/Makefile
index 33188b6..a3d0fef 100644
--- a/arch/mn10300/Makefile
+++ b/arch/mn10300/Makefile
@@ -26,7 +26,7 @@ CHECKFLAGS	+=
 PROCESSOR	:= unset
 UNIT		:= unset
 
-KBUILD_CFLAGS	+= -mam33 -mmem-funcs -DCPU=AM33
+KBUILD_CFLAGS	+= -mam33 -DCPU=AM33 $(call cc-option,-mmem-funcs,)
 KBUILD_AFLAGS	+= -mam33 -DCPU=AM33
 
 ifeq ($(CONFIG_MN10300_CURRENT_IN_E2),y)
-- 
1.7.0.4

