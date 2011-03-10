Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753430Ab1CJQAt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:00:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:41178 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752550Ab1CJP7N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 10:59:13 -0500
X-Authority-Analysis: v=1.1 cv=UQuFHoD2CPQ248x8AXEbKhr4z9AaDqApxmEl3BhfZ64= c=1 sm=0 a=S2mbvSiwNDUA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=WXfvmbAI4Rpl6lzlBgQA:9 a=XyqPVa_guuUqm1lPd5VNMU-dniIA:4 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110310155911.537759130@goodmis.org>
User-Agent: quilt/0.48-1
Date: Thu, 10 Mar 2011 10:58:10 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 10/15] ftrace: Add .ref.text as one of the safe areas to trace
References: <20110310155800.478792851@goodmis.org>
Content-Disposition: inline; filename=0010-ftrace-Add-.ref.text-as-one-of-the-safe-areas-to-tra.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The section .ref.text will not go away unexpectedly and is
safe to trace. Add it to the safe list of sections to allow
tracing.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c  |    3 ++-
 scripts/recordmcount.pl |    1 +
 2 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 038b3d1..f9f6f52 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -206,7 +206,8 @@ static uint32_t (*w2)(uint16_t);
 static int
 is_mcounted_section_name(char const *const txtname)
 {
-	return 0 == strcmp(".text",          txtname) ||
+	return 0 == strcmp(".text",           txtname) ||
+		0 == strcmp(".ref.text",      txtname) ||
 		0 == strcmp(".sched.text",    txtname) ||
 		0 == strcmp(".spinlock.text", txtname) ||
 		0 == strcmp(".irqentry.text", txtname) ||
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 1d7963f..4be0dee 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -130,6 +130,7 @@ if ($inputfile =~ m,kernel/trace/ftrace\.o$,) {
 # Acceptable sections to record.
 my %text_sections = (
      ".text" => 1,
+     ".ref.text" => 1,
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
-- 
1.7.2.3


