Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1HSCnf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 22:43:35 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:35987 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752098Ab1HSCne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 22:43:34 -0400
X-Authority-Analysis: v=1.1 cv=s3eDhkhcaTLnj7IEXy8aaXUiY7FbET0mf+/2Xe0elbc= c=1 sm=0 a=poF6ICSe450A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=hD80L64hAAAA:8 a=pGLkceISAAAA:8 a=meVymXHHAAAA:8 a=uZzB4uCBtwBe02ULVPwA:9 a=9hNdVQouoWKd_NWpvHQA:7 a=PUjeQqilurYA:10 a=v3rLFGiuRE8A:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL][v3.1] ftrace: Fix README to state tracing_on to
 start/stop tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Geunsik Lim <geunsik.lim@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 18 Aug 2011 22:43:31 -0400
Message-ID: <1313721812.15704.85.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

This patch isn't critical but it is rather embarrassing that
tracing_enabled has been marked deprecated, but we still report to use
it in the README file. This patch has extremely low risk in breaking
anything and fixes an embarrassing documentation issue.

I would like to see this fixed in the next major release.

Thanks!

Please pull the latest tip/perf/urgent tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/urgent

Head SHA1: 7bd09e1564b3d3534c8f5b32566dc5427d22c372


Geunsik Lim (1):
      ftrace: Fix README to state tracing_on to start/stop tracing

----
 kernel/trace/trace.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)
---------------------------
commit 7bd09e1564b3d3534c8f5b32566dc5427d22c372
Author: Geunsik Lim <geunsik.lim@samsung.com>
Date:   Fri Aug 12 14:30:22 2011 +0900

    ftrace: Fix README to state tracing_on to start/stop tracing
    
    tracing_enabled option is deprecated.
    To start/stop tracing, write to /sys/kernel/debug/tracing/tracing_on
    without tracing_enabled. This patch is based on Linux 3.1.0-rc1
    
    Signed-off-by: Geunsik Lim <geunsik.lim@samsung.com>
    Link: http://lkml.kernel.org/r/1313127022-23830-1-git-send-email-leemgs1@gmail.com
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index e5df02c..91abdbf 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -2710,9 +2710,9 @@ static const char readme_msg[] =
 	"# cat /sys/kernel/debug/tracing/trace_options\n"
 	"noprint-parent nosym-offset nosym-addr noverbose\n"
 	"# echo print-parent > /sys/kernel/debug/tracing/trace_options\n"
-	"# echo 1 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 1 > /sys/kernel/debug/tracing/tracing_on\n"
 	"# cat /sys/kernel/debug/tracing/trace > /tmp/trace.txt\n"
-	"# echo 0 > /sys/kernel/debug/tracing/tracing_enabled\n"
+	"# echo 0 > /sys/kernel/debug/tracing/tracing_on\n"
 ;
 
 static ssize_t


