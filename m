Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037Ab2JRTla (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 15:41:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4856 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab2JRTlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 15:41:09 -0400
Date: Thu, 18 Oct 2012 15:41:04 -0400
From: Dave Jones <davej@redhat.com>
To: gorcunov@openvz.org
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] print reason for failure in kcmp_test
Message-ID: <20121018194104.GA15690@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, gorcunov@openvz.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was curious why sys_kcmp wasn't working, which led me to the testcase.
It turned out I hadn't enabled CHECKPOINT_RESTORE in the kernel I was testing.
Add a decoding of errno to the testcase to make that obvious.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/tools/testing/selftests/kcmp/kcmp_test.c b/tools/testing/selftests/kcmp/kcmp_test.c
index 358cc6b..fa4f1b3 100644
--- a/tools/testing/selftests/kcmp/kcmp_test.c
+++ b/tools/testing/selftests/kcmp/kcmp_test.c
@@ -72,7 +72,8 @@ int main(int argc, char **argv)
 		/* This one should return same fd */
 		ret = sys_kcmp(pid1, pid2, KCMP_FILE, fd1, fd1);
 		if (ret) {
-			printf("FAIL: 0 expected but %d returned\n", ret);
+			printf("FAIL: 0 expected but %d returned (%s)\n",
+				ret, strerror(errno));
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
@@ -80,7 +81,8 @@ int main(int argc, char **argv)
 		/* Compare with self */
 		ret = sys_kcmp(pid1, pid1, KCMP_VM, 0, 0);
 		if (ret) {
-			printf("FAIL: 0 expected but %li returned\n", ret);
+			printf("FAIL: 0 expected but %li returned (%s)\n",
+				ret, strerror(errno));
 			ret = -1;
 		} else
 			printf("PASS: 0 returned as expected\n");
