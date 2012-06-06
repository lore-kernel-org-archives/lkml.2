Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab2FFHDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 03:03:54 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35856 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab2FFHDx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 03:03:53 -0400
Date: Wed, 6 Jun 2012 00:03:33 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-a59e64a13a927fb7530bef39e9f5e7de8268137e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, tglx@linutronix.de, namhyung@gmail.com
In-Reply-To: <1338443506-25009-2-git-send-email-namhyung.kim@lge.com>
References: <1338443506-25009-2-git-send-email-namhyung.kim@lge.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Update ioctl documentation for PERF_IOC_FLAG_GROUP
Git-Commit-ID: a59e64a13a927fb7530bef39e9f5e7de8268137e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 06 Jun 2012 00:03:38 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a59e64a13a927fb7530bef39e9f5e7de8268137e
Gitweb:     http://git.kernel.org/tip/a59e64a13a927fb7530bef39e9f5e7de8268137e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 31 May 2012 14:51:45 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 31 May 2012 11:38:42 -0300

perf tools: Update ioctl documentation for PERF_IOC_FLAG_GROUP

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
