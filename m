Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754407Ab0CSB3w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 21:29:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1885 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab0CSB3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 21:29:49 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Richard Kennedy <richard@rsk.demon.co.uk>,
       Johannes Berg <johannes@sipsolutions.net>,
       Pavel Roskin <proski@gnu.org>,
       David Gibson <hermes@gibson.dropbear.id.au>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-wireless@vger.kernel.org, orinoco-users@lists.sourceforge.net,
       orinoco-devel@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH v3 8/9] orinoco/wext.c: Remove local #define STD_IW_HANDLER
Date: Thu, 18 Mar 2010 18:29:39 -0700
Message-Id: <d71351dbdd9b827b376351213012c134e7c7ddf7.1268961559.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.14.g7e948
In-Reply-To: <cover.1268961559.git.joe@perches.com>
References: <cover.1268961559.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use IW_HANDLER from wireless.h instead

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/orinoco/wext.c |   94 +++++++++++++++++------------------
 1 files changed, 46 insertions(+), 48 deletions(-)

diff --git a/drivers/net/wireless/orinoco/wext.c b/drivers/net/wireless/orinoco/wext.c
index 31ca241..29f9bc0 100644
--- a/drivers/net/wireless/orinoco/wext.c
+++ b/drivers/net/wireless/orinoco/wext.c
@@ -1505,46 +1505,44 @@ static const struct iw_priv_args orinoco_privtab[] = {
  * Structures to export the Wireless Handlers
  */
 
-#define STD_IW_HANDLER(id, func) \
-	[IW_IOCTL_IDX(id)] = (iw_handler) func
 static const iw_handler	orinoco_handler[] = {
-	STD_IW_HANDLER(SIOCSIWCOMMIT,	orinoco_ioctl_commit),
-	STD_IW_HANDLER(SIOCGIWNAME,	cfg80211_wext_giwname),
-	STD_IW_HANDLER(SIOCSIWFREQ,	orinoco_ioctl_setfreq),
-	STD_IW_HANDLER(SIOCGIWFREQ,	orinoco_ioctl_getfreq),
-	STD_IW_HANDLER(SIOCSIWMODE,	cfg80211_wext_siwmode),
-	STD_IW_HANDLER(SIOCGIWMODE,	cfg80211_wext_giwmode),
-	STD_IW_HANDLER(SIOCSIWSENS,	orinoco_ioctl_setsens),
-	STD_IW_HANDLER(SIOCGIWSENS,	orinoco_ioctl_getsens),
-	STD_IW_HANDLER(SIOCGIWRANGE,	cfg80211_wext_giwrange),
-	STD_IW_HANDLER(SIOCSIWSPY,	iw_handler_set_spy),
-	STD_IW_HANDLER(SIOCGIWSPY,	iw_handler_get_spy),
-	STD_IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
-	STD_IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
-	STD_IW_HANDLER(SIOCSIWAP,	orinoco_ioctl_setwap),
-	STD_IW_HANDLER(SIOCGIWAP,	orinoco_ioctl_getwap),
-	STD_IW_HANDLER(SIOCSIWSCAN,	cfg80211_wext_siwscan),
-	STD_IW_HANDLER(SIOCGIWSCAN,	cfg80211_wext_giwscan),
-	STD_IW_HANDLER(SIOCSIWESSID,	orinoco_ioctl_setessid),
-	STD_IW_HANDLER(SIOCGIWESSID,	orinoco_ioctl_getessid),
-	STD_IW_HANDLER(SIOCSIWRATE,	orinoco_ioctl_setrate),
-	STD_IW_HANDLER(SIOCGIWRATE,	orinoco_ioctl_getrate),
-	STD_IW_HANDLER(SIOCSIWRTS,	orinoco_ioctl_setrts),
-	STD_IW_HANDLER(SIOCGIWRTS,	orinoco_ioctl_getrts),
-	STD_IW_HANDLER(SIOCSIWFRAG,	orinoco_ioctl_setfrag),
-	STD_IW_HANDLER(SIOCGIWFRAG,	orinoco_ioctl_getfrag),
-	STD_IW_HANDLER(SIOCGIWRETRY,	orinoco_ioctl_getretry),
-	STD_IW_HANDLER(SIOCSIWENCODE,	orinoco_ioctl_setiwencode),
-	STD_IW_HANDLER(SIOCGIWENCODE,	orinoco_ioctl_getiwencode),
-	STD_IW_HANDLER(SIOCSIWPOWER,	orinoco_ioctl_setpower),
-	STD_IW_HANDLER(SIOCGIWPOWER,	orinoco_ioctl_getpower),
-	STD_IW_HANDLER(SIOCSIWGENIE,	orinoco_ioctl_set_genie),
-	STD_IW_HANDLER(SIOCGIWGENIE,	orinoco_ioctl_get_genie),
-	STD_IW_HANDLER(SIOCSIWMLME,	orinoco_ioctl_set_mlme),
-	STD_IW_HANDLER(SIOCSIWAUTH,	orinoco_ioctl_set_auth),
-	STD_IW_HANDLER(SIOCGIWAUTH,	orinoco_ioctl_get_auth),
-	STD_IW_HANDLER(SIOCSIWENCODEEXT, orinoco_ioctl_set_encodeext),
-	STD_IW_HANDLER(SIOCGIWENCODEEXT, orinoco_ioctl_get_encodeext),
+	IW_HANDLER(SIOCSIWCOMMIT,	(iw_handler)orinoco_ioctl_commit),
+	IW_HANDLER(SIOCGIWNAME,		(iw_handler)cfg80211_wext_giwname),
+	IW_HANDLER(SIOCSIWFREQ,		(iw_handler)orinoco_ioctl_setfreq),
+	IW_HANDLER(SIOCGIWFREQ,		(iw_handler)orinoco_ioctl_getfreq),
+	IW_HANDLER(SIOCSIWMODE,		(iw_handler)cfg80211_wext_siwmode),
+	IW_HANDLER(SIOCGIWMODE,		(iw_handler)cfg80211_wext_giwmode),
+	IW_HANDLER(SIOCSIWSENS,		(iw_handler)orinoco_ioctl_setsens),
+	IW_HANDLER(SIOCGIWSENS,		(iw_handler)orinoco_ioctl_getsens),
+	IW_HANDLER(SIOCGIWRANGE,	(iw_handler)cfg80211_wext_giwrange),
+	IW_HANDLER(SIOCSIWSPY,		iw_handler_set_spy),
+	IW_HANDLER(SIOCGIWSPY,		iw_handler_get_spy),
+	IW_HANDLER(SIOCSIWTHRSPY,	iw_handler_set_thrspy),
+	IW_HANDLER(SIOCGIWTHRSPY,	iw_handler_get_thrspy),
+	IW_HANDLER(SIOCSIWAP,		(iw_handler)orinoco_ioctl_setwap),
+	IW_HANDLER(SIOCGIWAP,		(iw_handler)orinoco_ioctl_getwap),
+	IW_HANDLER(SIOCSIWSCAN,		(iw_handler)cfg80211_wext_siwscan),
+	IW_HANDLER(SIOCGIWSCAN,		(iw_handler)cfg80211_wext_giwscan),
+	IW_HANDLER(SIOCSIWESSID,	(iw_handler)orinoco_ioctl_setessid),
+	IW_HANDLER(SIOCGIWESSID,	(iw_handler)orinoco_ioctl_getessid),
+	IW_HANDLER(SIOCSIWRATE,		(iw_handler)orinoco_ioctl_setrate),
+	IW_HANDLER(SIOCGIWRATE,		(iw_handler)orinoco_ioctl_getrate),
+	IW_HANDLER(SIOCSIWRTS,		(iw_handler)orinoco_ioctl_setrts),
+	IW_HANDLER(SIOCGIWRTS,		(iw_handler)orinoco_ioctl_getrts),
+	IW_HANDLER(SIOCSIWFRAG,		(iw_handler)orinoco_ioctl_setfrag),
+	IW_HANDLER(SIOCGIWFRAG,		(iw_handler)orinoco_ioctl_getfrag),
+	IW_HANDLER(SIOCGIWRETRY,	(iw_handler)orinoco_ioctl_getretry),
+	IW_HANDLER(SIOCSIWENCODE,	(iw_handler)orinoco_ioctl_setiwencode),
+	IW_HANDLER(SIOCGIWENCODE,	(iw_handler)orinoco_ioctl_getiwencode),
+	IW_HANDLER(SIOCSIWPOWER,	(iw_handler)orinoco_ioctl_setpower),
+	IW_HANDLER(SIOCGIWPOWER,	(iw_handler)orinoco_ioctl_getpower),
+	IW_HANDLER(SIOCSIWGENIE,	orinoco_ioctl_set_genie),
+	IW_HANDLER(SIOCGIWGENIE,	orinoco_ioctl_get_genie),
+	IW_HANDLER(SIOCSIWMLME,		orinoco_ioctl_set_mlme),
+	IW_HANDLER(SIOCSIWAUTH,		orinoco_ioctl_set_auth),
+	IW_HANDLER(SIOCGIWAUTH,		orinoco_ioctl_get_auth),
+	IW_HANDLER(SIOCSIWENCODEEXT,	orinoco_ioctl_set_encodeext),
+	IW_HANDLER(SIOCGIWENCODEEXT,	orinoco_ioctl_get_encodeext),
 };
 
 
@@ -1552,15 +1550,15 @@ static const iw_handler	orinoco_handler[] = {
   Added typecasting since we no longer use iwreq_data -- Moustafa
  */
 static const iw_handler	orinoco_private_handler[] = {
-	[0] = (iw_handler) orinoco_ioctl_reset,
-	[1] = (iw_handler) orinoco_ioctl_reset,
-	[2] = (iw_handler) orinoco_ioctl_setport3,
-	[3] = (iw_handler) orinoco_ioctl_getport3,
-	[4] = (iw_handler) orinoco_ioctl_setpreamble,
-	[5] = (iw_handler) orinoco_ioctl_getpreamble,
-	[6] = (iw_handler) orinoco_ioctl_setibssport,
-	[7] = (iw_handler) orinoco_ioctl_getibssport,
-	[9] = (iw_handler) orinoco_ioctl_getrid,
+	[0] = (iw_handler)orinoco_ioctl_reset,
+	[1] = (iw_handler)orinoco_ioctl_reset,
+	[2] = (iw_handler)orinoco_ioctl_setport3,
+	[3] = (iw_handler)orinoco_ioctl_getport3,
+	[4] = (iw_handler)orinoco_ioctl_setpreamble,
+	[5] = (iw_handler)orinoco_ioctl_getpreamble,
+	[6] = (iw_handler)orinoco_ioctl_setibssport,
+	[7] = (iw_handler)orinoco_ioctl_getibssport,
+	[9] = (iw_handler)orinoco_ioctl_getrid,
 };
 
 const struct iw_handler_def orinoco_handler_def = {
-- 
1.7.0.14.g7e948

