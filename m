Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752292Ab1HOFIS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:08:18 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44899 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1HOFIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:08:12 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        linux-kbuild@vger.kernel.org
Subject: [PATCH 10/11] scripts/Makefile.build: do not reference EXTRA_CFLAGS as CFLAGS replacement
Date: Mon, 15 Aug 2011 01:07:13 -0400
Message-Id: <1313384834-24433-11-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.6.153.g78432
In-Reply-To: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
References: <1313384834-24433-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Usage of these flags has been deprecated for nearly 4 years by:

    commit f77bf01425b11947eeb3b5b54685212c302741b8
    Author: Sam Ravnborg <sam@neptun.(none)>
    Date:   Mon Oct 15 22:25:06 2007 +0200

        kbuild: introduce ccflags-y, asflags-y and ldflags-y

Moreover, these flags (at least EXTRA_CFLAGS) have been documented for command
line use. By default, gmake(1) do not override command line setting, so this is
likely to result in build failure or unexpected behavior.

Do not advertise for its usage.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild@vger.kernel.org
---
 scripts/Makefile.build |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index a0fd502..d2b366c 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -46,7 +46,7 @@ include $(kbuild-file)
 # If the save-* variables changed error out
 ifeq ($(KBUILD_NOPEDANTIC),)
         ifneq ("$(save-cflags)","$(CFLAGS)")
-                $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use EXTRA_CFLAGS)
+                $(error CFLAGS was changed in "$(kbuild-file)". Fix it to use ccflags-y)
         endif
 endif
 
-- 
1.7.6.153.g78432

