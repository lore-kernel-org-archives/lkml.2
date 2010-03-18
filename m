Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753145Ab0CRGXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 02:23:48 -0400
Received: from mail.perches.com ([173.55.12.10]:1785 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752728Ab0CRGVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 02:21:45 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       "David S. Miller" <davem@davemloft.net>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org
Subject: [PATCH v2 3/7] net/wireless/wext-core.c: Use IW_EVENT_IDX macro
Date: Wed, 17 Mar 2010 23:21:36 -0700
Message-Id: <43329e554e9c7ee1a7e3eaa6e20a7ab329cbb3eb.1268892664.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1268892663.git.joe@perches.com>
References: <cover.1268892663.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's a wireless.h macro for this, might as well use it.

Signed-off-by: Joe Perches <joe@perches.com>
---
 net/wireless/wext-core.c |   22 +++++++++++-----------
 1 files changed, 11 insertions(+), 11 deletions(-)

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
-- 
1.7.0.14.g7e948

