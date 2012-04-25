Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2DYNrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:47:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44436 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757396Ab2DYNrs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:47:48 -0400
Date: Wed, 25 Apr 2012 06:47:31 -0700
From: tip-bot for Otavio Salvador <otavio@ossystems.com.br>
Message-ID: <tip-6ffd7bdbf8516d691974d21098278af65d4817a5@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de, otavio@ossystems.com.br
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, tglx@linutronix.de, otavio@ossystems.com.br
In-Reply-To: <1334148270-13139-1-git-send-email-otavio@ossystems.com.br>
References: <1334148270-13139-1-git-send-email-otavio@ossystems.com.br>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf tools:
  Drop CROSS_COMPILE from flex and bison calls
Git-Commit-ID: 6ffd7bdbf8516d691974d21098278af65d4817a5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 25 Apr 2012 06:47:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6ffd7bdbf8516d691974d21098278af65d4817a5
Gitweb:     http://git.kernel.org/tip/6ffd7bdbf8516d691974d21098278af65d4817a5
Author:     Otavio Salvador <otavio@ossystems.com.br>
AuthorDate: Wed, 11 Apr 2012 09:44:30 -0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 16 Apr 2012 16:10:22 -0300

perf tools: Drop CROSS_COMPILE from flex and bison calls

The flex and bison tools generate arch-independent C code so its
binaries are not prefixed with the target-arch prefix. With this patch
the Linux 3.4-rc2 can be successfuly build on OE-Core.

Signed-off-by: Otavio Salvador <otavio@ossystems.com.br>
Link: http://lkml.kernel.org/r/1334148270-13139-1-git-send-email-otavio@ossystems.com.br
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index 03059e7..9bf3fc7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -234,8 +234,8 @@ endif
 
 export PERL_PATH
 
-FLEX = $(CROSS_COMPILE)flex
-BISON= $(CROSS_COMPILE)bison
+FLEX = flex
+BISON= bison
 
 $(OUTPUT)util/parse-events-flex.c: util/parse-events.l
 	$(QUIET_FLEX)$(FLEX) --header-file=$(OUTPUT)util/parse-events-flex.h -t util/parse-events.l > $(OUTPUT)util/parse-events-flex.c
