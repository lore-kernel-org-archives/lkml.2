Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab0F2Rht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 13:37:49 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:50076 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175Ab0F2Rhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 13:37:47 -0400
Date: Tue, 29 Jun 2010 23:02:26 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: [Bugfix] [2.6.35-rc3-tip] perf build failure on latest tip.
Message-ID: <20100629173226.GC23231@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When compiling perf on latest tip/master
I see the following error

cc1: warnings being treated as errors
util/newt.c: In function ‘hist_entry__tui_annotate’:
util/newt.c:764: warning: ‘ret’ is used uninitialized in this function
make: *** [util/newt.o] Error 1

I think the problem was introduced by commit 
13f499f076c67675e6e3022973729b5d906a84e9

Below is a patch that fixes the problem.

Signed-off-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
---

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
