Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032480Ab2I1U0f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:26:35 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:61998 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1032464Ab2I1U0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:26:30 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Hante Meuleman <meuleman@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 093/218] brcmfmac: fix big endian bug in i-scan.
Date: Fri, 28 Sep 2012 13:15:10 -0700
Message-Id: <20120928201512.221612969@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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


