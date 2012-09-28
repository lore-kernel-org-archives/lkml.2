Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423352Ab2I1VlU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:41:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:52836 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032431Ab2I1U00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:26 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 092/218] mac80211: clear bssid on auth/assoc failure
Date: Fri, 28 Sep 2012 13:15:09 -0700
Message-Id: <20120928201512.111060377@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eliad Peller <eliad@wizery.com>

commit 3d2abdfdf14f4d6decc2023708211e19b096f4ca upstream.

ifmgd->bssid wasn't cleared properly in some
auth/assoc failure cases, causing mac80211 and
the low-level driver to go out of sync.

Clear ifmgd->bssid on failure, and notify the driver.

Signed-off-by: Eliad Peller <eliad@wizery.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/mac80211/mlme.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -3232,6 +3232,8 @@ int ieee80211_mgd_auth(struct ieee80211_
 	goto out_unlock;
 
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
  err_free:
 	kfree(auth_data);
@@ -3410,6 +3412,8 @@ int ieee80211_mgd_assoc(struct ieee80211
 	err = 0;
 	goto out;
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);


