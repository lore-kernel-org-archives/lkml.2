Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab1JZRtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:49:20 -0400
Received: from merlin.infradead.org ([205.233.59.134]:37749 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933785Ab1JZRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:48:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 11/11] perf header: Fix build on old systems
Date: Wed, 26 Oct 2011 15:48:34 -0200
Message-Id: <1319651314-29404-12-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1319651314-29404-1-git-send-email-acme@infradead.org>
References: <1319651314-29404-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

For instance, on Fedora 8:

CC /home/acme/git/build/perf/util/header.o
cc1: warnings being treated as errors
util/header.c: In function ‘write_cpudesc’:
util/header.c:281: warning: implicit declaration of function ‘getline’
util/header.c:281: warning: nested extern declaration of ‘getline’
make: *** [/home/acme/git/build/perf/util/header.o] Error 1
make: Leaving directory `/home/acme/git/linux/tools/perf'
[acme@localhost linux]$

This happens due to header ordering, in perf util.h sets _GNU_SOURCE, so
it must come first.

Reported-by: Ingo Molnar <mingo@elte.hu>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-alfra9wao63euguj7gr8jw7e@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 76c0b2c..bcd05d0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -1,5 +1,6 @@
 #define _FILE_OFFSET_BITS 64
 
+#include "util.h"
 #include <sys/types.h>
 #include <byteswap.h>
 #include <unistd.h>
@@ -11,7 +12,6 @@
 
 #include "evlist.h"
 #include "evsel.h"
-#include "util.h"
 #include "header.h"
 #include "../perf.h"
 #include "trace-event.h"
-- 
1.6.2.5

