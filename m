Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752850Ab1HLNcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29225 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752593Ab1HLNcV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:21 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 01/10] ktest: create outputdir, if it doesn't exist
Date: Fri, 12 Aug 2011 15:32:03 +0200
Message-Id: <1313155932-20092-2-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8d02ccb..7c0b201 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -2850,9 +2850,11 @@ for (my $i = 1; $i <= $opt{"NUM_TESTS"}; $i++) {
 
     chdir $builddir || die "can't change directory to $builddir";
 
-    if (!-d $tmpdir) {
-	mkpath($tmpdir) or
-	    die "can't create $tmpdir";
+    foreach my $dir ($tmpdir, $outputdir) {
+	if (!-d $dir) {
+	    mkpath($dir) or
+		die "can't create $dir";
+	}
     }
 
     $ENV{"SSH_USER"} = $ssh_user;
-- 
1.7.4.1

