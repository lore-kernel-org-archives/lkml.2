Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755739Ab0LASBW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:01:22 -0500
Received: from casper.infradead.org ([85.118.1.10]:52303 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755637Ab0LASBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:01:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?utf-8?q?Fr=C3=A9d=C3=A9ric=20Weisbecker?= <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 15/15] perf stat: Use --big-num format by default
Date: Wed,  1 Dec 2010 16:01:05 -0200
Message-Id: <1291226465-26337-16-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1291226465-26337-1-git-send-email-acme@infradead.org>
References: <1291226465-26337-1-git-send-email-acme@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[acme@mica linux]$ perf stat ls > /dev/null

 Performance counter stats for 'ls':

           1.512532  task-clock-msecs         #      0.801 CPUs
                  2  context-switches         #      0.001 M/sec
                  0  CPU-migrations           #      0.000 M/sec
                241  page-faults              #      0.159 M/sec
          2,973,331  cycles                   #   1965.797 M/sec
          1,460,802  instructions             #      0.491 IPC
            314,642  branches                 #    208.023 M/sec
             18,475  branch-misses            #      5.872 %
      <not counted>  cache-references
      <not counted>  cache-misses

        0.001887676  seconds time elapsed

To get the previous behaviour just use --no-big-num:

[acme@mica linux]$ perf stat --no-big-num ls > /dev/null

 Performance counter stats for 'ls':

           1.468014  task-clock-msecs         #      0.795 CPUs
                  1  context-switches         #      0.001 M/sec
                  0  CPU-migrations           #      0.000 M/sec
                241  page-faults              #      0.164 M/sec
            2900254  cycles                   #   1975.631 M/sec
            1437991  instructions             #      0.496 IPC
             310905  branches                 #    211.786 M/sec
              17912  branch-misses            #      5.761 %
      <not counted>  cache-references
      <not counted>  cache-misses

        0.001845435  seconds time elapsed

[acme@mica linux]$

Suggested-by: Ingo Molnar <mingo@elte.hu>
Cc: Frédéric Weisbecker <fweisbec@gmail.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Stephane Eranian <eranian@google.com>
LKML-Reference: <new-submission>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-stat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
index 970a7f2..acbf7cc 100644
--- a/tools/perf/builtin-stat.c
+++ b/tools/perf/builtin-stat.c
@@ -82,7 +82,7 @@ static pid_t			*all_tids			=  NULL;
 static int			thread_num			=  0;
 static pid_t			child_pid			= -1;
 static bool			null_run			=  false;
-static bool			big_num				=  false;
+static bool			big_num				=  true;
 static const char		*cpu_list;
 
 
-- 
1.6.2.5

