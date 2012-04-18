Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab2DRT7B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:59:01 -0400
Received: from mail.windriver.com ([147.11.1.11]:59962 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238Ab2DRT7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:59:00 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: jesper.nilsson@axis.com
Cc: starvik@axis.com, linux-cris-kernel@axis.com, linux-kernel@vger.kernel.org,
        linux-next@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH] cris: Remove old legacy "-traditional" flag from arch-v10/lib/Makefile
Date: Wed, 18 Apr 2012 15:58:43 -0400
Message-Id: <1334779123-21957-1-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most of these have been purged years ago.  This one silently lived
on until commit 69349c2dc01c489eccaa4c472542c08e370c6d7e

    "kconfig: fix IS_ENABLED to not require all options to be defined"

In the above, we use some macro trickery to create a conditional that
is valid in CPP and in C usage.  However that trickery doesn't sit
well if you have the legacy "-traditional" flag enabled.  You'll get:

  AS      arch/cris/arch-v10/lib/checksum.o
In file included from <command-line>:4:0:
include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
make[2]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1

Everything builds fine w/o "-traditional" so simply drop it from this
location as well.

Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

diff --git a/arch/cris/arch-v10/lib/Makefile b/arch/cris/arch-v10/lib/Makefile
index 36e9a9c..725153e 100644
--- a/arch/cris/arch-v10/lib/Makefile
+++ b/arch/cris/arch-v10/lib/Makefile
@@ -2,8 +2,5 @@
 # Makefile for Etrax-specific library files..
 #
 
-
-EXTRA_AFLAGS := -traditional
-
 lib-y  = checksum.o checksumcopy.o string.o usercopy.o memset.o csumcpfruser.o
 
-- 
1.7.9.1

