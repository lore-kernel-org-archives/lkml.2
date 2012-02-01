Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645Ab2BAWQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 17:16:53 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45294 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755410Ab2BAWQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 17:16:52 -0500
From: John Kacur <jkacur@redhat.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: lkml <linux-kernel@vger.kernel.org>, John Kacur <jkacur@redhat.com>
Subject: [PATCH] perf: Remove distclean from Makefile help output
Date: Wed,  1 Feb 2012 23:16:31 +0100
Message-Id: <1328134591-19851-1-git-send-email-jkacur@redhat.com>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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

Signed-off-by: John Kacur <jkacur@redhat.com>
---
 tools/perf/Makefile |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/tools/perf/Makefile b/tools/perf/Makefile
index ac86d67..e4233c7 100644
--- a/tools/perf/Makefile
+++ b/tools/perf/Makefile
@@ -795,7 +795,6 @@ help:
 	@echo '  quick-install-html	- install the html documentation quickly'
 	@echo ''
 	@echo 'Perf maintainer targets:'
-	@echo '  distclean		- alias to clean'
 	@echo '  clean			- clean all binary objects and build output'
 
 doc:
-- 
1.7.7.6

