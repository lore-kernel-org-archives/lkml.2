Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992828Ab2K3S4x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 13:56:53 -0500
Received: from mail.kernel.org ([198.145.19.201]:58543 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992760Ab2K3S4k (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 13:56:40 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [ 08/56] rtlwifi: rtl8192se: Fix gcc 4.7.x warning
Date: Fri, 30 Nov 2012 10:55:00 -0800
Message-Id: <20121130185119.192350431@linuxfoundation.org>
X-Mailer: git-send-email 1.8.0.197.g5a90748
In-Reply-To: <20121130185118.302752929@linuxfoundation.org>
References: <20121130185118.302752929@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Larry Finger <Larry.Finger@lwfinger.net>

commit f761b6947dde42890beea59b020e1be87491809e upstream.

With gcc 4.7.x, the following warning is issued as the routine that sets
the array has the possibility of not initializing the values:

  CC [M]  drivers/net/wireless/rtlwifi/rtl8192se/phy.o
drivers/net/wireless/rtlwifi/rtl8192se/phy.c: In function ‘rtl92s_phy_set_txpower’:
drivers/net/wireless/rtlwifi/rtl8192se/phy.c:1268:23: warning: ‘ofdmpowerLevel[0]’ may be used uninitialized in this function [-Wuninitialized]

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/rtlwifi/rtl8192se/phy.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192se/phy.c
@@ -1247,6 +1247,9 @@ static void _rtl92s_phy_get_txpower_inde
 		/* Read HT 40 OFDM TX power */
 		ofdmpowerLevel[0] = rtlefuse->txpwrlevel_ht40_2s[0][index];
 		ofdmpowerLevel[1] = rtlefuse->txpwrlevel_ht40_2s[1][index];
+	} else {
+		ofdmpowerLevel[0] = 0;
+		ofdmpowerLevel[1] = 0;
 	}
 }
 


