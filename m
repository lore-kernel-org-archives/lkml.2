Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964821Ab2KXId2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:33:28 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753479Ab2KXIb1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:27 -0500
Message-Id: <20121124083138.174041677@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:21 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 3/8] cpu-hotplug selftests: print failure status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-cpu-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  bash-4.1$ make -C cpu-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
  ./on-off-test.sh
  make: execvp: ./on-off-test.sh: Permission denied
  make: *** [run_tests] Error 127
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
  
After applying the patch:
  bash-4.1$ make -C cpu-hotplug run_tests
  make: Entering directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'
  /bin/sh: ./on-off-test.sh: Permission denied
  cpu-hotplug selftests: [FAIL]
  make: Leaving directory `/home/dave/git/linux-2.6/tools/testing/selftests/cpu-hotplug'

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/cpu-hotplug/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/tools/testing/selftests/cpu-hotplug/Makefile	2012-11-23 22:37:04.905724227 +0800
+++ linux-2.6/tools/testing/selftests/cpu-hotplug/Makefile	2012-11-23 22:38:43.125192126 +0800
@@ -1,6 +1,6 @@
 all:
 
 run_tests:
-	./on-off-test.sh
+	@./on-off-test.sh || echo "cpu-hotplug selftests: [FAIL]"
 
 clean:

