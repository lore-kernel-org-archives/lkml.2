Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923Ab2BFWKe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:10:34 -0500
Received: from casper.infradead.org ([85.118.1.10]:56431 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755401Ab2BFWKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:10:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 2/8] perf tools: Remove distclean from Makefile help output
Date: Mon,  6 Feb 2012 20:10:17 -0200
Message-Id: <1328566223-27218-3-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.123.g65da0
In-Reply-To: <1328566223-27218-1-git-send-email-acme@infradead.org>
References: <1328566223-27218-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: John Kacur <jkacur@redhat.com>

distclean as an alias for clean was removed from the perf Makefile by
commit a3d1ee10d1bf4520af3d44c1aa6cd46956ec4fd7

However, that commit neglected to remove it from the help output of
the perf Makefile, which could result in a user trying the following.

$ cd tools/perf/
$ make help | grep distclean
  distclean		- alias to clean
$ make distclean
make: *** No rule to make target `distclean'.  Stop.

This patch removes it from the Makefile help output.

Link: http://lkml.kernel.org/r/1328134591-19851-1-git-send-email-jkacur@redhat.com
Signed-off-by: John Kacur <jkacur@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index d64f581..64df5de 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -794,7 +794,6 @@ help:
 	@echo '  quick-install-html	- install the html documentation quickly'
 	@echo ''
 	@echo 'Perf maintainer targets:'
-	@echo '  distclean		- alias to clean'
 	@echo '  clean			- clean all binary objects and build output'
 
 doc:
-- 
1.7.9.123.g65da0

