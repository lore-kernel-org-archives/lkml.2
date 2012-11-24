Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756905Ab2KXIb3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:31:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33461 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753166Ab2KXIb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:26 -0500
Message-Id: <20121124083137.625931698@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:20 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 2/8] mqueue selftests: print failure status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-mqueue.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Original behavior:
  bash-4.1$ make -C mqueue run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
  ./mq_open_tests /test1
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  make: *** [run_tests] Error 1
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'

After applying the patch:
  bash-4.1$ make -C mqueue run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  mq_open_tests: [FAIL]
  Not running as root, but almost all tests require root in order to modify
  system settings.  Exiting.
  mq_perf_tests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/mqueue'

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/mqueue/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- linux-2.6.orig/tools/testing/selftests/mqueue/Makefile	2012-11-23 22:37:04.945724010 +0800
+++ linux-2.6/tools/testing/selftests/mqueue/Makefile	2012-11-23 22:38:43.101858919 +0800
@@ -3,8 +3,8 @@ all:
 	gcc -O2 -lrt -lpthread -lpopt -o mq_perf_tests mq_perf_tests.c
 
 run_tests:
-	./mq_open_tests /test1
-	./mq_perf_tests
+	@./mq_open_tests /test1 || echo "mq_open_tests: [FAIL]"
+	@./mq_perf_tests || echo "mq_perf_tests: [FAIL]"
 
 clean:
 	rm -f mq_open_tests mq_perf_tests

