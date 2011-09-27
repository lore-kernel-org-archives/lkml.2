Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752617Ab1I0Cvj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 22:51:39 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:41382 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752184Ab1I0Cvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 22:51:38 -0400
Date: Tue, 27 Sep 2011 12:51:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "Wey-Yi Guy" <wey-yi.w.guy@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: linux-next: manual merge of the net tree with the wireless-current
 tree
Message-Id: <20110927125132.002db8176a66f85286dcd027@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Today's linux-next merge of the net tree got a conflict in
drivers/net/wireless/iwlwifi/iwl-scan.c between commit 6c80c39d9a69
("iwlagn: fix dangling scan request") from the wireless-current tree and
commits 63013ae30159 ("iwlagn: priv->status moves to iwl_shared") and
6ac2f839b0b2 ("iwlagn: priv->mutex moves to iwl_shared") from the net
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/net/wireless/iwlwifi/iwl-scan.c
index 77e528f,fc5af34..0000000
--- a/drivers/net/wireless/iwlwifi/iwl-scan.c
+++ b/drivers/net/wireless/iwlwifi/iwl-scan.c
@@@ -403,8 -413,19 +413,8 @@@ int iwl_mac_hw_scan(struct ieee80211_h
  	if (req->n_channels == 0)
  		return -EINVAL;
  
- 	mutex_lock(&priv->mutex);
+ 	mutex_lock(&priv->shrd->mutex);
  
 -	if (test_bit(STATUS_SCANNING, &priv->shrd->status) &&
 -	    priv->scan_type != IWL_SCAN_NORMAL) {
 -		IWL_DEBUG_SCAN(priv, "Scan already in progress.\n");
 -		ret = -EAGAIN;
 -		goto out_unlock;
 -	}
 -
 -	/* mac80211 will only ask for one band at a time */
 -	priv->scan_request = req;
 -	priv->scan_vif = vif;
 -
  	/*
  	 * If an internal scan is in progress, just set
  	 * up the scan_request as per above.
@@@ -432,7 -439,8 +442,7 @@@
  
  	IWL_DEBUG_MAC80211(priv, "leave\n");
  
- 	mutex_unlock(&priv->mutex);
 -out_unlock:
+ 	mutex_unlock(&priv->shrd->mutex);
  
  	return ret;
  }
