Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1DUCjm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 22:39:42 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:47909 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab1DUChi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 22:37:38 -0400
X-Authority-Analysis: v=1.1 cv=aqMe+0lCtaYvy4h0jyaoPGyq+DPF+P6rPG2xbekoY9Q= c=1 sm=0 a=vhdKIqpQuCYA:10 a=bNuMndPgQ34A:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=SyI_GHdlAAAA:8 a=3nbZYyFuAAAA:8 a=meVymXHHAAAA:8 a=2leT-LOfYuQouot-9QgA:9 a=jEp0ucaQiEUA:10 a=UQxMgyrMzRwA:10 a=EvKJbDF4Ut8A:10 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110421023737.743350547@goodmis.org>
User-Agent: quilt/0.48-1
Date: Wed, 20 Apr 2011 22:28:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "H. Peter Anvin" <hpa@zytor.com>, John Reiser <jreiser@bitwagon.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: [RFC][PATCH 03/11] ftrace: Add .kprobe.text section to whitelist for recordmcount.c
References: <20110421022825.535486725@goodmis.org>
Content-Disposition: inline; filename=0003-ftrace-Add-.kprobe.text-section-to-whitelist-for-rec.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <srostedt@redhat.com>

The .kprobe.text section is safe to modify mcount to nop and tracing.
Add it to the whitelist in recordmcount.c and recordmcount.pl.

Cc: John Reiser <jreiser@bitwagon.com>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
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
1.7.2.3


