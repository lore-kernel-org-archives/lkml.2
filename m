Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932472Ab2JQRUr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:20:47 -0400
Received: from casper.infradead.org ([85.118.1.10]:46121 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932428Ab2JQRUi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:20:38 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 09/11] perf python: Link with libtraceevent
Date: Wed, 17 Oct 2012 14:19:45 -0300
Message-Id: <1350494387-10987-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1350494387-10987-1-git-send-email-acme@infradead.org>
References: <1350494387-10987-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

The evsel methods to read tracepoint fields uses libtraceevent
functions, becoming needed by the python binding as well.

Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-j3o4v7jyvp9ke9n230l96a1m@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/setup.py |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/setup.py b/tools/perf/util/setup.py
index d0f9f29..09c3cea 100644
--- a/tools/perf/util/setup.py
+++ b/tools/perf/util/setup.py
@@ -31,6 +31,7 @@ perf = Extension('perf',
 		  sources = ext_sources,
 		  include_dirs = ['util/include'],
 		  extra_compile_args = cflags,
+		  extra_objects = [build_tmp + '/../../libtraceevent.a'],
                  )
 
 setup(name='perf',
-- 
1.7.1

