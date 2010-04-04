Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0DDINd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:13:33 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55384 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0DDINZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:13:25 -0400
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, mitake@dcl.info.waseda.ac.jp,
       h.mitake@gmail.com, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] Swap including order of util.h and string.h of util/string.c
Date: Sun,  4 Apr 2010 17:13:18 +0900
Message-Id: <1270368798-27232-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
X-Mailer: git-send-email 1.6.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current util/string.c includes headers in this order: string.h, util.h
But this causes build error because __USE_GNU definition
is needed for strndup() definition like this,
% make -j
touch .perf.dev.null
    CC util/string.o
cc1: warnings being treated as errors
util/string.c: In function ‘argv_split’:
util/string.c:171: error: implicit declaration of function ‘strndup’
util/string.c:171: error: incompatible implicit declaration of built-in function ‘strndup’

So this patch swaps order of including headers.
util.h defines _GNU_SOURCE, and /usr/include/features.h defines __USE_GNU as 1
if _GNU_SOURCE is defined.

Signed-off-by: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/string.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/string.c b/tools/perf/util/string.c
index d438924..0409fc7 100644
--- a/tools/perf/util/string.c
+++ b/tools/perf/util/string.c
@@ -1,5 +1,5 @@
-#include "string.h"
 #include "util.h"
+#include "string.h"
 
 #define K 1024LL
 /*
-- 
1.6.5.2

