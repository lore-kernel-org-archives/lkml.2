Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758233Ab2JKBEB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 21:04:01 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49698 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758086Ab2JKBDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 21:03:48 -0400
X-Sasl-enc: FyWTMgNwcxaw9npNn9KbzZgr0yO1jGSCZge8jY5JqE34 1349917427
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sascha Hauer <s.hauer@pengutronix.de>, Jan Luebbe <jlu@pengutronix.de>,
        Sam Ravnborg <sam@ravnborg.org>, Bernhard Walle <bernhard@bwalle.de>,
        Michal Marek <mmarek@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [ 002/120] kbuild: make: fix if_changed when command contains backslashes
Date: Thu, 11 Oct 2012 09:59:14 +0900
Message-Id: <20121011005825.804854308@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.rc0.18.gf84667d
In-Reply-To: <20121011005825.364610894@linuxfoundation.org>
References: <20121011005825.364610894@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 scripts/Kbuild.include |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

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


