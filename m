Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760661Ab0FQU2T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:28:19 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:4490 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757508Ab0FQU2S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:28:18 -0400
From: "Scott J. Goldman" <scottjg@vmware.com>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-kernel@vger.kernel.org, "Scott J. Goldman" <scottjg@vmware.com>
Subject: [PATCH] checkpatch: fix false positive on casting to double pointer
Date: Thu, 17 Jun 2010 13:26:51 -0700
Message-Id: <1276806411-15176-1-git-send-email-scottjg@vmware.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Scott J. Goldman <scottjg@vmware.com>
---
 scripts/checkpatch.pl         |    4 +++-
 tests/t/t9190-double-pointers |    6 ++++++
 2 files changed, 9 insertions(+), 1 deletions(-)
 create mode 100644 tests/t/t9190-double-pointers

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 87bbb8b..687bd6f 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -1982,7 +1982,9 @@ sub process {
 					 $op eq '*' or $op eq '/' or
 					 $op eq '%')
 				{
-					if ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
+					if ($op eq '*' && $cc =~ /^\*/) {
+						# double pointer is ok
+					} elsif ($ctx =~ /Wx[^WCE]|[^WCE]xW/) {
 						ERROR("need consistent spacing around '$op' $at\n" .
 							$hereptr);
 					}
diff --git a/tests/t/t9190-double-pointers b/tests/t/t9190-double-pointers
new file mode 100644
index 0000000..3f3f7f9
--- /dev/null
+++ b/tests/t/t9190-double-pointers
@@ -0,0 +1,6 @@
+pass "foo **x;"
+pass "x = **y;"
+pass "x = (foo **)y;"
+
+err='"(foo ** )" should be "(foo **)"'
+fail	"x = (foo ** )y;"	"$err"
-- 
1.6.0.3

