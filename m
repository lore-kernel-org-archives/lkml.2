Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936171Ab1KJD4c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:56:32 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45113 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965993Ab1KJDsM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:48:12 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:07 2011
Message-Id: <20111109213207.073441721@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:51 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Eliad Peller <eliad@wizery.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [244/264] mac80211: config hw when going back on-channel
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 6911bf0453e0d6ea8eb694a4ce67a68d071c538e upstream.

When going back on-channel, we should reconfigure
the hw iff the hardware is not already configured
to the operational channel.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 net/mac80211/work.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/mac80211/work.c
+++ b/net/mac80211/work.c
@@ -1093,7 +1093,6 @@ static void ieee80211_work_work(struct w
 	}
 
 	if (!remain_off_channel && local->tmp_channel) {
-		bool on_oper_chan = ieee80211_cfg_on_oper_channel(local);
 		local->tmp_channel = NULL;
 		/* If tmp_channel wasn't operating channel, then
 		 * we need to go back on-channel.
@@ -1103,7 +1102,7 @@ static void ieee80211_work_work(struct w
 		 * we still need to do a hardware config.  Currently,
 		 * we cannot be here while scanning, however.
 		 */
-		if (ieee80211_cfg_on_oper_channel(local) && !on_oper_chan)
+		if (!ieee80211_cfg_on_oper_channel(local))
 			ieee80211_hw_config(local, 0);
 
 		/* At the least, we need to disable offchannel_ps,


