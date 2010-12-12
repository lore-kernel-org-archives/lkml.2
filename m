Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab0LLXpv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 18:45:51 -0500
Received: from one.firstfloor.org ([213.235.205.2]:44656 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab0LLXpR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 18:45:17 -0500
From: Andi Kleen <andi@firstfloor.org>
References: <201012131244.547034648@firstfloor.org>
In-Reply-To: <201012131244.547034648@firstfloor.org>
To: lrodriguez@atheros.com, pstew@google.com, amod.bodas@atheros.com,
        linville@tuxdriver.com, gregkh@suse.de, ak@linux.intel.com,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [20/223] mac80211: disable beacon monitor while going offchannel
Message-Id: <20101212234515.D7D9DB27BF@basil.firstfloor.org>
Date: Mon, 13 Dec 2010 00:45:15 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Luis R. Rodriguez <lrodriguez@atheros.com>

commit 3bc3c0d748402e8c1f31b8569f5924d25d7b8e30 upstream.

The beacon monitor should be disabled when going off channel
to prevent spurious warnings and triggering connection
deterioration work such as sending probe requests. Re-enable
the beacon monitor once we come back to the home channel.

This patch has fixes for stable kernels [2.6.34+].

Cc: Paul Stewart <pstew@google.com>
Cc: Amod Bodas <amod.bodas@atheros.com>
Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 net/mac80211/offchannel.c |    2 ++
 1 file changed, 2 insertions(+)

Index: linux/net/mac80211/offchannel.c
===================================================================
--- linux.orig/net/mac80211/offchannel.c
+++ linux/net/mac80211/offchannel.c
@@ -29,6 +29,7 @@ static void ieee80211_offchannel_ps_enab
 	/* FIXME: what to do when local->pspolling is true? */
 
 	del_timer_sync(&local->dynamic_ps_timer);
+	del_timer_sync(&ifmgd->bcn_mon_timer);
 	del_timer_sync(&ifmgd->conn_mon_timer);
 
 	cancel_work_sync(&local->dynamic_ps_enable_work);
@@ -89,6 +90,7 @@ static void ieee80211_offchannel_ps_disa
 			  msecs_to_jiffies(local->hw.conf.dynamic_ps_timeout));
 	}
 
+	ieee80211_sta_reset_beacon_monitor(sdata);
 	ieee80211_sta_reset_conn_monitor(sdata);
 }
 
