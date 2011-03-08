Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932074Ab1CHP1Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 10:27:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:55502 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755614Ab1CHPZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 10:25:30 -0500
X-Authority-Analysis: v=1.1 cv=dquaJDitHqzHCdqWSoZ6IgapSuTzW/4TaRYx9N9k4W8= c=1 sm=0 a=woaBbrhj3SwA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=baQDsGYkUlise2-xbzIA:9 a=FBjzRRG2TkE1Il434AP8IcOZQqoA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110308152527.775152850@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 08 Mar 2011 10:22:00 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 2/9] ktest: Start failure timeout on panic too
References: <20110308152158.799699072@goodmis.org>
Content-Disposition: inline; filename=0002-ktest-Start-failure-timeout-on-panic-too.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

Currently we just look for a Call Trace to start the time out
when to reboot the box. But if the kernel panics and does not
show a Call Trace, the test will not reboot the box after
the specified timeout.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/testing/ktest/ktest.pl |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
index 3e3615a..6620fe4 100755
--- a/tools/testing/ktest/ktest.pl
+++ b/tools/testing/ktest/ktest.pl
@@ -820,6 +820,7 @@ sub monitor {
 	}
 
 	if ($full_line =~ /Kernel panic -/) {
+	    $failure_start = time;
 	    $bug = 1;
 	}
 
-- 
1.7.2.3


