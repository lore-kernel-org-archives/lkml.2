Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933641Ab2ERCwc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 22:52:32 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:40401 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1762553Ab2ERCw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 22:52:28 -0400
Message-Id: <20120518023257.040479537@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 18 May 2012 03:33:14 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jonathan Nieder <jrnieder@gmail.com>
Subject: [ 20/53] brcm80211: smac: pass missing argument to brcms_b_mute
In-Reply-To: <20120518023254.339945758@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.185
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonathan Nieder <jrnieder@gmail.com>

[Not needed upstream --- this bug is specific to 3.2.y.]

Commit c6c44893c864, which removes the flag argument from brcms_b_mute,
is not part of 3.2.y, and we forgot to adjust a new call accordingly
when applying commit badc4f07622f ("brcm80211: smac: resume transmit
fifo upon receiving frames").

 drivers/net/wireless/brcm80211/brcmsmac/main.c: In function 'brcms_c_recvctl':
 drivers/net/wireless/brcm80211/brcmsmac/main.c:7882:4: error: too few arguments to function 'brcms_b_mute'
 drivers/net/wireless/brcm80211/brcmsmac/main.c:2538:13: note: declared here

Earlier build tests missed this because they didn't include this driver
due to 'depends on BCMA=n'.

Reported-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/wireless/brcm80211/brcmsmac/main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c b/drivers/net/wireless/brcm80211/brcmsmac/main.c
index f98becc9e169..833cbefcbfd2 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
+++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
@@ -7879,7 +7879,7 @@ brcms_c_recvctl(struct brcms_c_info *wlc, struct d11rxhdr *rxh,
 	if (wlc->hw->suspended_fifos) {
 		hdr = (struct ieee80211_hdr *)p->data;
 		if (ieee80211_is_beacon(hdr->frame_control))
-			brcms_b_mute(wlc->hw, false);
+			brcms_b_mute(wlc->hw, false, 0);
 	}
 
 	memcpy(IEEE80211_SKB_RXCB(p), &rx_status, sizeof(rx_status));
-- 
1.7.10.1





