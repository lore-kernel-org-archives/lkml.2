Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2GRANd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:13:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52583 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757851Ab2GRANC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:13:02 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Michal Kazior <michal.kazior@tieto.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [ 12/23] cfg80211: check iface combinations only when iface is running
Date: Tue, 17 Jul 2012 17:12:05 -0700
Message-Id: <20120717232330.217606383@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232329.276003806@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232329.276003806@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
[Fixes regression introduced by cherry pick of 463454b5dbd8]
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

---
 net/wireless/util.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/wireless/util.c
+++ b/net/wireless/util.c
@@ -807,7 +807,7 @@ int cfg80211_change_iface(struct cfg8021
 	     ntype == NL80211_IFTYPE_P2P_CLIENT))
 		return -EBUSY;
 
-	if (ntype != otype) {
+	if (ntype != otype && netif_running(dev)) {
 		err = cfg80211_can_change_interface(rdev, dev->ieee80211_ptr,
 						    ntype);
 		if (err)


