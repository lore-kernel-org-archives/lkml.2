Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1EJUNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 16:13:45 -0400
Received: from hera.kernel.org ([140.211.167.34]:50678 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451Ab1EJUNn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 16:13:43 -0400
Date: Tue, 10 May 2011 20:13:31 GMT
From: tip-bot for Lin Ming <ming.m.lin@intel.com>
Message-ID: <tip-2b348a77981227c6b64fb9cf19f7c711a6806bc9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        acme@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@infradead.org, ming.m.lin@intel.com, tglx@linutronix.de,
        mingo@elte.hu
In-Reply-To: <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
References: <1304066518-30420-2-git-send-email-ming.m.lin@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf probe: Fix the missed parameter initialization
Git-Commit-ID: 2b348a77981227c6b64fb9cf19f7c711a6806bc9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 10 May 2011 20:13:31 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2b348a77981227c6b64fb9cf19f7c711a6806bc9
Gitweb:     http://git.kernel.org/tip/2b348a77981227c6b64fb9cf19f7c711a6806bc9
Author:     Lin Ming <ming.m.lin@intel.com>
AuthorDate: Fri, 29 Apr 2011 08:41:57 +0000
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 10 May 2011 17:06:23 +0200

perf probe: Fix the missed parameter initialization

pubname_callback_param::found should be initialized to 0 in
fastpath lookup, the structure is on the stack and
uninitialized otherwise.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>
Link: http://lkml.kernel.org/r/1304066518-30420-2-git-send-email-ming.m.lin@intel.com
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/probe-finder.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
index a7c7145..3b9d0b8 100644
--- a/tools/perf/util/probe-finder.c
+++ b/tools/perf/util/probe-finder.c
@@ -1538,6 +1538,7 @@ static int find_probes(int fd, struct probe_finder *pf)
 			.file	  = pp->file,
 			.cu_die	  = &pf->cu_die,
 			.sp_die	  = &pf->sp_die,
+			.found	  = 0,
 		};
 		struct dwarf_callback_param probe_param = {
 			.data = pf,
