Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab1HOFJz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 01:09:55 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:39542 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751954Ab1HOFHl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 01:07:41 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>
Subject: [PATCH 03/11] arch/unicore32: do not use EXTRA_AFLAGS or EXTRA_CFLAGS
Date: Mon, 15 Aug 2011 01:07:06 -0400
Message-Id: <1313384834-24433-4-git-send-email-lacombar@gmail.com>
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

Replace their usage by Kbuild's `{as,cc,ld}flags-y'.

Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Guan Xuetao <gxt@mprc.pku.edu.cn>
---
 arch/unicore32/boot/compressed/Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/unicore32/boot/compressed/Makefile b/arch/unicore32/boot/compressed/Makefile
index b0954a2..950a9af 100644
--- a/arch/unicore32/boot/compressed/Makefile
+++ b/arch/unicore32/boot/compressed/Makefile
@@ -10,8 +10,8 @@
 # Copyright (C) 2001~2010 GUAN Xue-tao
 #
 
-EXTRA_CFLAGS	:= -fpic -fno-builtin
-EXTRA_AFLAGS	:= -Wa,-march=all
+ccflags-y	:= -fpic -fno-builtin
+asflags-y	:= -Wa,-march=all
 
 OBJS		:= misc.o
 
-- 
1.7.6.153.g78432

