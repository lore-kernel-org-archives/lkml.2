Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891Ab0EMGFQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:05:16 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:45537 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab0EMGEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:04:54 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
       Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>, Ian Munsie <imunsie@au1.ibm.com>,
       Tom Zanussi <tzanussi@gmail.com>,
       Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Subject: [PATCH 5/7] perf trace: use long_size from trace-event-read
Date: Thu, 13 May 2010 16:03:50 +1000
Message-Id: <1273730632-21008-6-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
References: <1273730632-21008-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

long_size was not being initialised in trace-event-parse, which caused a
few bugs. This patch makes it use the long_size from trace-event-read.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 tools/perf/util/trace-event-parse.c |    2 +-
 tools/perf/util/trace-event-read.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/util/trace-event-parse.c b/tools/perf/util/trace-event-parse.c
index 950c757..f9f80be 100644
--- a/tools/perf/util/trace-event-parse.c
+++ b/tools/perf/util/trace-event-parse.c
@@ -52,7 +52,7 @@ static unsigned long long input_buf_ptr;
 static unsigned long long input_buf_siz;
 
 static int cpus;
-static int long_size;
+extern int long_size;
 static int is_flag_field;
 static int is_symbolic_field;
 
diff --git a/tools/perf/util/trace-event-read.c b/tools/perf/util/trace-event-read.c
index 43f19c1..de30159 100644
--- a/tools/perf/util/trace-event-read.c
+++ b/tools/perf/util/trace-event-read.c
@@ -46,7 +46,7 @@ static int read_page;
 
 int file_bigendian;
 int host_bigendian;
-static int long_size;
+int long_size;
 
 static unsigned long	page_size;
 
-- 
1.7.1

