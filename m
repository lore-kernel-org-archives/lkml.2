Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965851Ab2FAWUM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 18:20:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:54287 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759564Ab2FAWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 18:16:52 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 07/15] perf tools: Update ioctl documentation for PERF_IOC_FLAG_GROUP
Date: Fri,  1 Jun 2012 19:16:31 -0300
Message-Id: <1338588999-32509-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1338588999-32509-1-git-send-email-acme@infradead.org>
References: <1338588999-32509-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

The ioctl interface of perf event fd receives 3 arguments to control
event group behavior but it lacked documentation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1338443506-25009-2-git-send-email-namhyung.kim@lge.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/design.txt |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index bd0bb1b..67e5d0c 100644
--- a/tools/perf/design.txt
+++ b/tools/perf/design.txt
@@ -409,14 +409,15 @@ Counters can be enabled and disabled in two ways: via ioctl and via
 prctl.  When a counter is disabled, it doesn't count or generate
 events but does continue to exist and maintain its count value.
 
-An individual counter or counter group can be enabled with
+An individual counter can be enabled with
 
-	ioctl(fd, PERF_EVENT_IOC_ENABLE);
+	ioctl(fd, PERF_EVENT_IOC_ENABLE, 0);
 
 or disabled with
 
-	ioctl(fd, PERF_EVENT_IOC_DISABLE);
+	ioctl(fd, PERF_EVENT_IOC_DISABLE, 0);
 
+For a counter group, pass PERF_IOC_FLAG_GROUP as the third argument.
 Enabling or disabling the leader of a group enables or disables the
 whole group; that is, while the group leader is disabled, none of the
 counters in the group will count.  Enabling or disabling a member of a
-- 
1.7.1

