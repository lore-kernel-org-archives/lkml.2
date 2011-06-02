Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab1FBTO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 15:14:58 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55056 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753628Ab1FBTO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 15:14:56 -0400
X-Authority-Analysis: v=1.1 cv=rr9DlE2fnT1UeYFJeFag6ks/js+bHNfqVlaSByoS2d4= c=1 sm=0 a=vhdKIqpQuCYA:10 a=HIwvLAw1AxUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=UvKXBI6uy8NvmMw4qVEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110602191454.459106702@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 02 Jun 2011 15:13:37 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 3/3] ktest: Ignore unset values of the minconfig in config_bisect
References: <20110602191334.417940259@goodmis.org>
Content-Disposition: inline; filename=0003-ktest-Ignore-unset-values-of-the-minconfig-in-config.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

By ignoring the unset values of the minconfig in deciding
what to test in the config_bisect can cause the problem
config from being tested too.

Just do not test the configs that are set in the minconfig.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 6c68259..cef28e6 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1480,7 +1480,7 @@ sub process_config_ignore {
 	or dodie "Failed to read $config";
 
     while (<IN>) {
-	if (/^(.*?(CONFIG\S*)(=.*| is not set))/) {
+	if (/^((CONFIG\S*)=.*)/) {
 	    $config_ignore{$2} = $1;
 	}
     }
-- 
1.7.4.4


