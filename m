Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753213Ab1GZB1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 21:27:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:47975 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752895Ab1GZBYb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 21:24:31 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=UiDc4r-54BsA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=nn75H-gwKS6pqWpxH3UA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110726012427.165799233@goodmis.org>
User-Agent: quilt/0.48-1
Date: Mon, 25 Jul 2011 21:22:49 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 11/19] ktest: Fix tar extracting of modules to target
References: <20110726012238.271008621@goodmis.org>
Content-Disposition: inline; filename=0011-ktest-Fix-tar-extracting-of-modules-to-target.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The tar command to create the module directory is cjf, but the
extraction only had xf. This works on most versions of tar, but some
versions of tar require xjf for extraction as well.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 24286ce..5b35fa0 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -1087,7 +1087,7 @@ sub install {
 
     unlink "$tmpdir/$modtar";
 
-    run_ssh "'(cd / && tar xf /tmp/$modtar)'" or
+    run_ssh "'(cd / && tar xjf /tmp/$modtar)'" or
 	dodie "failed to tar modules";
 
     run_ssh "rm -f /tmp/$modtar";
-- 
1.7.5.4


