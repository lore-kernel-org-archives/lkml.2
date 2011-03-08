Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755960Ab1CHPZe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:25:34 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55482 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab1CHPZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:29 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=pdo29kblASgA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=_M-mZM7vD_ZjcL4dt-UA:9 a=cN03hAW91wsp1vTxznH67cec6kkA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152527.415017121@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:21:59 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/9] ktest: Print logfile name on failure
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0001-ktest-Print-logfile-name-on-failure.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

If the test fails and a logfile was specified. Print the name to
let the user know where to look for more information on the
failure.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index e1c62ee..3e3615a 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -462,6 +462,10 @@ sub dodie {
 	`$power_off`;
     }
 
+    if (defined($opt{"LOG_FILE"})) {
+	print " See $opt{LOG_FILE} for more info.\n";
+    }
+
     die @_, "\n";
 }
 
-- 
1.7.2.3


