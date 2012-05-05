Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab2EEIT6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 04:19:58 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29981 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab2EEISu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 04:18:50 -0400
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 8/8] kbuild: remove useless warning
Date: Sat,  5 May 2012 10:18:46 +0200
Message-Id: <1336205926-13946-8-git-send-email-sam@ravnborg.org>
X-Mailer: git-send-email 1.6.0.6
In-Reply-To: <20120505080640.GA13773@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch removes annoying warning:

Makefile:708: "WARNING: Appending $KCFLAGS (-Wno-sign-compare) from command line to kernel $CFLAGS"

which is printed every time I use KCFLAFS. The commit which introduced the
warning:

69ee0b3 kbuild: do not pick up CFLAGS from the environment

tells about the problems when people have CFLAGS in their environment,
then switches to KCFLAFS which should be enough to solve the issue, but
it anyway introduces a warning. I think it is too much and I find this
warning very annoying - why should we warn users when they use the
build system properly?

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/Kbuild.arch |    7 -------
 1 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/scripts/Kbuild.arch b/scripts/Kbuild.arch
index 6ff27c6..7841825 100644
--- a/scripts/Kbuild.arch
+++ b/scripts/Kbuild.arch
@@ -127,20 +127,13 @@ KBUILD_CFLAGS += $(warning)
 endif
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-# But warn user when we do so
-warn-assign = \
-$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
-
 ifneq ($(KCPPFLAGS),)
-        $(call warn-assign,CPPFLAGS)
         KBUILD_CPPFLAGS += $(KCPPFLAGS)
 endif
 ifneq ($(KAFLAGS),)
-        $(call warn-assign,AFLAGS)
         KBUILD_AFLAGS += $(KAFLAGS)
 endif
 ifneq ($(KCFLAGS),)
-        $(call warn-assign,CFLAGS)
         KBUILD_CFLAGS += $(KCFLAGS)
 endif
 
-- 
1.6.0.6

