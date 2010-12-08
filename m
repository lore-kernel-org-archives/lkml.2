Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932077Ab0LHA7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 19:59:50 -0500
Received: from kroah.org ([198.145.64.141]:48608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756993Ab0LHA7s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 19:59:48 -0500
X-Mailbox-Line: From gregkh@clark.site Tue Dec  7 16:57:26 2010
Message-Id: <20101208005726.738298142@clark.site>
User-Agent: quilt/0.48-11.2
Date: Tue, 07 Dec 2010 16:57:11 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Paul Stewart <pstew@google.com>, Amod Bodas <amod.bodas@atheros.com>,
        "Luis R. Rodriguez" <lrodriguez@atheros.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [054/289] mac80211: disable beacon monitor while going offchannel
In-Reply-To: <20101208005821.GA2922@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.36-stable review patch.  If anyone has any objections, please let us know.

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

---
 net/mac80211/offchannel.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/mac80211/offchannel.c
+++ b/net/mac80211/offchannel.c
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
 


