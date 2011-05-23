Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab1EWNxT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 09:53:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:53155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753994Ab1EWNxQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 09:53:16 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=lIX4sRQ4jyAA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nn75H-gwKS6pqWpxH3UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110523135314.353670787@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 23 May 2011 09:51:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/6] ktest: Fix post install command
References: <20110523135120.309567301@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Fix-post-install-command.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The command to run post install (for those that want initrds) was
broken. Instead of doing a substitution for the $KERNEL_VERSION
variable. It was replacing the entire command with nothing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 8ce792e..7301d03 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -907,7 +907,7 @@ sub install {
     return if (!defined($post_install));
 
     my $cp_post_install = $post_install;
-    $cp_post_install = s/\$KERNEL_VERSION/$version/g;
+    $cp_post_install =~ s/\$KERNEL_VERSION/$version/g;
     run_command "$cp_post_install" or
 	dodie "Failed to run post install";
 }
-- 
1.7.4.4


