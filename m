Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933665Ab2JZPHx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 11:07:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54861 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab2JZPHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 11:07:51 -0400
Date: Fri, 26 Oct 2012 08:07:24 -0700
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-cf3aa103555136c04894058152b129c133ebf350@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, bp@amd64.org, namhyung@kernel.org,
        jolsa@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung.kim@lge.com, namhyung@kernel.org, bp@amd64.org,
        jolsa@redhat.com, tglx@linutronix.de
In-Reply-To: <1351241752-2919-4-git-send-email-namhyung@kernel.org>
References: <1351241752-2919-4-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Always show CHK message when doing try-cc
Git-Commit-ID: cf3aa103555136c04894058152b129c133ebf350
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Fri, 26 Oct 2012 08:07:29 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cf3aa103555136c04894058152b129c133ebf350
Gitweb:     http://git.kernel.org/tip/cf3aa103555136c04894058152b129c133ebf350
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Fri, 26 Oct 2012 17:55:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 26 Oct 2012 11:22:24 -0200

perf tools: Always show CHK message when doing try-cc

It might be useful to see what's happening behind us rather than just
waiting few seconds during the config checking.

Also align the CHK message with other ones.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Borislav Petkov <bp@amd64.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1351241752-2919-4-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/config/utilities.mak |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/tools/perf/config/utilities.mak b/tools/perf/config/utilities.mak
index ea853c2..e541312 100644
--- a/tools/perf/config/utilities.mak
+++ b/tools/perf/config/utilities.mak
@@ -183,9 +183,8 @@ _gea_err  = $(if $(1),$(error Please set '$(1)' appropriately))
 # Usage: option = $(call try-cc, source-to-build, cc-options, msg)
 ifndef V
 TRY_CC_OUTPUT= > /dev/null 2>&1
-else
-TRY_CC_MSG=echo "CHK $(3)" 1>&2;
 endif
+TRY_CC_MSG=echo "    CHK $(3)" 1>&2;
 
 try-cc = $(shell sh -c						  \
 	'TMP="$(OUTPUT)$(TMPOUT).$$$$";				  \
