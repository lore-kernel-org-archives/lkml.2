Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933556Ab1I1Wxy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:53:54 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55054 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933516Ab1I1Wub (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:50:31 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:50 2011
Message-Id: <20110928220150.576775630@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 15:03:23 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [239/244] rtlwifi: rtl8192cu: Fix unitialized struct
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit 831d85471e761e190c3c8979b37540d699ae5812 upstream.

Driver rtl8192cu assigns a new struct rtl_tcb_desc object, but fails to
clear it.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/rtlwifi/usb.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/net/wireless/rtlwifi/usb.c
+++ b/drivers/net/wireless/rtlwifi/usb.c
@@ -861,6 +861,7 @@ static void _rtl_usb_tx_preprocess(struc
 	u8 tid = 0;
 	u16 seq_number = 0;
 
+	memset(&tcb_desc, 0, sizeof(struct rtl_tcb_desc));
 	if (ieee80211_is_auth(fc)) {
 		RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG, ("MAC80211_LINKING\n"));
 		rtl_ips_nic_on(hw);


