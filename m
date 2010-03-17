Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753862Ab0CQRsI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 13:48:08 -0400
Received: from mail.perches.com ([173.55.12.10]:1755 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab0CQRsG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 13:48:06 -0400
Subject: [PATCH 2/2] net/wireless/wext_core.c: Use IW_EVENT_IDX macro
From: Joe Perches <joe@perches.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Andy Whitcroft <apw@canonical.com>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1268847991.1652.106.camel@Joe-Laptop.home>
References: <1268823629.1999.9.camel@localhost>
	 <1268839535.1652.43.camel@Joe-Laptop.home>
	 <1268840454.1999.22.camel@localhost>
	 <1268841904.1652.94.camel@Joe-Laptop.home>
	 <1268842112.5989.8.camel@jlt3.sipsolutions.net>
	 <1268847991.1652.106.camel@Joe-Laptop.home>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 10:48:04 -0700
Message-ID: <1268848084.1652.108.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a wireless.h macro for this, might as well use it.

Signed-off-by: Joe Perches <joe@perches.com>
---
diff --git a/net/wireless/wext-core.c b/net/wireless/wext-core.c
index dbde22b..bfcbeee 100644
--- a/net/wireless/wext-core.c
+++ b/net/wireless/wext-core.c
@@ -261,44 +261,44 @@ static const unsigned standard_ioctl_num = ARRAY_SIZE(standard_ioctl);
  * we know about.
  */
 static const struct iw_ioctl_description standard_event[] = {
-	[IWEVTXDROP	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVTXDROP)] = {
 		.header_type	= IW_HEADER_TYPE_ADDR,
 	},
-	[IWEVQUAL	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVQUAL)] = {
 		.header_type	= IW_HEADER_TYPE_QUAL,
 	},
-	[IWEVCUSTOM	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVCUSTOM)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= IW_CUSTOM_MAX,
 	},
-	[IWEVREGISTERED	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVREGISTERED)] = {
 		.header_type	= IW_HEADER_TYPE_ADDR,
 	},
-	[IWEVEXPIRED	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVEXPIRED)] = {
 		.header_type	= IW_HEADER_TYPE_ADDR,
 	},
-	[IWEVGENIE	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVGENIE)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= IW_GENERIC_IE_MAX,
 	},
-	[IWEVMICHAELMICFAILURE	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVMICHAELMICFAILURE)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= sizeof(struct iw_michaelmicfailure),
 	},
-	[IWEVASSOCREQIE	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVASSOCREQIE)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= IW_GENERIC_IE_MAX,
 	},
-	[IWEVASSOCRESPIE	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVASSOCRESPIE)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= IW_GENERIC_IE_MAX,
 	},
-	[IWEVPMKIDCAND	- IWEVFIRST] = {
+	[IW_EVENT_IDX(IWEVPMKIDCAND)] = {
 		.header_type	= IW_HEADER_TYPE_POINT,
 		.token_size	= 1,
 		.max_tokens	= sizeof(struct iw_pmkid_cand),
@@ -453,7 +453,7 @@ void wireless_send_event(struct net_device *	dev,
 		if (cmd_index < standard_ioctl_num)
 			descr = &(standard_ioctl[cmd_index]);
 	} else {
-		cmd_index = cmd - IWEVFIRST;
+		cmd_index = IW_EVENT_IDX(cmd);
 		if (cmd_index < standard_event_num)
 			descr = &(standard_event[cmd_index]);
 	}


