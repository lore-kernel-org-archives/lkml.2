Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753948Ab0CXItm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 04:49:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:59680 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753656Ab0CXItk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 04:49:40 -0400
From: Tejun Heo <tj@kernel.org>
To: torvalds@linux-foundation.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, Lee.Schermerhorn@hp.com,
       cl@linux-foundation.org, mingo@elte.hu, adobriyan@gmail.com,
       tglx@linutronix.de, hpa@zytor.com, yi.zhu@intel.com,
       reinette.chatre@intel.com, ilw@linux.intel.com
Cc: Tejun Heo <tj@kernel.org>, Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 2/4] iwlwifi: don't include iwl-dev.h from iwl-devtrace.h
Date: Wed, 24 Mar 2010 17:48:56 +0900
Message-Id: <1269420538-18039-3-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269420538-18039-1-git-send-email-tj@kernel.org>
References: <1269420538-18039-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 24 Mar 2010 08:49:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

iwl-devtrace.h is used to declare and define trace points and
including iwl-dev.h from the file, which in turn includes other
generic headers can lead to problems like generating duplicate copies
of generic trace points depending on the order of includes.  Don't
include iwl-dev.h from iwl-devtrace.h but include it from its users -
iwl-io.h and iwl-devtrace.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Zhu Yi <yi.zhu@intel.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
---
 drivers/net/wireless/iwlwifi/iwl-devtrace.c |    2 ++
 drivers/net/wireless/iwlwifi/iwl-devtrace.h |    1 -
 drivers/net/wireless/iwlwifi/iwl-io.h       |    1 +
 3 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.c b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
index 36580d8..2ffc2ed 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.c
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.c
@@ -28,6 +28,8 @@
 
 /* sparse doesn't like tracepoint macros */
 #ifndef __CHECKER__
+#include "iwl-dev.h"
+
 #define CREATE_TRACE_POINTS
 #include "iwl-devtrace.h"
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
index ff4d012..ae7319b 100644
--- a/drivers/net/wireless/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/iwlwifi/iwl-devtrace.h
@@ -28,7 +28,6 @@
 #define __IWLWIFI_DEVICE_TRACE
 
 #include <linux/tracepoint.h>
-#include "iwl-dev.h"
 
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
 #undef TRACE_EVENT
diff --git a/drivers/net/wireless/iwlwifi/iwl-io.h b/drivers/net/wireless/iwlwifi/iwl-io.h
index c719baf..16eb3ce 100644
--- a/drivers/net/wireless/iwlwifi/iwl-io.h
+++ b/drivers/net/wireless/iwlwifi/iwl-io.h
@@ -31,6 +31,7 @@
 
 #include <linux/io.h>
 
+#include "iwl-dev.h"
 #include "iwl-debug.h"
 #include "iwl-devtrace.h"
 
-- 
1.6.4.2

