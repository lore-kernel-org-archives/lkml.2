Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754450Ab2BDV1u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Feb 2012 16:27:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48912 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754022Ab2BDV1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Feb 2012 16:27:49 -0500
X-Authority-Analysis: v=2.0 cv=T9kOvo2Q c=1 sm=0 a=4xDcOe4IjvRdPVVETi+CqA==:17 a=TRgVYD6ZyiEA:10 a=F5tMN8wPD2kA:10 a=Zx2FLkwYMp0A:10 a=kj9zAlcOel0A:10 a=yQdBAQUQAAAA:8 a=avBIM0DbfhNPUOXmNLkA:9 a=pizzB0DndZaKmPALZsYA:7 a=CjuIK1q_8ugA:10 a=IcxpeKGZWnEA:10 a=4xDcOe4IjvRdPVVETi+CqA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 75.81.36.228
Date: Sat, 04 Feb 2012 15:28:06 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: r8712u: Remove configuration parameter
 CONFIG_R8712_AP
Message-ID: <4f2da2e6.fVTqWGXhdTGpLskE%Larry.Finger@lwfinger.net>
User-Agent: Heirloom mailx 12.5 7/5/10
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The configuration parameter R8712_AP is misleading as the driver cannot
function as an AP without a heavily hacked version of hostapd. Thus, it
makes sense to remove the parameter; however the code and data configured
for the option is left in.

Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
---

Index: wireless-testing-new/drivers/staging/rtl8712/Kconfig
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/Kconfig
+++ wireless-testing-new/drivers/staging/rtl8712/Kconfig
@@ -9,13 +9,6 @@ config R8712U
 	This option adds the Realtek RTL8712 USB device such as the D-Link DWA-130.
 	If built as a module, it will be called r8712u.
 
-config R8712_AP
-	bool "Realtek RTL8712U AP code"
-	depends on R8712U
-	default N
-	---help---
-	This option allows the Realtek RTL8712 USB device to be an Access Point.
-
 config R8712_TX_AGGR
 	bool "Realtek RTL8712U Transmit Aggregation code"
 	depends on R8712U && BROKEN
Index: wireless-testing-new/drivers/staging/rtl8712/rtl871x_sta_mgt.c
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/rtl871x_sta_mgt.c
+++ wireless-testing-new/drivers/staging/rtl8712/rtl871x_sta_mgt.c
@@ -42,10 +42,8 @@ static void _init_stainfo(struct sta_inf
 	_init_listhead(&psta->hash_list);
 	_r8712_init_sta_xmit_priv(&psta->sta_xmitpriv);
 	_r8712_init_sta_recv_priv(&psta->sta_recvpriv);
-#ifdef CONFIG_R8712_AP
 	_init_listhead(&psta->asoc_list);
 	_init_listhead(&psta->auth_list);
-#endif
 }
 
 u32 _r8712_init_sta_priv(struct	sta_priv *pstapriv)
@@ -72,10 +70,8 @@ u32 _r8712_init_sta_priv(struct	sta_priv
 				 get_list_head(&pstapriv->free_sta_queue));
 		psta++;
 	}
-#ifdef CONFIG_R8712_AP
 	_init_listhead(&pstapriv->asoc_list);
 	_init_listhead(&pstapriv->auth_list);
-#endif
 	return _SUCCESS;
 }
 
Index: wireless-testing-new/drivers/staging/rtl8712/sta_info.h
===================================================================
--- wireless-testing-new.orig/drivers/staging/rtl8712/sta_info.h
+++ wireless-testing-new/drivers/staging/rtl8712/sta_info.h
@@ -90,7 +90,6 @@ struct sta_info {
 	 * curr_network(mlme_priv/security_priv/qos/ht) : AP CAP/INFO
 	 * sta_info: (AP & STA) CAP/INFO
 	 */
-#ifdef CONFIG_R8712_AP
 	struct list_head asoc_list;
 	struct list_head auth_list;
 	unsigned int expire_to;
@@ -98,7 +97,6 @@ struct sta_info {
 	unsigned int authalg;
 	unsigned char chg_txt[128];
 	unsigned int tx_ra_bitmap;
-#endif
 };
 
 struct	sta_priv {
@@ -111,13 +109,11 @@ struct	sta_priv {
 	struct  __queue sleep_q;
 	struct  __queue wakeup_q;
 	struct _adapter *padapter;
-#ifdef CONFIG_R8712_AP
 	struct list_head asoc_list;
 	struct list_head auth_list;
 	unsigned int auth_to;  /* sec, time to expire in authenticating. */
 	unsigned int assoc_to; /* sec, time to expire before associating. */
 	unsigned int expire_to; /* sec , time to expire after associated. */
-#endif
 };
 
 static inline u32 wifi_mac_hash(u8 *mac)
