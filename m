Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757008Ab2KXIcH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:32:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40249 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2KXIb2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:28 -0500
Message-Id: <20121124083139.691424172@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:24 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 6/8] kcmp selftests: build fix
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-kcmp-build.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For old glibc there's no the syscall number this tests will cause
make run_tests fail.
Add a macro to define the number. This should be ok because it will be
built in latest kernel source.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/kcmp/kcmp_test.c |    3 +++
 1 file changed, 3 insertions(+)

--- linux-2.6.orig/tools/testing/selftests/kcmp/kcmp_test.c	2012-11-23 22:37:04.789058192 +0800
+++ linux-2.6/tools/testing/selftests/kcmp/kcmp_test.c	2012-11-23 22:38:43.195191747 +0800
@@ -17,6 +17,9 @@
 #include <sys/stat.h>
 #include <sys/wait.h>
 
+#ifndef __NR_kcmp
+#define __NR_kcmp 272
+#endif
 static long sys_kcmp(int pid1, int pid2, int type, int fd1, int fd2)
 {
 	return syscall(__NR_kcmp, pid1, pid2, type, fd1, fd2);

