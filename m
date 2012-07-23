Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2GWBvJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2012 21:51:09 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54388 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753486Ab2GWBnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2012 21:43:25 -0400
Message-Id: <20120723010659.036563148@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 23 Jul 2012 02:07:41 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Michal Kazior <michal.kazior@tieto.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 050/108] cfg80211: check iface combinations only when iface is running
In-Reply-To: <20120723010651.408577075@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Kazior <michal.kazior@tieto.com>

commit f8cdddb8d61d16a156229f0910f7ecfc7a82c003 upstream.

Don't validate interface combinations on a stopped
interface. Otherwise we might end up being able to
create a new interface with a certain type, but
won't be able to change an existing interface
into that type.

This also skips some other functions when
interface is stopped and changing interface type.

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/util.c b/net/wireless/util.c
index 8f2d68f..316cfd0 100644
--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -804,7 +804,7 @@ int cfg80211_change_iface(struct cfg80211_registered_device *rdev,
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
-	if (ntype != otype) {
+	if (ntype != otype && netif_running(dev)) {
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
 		if (err)


