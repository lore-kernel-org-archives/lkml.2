Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756866Ab2KXIb2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:31:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10150 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752853Ab2KXIb0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:26 -0500
Message-Id: <20121124083137.114233616@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:19 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 1/8] vm selftests: print failure status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-vmtests.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  bash-4.1$ make -C vm run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'
  /bin/sh ./run_vmtests
  ./run_vmtests: line 24: /proc/sys/vm/nr_hugepages: Permission denied
  Please run this test as root
  make: *** [run_tests] Error 1
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'

After applying the patch:
  bash-4.1$ make -C vm run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'
  ./run_vmtests: line 24: /proc/sys/vm/nr_hugepages: Permission denied
  Please run this test as root
  vmtests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/vm'

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/vm/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/tools/testing/selftests/vm/Makefile	2012-11-23 22:37:04.985723793 +0800
+++ linux-2.6/tools/testing/selftests/vm/Makefile	2012-11-23 22:38:43.075192397 +0800
@@ -8,7 +8,7 @@ all: hugepage-mmap hugepage-shm  map_hug
 	$(CC) $(CFLAGS) -o $@ $^
 
 run_tests: all
-	/bin/sh ./run_vmtests
+	@/bin/sh ./run_vmtests || echo "vmtests: [FAIL]"
 
 clean:
 	$(RM) hugepage-mmap hugepage-shm  map_hugetlb

