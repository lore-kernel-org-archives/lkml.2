Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab1BHNUu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:20:50 -0500
Received: from smtp-out.google.com ([74.125.121.67]:16932 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752811Ab1BHNUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:20:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=message-id:from:date:to:reply-to:cc:subject;
        b=WwS8QvPGaoJAo8qacXrO2Sl8XdGI6X//WiWNdQpLmi/JBUzj8XUbFwKR1jYQXOY55x
         /IFxzcEDv49Af5ya8JIA==
Message-ID: <4d51432a.a7fed80a.1571.fffffe9f@mx.google.com>
From: Stephane Eranian <eranian@google.com>
Date: Tue, 8 Feb 2011 14:20:01 +0200
To: linux-kernel@vger.kernel.org
Reply-to: eranian@google.com
Cc: peterz@infradead.org, mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
        fweisbec@gmail.com, perfmon2-devel@lists.sf.net, eranian@gmail.com,
        eranian@google.com, robert.richter@amd.com, acme@redhat.com
Subject: [PATCH] perf: fix compile error in annotate.h
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following patch is necessary to compile without NEWT.

Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/util/annotate.h b/tools/perf/util/annotate.h
index b1253aa..bc08b36 100644
--- a/tools/perf/util/annotate.h
+++ b/tools/perf/util/annotate.h
@@ -82,7 +82,7 @@ int symbol__tty_annotate(struct symbol *sym, struct map *map, int evidx,
 			 int max_lines);
 
 #ifdef NO_NEWT_SUPPORT
-static inline int symbol__tui_annotate(symbol *sym __used,
+static inline int symbol__tui_annotate(struct symbol *sym __used,
 				       struct map *map __used, int evidx __used)
 {
 	return 0;
