Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222Ab0FMRLy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 13:11:54 -0400
Received: from adelie.canonical.com ([91.189.90.139]:57893 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0FMRLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 13:11:52 -0400
From: Chase Douglas <chase.douglas@canonical.com>
To: Steven Rostedt <srostedt@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] trace-cmd: append to CFLAGS instead of being overriden
Date: Sun, 13 Jun 2010 13:11:47 -0400
Message-Id: <1276449108-21328-1-git-send-email-chase.douglas@canonical.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Most package builders apply their own CFLAGS, often set during the make
invocation. The trace-cmd internal CFLAGS is overriden in this case.
Make sure the important flags are appended.

Signed-off-by: Chase Douglas <chase.douglas@canonical.com>
---
 Makefile |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/Makefile b/Makefile
index a278510..08fc4ca 100644
--- a/Makefile
+++ b/Makefile
@@ -183,7 +183,11 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
 
 INCLUDES = -I. -I/usr/local/include $(CONFIG_INCLUDES)
 
-CFLAGS = -g -Wall $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
+# Set compile option CFLAGS if not set elsewhere
+CFLAGS ?= -g -Wall
+
+# Append required CFLAGS
+override CFLAGS += $(CONFIG_FLAGS) $(INCLUDES) $(PLUGIN_DIR_SQ)
 
 ifeq ($(VERBOSE),1)
   Q =
-- 
1.7.0.4

