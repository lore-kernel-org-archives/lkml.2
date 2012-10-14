Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755132Ab2JNO77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 10:59:59 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46490 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932172Ab2JNOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:22 -0400
Message-Id: <20121014143547.422134137@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Tony Breeds <tony@bakeyournoodle.com>,
        David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 101/147] mn10300: only add -mmem-funcs to KBUILD_CFLAGS if gcc supports it
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert@linux-m68k.org>

commit 9957423f035c2071f6d1c5d2f095cdafbeb25ad7 upstream.

It seems the current (gcc 4.6.3) no longer provides this so make it
conditional.

As reported by Tony before, the mn10300 architecture cross-compiles with
gcc-4.6.3 if -mmem-funcs is not added to KBUILD_CFLAGS.

Reported-by: Tony Breeds <tony@bakeyournoodle.com>
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: David Howells <dhowells@redhat.com>
Cc: Koichi Yasutake <yasutake.koichi@jp.panasonic.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/mn10300/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


