Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab0F2VEl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 17:04:41 -0400
Received: from hera.kernel.org ([140.211.167.34]:36464 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751519Ab0F2VEk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 17:04:40 -0400
Date: Tue, 29 Jun 2010 21:03:42 GMT
From: tip-bot for Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
       mingo@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
       mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
       linux-kernel@vger.kernel.org, srikar@linux.vnet.ibm.com,
       tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20100629173226.GC23231@linux.vnet.ibm.com>
References: <20100629173226.GC23231@linux.vnet.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix hist_entry__tui_annotate() build failure
Message-ID: <tip-0879b100f3c187257729f36cba33d96ec2875766@git.kernel.org>
Git-Commit-ID: 0879b100f3c187257729f36cba33d96ec2875766
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 29 Jun 2010 21:03:54 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  0879b100f3c187257729f36cba33d96ec2875766
Gitweb:     http://git.kernel.org/tip/0879b100f3c187257729f36cba33d96ec2875766
Author:     Srikar Dronamraju <srikar@linux.vnet.ibm.com>
AuthorDate: Tue, 29 Jun 2010 23:02:26 +0530
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Tue, 29 Jun 2010 22:59:05 +0200

perf: Fix hist_entry__tui_annotate() build failure

When compiling perf on latest tip/master I see the following
error:

  cc1: warnings being treated as errors
  util/newt.c: In function 'hist_entry__tui_annotate':
  util/newt.c:764: warning: 'ret' is used uninitialized in
  this function make: *** [util/newt.o] Error 1

I think the problem was introduced by commit
13f499f076c67675e6e3022973729b5d906a84e9

Below is a patch that fixes the problem.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
LKML-Reference: <20100629173226.GC23231@linux.vnet.ibm.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 tools/perf/util/newt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/newt.c b/tools/perf/util/newt.c
index 89c52fc..06f248f 100644
--- a/tools/perf/util/newt.c
+++ b/tools/perf/util/newt.c
@@ -753,7 +753,7 @@ int hist_entry__tui_annotate(struct hist_entry *self)
 
 	browser.width += 18; /* Percentage */
 	ui_browser__show(&browser, self->ms.sym->name);
-	ui_browser__run(&browser, &es);
+	ret = ui_browser__run(&browser, &es);
 	newtFormDestroy(browser.form);
 	newtPopWindow();
 	list_for_each_entry_safe(pos, n, &head, node) {
