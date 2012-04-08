Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab2DHXi3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2012 19:38:29 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47402 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab2DHXi2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2012 19:38:28 -0400
Date: Mon, 9 Apr 2012 03:38:20 +0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Pekka Enberg <penberg@kernel.org>
Cc: Leonid Moiseichuk <leonid.moiseichuk@nokia.com>,
        John Stultz <john.stultz@linaro.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linaro-kernel@lists.linaro.org
Subject: [PATCH 2/3] vmevent-test: No need for SDL library
Message-ID: <20120408233820.GB4839@panacea>
References: <20120408233550.GA3791@panacea>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120408233550.GA3791@panacea>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

panacea:~/src/linux/linux-vmevent/tools/testing/vmevent$ make
cc -O3 -g -std=gnu99 -Wcast-align -Wformat -Wformat-security
-Wformat-y2k -Wshadow -Winit-self -Wpacked -Wredundant-decls
-Wstrict-aliasing=3 -Wswitch-default -Wno-system-headers -Wundef
-Wwrite-strings -Wbad-function-cast -Wmissing-declarations
-Wmissing-prototypes -Wnested-externs -Wold-style-definition
-Wstrict-prototypes -Wdeclaration-after-statement  -lSDL  vmevent-test.c
-o vmevent-test
/usr/bin/ld: cannot find -lSDL
collect2: ld returned 1 exit status
make: *** [vmevent-test] Error 1

This patch fixes the issue.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 tools/testing/vmevent/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/testing/vmevent/Makefile b/tools/testing/vmevent/Makefile
index 5b5505f..d14b5c9 100644
--- a/tools/testing/vmevent/Makefile
+++ b/tools/testing/vmevent/Makefile
@@ -20,7 +20,6 @@ WARNINGS += -Wstrict-prototypes
 WARNINGS += -Wdeclaration-after-statement
 
 CFLAGS  = -O3 -g -std=gnu99 $(WARNINGS)
-LDFLAGS = -lSDL
 
 PROGRAMS = vmevent-test
 
-- 
1.7.7.6

