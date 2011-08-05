Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1HEVNS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 17:13:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33514 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1HEVNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 17:13:09 -0400
X-Authority-Analysis: v=1.1 cv=Pm0sEXe2MdIPK/rOEC7hwDW84D/yDsPO3JtCzsVYOFU= c=1 sm=0 a=vhdKIqpQuCYA:10 a=jSsYPeIuRhoA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=meVymXHHAAAA:8 a=ypmUsLejEkFimdOkLKMA:9 a=QNHPeVSe8ckgUiPhkGMA:7 a=jeBq3FmKZ4MA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Message-Id: <20110805211302.691098692@goodmis.org>
User-Agent: quilt/0.48-1
Date: Fri, 05 Aug 2011 16:59:29 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>,
        Julia Lawall <julia@diku.dk>
Subject: [RFC][PATCH 8/8] perf/events: Correct size given to memset
References: <20110805205921.909038487@goodmis.org>
Content-Disposition: inline; filename=0008-perf-events-Correct-size-given-to-memset.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

This is a forward port of commit 5660ce34241ab
perf tools: Correct size given to memset
written by Julia Lawall and forward ported by Steven Rostedt.

Signed-off-by: Julia Lawall <julia@diku.dk>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 tools/lib/events/event-parse.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/lib/events/event-parse.c b/tools/lib/events/event-parse.c
index 3e9af2c..10e936f 100644
--- a/tools/lib/events/event-parse.c
+++ b/tools/lib/events/event-parse.c
@@ -2076,7 +2076,7 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
 			goto out_free;
 
 		field = malloc_or_die(sizeof(*field));
-		memset(field, 0, sizeof(field));
+		memset(field, 0, sizeof(*field));
 
 		value = arg_eval(arg);
 		field->value = strdup(value);
-- 
1.7.5.4


