Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694Ab0CWAdG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 20:33:06 -0400
Received: from cantor.suse.de ([195.135.220.2]:45246 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755600Ab0CWAcO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 20:32:14 -0400
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Jan Kara <jack@suse.cz>, linux-wireless@vger.kernel.org
Subject: [PATCH 04/18] mac80211: Generate trace points only if api tracer enabled
Date: Tue, 23 Mar 2010 01:32:06 +0100
Message-Id: <1269304340-25372-5-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269304340-25372-1-git-send-email-jack@suse.cz>
References: <1269304340-25372-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CC: linux-wireless@vger.kernel.org
Signed-off-by: Jan Kara <jack@suse.cz>
---
 net/mac80211/driver-trace.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 41baf73..0e6c059 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1,11 +1,13 @@
 #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
 #define __MAC80211_DRIVER_TRACE
 
+#undef TRACE_CONFIG
+#define TRACE_CONFIG CONFIG_MAC80211_DRIVER_API_TRACER
 #include <linux/tracepoint.h>
 #include <net/mac80211.h>
 #include "ieee80211_i.h"
 
-#if !defined(CONFIG_MAC80211_DRIVER_API_TRACER) || defined(__CHECKER__)
+#if defined(__CHECKER__)
 #undef TRACE_EVENT
 #define TRACE_EVENT(name, proto, ...) \
 static inline void trace_ ## name(proto) {}
-- 
1.6.4.2

