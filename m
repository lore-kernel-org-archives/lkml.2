Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752473Ab2H2GXR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 02:23:17 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:64157 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2H2GXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 02:23:15 -0400
X-AuditID: 9c930197-b7b93ae0000028a7-71-503db550ea30
From: =?ks_c_5601-1987?B?wMywx8ij?= <gunho.lee@lge.com>
To: "'Michal Marek'" <mmarek@suse.cz>
Cc: <linux-kbuild@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] scripts/Makefile.modpost: error in finding modules from .mod files.
Date: Wed, 29 Aug 2012 15:23:12 +0900
Message-ID: <013701cd85ae$c46353e0$4d29fba0$@lge.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="ks_c_5601-1987"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac2Frqh/Geu2bCPPRmmx4jjQdqhz6A==
Content-Language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This error may happen when the user's id or path includes .ko string.
For example, user's id is xxx.ko and building test.ko module,
the test.mod file lists ko name and all object files.
   /home/xxx.ko/kernel_dev/device/drivers/test.ko
   /home/xxx.ko/kernel_dev/device/drivers/test_main.o
/home/xxx.ko/kernel_dev/device/drivers/test_io.o ...
Current Makefile.modpost and Makefile.modinst find and list up not only
test.ko but also other object files.
because all of object file's path includes .ko string.
This is a patch to fix it.

Signed-off-by: gunho.lee@lge.com <gunho@swc-osl.(none)>
---
 scripts/Makefile.modinst |    2 +-
 scripts/Makefile.modpost |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/Makefile.modinst b/scripts/Makefile.modinst
index efa5d94..3d13d3a 100644
--- a/scripts/Makefile.modinst
+++ b/scripts/Makefile.modinst
@@ -9,7 +9,7 @@ include scripts/Kbuild.include
 
 #
 
-__modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard
$(MODVERDIR)/*.mod)))
+__modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard
$(MODVERDIR)/*.mod)))
 modules := $(patsubst %.o,%.ko,$(wildcard $(__modules:.ko=.o)))
 
 PHONY += $(modules)
diff --git a/scripts/Makefile.modpost b/scripts/Makefile.modpost
index 08dce14..a1cb022 100644
--- a/scripts/Makefile.modpost
+++ b/scripts/Makefile.modpost
@@ -60,7 +60,7 @@ kernelsymfile := $(objtree)/Module.symvers
 modulesymfile := $(firstword $(KBUILD_EXTMOD))/Module.symvers
 
 # Step 1), find all modules listed in $(MODVERDIR)/
-__modules := $(sort $(shell grep -h '\.ko' /dev/null $(wildcard
$(MODVERDIR)/*.mod)))
+__modules := $(sort $(shell grep -h '\.ko$$' /dev/null $(wildcard
$(MODVERDIR)/*.mod)))
 modules   := $(patsubst %.o,%.ko, $(wildcard $(__modules:.ko=.o)))
 
 # Stop after building .o files if NOFINAL is set. Makes compile tests
quicker
-- 
1.6.3.3


