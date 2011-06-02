Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1FBTPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:15:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:39879 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753581Ab1FBTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:14:55 -0400
X-Authority-Analysis: v=1.1 cv=5asQ6euaRPJxDdFxwvXsn6JDb7fmFbz8qWDLMfa45gU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=pwPQQj_P18sA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nn75H-gwKS6pqWpxH3UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=ZcncthuALHLocDxX:21 a=s48OujXxuYAY_UqM:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110602191454.018637647@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Jun 2011 15:13:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/3] ktest: Fix result of rebooting the kernel
References: <20110602191334.417940259@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Fix-result-of-rebooting-the-kernel.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The command that is called that reboots the kernel may fail
but the return code is not passed back to the ktest.pl script.
This is because a ';' is used between the two commands and
if the second command fails, only the first command's return
code is returned. Using a '&&' between the two commands fixes
this.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8dc8c3c..6c68259 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -788,7 +788,7 @@ sub wait_for_input
 
 sub reboot_to {
     if ($reboot_type eq "grub") {
-	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch; reboot)'";
+	run_ssh "'(echo \"savedefault --default=$grub_number --once\" | grub --batch && reboot)'";
 	return;
     }
 
-- 
1.7.4.4


