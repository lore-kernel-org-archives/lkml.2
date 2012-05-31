Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753766Ab2EaFyp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 01:54:45 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:54050 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab2EaFyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 01:54:23 -0400
X-AuditID: 9c93016f-b7c3cae000001954-03-4fc7078cac62
From: Namhyung Kim <namhyung.kim@lge.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>, Namhyung Kim <namhyung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 2/3] perf tools: Update ioctl documentation for PERF_IOC_FLAG_GROUP
Date: Thu, 31 May 2012 14:51:45 +0900
Message-Id: <1338443506-25009-2-git-send-email-namhyung.kim@lge.com>
X-Mailer: git-send-email 1.7.10.2
In-Reply-To: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-1-git-send-email-namhyung.kim@lge.com>
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ioctl interface of perf event fd receives 3 arguments
to control event group behavior but it lacked documentation.

Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
---
 tools/perf/design.txt |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/tools/perf/design.txt b/tools/perf/design.txt
index bd0bb1b1279b..67e5d0cace85 100644
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
1.7.10.2

