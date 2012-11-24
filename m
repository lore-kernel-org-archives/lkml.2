Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757074Ab2KXIck (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:32:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756860Ab2KXIb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:28 -0500
Message-Id: <20121124083139.208239076@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:23 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 5/8] kcmp selftests: make run_tests fix
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-kcmp.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

make run_tests need the target is run_tests instead of run-tests
Also gcc output should be kcmp_test. Fix these two issues.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/kcmp/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/tools/testing/selftests/kcmp/Makefile	2012-11-23 23:08:23.000000000 +0800
+++ linux-2.6/tools/testing/selftests/kcmp/Makefile	2012-11-23 23:10:18.684922998 +0800
@@ -16,12 +16,12 @@ CFLAGS += -I../../../../arch/x86/include
 
 all:
 ifeq ($(ARCH),X86)
-	gcc $(CFLAGS) kcmp_test.c -o run_test
+	gcc $(CFLAGS) kcmp_test.c -o kcmp_test
 else
 	echo "Not an x86 target, can't build kcmp selftest"
 endif
 
-run-tests: all
+run_tests: all
 	./kcmp_test
 
 clean:

