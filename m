Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab1HLNcb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 09:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17201 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752479Ab1HLNcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 09:32:23 -0400
From: Andrew Jones <drjones@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: drjones@redhat.com, rostedt@goodmis.org
Subject: [PATCH 02/10] ktest: small cleanup
Date: Fri, 12 Aug 2011 15:32:04 +0200
Message-Id: <1313155932-20092-3-git-send-email-drjones@redhat.com>
In-Reply-To: <1313155932-20092-1-git-send-email-drjones@redhat.com>
References: <1313155932-20092-1-git-send-email-drjones@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

only save the .config file if we're doing mrproper

Signed-off-by: Andrew Jones <drjones@redhat.com>
---
 tools/testing/ktest/ktest.pl |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 7c0b201..f1358c5 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1272,15 +1272,15 @@ sub build {
 	# allow for empty configs
 	run_command "touch $output_config";
 
-	run_command "mv $output_config $outputdir/config_temp" or
-	    dodie "moving .config";
+	if (!$noclean) {
+	    run_command "mv $output_config $outputdir/config_temp" or
+		dodie "moving .config";
 
-	if (!$noclean && !run_command "$make mrproper") {
-	    dodie "make mrproper";
-	}
+	    run_command "$make mrproper" or dodie "make mrproper";
 
-	run_command "mv $outputdir/config_temp $output_config" or
-	    dodie "moving config_temp";
+	    run_command "mv $outputdir/config_temp $output_config" or
+		dodie "moving config_temp";
+	}
 
     } elsif (!$noclean) {
 	unlink "$output_config";
-- 
1.7.4.1

