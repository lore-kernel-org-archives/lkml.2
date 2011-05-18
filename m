Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933613Ab1ERSxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 14:53:34 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:2845 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933562Ab1ERSxd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 14:53:33 -0400
X-Server-Uuid: D3C04415-6FA8-4F2C-93C1-920E106A2031
From: "Sukesh Srikakula" <sukeshs@broadcom.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>, "Greg KH" <greg@kroah.com>
cc: "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jouni Malinen" <jouni.malinen@atheros.com>,
        "Arend Van Spriel" <arend@broadcom.com>
Date: Wed, 18 May 2011 11:53:22 -0700
Subject: RE: linux-next: manual merge of the staging tree with the
 wireless tree
Thread-Topic: linux-next: manual merge of the staging tree with the
 wireless tree
Thread-Index: AcwVBzuAG2Lh66i5Q1iM2tgRMRnJAQAhVwqg
Message-ID: <400C43189542CE41BC0A5B252FC901369670F0AD03@SJEXCHCCR02.corp.ad.broadcom.com>
References: <20110518125633.0164cb32.sfr@canb.auug.org.au>
In-Reply-To: <20110518125633.0164cb32.sfr@canb.auug.org.au>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 61CAC9093IC2832121-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

Thanks for merging. 
Merge looks to be fine.

Regards,
Sukesh.

-----Original Message-----
From: Stephen Rothwell [mailto:sfr@canb.auug.org.au] 
Sent: Tuesday, May 17, 2011 7:57 PM
To: Greg KH
Cc: linux-next@vger.kernel.org; linux-kernel@vger.kernel.org; Jouni Malinen; Sukesh Srikakula; Arend Van Spriel
Subject: linux-next: manual merge of the staging tree with the wireless tree

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
  


