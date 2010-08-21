Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751763Ab0HUJbg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 05:31:36 -0400
Received: from mga09.intel.com ([134.134.136.24]:54787 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751721Ab0HUJbd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 05:31:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,244,1280732400"; 
   d="scan'208";a="547390771"
Date: Sat, 21 Aug 2010 17:31:21 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tiago Maluta <tiago.maluta@gmail.com>, Michal Marek <mmarek@suse.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm V2] fix compilation error with CROSS_COMPILE
Message-ID: <20100821093121.GA11036@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

        $ ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- make
        ...
        cc1: error: unrecognized command line option "-m64"
        cc1: error: unrecognized command line option "-mno-red-zone"
        cc1: error: unrecognized command line option "-mcmodel=kernel"
        cc1: error: unrecognized command line option "-maccumulate-outgoing-args"

Cc: Tiago Maluta <tiago.maluta@gmail.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---

Andrew: the compile error only occurs in the -mm tree

The error was introduced by patch
kbuild-fix-config_cross_compile-issue-in-config.patch

diff --git a/Makefile b/Makefile
index d646d69..af8864e 100644
--- a/Makefile
+++ b/Makefile
@@ -190,7 +190,7 @@ SUBARCH := $(shell uname -m | sed -e s/i.86/i386/ -e s/sun4u/sparc64/ \
 export KBUILD_BUILDHOST := $(SUBARCH)
 ARCH		?= $(SUBARCH)
 CROSS_COMPILE	?=
-CROSS_COMPILE	:= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
+CROSS_COMPILE	?= $(shell grep CONFIG_CROSS_COMPILE .config | cut -d'"' -f2)
 
 # Architecture as present in compile.h
 UTS_MACHINE 	:= $(ARCH)
