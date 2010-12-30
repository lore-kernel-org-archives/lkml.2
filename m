Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0L3EDF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Dec 2010 23:03:05 -0500
Received: from smtp-out.google.com ([216.239.44.51]:38153 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751888Ab0L3ECy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Dec 2010 23:02:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=vkPt+p/+vtra3VZFDJ/yP/cnL8hT6WDSWMEATtfKbV6c9K5kqdi93icqnnnnoTg/0o
         cMWi5eKbzGFptwEv622g==
Date: Wed, 29 Dec 2010 20:02:49 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Ingo Molnar <mingo@elte.hu>, Greg KH <gregkh@suse.de>,
        "David S. Miller" <davem@davemloft.net>, Jens Axboe <axboe@kernel.dk>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [patch 6/8] init: rename CONFIG_EMBEDDED to CONFIG_EXPERT
In-Reply-To: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1012292001250.27241@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1012291959200.27241@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CONFIG_EMBEDDED has been renamed to CONFIG_EXPERT, so fix it in the net/
directory.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 net/mac80211/Kconfig |    6 +++---
 net/rfkill/Kconfig   |    4 ++--
 net/wireless/Kconfig |    2 +-
 3 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
--- a/net/mac80211/Kconfig
+++ b/net/mac80211/Kconfig
@@ -19,7 +19,7 @@ config MAC80211_HAS_RC
 	def_bool n
 
 config MAC80211_RC_PID
-	bool "PID controller based rate control algorithm" if EMBEDDED
+	bool "PID controller based rate control algorithm" if EXPERT
 	select MAC80211_HAS_RC
 	---help---
 	  This option enables a TX rate control algorithm for
@@ -27,14 +27,14 @@ config MAC80211_RC_PID
 	  rate.
 
 config MAC80211_RC_MINSTREL
-	bool "Minstrel" if EMBEDDED
+	bool "Minstrel" if EXPERT
 	select MAC80211_HAS_RC
 	default y
 	---help---
 	  This option enables the 'minstrel' TX rate control algorithm
 
 config MAC80211_RC_MINSTREL_HT
-	bool "Minstrel 802.11n support" if EMBEDDED
+	bool "Minstrel 802.11n support" if EXPERT
 	depends on MAC80211_RC_MINSTREL
 	default y
 	---help---
diff --git a/net/rfkill/Kconfig b/net/rfkill/Kconfig
--- a/net/rfkill/Kconfig
+++ b/net/rfkill/Kconfig
@@ -18,7 +18,7 @@ config RFKILL_LEDS
 	default y
 
 config RFKILL_INPUT
-	bool "RF switch input support" if EMBEDDED
+	bool "RF switch input support" if EXPERT
 	depends on RFKILL
 	depends on INPUT = y || RFKILL = INPUT
-	default y if !EMBEDDED
+	default y if !EXPERT
diff --git a/net/wireless/Kconfig b/net/wireless/Kconfig
--- a/net/wireless/Kconfig
+++ b/net/wireless/Kconfig
@@ -95,7 +95,7 @@ config CFG80211_DEBUGFS
 	  If unsure, say N.
 
 config CFG80211_INTERNAL_REGDB
-	bool "use statically compiled regulatory rules database" if EMBEDDED
+	bool "use statically compiled regulatory rules database" if EXPERT
 	default n
 	depends on CFG80211
 	---help---
