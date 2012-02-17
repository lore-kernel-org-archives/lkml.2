Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752608Ab2BQJsn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 04:48:43 -0500
Received: from terminus.zytor.com ([198.137.202.10]:38635 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751097Ab2BQJsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 04:48:41 -0500
Date: Fri, 17 Feb 2012 01:47:54 -0800
From: tip-bot for Joerg Roedel <joerg.roedel@amd.com>
Message-ID: <tip-c4a7dca92bbb9881a5d678720f1d0c2153499749@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        jasowang@redhat.com, joerg.roedel@amd.com, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, joerg.roedel@amd.com,
        jasowang@redhat.com, a.p.zijlstra@chello.nl, dsahern@gmail.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1328893505-4115-3-git-send-email-joerg.roedel@amd.com>
References: <1328893505-4115-3-git-send-email-joerg.roedel@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Change perf_guest default back to false
Git-Commit-ID: c4a7dca92bbb9881a5d678720f1d0c2153499749
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 17 Feb 2012 01:48:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c4a7dca92bbb9881a5d678720f1d0c2153499749
Gitweb:     http://git.kernel.org/tip/c4a7dca92bbb9881a5d678720f1d0c2153499749
Author:     Joerg Roedel <joerg.roedel@amd.com>
AuthorDate: Fri, 10 Feb 2012 18:05:05 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 13 Feb 2012 23:14:44 -0200

perf tools: Change perf_guest default back to false

Setting perf_guest to true by default makes no sense because the perf
subcommands can not setup guest symbol information and thus not process
and guest samples. The only exception is perf-kvm which changes the
perf_guest value on its own.  So change the default for perf_guest back
to false.

Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jason Wang <jasowang@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1328893505-4115-3-git-send-email-joerg.roedel@amd.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 8131410..fb25d13 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,7 +6,7 @@
  * XXX We need to find a better place for these things...
  */
 bool perf_host  = true;
-bool perf_guest = true;
+bool perf_guest = false;
 
 void event_attr_init(struct perf_event_attr *attr)
 {
