Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757365Ab1ERQMi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:12:38 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:41494 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757259Ab1ERQJI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:09:08 -0400
X-Authority-Analysis: v=1.1 cv=ou1QuR4lBR9YeJgEH9ccYmbAdaWqVVq3lOvCKJtMpGM= c=1 sm=0 a=vhdKIqpQuCYA:10 a=LHBU2Ulwkt8A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=2leT-LOfYuQouot-9QgA:9 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110518160906.874565914@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 18 May 2011 12:08:13 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        John Reiser <jreiser@bitwagon.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [PATCH 04/15] ftrace: Add .kprobe.text section to whitelist for recordmcount.c
References: <20110518160809.724215604@goodmis.org>
Content-Disposition: inline; filename=0004-ftrace-Add-.kprobe.text-section-to-whitelist-for-rec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The .kprobe.text section is safe to modify mcount to nop and tracing.
Add it to the whitelist in recordmcount.c and recordmcount.pl.

Cc: John Reiser <jreiser@bitwagon.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Link: http://lkml.kernel.org/r/20110421023737.743350547@goodmis.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 scripts/recordmcount.c  |    1 +
 scripts/recordmcount.pl |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/recordmcount.c b/scripts/recordmcount.c
index 4ebd839..37c5965 100644
--- a/scripts/recordmcount.c
+++ b/scripts/recordmcount.c
@@ -211,6 +211,7 @@ is_mcounted_section_name(char const *const txtname)
 		strcmp(".sched.text",    txtname) == 0 ||
 		strcmp(".spinlock.text", txtname) == 0 ||
 		strcmp(".irqentry.text", txtname) == 0 ||
+		strcmp(".kprobes.text", txtname) == 0 ||
 		strcmp(".text.unlikely", txtname) == 0;
 }
 
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
index 4be0dee..a871cd4 100755
--- a/scripts/recordmcount.pl
+++ b/scripts/recordmcount.pl
@@ -134,6 +134,7 @@ my %text_sections = (
      ".sched.text" => 1,
      ".spinlock.text" => 1,
      ".irqentry.text" => 1,
+     ".kprobes.text" => 1,
      ".text.unlikely" => 1,
 );
 
-- 
1.7.4.4


