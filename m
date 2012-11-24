Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab2KXIbv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 03:31:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37222 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756874Ab2KXIb3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 03:31:29 -0500
Message-Id: <20121124083140.241502487@redhat.com>
User-Agent: quilt/0.48-1
Date: Sat, 24 Nov 2012 16:29:25 +0800
From: dyoung@redhat.com
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Cc: Dave Young <dyoung@redhat.com>
Subject: [patch 7/8] kcmp selftests: print fail status instead of cause make error
References: <20121124082918.671430919@redhat.com>
Content-Disposition: inline; filename=fix-kcmp-2.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case kcmp_test exit non zero value it will cause make error.
Better way is just print the test failure status.

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 tools/testing/selftests/kcmp/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-2.6.orig/tools/testing/selftests/kcmp/Makefile	2012-11-23 23:10:18.000000000 +0800
+++ linux-2.6/tools/testing/selftests/kcmp/Makefile	2012-11-23 23:11:52.474414896 +0800
@@ -22,7 +22,7 @@ else
 endif
 
 run_tests: all
-	./kcmp_test
+	@./kcmp_test || echo "kcmp_test: [FAIL]"
 
 clean:
 	rm -fr ./run_test

