Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab2I1S7p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 14:59:45 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:44036 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965261Ab2I1S7k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Eliad Peller <eliad@wizery.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [ 118/262] mac80211: clear bssid on auth/assoc failure
Date: Fri, 28 Sep 2012 11:50:47 -0700
Message-Id: <20120928183012.053293129@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3270,6 +3270,8 @@ int ieee80211_mgd_auth(struct ieee80211_
 	goto out_unlock;
 
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->auth_data = NULL;
  err_free:
 	kfree(auth_data);
@@ -3449,6 +3451,8 @@ int ieee80211_mgd_assoc(struct ieee80211
 	err = 0;
 	goto out;
  err_clear:
+	memset(ifmgd->bssid, 0, ETH_ALEN);
+	ieee80211_bss_info_change_notify(sdata, BSS_CHANGED_BSSID);
 	ifmgd->assoc_data = NULL;
  err_free:
 	kfree(assoc_data);


