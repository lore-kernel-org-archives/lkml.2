Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932491Ab0DGB6G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 21:58:06 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:57639 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932412Ab0DGB57 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 21:57:59 -0400
X-Authority-Analysis: v=1.1 cv=1G73JCAd+9Vhhx30tk0+Sc/rngIYAy4Ia+6Xn7XSY0k= c=1 sm=0 a=WnmCEawLP7YA:10 a=7U3hwN5JcxgA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=stkexhm8AAAA:8 a=vmLDa1wCAAAA:8 a=meVymXHHAAAA:8 a=W_0wKJI25PAUMmnWhpIA:9 a=ee1otBIoTRs1GaKok8Rx0QTHeaEA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=DV8Pb4sAe4kA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: [PATCH][GIT PULL] tracing/mac80211: Move TRACE_SYSTEM out of #if
 protection
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: LKML <linux-kernel@vger.kernel.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
       Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Tue, 06 Apr 2010 21:57:57 -0400
Message-ID: <1270605477.19685.15613.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


John,

You can pull this or just use this patch. Which ever you prefer.

Please pull the latest wireless tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
wireless


Steven Rostedt (1):
      tracing/mac80211: Move TRACE_SYSTEM out of #if protection

----
 net/mac80211/driver-trace.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)
---------------------------
commit 27322da6e367b9e83d6b734f9a9ca3b8827d7b24
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Tue Apr 6 21:50:55 2010 -0400

    tracing/mac80211: Move TRACE_SYSTEM out of #if protection
    
    As explained in:
    
    commit d0b6e04a4cd8360e3c9c419f7c30a3081a0c142a
    tracing/events: Move TRACE_SYSTEM outside of include guard
    
    The TRACE_SYSTEM must be outside the #if include protection.
    
    Cc: Johannes Berg <johannes@sipsolutions.net>
    Cc: John W. Linville <linville@tuxdriver.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/net/mac80211/driver-trace.h b/net/mac80211/driver-trace.h
index 41baf73..f5a4239 100644
--- a/net/mac80211/driver-trace.h
+++ b/net/mac80211/driver-trace.h
@@ -1,3 +1,6 @@
+#undef TRACE_SYSTEM
+#define TRACE_SYSTEM mac80211
+
 #if !defined(__MAC80211_DRIVER_TRACE) || defined(TRACE_HEADER_MULTI_READ)
 #define __MAC80211_DRIVER_TRACE
 
@@ -11,9 +14,6 @@
 static inline void trace_ ## name(proto) {}
 #endif
 
-#undef TRACE_SYSTEM
-#define TRACE_SYSTEM mac80211
-
 #define MAXNAME		32
 #define LOCAL_ENTRY	__array(char, wiphy_name, 32)
 #define LOCAL_ASSIGN	strlcpy(__entry->wiphy_name, wiphy_name(local->hw.wiphy), MAXNAME)


