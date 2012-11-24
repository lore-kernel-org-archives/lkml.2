Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2KXIdB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:33:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab2KXIb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:27 -0500
Message-Id: <20121124083138.648113811@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:22 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 4/8] mem-hotplug selftests: print failure status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-memory-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  bash-4.1$ make -C memory-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
  ./on-off-test.sh
  make: execvp: ./on-off-test.sh: Permission denied
  make: *** [run_tests] Error 127
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
  
After applying the patch:
  bash-4.1$ make -C memory-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'
  /bin/sh: ./on-off-test.sh: Permission denied
  memory-hotplug selftests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/memory-hotplug'

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/memory-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/tools/testing/selftests/memory-hotplug/Makefile	2012-11-23 22:37:04.869057759 +0800
+++ linux-2.6/tools/testing/selftests/memory-hotplug/Makefile	2012-11-23 22:38:43.148525333 +0800
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	./on-off-test.sh
+	@./on-off-test.sh || echo "memory-hotplug selftests: [FAIL]"
 
 clean:

