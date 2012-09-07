Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760265Ab2IGJgA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 05:36:00 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50951 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755886Ab2IGJf6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 05:35:58 -0400
From: Sascha Hauer <s.hauer@pengutronix.de>
To: linux-kernel@vger.kernel.org
Cc: Sam Ravnborg <sam@ravnborg.org>, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>, kernel@pengutronix.de,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: [PATCH] Make: Fix if_changed when command contains backslashes
Date: Fri,  7 Sep 2012 11:35:52 +0200
Message-Id: <1347010552-26595-1-git-send-email-s.hauer@pengutronix.de>
X-Mailer: git-send-email 1.7.10.4
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The call if_changed mechanism does not work when the command
contains backslashes. This basically is an issue with lzo
and bzip2 compressed kernels. The compressed binaries do not
contain the uncompressed image size, so these use size_append
to append the size. This results in backslashes in the executed
command. With this if_changed always detects a change in the
command and rebuilds the compressed image even if nothing
has changed.

Fix this by escaping backslashes in make-cmd

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/Kbuild.include b/scripts/Kbuild.include
index 6a3ee98..afa4459 100644
--- a/scripts/Kbuild.include
+++ b/scripts/Kbuild.include
@@ -209,7 +209,7 @@ endif
 # >$< substitution to preserve $ when reloading .cmd file
 # note: when using inline perl scripts [perl -e '...$$t=1;...']
 # in $(cmd_xxx) double $$ your perl vars
-make-cmd = $(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1)))))
+make-cmd = $(subst \\,\\\\,$(subst \#,\\\#,$(subst $$,$$$$,$(call escsq,$(cmd_$(1))))))
 
 # Find any prerequisites that is newer than target or that does not exist.
 # PHONY targets skipped in both cases.
-- 
1.7.10.4

