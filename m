Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab2AIH3i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 02:29:38 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46121 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755486Ab2AIH3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 02:29:36 -0500
Date: Sun, 8 Jan 2012 23:29:11 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-172d1b0b73256551f100fc00c69e356d047103f5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        joerg.roedel@amd.com, namhyung@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, joerg.roedel@amd.com,
        a.p.zijlstra@chello.nl, tglx@linutronix.de, namhyung@gmail.com,
        mingo@elte.hu
In-Reply-To: <1326035430-7621-1-git-send-email-namhyung@gmail.com>
References: <1326035430-7621-1-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Fix compile error on x86_64 Ubuntu
Git-Commit-ID: 172d1b0b73256551f100fc00c69e356d047103f5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 08 Jan 2012 23:29:17 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  172d1b0b73256551f100fc00c69e356d047103f5
Gitweb:     http://git.kernel.org/tip/172d1b0b73256551f100fc00c69e356d047103f5
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Mon, 9 Jan 2012 00:10:30 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sun, 8 Jan 2012 13:34:55 -0200

perf tools: Fix compile error on x86_64 Ubuntu

The ctype.h include is not needed here and it breaks build on some systems (at
least 64bit Ubuntu 10.04) like below. Just get rid of it.

    CC util/trace-event-info.o
cc1: warnings being treated as errors
util/trace-event-info.c: In function ‘record_file’:
util/trace-event-info.c:192: error: implicit declaration of function ‘pwrite’
util/trace-event-info.c:192: error: nested extern declaration of ‘pwrite’
make: *** [util/trace-event-info.o] Error 1

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joerg.roedel@amd.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1326035430-7621-1-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/trace-event-info.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
index ac6830d..fc22cf5 100644
--- a/tools/perf/util/trace-event-info.c
+++ b/tools/perf/util/trace-event-info.c
@@ -18,7 +18,6 @@
  *
  * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  */
-#include <ctype.h>
 #include "util.h"
 #include <dirent.h>
 #include <mntent.h>
