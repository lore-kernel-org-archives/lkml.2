Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932795Ab1ERC4j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 22:56:39 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:39835 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755436Ab1ERC4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 22:56:38 -0400
Date: Wed, 18 May 2011 12:56:33 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jouni Malinen <jouni.malinen@atheros.com>,
        Sukesh Srikakula <sukeshs@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>
Subject: linux-next: manual merge of the staging tree with the wireless tree
Message-Id: <20110518125633.0164cb32.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c between commit
5a083c0aba95 ("cfg80211: Use consistent BSS matching between scan and
sme") from the wireless tree and commit e494632efcd9 ("staging:
brcm80211: Fixed bss (re)connect/disconnect issues in brcmfmac driver")
from the staging tree.

I fixed it up (see below) anc can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 7aaf99c,e3b409b..0000000
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@@ -2627,17 -2863,20 +2863,19 @@@ wl_bss_roaming_done(struct wl_priv *wl
  	struct wl_connect_info *conn_info = wl_to_conn(wl);
  	s32 err = 0;
  
+ 	WL_TRACE("Enter\n");
+ 
  	wl_get_assoc_ies(wl);
- 	memcpy(&wl->bssid, &e->addr, ETH_ALEN);
+ 	wl_update_prof(wl, NULL, &e->addr, WL_PROF_BSSID);
  	wl_update_bss_info(wl);
 -
 -	cfg80211_roamed(ndev,
 +	cfg80211_roamed(ndev, NULL,
- 			(u8 *)&wl->bssid,
+ 			(u8 *)wl_read_prof(wl, WL_PROF_BSSID),
  			conn_info->req_ie, conn_info->req_ie_len,
  			conn_info->resp_ie, conn_info->resp_ie_len, GFP_KERNEL);
- 	WL_DBG("Report roaming result\n");
+ 	WL_CONN("Report roaming result\n");
  
  	set_bit(WL_STATUS_CONNECTED, &wl->status);
- 
+ 	WL_TRACE("Exit\n");
  	return err;
  }
  
