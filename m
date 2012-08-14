Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755882Ab2HNQBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 12:01:05 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:36241 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab2HNQBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 12:01:02 -0400
From: =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: mmarek@suse.cz, linux-kbuild@vger.kernel.org, sam@ravnborg.org,
        artem.bityutskiy@linux.intel.com,
        =?UTF-8?q?Ozan=20=C3=87a=C4=9Flayan?= <ozancag@gmail.com>
Subject: [PATCH] kbuild: Remove useless warning while appending KCFLAGS
Date: Tue, 14 Aug 2012 19:00:54 +0300
Message-Id: <1344960054-26557-1-git-send-email-ozancag@gmail.com>
X-Mailer: git-send-email 1.7.11.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a respin of an older patch sent by Sam Ravnborg:
  http://www.gossamer-threads.com/lists/linux/kernel/1530602

This patch removes the annoying warning:

Makefile:708: "WARNING: Appending $KCFLAGS (-Wno-sign-compare) from command
line to kernel $CFLAGS"

which is printed every time I use KCFLAFS. The commit which introduced the
warning:

69ee0b3 kbuild: do not pick up CFLAGS from the environment

tells about the problems when people have CFLAGS in their environment,
then switches to KCFLAFS which should be enough to solve the issue, but
it anyway introduces a warning. Drop this warning.

Signed-off-by: Ozan Çağlayan <ozancag@gmail.com>
---
 Makefile | 19 +++----------------
 1 file changed, 3 insertions(+), 16 deletions(-)

diff --git a/Makefile b/Makefile
index 0d718ed..34751eb 100644
--- a/Makefile
+++ b/Makefile
@@ -648,22 +648,9 @@ ifeq ($(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-goto.sh $(CC)), y)
 endif
 
 # Add user supplied CPPFLAGS, AFLAGS and CFLAGS as the last assignments
-# But warn user when we do so
-warn-assign = \
-$(warning "WARNING: Appending $$K$(1) ($(K$(1))) from $(origin K$(1)) to kernel $$$(1)")
-
-ifneq ($(KCPPFLAGS),)
-        $(call warn-assign,CPPFLAGS)
-        KBUILD_CPPFLAGS += $(KCPPFLAGS)
-endif
-ifneq ($(KAFLAGS),)
-        $(call warn-assign,AFLAGS)
-        KBUILD_AFLAGS += $(KAFLAGS)
-endif
-ifneq ($(KCFLAGS),)
-        $(call warn-assign,CFLAGS)
-        KBUILD_CFLAGS += $(KCFLAGS)
-endif
+KBUILD_CPPFLAGS += $(KCPPFLAGS)
+KBUILD_AFLAGS += $(KAFLAGS)
+KBUILD_CFLAGS += $(KCFLAGS)
 
 # Use --build-id when available.
 LDFLAGS_BUILD_ID = $(patsubst -Wl$(comma)%,%,\
-- 
1.7.11.2

