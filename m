Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758611Ab1D2Nby (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 09:31:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58826 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751640Ab1D2Nbx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 09:31:53 -0400
From: Michal Marek <mmarek@suse.cz>
To: Valdis.Kletnieks@vt.edu
Cc: bp@alien8.de, sam@ravnborg.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org, davej@redhat.com
Subject: [PATCH] kbuild: Allow to combine multiple W= levels
Date: Fri, 29 Apr 2011 15:31:33 +0200
Message-Id: <1304083893-18849-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <71633.1304013549@localhost>
References: <71633.1304013549@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for make W=12, make W=123 and so on, to enable warnings from
multiple W= levels. Normally, make W=<level> does not include warnings
from the previous level.

Signed-off-by: Michal Marek <mmarek@suse.cz>
---
 scripts/Makefile.build |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.build b/scripts/Makefile.build
index 9c0c481..28cef2a 100644
--- a/scripts/Makefile.build
+++ b/scripts/Makefile.build
@@ -60,6 +60,8 @@ endif
 # $(call cc-option, -W...) handles gcc -W.. options which
 # are not supported by all versions of the compiler
 ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS
+warning-  := $(empty)
+
 warning-1 := -Wextra -Wunused -Wno-unused-parameter
 warning-1 += -Wmissing-declarations
 warning-1 += -Wmissing-format-attribute
@@ -85,9 +87,11 @@ warning-3 += -Wswitch-default
 warning-3 += $(call cc-option, -Wpacked-bitfield-compat)
 warning-3 += $(call cc-option, -Wvla)
 
-warning := $(warning-$(KBUILD_ENABLE_EXTRA_GCC_CHECKS))
+warning := $(warning-$(findstring 1, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 2, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
+warning += $(warning-$(findstring 3, $(KBUILD_ENABLE_EXTRA_GCC_CHECKS)))
 
-ifeq ("$(warning)","")
+ifeq ("$(strip $(warning))","")
         $(error W=$(KBUILD_ENABLE_EXTRA_GCC_CHECKS) is unknown)
 endif
 
-- 
1.7.4.1

