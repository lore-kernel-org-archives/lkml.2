Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2DJKfT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:35:19 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:39382 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753992Ab2DJKfR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:35:17 -0400
Date: Tue, 10 Apr 2012 12:35:13 +0200
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: acme@redhat.com, peterz@infradead.org, mingo@elte.hu, dsahern@gmail.com,
        penberg@kernel.org
Subject: [PATCH] perf tools: fix NO_GTK2 Makefile config error
Message-ID: <20120410103513.GA9229@quad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In case the user specified NO_GTK2 on the make cmdline,
compilation would fail with undefined symbol because the
Makefile would not set the correct cpp variable:
NO_GTK2 vs. NO_GTK2_SUPPORT.

This patch renames the variable to the correct name.
    
Signed-off-by: Stephane Eranian <eranian@google.com>
---

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 820371f..a20d0c5 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -527,7 +527,7 @@ else
 endif
 
 ifdef NO_GTK2
-	BASIC_CFLAGS += -DNO_GTK2
+	BASIC_CFLAGS += -DNO_GTK2_SUPPORT
 else
 	FLAGS_GTK2=$(ALL_CFLAGS) $(ALL_LDFLAGS) $(EXTLIBS) $(shell pkg-config --libs --cflags gtk+-2.0)
 	ifneq ($(call try-cc,$(SOURCE_GTK2),$(FLAGS_GTK2)),y)
