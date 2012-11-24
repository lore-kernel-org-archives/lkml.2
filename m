Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756936Ab2KXIbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:31:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756894Ab2KXIb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:29 -0500
Message-Id: <20121124083140.791341108@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:26 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 8/8] breakpoint selftests: print failure status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-breakpoints.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case breakpoint test exit non zero value it will cause make error.
Better way is just print the test failure status.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/breakpoints/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/tools/testing/selftests/breakpoints/Makefile	2012-11-23 22:37:04.749058409 +0800
+++ linux-2.6/tools/testing/selftests/breakpoints/Makefile	2012-11-23 22:38:43.221858269 +0800
@@ -17,7 +17,7 @@ else
 endif
 
 run_tests:
-	./breakpoint_test
+	@./breakpoint_test || echo "breakpoints selftests: [FAIL]"
 
 clean:
 	rm -fr breakpoint_test

