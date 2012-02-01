Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932115Ab2BALIa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 06:08:30 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:55869 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2BALI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 06:08:28 -0500
From: Franck Bui-Huu <fbuihuu@gmail.com>
To: linux@dominikbrodowski.net
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] cpupower tool: makefile: simplify the recipe used to generate cpupower.pot target
Date: Wed,  1 Feb 2012 12:08:19 +0100
Message-Id: <1328094500-19393-3-git-send-email-fbuihuu@gmail.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
References: <1328094500-19393-1-git-send-email-fbuihuu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the '-p' and '-o' switches to specify the pathname of the output
file to xgettext(1). This avoids to move manually the output file if
xgettext(1) succeeds.

Signed-off-by: Franck Bui-Huu <fbuihuu@gmail.com>
---
 tools/power/cpupower/Makefile |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/tools/power/cpupower/Makefile b/tools/power/cpupower/Makefile
index b7d87af..f1fe491 100644
--- a/tools/power/cpupower/Makefile
+++ b/tools/power/cpupower/Makefile
@@ -199,9 +199,7 @@ cpupower: $(UTIL_OBJS) libcpupower.so.$(LIB_MAJ)
 po/$(PACKAGE).pot: $(UTIL_SRC)
 	$(ECHO) "  GETTEXT " $@
 	$(QUIET) xgettext --default-domain=$(PACKAGE) --add-comments \
-		--keyword=_ --keyword=N_ $(UTIL_SRC) && \
-	test -f $(PACKAGE).po && \
-	mv -f $(PACKAGE).po po/$(PACKAGE).pot
+		--keyword=_ --keyword=N_ $(UTIL_SRC) -p $(@D) -o $(@F)
 
 po/%.gmo: po/%.po
 	$(ECHO) "  MSGFMT  " $@
-- 
1.7.7.4

