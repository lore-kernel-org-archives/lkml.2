Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757909Ab1DIUzz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 16:55:55 -0400
Received: from paul.0au.de ([94.23.237.123]:40618 "EHLO 0au.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757348Ab1DIUzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 16:55:53 -0400
X-Greylist: delayed 1929 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Apr 2011 16:55:52 EDT
X-Spam-Score: -1.9
Date: Sat, 9 Apr 2011 22:55:32 +0200
From: Valentin Ochs <a@0au.de>
Cc: trivial@kernel.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fixdep: define _POSIX_C_SOURCE
Message-ID: <20110409205532.GE4663@erwin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixdep.c uses PATH_MAX without defining the required _POSIX_C_SOURCE
feature test macro.  This prevents compilation with the musl libc.
The patch applies to 2.6.38.2.

Best regards,
Valentin

Signed-off-by: Valentin Ochs <a@0au.de>
---
--- a/scripts/basic/fixdep.c
+++ b/scripts/basic/fixdep.c
@@ -102,6 +102,7 @@
  * through arch/um/include/uml-config.h; this fixdep "bug" makes sure that
  * those files will have correct dependencies.
  */
+#define _POSIX_C_SOURCE 200809L
 #include <sys/types.h>
 #include <sys/stat.h>
 #include <sys/mman.h>
