Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880Ab0EMUTf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:19:35 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58323 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932851Ab0EMUTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:19:34 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Paul Mackerras <paulus@samba.org>
Subject: [PATCH 2/4] perf hist: Fix missing getline declaration
Date: Thu, 13 May 2010 17:19:22 -0300
Message-Id: <1273781964-29552-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1273781964-29552-1-git-send-email-acme@infradead.org>
References: <1273781964-29552-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Frederic Weisbecker <fweisbec@gmail.com>

hist.c needs to include util.h so that it gets stdio.h
inclusion with __GNU_SOURCE defined.

Fixes:
	util/hist.c: In function ‘hist_entry__parse_objdump_line’:
	util/hist.c:931: erreur: implicit declaration of function ‘getline’
	util/hist.c:931: erreur: nested extern declaration of ‘getline’

Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
LKML-Reference: <1273772836-11533-1-git-send-regression-fweisbec@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/hist.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/hist.c b/tools/perf/util/hist.c
index 451d2e4..5dc4f84 100644
--- a/tools/perf/util/hist.c
+++ b/tools/perf/util/hist.c
@@ -1,3 +1,4 @@
+#include "util.h"
 #include "hist.h"
 #include "session.h"
 #include "sort.h"
-- 
1.6.2.5

