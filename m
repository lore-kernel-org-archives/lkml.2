Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756565Ab2HUPZq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:25:46 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59745 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754934Ab2HUPZn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:25:43 -0400
Date: Tue, 21 Aug 2012 08:25:23 -0700
From: tip-bot for Robert Richter <robert.richter@amd.com>
Message-ID: <tip-e6b978335424029d05edc01374744516b21b1ede@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, robert.richter@amd.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, robert.richter@amd.com, tglx@linutronix.de
In-Reply-To: <1344361396-7237-2-git-send-email-robert.richter@amd.com>
References: <1344361396-7237-2-git-send-email-robert.richter@amd.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Fix version file for perf documentation with OUTPUT variable set
Git-Commit-ID: e6b978335424029d05edc01374744516b21b1ede
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 21 Aug 2012 08:25:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e6b978335424029d05edc01374744516b21b1ede
Gitweb:     http://git.kernel.org/tip/e6b978335424029d05edc01374744516b21b1ede
Author:     Robert Richter <robert.richter@amd.com>
AuthorDate: Tue, 7 Aug 2012 19:43:11 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 8 Aug 2012 12:36:49 -0300

perf tools: Fix version file for perf documentation with OUTPUT variable set

Fixes the following:

 + make OUTPUT=/.../.build/perf-user/ DESTDIR=/.../.install/perf-user/ man install-man
 make -C Documentation man
 make[1]: Entering directory `/.../.source/linux.perf/tools/perf/Documentation'
 make[2]: Entering directory `/.../.source/linux.perf/tools/perf'
 make[2]: *** No rule to make target `PERF-VERSION-FILE'.  Stop.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@kernel.org>
Link: http://lkml.kernel.org/r/1344361396-7237-2-git-send-email-robert.richter@amd.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/Makefile |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/Documentation/Makefile b/tools/perf/Documentation/Makefile
index ca600e0..9f2e44f 100644
--- a/tools/perf/Documentation/Makefile
+++ b/tools/perf/Documentation/Makefile
@@ -195,10 +195,10 @@ install-pdf: pdf
 #install-html: html
 #	'$(SHELL_PATH_SQ)' ./install-webdoc.sh $(DESTDIR)$(htmldir)
 
-../PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
-	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) PERF-VERSION-FILE
+$(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
+	$(QUIET_SUBDIR0)../ $(QUIET_SUBDIR1) $(OUTPUT)PERF-VERSION-FILE
 
--include ../PERF-VERSION-FILE
+-include $(OUTPUT)PERF-VERSION-FILE
 
 #
 # Determine "include::" file references in asciidoc files.
