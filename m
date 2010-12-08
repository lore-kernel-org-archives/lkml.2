Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab0LHX5V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 18:57:21 -0500
Received: from web31803.mail.mud.yahoo.com ([68.142.207.66]:30506 "HELO
	web31803.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755283Ab0LHX5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 18:57:20 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=MZz9iYBMVd/SYjYTy+WQzRZsCBgO3o+AzVXZ25obzbrLAtddoBtUwrV6NUqX1BppvUM2/3xUi3DnJfoYckq4N2Y8Wva6AX/gXcZG/nkCsNbJJHA+aeQrl5RSOhwlcqg+42/kpDZFo/yIPI5VZG5Al1wd2ntEETlEOuvPMamszBg=;
Message-ID: <868332.80097.qm@web31803.mail.mud.yahoo.com>
X-YMail-OSG: aWGq.7IVM1m4LNdvaklVjA7wKowPJ65_CmaIMcj5_mr2dfb
 O5W349LfYgM3QQpGrnQUIhy7dcNB3PZ_RgecCVmFeU3ZcQIJANu97xm9WiZy
 NY0fBX3K_UbInkhzLNWR3l6HsQCxlsD9IlgB2buIDFpQRQXIK_sP2dUOKz76
 nb2fU0RMqASseXH5t3o89RSxGbQ1Jxqpl6af69utvd7HAdhuHsvQuoqVFXNH
 1v81bDJEEs_jyNiQxHkkJPd3r91DIP8amB8gQ_Z2uVb9Acxm6VZdm7hmgwgI
 rF6d9cnX_91KhT9VPu8HON9diNaHU_XlZQbeXeCXUMBno.1rVPHfqIsZ9i3g
 KUcypI.6YBys3tm3R7w--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Wed, 8 Dec 2010 15:57:18 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: [PATCH 4/4] [USB] UASP: Return -ENODEV instead of -1 on error
To: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return -ENODEV instead of -1 on configuration
errors when discovering the attached device.

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/usb/storage/uasp.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/storage/uasp.c b/drivers/usb/storage/uasp.c
index 40ee5a4..eb8933f 100644
--- a/drivers/usb/storage/uasp.c
+++ b/drivers/usb/storage/uasp.c
@@ -943,7 +943,7 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
 	    tpinfo->eps[2] == NULL || tpinfo->eps[3] == NULL) {
 		dev_err(&udev->dev, "%s: one or more endpoints are missing\n",
 			__func__);
-		return -1;
+		return -ENODEV;
 	}
 
 	tpinfo->cmd_pipe = usb_sndbulkpipe(udev,
@@ -968,7 +968,7 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
 		
 		if (tpinfo->max_streams <= 1) {
 			dev_err(&udev->dev, "%s: no streams\n", __func__);
-			return -1;
+			return -ENODEV;
 		}
 		
 		tpinfo->use_streams = 1;
@@ -985,7 +985,7 @@ static int uasp_ep_conf(struct uasp_tport_info *tpinfo)
 				"%s: Couldn't allocate %d streams (%d)\n",
 				__func__, tpinfo->max_streams,
 				tpinfo->num_streams);
-			return -1;
+			return -ENODEV;
 		}
 
 		uasp_set_max_cmds(tpinfo);
-- 
1.7.0.1


