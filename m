Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880Ab1AFRJw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 12:09:52 -0500
Received: from mga11.intel.com ([192.55.52.93]:57356 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1AFRJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 12:09:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,284,1291622400"; 
   d="scan'208";a="644140292"
From: Darren Hart <darren@dvhart.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Darren Hart <dvhart@linux.intel.com>,
        Tim Bird <tim.bird@am.sony.com>
Subject: [[PATCH] trace-cmd: ] Use conditional assignment of CC and AR
Date: Thu,  6 Jan 2011 09:08:53 -0800
Message-Id: <1294333733-7746-1-git-send-email-darren@dvhart.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Darren Hart <dvhart@linux.intel.com>

Allow the user to specify CC and AR via the environment by only
setting them in the Makefile if they don't already exist. This is
useful for external build systems for example.

Signed-off-by: Darren Hart <dvhart@linux.intel.com>
CC: Tim Bird <tim.bird@am.sony.com>
---
 Makefile |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Makefile b/Makefile
index 74f2c44..52d422c 100644
--- a/Makefile
+++ b/Makefile
@@ -13,8 +13,8 @@ FILE_VERSION = 6
 
 MAKEFLAGS += --no-print-directory
 
-CC = $(CROSS_COMPILE)gcc
-AR = $(CROSS_COMPILE)ar
+CC ?= $(CROSS_COMPILE)gcc
+AR ?= $(CROSS_COMPILE)ar
 EXT = -std=gnu99
 INSTALL = install
 
-- 
1.7.1

