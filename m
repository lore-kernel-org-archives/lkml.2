Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031546Ab2I1Tme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:42:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:51579 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965250Ab2I1S7n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 14:59:43 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 119/262] brcmfmac: fix big endian bug in i-scan.
Date: Fri, 28 Sep 2012 11:50:48 -0700
Message-Id: <20120928183012.160415570@linuxfoundation.org>
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

From: Hante Meuleman <meuleman@broadcom.com>

commit ed205b361956c96e0d8c09a8c9135a6a79cd9541 upstream.

ssid len is 32 bit and needs endian conversion for big endian systems.

Signed-off-by: Hante Meuleman <meuleman@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/wl_cfg80211.c
@@ -500,8 +500,10 @@ static void wl_iscan_prep(struct brcmf_s
 	params_le->active_time = cpu_to_le32(-1);
 	params_le->passive_time = cpu_to_le32(-1);
 	params_le->home_time = cpu_to_le32(-1);
-	if (ssid && ssid->SSID_len)
-		memcpy(&params_le->ssid_le, ssid, sizeof(struct brcmf_ssid));
+	if (ssid && ssid->SSID_len) {
+		params_le->ssid_le.SSID_len = cpu_to_le32(ssid->SSID_len);
+		memcpy(&params_le->ssid_le.SSID, ssid->SSID, ssid->SSID_len);
+	}
 }
 
 static s32


