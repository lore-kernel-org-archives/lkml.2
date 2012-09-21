Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932984Ab2IUKCG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 06:02:06 -0400
Received: from cpsmtpb-ews05.kpnxchange.com ([213.75.39.8]:1986 "EHLO
	cpsmtpb-ews05.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932742Ab2IUKCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 06:02:04 -0400
Message-ID: <1348221722.1581.12.camel@x61.thuisdomein>
Subject: [PATCH] ipw2x00: silence GCC warning for unused variable 'dev'
From: Paul Bolle <pebolle@tiscali.nl>
To: Stanislav Yakovlev <stas.yakovlev@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Fri, 21 Sep 2012 12:02:02 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-1.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 Sep 2012 10:02:02.0679 (UTC) FILETIME=[25D4E470:01CD97E0]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Building the libipw component without CONFIG_LIBIPW_DEBUG set triggers this GCC
warning:
    drivers/net/wireless/ipw2x00/libipw_wx.c:526:21: warning: unused variable 'dev' [-Wunused-variable]

The cause of this warning is that, without CONFIG_LIBIPW_DEBUG set,
LIBIPW_DEBUG_WX compiles away. Fix it by substituting ieee->dev for (its
equivalent) dev.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) I noticed this warning while building v3.6-rc6 on current Fedora 17,
using Fedora's default config.

1) Compile tested only (by just compiling libipw_wx.o).

 drivers/net/wireless/ipw2x00/libipw_wx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ipw2x00/libipw_wx.c b/drivers/net/wireless/ipw2x00/libipw_wx.c
index 1571505..54aba47 100644
--- a/drivers/net/wireless/ipw2x00/libipw_wx.c
+++ b/drivers/net/wireless/ipw2x00/libipw_wx.c
@@ -675,7 +675,7 @@ int libipw_wx_set_encodeext(struct libipw_device *ieee,
 	}
       done:
 	if (ieee->set_security)
-		ieee->set_security(ieee->dev, &sec);
+		ieee->set_security(dev, &sec);
 
 	return ret;
 }
-- 
1.7.11.4

