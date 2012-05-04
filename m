Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753727Ab2EDHlo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 03:41:44 -0400
Received: from mga03.intel.com ([143.182.124.21]:41686 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753189Ab2EDHln (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 03:41:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="96298515"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 2/2] Makefile: remove useless warning
Date: Fri,  4 May 2012 10:42:35 +0300
Message-Id: <1336117355-21348-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.9.1
In-Reply-To: <1336117355-21348-1-git-send-email-dedekind1@gmail.com>
References: <1336117355-21348-1-git-send-email-dedekind1@gmail.com>
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
---
 Makefile |    6 ------
 1 files changed, 0 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index 2cba5db..53e6b7d 100644
--- a/Makefile
+++ b/Makefile
@@ -692,20 +692,14 @@ KBUILD_CFLAGS += $(warning)
 endif
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-# But warn user when we do so
-warn-assign = \
-$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
 
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
1.7.9.1

