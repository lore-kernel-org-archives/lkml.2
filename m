Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754848Ab2IHUhH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 16:37:07 -0400
Received: from merlin.infradead.org ([205.233.59.134]:36165 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab2IHUhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 16:37:03 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Irina Tirdea <irina.tirdea@gmail.com>,
        Pekka Enberg <penberg@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 9/9] perf symbols: Remove BIONIC wrapper around libgen.h
Date: Sat,  8 Sep 2012 17:36:54 -0300
Message-Id: <1347136614-25598-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1347136614-25598-1-git-send-email-acme@infradead.org>
References: <1347136614-25598-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Now that the 2 offenders are fixed, the BIONIC conditional around
libgen.h can be removed.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Pekka Enberg <penberg@kernel.org>
Cc: Irina Tirdea <irina.tirdea@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Link: http://lkml.kernel.org/r/1347116812-93646-4-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index d3b330c..41a15da 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -10,9 +10,7 @@
 #include <linux/rbtree.h>
 #include <stdio.h>
 #include <byteswap.h>
-#if defined(__BIONIC__)
 #include <libgen.h>
-#endif
 
 #ifndef NO_LIBELF_SUPPORT
 #include <libelf.h>
-- 
1.7.1

