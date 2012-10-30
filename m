Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933150Ab2J3MJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:09:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40953 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932741Ab2J3MJQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:09:16 -0400
Date: Tue, 30 Oct 2012 05:08:48 -0700
From: tip-bot for Feng Tang <feng.tang@intel.com>
Message-ID: <tip-79ee47faa77706f568f0329b7475c123b67a3b4a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, andi@firstfloor.org, peterz@infradead.org,
        namhyung@kernel.org, tglx@linutronix.de, feng.tang@intel.com,
        mingo@elte.hu
In-Reply-To: <1351569369-26732-5-git-send-email-feng.tang@intel.com>
References: <1351569369-26732-5-git-send-email-feng.tang@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf annotate browser:
  Integrate script browser into annotation browser
Git-Commit-ID: 79ee47faa77706f568f0329b7475c123b67a3b4a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 30 Oct 2012 05:08:54 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  79ee47faa77706f568f0329b7475c123b67a3b4a
Gitweb:     http://git.kernel.org/tip/79ee47faa77706f568f0329b7475c123b67a3b4a
Author:     Feng Tang <feng.tang@intel.com>
AuthorDate: Tue, 30 Oct 2012 11:56:05 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 29 Oct 2012 11:54:45 -0200

perf annotate browser: Integrate script browser into annotation browser

Integrate the script browser into annotation, users can press function
key 'r' to list all perf scripts and select one of them to run that
script, the output will be shown in a separate browser.

Signed-off-by: Feng Tang <feng.tang@intel.com>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1351569369-26732-5-git-send-email-feng.tang@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/ui/browsers/annotate.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/tools/perf/ui/browsers/annotate.c b/tools/perf/ui/browsers/annotate.c
index 8f8cd2d..28f8aab 100644
--- a/tools/perf/ui/browsers/annotate.c
+++ b/tools/perf/ui/browsers/annotate.c
@@ -676,8 +676,14 @@ static int annotate_browser__run(struct annotate_browser *browser, int evidx,
 		"o             Toggle disassembler output/simplified view\n"
 		"s             Toggle source code view\n"
 		"/             Search string\n"
+		"r             Run available scripts\n"
 		"?             Search previous string\n");
 			continue;
+		case 'r':
+			{
+				script_browse(NULL);
+				continue;
+			}
 		case 'H':
 			nd = browser->curr_hot;
 			break;
