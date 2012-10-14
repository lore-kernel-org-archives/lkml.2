Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab2JNPDt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 11:03:49 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46402 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754658Ab2JNOnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 10:43:03 -0400
Message-Id: <20121014143547.685720731@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 14 Oct 2012 15:37:16 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sascha Hauer <s.hauer@pengutronix.de>, Jan Luebbe <jlu@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 103/147] kbuild: make: fix if_changed when command contains backslashes
In-Reply-To: <20121014143533.742627615@decadent.org.uk>
X-SA-Exim-Connect-IP: 77.75.106.1
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sascha Hauer <s.hauer@pengutronix.de>

commit c353acba28fb3fa1fd05fd6b85a9fc7938330f9c upstream.

The call if_changed mechanism does not work when the command contains
backslashes.  This basically is an issue with lzo and bzip2 compressed
kernels.  The compressed binaries do not contain the uncompressed image
size, so these use size_append to append the size.  This results in
backslashes in the executed command.  With this if_changed always
detects a change in the command and rebuilds the compressed image even
if nothing has changed.

Fix this by escaping backslashes in make-cmd

Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Jan Luebbe <jlu@pengutronix.de>
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Bernhard Walle <bernhard@bwalle.de>
Cc: Michal Marek <mmarek@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
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


