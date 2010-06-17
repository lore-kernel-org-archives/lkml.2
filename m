Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759682Ab0FQLqc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:46:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36884 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752215Ab0FQLqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:46:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=i65VYIX6v+FcJRWSeR0LMcacp46AAgZW8E48G0uidUBR1JGeyNrSunz9Q4cmyfOQY1
         eitrSdy/q2Ii+ufHL2SUl72H0eXcbT/rIRPe6Qb0p2KkrQuEsPzNF9k3aYfWwSRORlLc
         XmO7Z0ZHQ+mwNpwtqlSEPpuqnRaYhq5figz4w=
From: Matti Lammi <mattij.lammi@gmail.com>
To: gregkh@suse.de, mithlesh@linsyssoft.com, joe@perches.com,
       dave@davemloft.net, a.beregalov@gmail.com, mattij.lammi@gmail.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Drivers: Staging: Fixed a lot of styling issues
Date: Thu, 17 Jun 2010 14:46:20 +0300
Message-Id: <1276775180-26010-1-git-send-email-mattij.lammi@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed all errors and a lot of wornings reported by the checkpatch.pl tool.

Signed-off-by: Matti Lammi <mattij.lammi@gmail.com>
---
 drivers/staging/otus/usbdrv.c |  721 +++++++++++++++++++++--------------------
 1 files changed, 362 insertions(+), 359 deletions(-)

diff --git a/drivers/staging/otus/usbdrv.c b/drivers/staging/otus/usbdrv.c
index 165a82b..8fb14e8 100644
--- a/drivers/staging/otus/usbdrv.c
+++ b/drivers/staging/otus/usbdrv.c
@@ -46,2 +46,2 @@
 #include "athr_common.h"
 #endif

-extern void zfDumpDescriptor(zdev_t* dev, u16_t type);
-//extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr);
+extern void zfDumpDescriptor(zdev_t *dev, u16_t type);
+/* extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr); */

-// ISR handler
+/* ISR handler*/
 irqreturn_t usbdrv_intr(int, void *, struct pt_regs *);

-// Network Device interface related function
+/* Network Device interface related function */
 int usbdrv_open(struct net_device *);
 int usbdrv_close(struct net_device *);
 int usbdrv_change_mtu(struct net_device *, int);
@@ -61,2 +61,2 @@ int usbdrv_xmit_frame(struct sk_buff *, struct net_device *);
 void usbdrv_set_multi(struct net_device *);
 struct net_device_stats *usbdrv_get_stats(struct net_device *);

-//wireless extension helper functions
+/* wireless extension helper functions */
 int usbdrv_ioctl_setessid(struct net_device *dev, struct iw_point *erq);
 int usbdrv_ioctl_getessid(struct net_device *dev, struct iw_point *erq);
 int usbdrv_ioctl_setrts(struct net_device *dev, struct iw_param *rrq);
 /* Wireless Extension Handler functions */
 int usbdrvwext_giwmode(struct net_device *dev, struct iw_request_info* info,
-        __u32 *mode, char *extra);
+		       __u32 *mode, char *extra);
int zfLnxPrivateIoctl(struct usbdrv_private *macp, struct zdap_ioctl *zdreq);

-void zfLnx10msTimer(struct net_device* dev);
-int zfUnregisterWdsDev(struct net_device* parentDev, u16_t wdsId);
-int zfRegisterWdsDev(struct net_device* parentDev, u16_t wdsId);
+void zfLnx10msTimer(struct net_device *dev);
+int zfUnregisterWdsDev(struct net_device *parentDev, u16_t wdsId);
+int zfRegisterWdsDev(struct net_device *parentDev, u16_t wdsId);
 int zfWdsOpen(struct net_device *dev);
 int zfWdsClose(struct net_device *dev);
 int zfLnxVapOpen(struct net_device *dev);
 int zfLnxVapClose(struct net_device *dev);
 int zfLnxVapXmitFrame(struct sk_buff *skb, struct net_device *dev);
-int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId);
+int zfLnxRegisterVapDev(struct net_device *parentDev, u16_t vapId);
 int usbdrv_wpa_ioctl(struct net_device *dev, struct athr_wlan_param *zdparm);
-extern u16_t zfLnxGetVapId(zdev_t* dev);
+extern u16_t zfLnxGetVapId(zdev_t *dev);
 extern u16_t zfLnxCheckTxBufferCnt(zdev_t *dev);
 extern UsbTxQ_t *zfLnxGetUsbTxBuffer(zdev_t *dev);

-extern u16_t zfLnxAuthNotify(zdev_t* dev, u16_t* macAddr);
-extern u16_t zfLnxAsocNotify(zdev_t* dev, u16_t* macAddr, u8_t* body, u16_t bodySize, u16_t port);
-extern u16_t zfLnxDisAsocNotify(zdev_t* dev, u8_t* macAddr, u16_t port);
-extern u16_t zfLnxApConnectNotify(zdev_t* dev, u8_t* macAddr, u16_t port);
-extern void zfLnxConnectNotify(zdev_t* dev, u16_t status, u16_t* bssid);
-extern void zfLnxScanNotify(zdev_t* dev, struct zsScanResult* result);
-extern void zfLnxStatisticsNotify(zdev_t* dev, struct zsStastics* result);
-extern void zfLnxMicFailureNotify(zdev_t* dev, u16_t* addr, u16_t status);
-extern void zfLnxApMicFailureNotify(zdev_t* dev, u8_t* addr, zbuf_t* buf);
-extern void zfLnxIbssPartnerNotify(zdev_t* dev, u16_t status, struct zsPartnerNotifyEvent *event);
-extern void zfLnxMacAddressNotify(zdev_t* dev, u8_t* addr);
-extern void zfLnxSendCompleteIndication(zdev_t* dev, zbuf_t* buf);
-extern void zfLnxRecvEth(zdev_t* dev, zbuf_t* buf, u16_t port);
-extern void zfLnxRestoreBufData(zdev_t* dev, zbuf_t* buf);
+extern u16_t zfLnxAuthNotify(zdev_t *dev, u16_t* macAddr);
+extern u16_t zfLnxAsocNotify(zdev_t *dev, u16_t* macAddr, u8_t* body,
+			     u16_t bodySize, u16_t port);
+extern u16_t zfLnxDisAsocNotify(zdev_t *dev, u8_t* macAddr, u16_t port);
+extern u16_t zfLnxApConnectNotify(zdev_t *dev, u8_t* macAddr, u16_t port);
+extern void zfLnxConnectNotify(zdev_t *dev, u16_t status, u16_t* bssid);
+extern void zfLnxScanNotify(zdev_t *dev, struct zsScanResult* result);
+extern void zfLnxStatisticsNotify(zdev_t *dev, struct zsStastics* result);
+extern void zfLnxMicFailureNotify(zdev_t *dev, u16_t* addr, u16_t status);
+extern void zfLnxApMicFailureNotify(zdev_t *dev, u8_t* addr, zbuf_t* buf);
+extern void zfLnxIbssPartnerNotify(zdev_t *dev, u16_t status,
+				   struct zsPartnerNotifyEvent *event);
+extern void zfLnxMacAddressNotify(zdev_t *dev, u8_t* addr);
+extern void zfLnxSendCompleteIndication(zdev_t *dev, zbuf_t* buf);
+extern void zfLnxRecvEth(zdev_t *dev, zbuf_t* buf, u16_t port);
+extern void zfLnxRestoreBufData(zdev_t *dev, zbuf_t* buf);
 #ifdef ZM_ENABLE_CENC
-extern u16_t zfLnxCencAsocNotify(zdev_t* dev, u16_t* macAddr, u8_t* body, u16_t bodySize, u16_t port);
-#endif //ZM_ENABLE_CENC
-extern void zfLnxWatchDogNotify(zdev_t* dev);
-extern void zfLnxRecv80211(zdev_t* dev, zbuf_t* buf, struct zsAdditionInfo* addInfo);
+extern u16_t zfLnxCencAsocNotify(zdev_t *dev, u16_t* macAddr,
+				 u8_t *body, u16_t bodySize, u16_t port);
+#endif /* ZM_ENABLE_CENC */
+extern void zfLnxWatchDogNotify(zdev_t *dev);
+extern void zfLnxRecv80211(zdev_t *dev, zbuf_t* buf,
+			   struct zsAdditionInfo *addInfo);
 extern u8_t zfLnxCreateThread(zdev_t *dev);

 /******************************************************************************
@@ -116,69 +120,100 @@ extern u8_t zfLnxCreateThread(zdev_t *dev);
 extern int usbdrv_ioctl_setessid(struct net_device *dev, struct iw_point *erq);
 extern int usbdrv_ioctl_setrts(struct net_device *dev, struct iw_param *rrq);
 /* Wireless Extension Handler functions */
-extern int usbdrvwext_giwname(struct net_device *dev, struct iw_request_info *info,
-        union iwreq_data *wrq, char *extra);
-extern int usbdrvwext_siwfreq(struct net_device *dev, struct iw_request_info *info,
-        struct iw_freq *freq, char *extra);
-extern int usbdrvwext_giwfreq(struct net_device *dev, struct iw_request_info *info,
-        struct iw_freq *freq, char *extra);
-extern int usbdrvwext_siwmode(struct net_device *dev, struct iw_request_info *info,
-        union iwreq_data *wrq, char *extra);
-extern int usbdrvwext_giwmode(struct net_device *dev, struct iw_request_info *info,
-        __u32 *mode, char *extra);
-extern int usbdrvwext_siwsens(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *sens, char *extra);
-extern int usbdrvwext_giwsens(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *sens, char *extra);
-extern int usbdrvwext_giwrange(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *data, char *extra);
-extern int usbdrvwext_siwap(struct net_device *dev, struct iw_request_info *info,
-        struct sockaddr *MacAddr, char *extra);
-extern int usbdrvwext_giwap(struct net_device *dev, struct iw_request_info *info,
-        struct sockaddr *MacAddr, char *extra);
-extern int usbdrvwext_iwaplist(struct net_device *dev, struct iw_request_info *info,
-		struct iw_point *data, char *extra);
-extern int usbdrvwext_siwscan(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *data, char *extra);
-extern int usbdrvwext_giwscan(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *data, char *extra);
-extern int usbdrvwext_siwessid(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *essid, char *extra);
-extern int usbdrvwext_giwessid(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *essid, char *extra);
-extern int usbdrvwext_siwnickn(struct net_device *dev, struct iw_request_info *info,
-	    struct iw_point *data, char *nickname);
-extern int usbdrvwext_giwnickn(struct net_device *dev, struct iw_request_info *info,
-	    struct iw_point *data, char *nickname);
-extern int usbdrvwext_siwrate(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frq, char *extra);
-extern int usbdrvwext_giwrate(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frq, char *extra);
-extern int usbdrvwext_siwrts(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *rts, char *extra);
-extern int usbdrvwext_giwrts(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *rts, char *extra);
-extern int usbdrvwext_siwfrag(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frag, char *extra);
-extern int usbdrvwext_giwfrag(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frag, char *extra);
-extern int usbdrvwext_siwtxpow(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *rrq, char *extra);
-extern int usbdrvwext_giwtxpow(struct net_device *dev, struct iw_request_info *info,
-		struct iw_param *rrq, char *extra);
-extern int usbdrvwext_siwretry(struct net_device *dev, struct iw_request_info *info,
-	    struct iw_param *rrq, char *extra);
-extern int usbdrvwext_giwretry(struct net_device *dev, struct iw_request_info *info,
-	    struct iw_param *rrq, char *extra);
-extern int usbdrvwext_siwencode(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *erq, char *key);
-extern int usbdrvwext_giwencode(struct net_device *dev, struct iw_request_info *info,
-        struct iw_point *erq, char *key);
-extern int usbdrvwext_siwpower(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frq, char *extra);
-extern int usbdrvwext_giwpower(struct net_device *dev, struct iw_request_info *info,
-        struct iw_param *frq, char *extra);
+extern int usbdrvwext_giwname(struct net_device *dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *wrq, char *extra);
+extern int usbdrvwext_siwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+extern int usbdrvwext_giwfreq(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_freq *freq, char *extra);
+extern int usbdrvwext_siwmode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      union iwreq_data *wrq, char *extra);
+extern int usbdrvwext_giwmode(struct net_device *dev,
+			      struct iw_request_info *info,
+			      __u32 *mode, char *extra);
+extern int usbdrvwext_siwsens(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *sens, char *extra);
+extern int usbdrvwext_giwsens(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *sens, char *extra);
+extern int usbdrvwext_giwrange(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *extra);
+extern int usbdrvwext_siwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *MacAddr, char *extra);
+extern int usbdrvwext_giwap(struct net_device *dev,
+			    struct iw_request_info *info,
+			    struct sockaddr *MacAddr, char *extra);
+extern int usbdrvwext_iwaplist(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *extra);
+extern int usbdrvwext_siwscan(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *data, char *extra);
+extern int usbdrvwext_giwscan(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_point *data, char *extra);
+extern int usbdrvwext_siwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *essid, char *extra);
+extern int usbdrvwext_giwessid(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *essid, char *extra);
+extern int usbdrvwext_siwnickn(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *nickname);
+extern int usbdrvwext_giwnickn(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_point *data, char *nickname);
+extern int usbdrvwext_siwrate(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *frq, char *extra);
+extern int usbdrvwext_giwrate(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *frq, char *extra);
+extern int usbdrvwext_siwrts(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *rts, char *extra);
+extern int usbdrvwext_giwrts(struct net_device *dev,
+			     struct iw_request_info *info,
+			     struct iw_param *rts, char *extra);
+extern int usbdrvwext_siwfrag(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *frag, char *extra);
+extern int usbdrvwext_giwfrag(struct net_device *dev,
+			      struct iw_request_info *info,
+			      struct iw_param *frag, char *extra);
+extern int usbdrvwext_siwtxpow(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *rrq, char *extra);
+extern int usbdrvwext_giwtxpow(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *rrq, char *extra);
+extern int usbdrvwext_siwretry(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *rrq, char *extra);
+extern int usbdrvwext_giwretry(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *rrq, char *extra);
+extern int usbdrvwext_siwencode(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *erq, char *key);
+extern int usbdrvwext_giwencode(struct net_device *dev,
+				struct iw_request_info *info,
+				struct iw_point *erq, char *key);
+extern int usbdrvwext_siwpower(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *frq, char *extra);
+extern int usbdrvwext_giwpower(struct net_device *dev,
+			       struct iw_request_info *info,
+			       struct iw_param *frq, char *extra);
 extern int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 /*
  * Structures to export the Wireless Handlers
  */

 struct iw_priv_args usbdrv_private_args[] = {
-//    { SIOCIWFIRSTPRIV + 0x0, 0, 0, "list_bss" },
-//    { SIOCIWFIRSTPRIV + 0x1, 0, 0, "card_reset" },
-    { SIOCIWFIRSTPRIV + 0x2, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "set_auth" },  /* 0 - open, 1 - shared key */
+  /* { SIOCIWFIRSTPRIV + 0x0, 0, 0, "list_bss" }, */
+  /* { SIOCIWFIRSTPRIV + 0x1, 0, 0, "card_reset" }, */
+    { SIOCIWFIRSTPRIV + 0x2, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED |
+      1, 0, "set_auth" },  /* 0 - open, 1 - shared key */
     { SIOCIWFIRSTPRIV + 0x3, 0, IW_PRIV_TYPE_CHAR | 12, "get_auth" },
-//    { SIOCIWFIRSTPRIV + 0x4, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "set_preamble" },  /* 0 - long, 1 - short */
-//    { SIOCIWFIRSTPRIV + 0x5, 0, IW_PRIV_TYPE_CHAR | 6, "get_preamble" },
-//    { SIOCIWFIRSTPRIV + 0x6, 0, 0, "cnt" },
-//    { SIOCIWFIRSTPRIV + 0x7, 0, 0, "regs" },
-//    { SIOCIWFIRSTPRIV + 0x8, 0, 0, "probe" },
-//    { SIOCIWFIRSTPRIV + 0x9, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "dbg_flag" },
-//    { SIOCIWFIRSTPRIV + 0xA, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "connect" },
-//    { SIOCIWFIRSTPRIV + 0xB, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED | 1, 0, "set_mac_mode" },
-//    { SIOCIWFIRSTPRIV + 0xC, 0, IW_PRIV_TYPE_CHAR | 12, "get_mac_mode" },
+    /* { SIOCIWFIRSTPRIV + 0x4, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED |
+       1, 0, "set_preamble" },  /* 0 - long, 1 - short */
+    /* { SIOCIWFIRSTPRIV + 0x5, 0, IW_PRIV_TYPE_CHAR | 6, "get_preamble" }, */
+    /* { SIOCIWFIRSTPRIV + 0x6, 0, 0, "cnt" }, */
+    /* { SIOCIWFIRSTPRIV + 0x7, 0, 0, "regs" }, */
+    /* { SIOCIWFIRSTPRIV + 0x8, 0, 0, "probe" }, */
+    /* { SIOCIWFIRSTPRIV + 0x9, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED |
+       1, 0, "dbg_flag" }, */
+    /* { SIOCIWFIRSTPRIV + 0xA, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED |
+       1, 0, "connect" }, */
+    /* { SIOCIWFIRSTPRIV + 0xB, IW_PRIV_TYPE_INT | IW_PRIV_SIZE_FIXED |
+       1, 0, "set_mac_mode" }, */
+    /* { SIOCIWFIRSTPRIV + 0xC, 0, IW_PRIV_TYPE_CHAR | 12, "get_mac_mode" }, */
 };

 static iw_handler usbdrvwext_handler[] = {
@@ -249,2 +289,2 @@ static iw_handler usbdrvwext_handler[] = {
     (iw_handler) usbdrvwext_giwpower,               /* SIOCGIWPOWER */
 };

-static const iw_handler usbdrv_private_handler[] =
-{
-	//(iw_handler) usbdrvwext_setparam,		/* SIOCWFIRSTPRIV+0 */
-	//(iw_handler) usbdrvwext_getparam,		/* SIOCWFIRSTPRIV+1 */
-	//(iw_handler) usbdrvwext_setkey,		    /* SIOCWFIRSTPRIV+2 */
-	//(iw_handler) usbdrvwext_setwmmparams,	/* SIOCWFIRSTPRIV+3 */
-	//(iw_handler) usbdrvwext_delkey,		    /* SIOCWFIRSTPRIV+4 */
-	//(iw_handler) usbdrvwext_getwmmparams,	/* SIOCWFIRSTPRIV+5 */
-	//(iw_handler) usbdrvwext_setmlme,		/* SIOCWFIRSTPRIV+6 */
-	//(iw_handler) usbdrvwext_getchaninfo,	/* SIOCWFIRSTPRIV+7 */
-	//(iw_handler) usbdrvwext_setoptie,		/* SIOCWFIRSTPRIV+8 */
-	//(iw_handler) usbdrvwext_getoptie,		/* SIOCWFIRSTPRIV+9 */
-	//(iw_handler) usbdrvwext_addmac,		    /* SIOCWFIRSTPRIV+10 */
-	//(iw_handler) usbdrvwext_getscanresults,	/* SIOCWFIRSTPRIV+11 */
-	//(iw_handler) usbdrvwext_delmac,		    /* SIOCWFIRSTPRIV+12 */
-	//(iw_handler) usbdrvwext_getchanlist,	/* SIOCWFIRSTPRIV+13 */
-	//(iw_handler) usbdrvwext_setchanlist,	/* SIOCWFIRSTPRIV+14 */
-	//(iw_handler) NULL,				        /* SIOCWFIRSTPRIV+15 */
-	//(iw_handler) usbdrvwext_chanswitch,	    /* SIOCWFIRSTPRIV+16 */
-	//(iw_handler) usbdrvwext_setmode,		/* SIOCWFIRSTPRIV+17 */
-	//(iw_handler) usbdrvwext_getmode,		/* SIOCWFIRSTPRIV+18 */
-    NULL,               /* SIOCIWFIRSTPRIV */
+static const iw_handler usbdrv_private_handler[] = {
+  /* (iw_handler) usbdrvwext_setparam, */       /* SIOCWFIRSTPRIV+0 */
+  /* (iw_handler) usbdrvwext_getparam, */       /* SIOCWFIRSTPRIV+1 */
+  /* (iw_handler) usbdrvwext_setkey, */		/* SIOCWFIRSTPRIV+2 */
+  /* (iw_handler) usbdrvwext_setwmmparams, */	/* SIOCWFIRSTPRIV+3 */
+  /* (iw_handler) usbdrvwext_delkey, */		/* SIOCWFIRSTPRIV+4 */
+  /* (iw_handler) usbdrvwext_getwmmparams, */	/* SIOCWFIRSTPRIV+5 */
+  /* (iw_handler) usbdrvwext_setmlme, */        /* SIOCWFIRSTPRIV+6 */
+  /* (iw_handler) usbdrvwext_getchaninfo, */	/* SIOCWFIRSTPRIV+7 */
+  /* (iw_handler) usbdrvwext_setoptie, */	/* SIOCWFIRSTPRIV+8 */
+  /* (iw_handler) usbdrvwext_getoptie, */	/* SIOCWFIRSTPRIV+9 */
+  /* (iw_handler) usbdrvwext_addmac, */		/* SIOCWFIRSTPRIV+10 */
+  /* (iw_handler) usbdrvwext_getscanresults, */	/* SIOCWFIRSTPRIV+11 */
+  /* (iw_handler) usbdrvwext_delmac, */		/* SIOCWFIRSTPRIV+12 */
+  /* (iw_handler) usbdrvwext_getchanlist, */	/* SIOCWFIRSTPRIV+13 */
+  /* (iw_handler) usbdrvwext_setchanlist, */	/* SIOCWFIRSTPRIV+14 */
+  /* (iw_handler) NULL, */			/* SIOCWFIRSTPRIV+15 */
+  /* (iw_handler) usbdrvwext_chanswitch, */	/* SIOCWFIRSTPRIV+16 */
+  /* (iw_handler) usbdrvwext_setmode, */	/* SIOCWFIRSTPRIV+17 */
+  /* (iw_handler) usbdrvwext_getmode, */	/* SIOCWFIRSTPRIV+18 */
+  NULL,                                         /* SIOCIWFIRSTPRIV */
 };

 static struct iw_handler_def p80211wext_handler_def = {
@@ -311,0 +350,0 @@ irqreturn_t usbdrv_intr(int irq, void *dev_inst, struct pt_regs *regs)


     /* Read register error, card may be unpluged */
-    if (0)//(intr_status == -1)
-        return IRQ_NONE;
+    if (0) /* (intr_status == -1) */
+      return IRQ_NONE;

     /* the device is closed, don't continue or else bad things may happen. */
     if (!netif_running(dev))
-        return IRQ_NONE;
+      return IRQ_NONE;

     if (macp->driver_isolated)
-        return IRQ_NONE;
+      return IRQ_NONE;

 #if (WLAN_HOSTIF == WLAN_PCI)
-    //zfiIsrPci(dev);
+    /* zfiIsrPci(dev); */
 #endif

     return IRQ_HANDLED;
@@ -333,6 +372,6 @@ int usbdrv_open(struct net_device *dev)
     struct usbdrv_private *macp = dev->ml_priv;
     int rc = 0;
     u16_t size;
-    void* mem;
-    //unsigned char addr[6];
+    void *mem;
+    /* unsigned char addr[6]; */
     struct zsCbFuncTbl cbFuncTbl;

     printk("Enter open()\n");
@@ -345,6 +384,6 @@ int usbdrv_open(struct net_device *dev)
  * #endif
  */
     if (macp->driver_isolated) {
-        rc = -EBUSY;
-        goto exit;
+      rc = -EBUSY;
+      goto exit;
     }

     size = zfiGlobalDataSize(dev);
     mem = kmalloc(size, GFP_KERNEL);
-    if (mem == NULL)
-    {
-        rc = -EBUSY;
-        goto exit;
+    if (mem == NULL) {
+      rc = -EBUSY;
+      goto exit;
     }
     macp->wd = mem;

@@ -376,6 +414,6 @@ int usbdrv_open(struct net_device *dev)
     cbFuncTbl.zfcbRestoreBufData = zfLnxRestoreBufData;
 #ifdef ZM_ENABLE_CENC
     cbFuncTbl.zfcbCencAsocNotify = zfLnxCencAsocNotify;
-#endif //ZM_ENABLE_CENC
+#endif /* ZM_ENABLE_CENC */
     cbFuncTbl.zfcbHwWatchDogNotify = zfLnxWatchDogNotify;
     zfiWlanOpen(dev, &cbFuncTbl);

 #if 0
     {
-        //u16_t mac[3] = {0x1300, 0xb6d4, 0x5aaf};
-        u16_t mac[3] = {0x8000, 0x00ab, 0x0000};
-        //zfiWlanSetMacAddress(dev, mac);
+      /* u16_t mac[3] = {0x1300, 0xb6d4, 0x5aaf}; */
+      u16_t mac[3] = {0x8000, 0x00ab, 0x0000};
+      /* zfiWlanSetMacAddress(dev, mac); */
     }
     /* MAC address */
     zfiWlanQueryMacAddress(dev, addr);
@@ -413,0 +451,0 @@ int usbdrv_open(struct net_device *dev)

   #if ZM_WEP_MOME == 1
     {
-        u8_t key[16] = {0x12, 0x34, 0x56, 0x78, 0x90};
-        struct zsKeyInfo keyInfo;
+      u8_t key[16] = {0x12, 0x34, 0x56, 0x78, 0x90};
+      struct zsKeyInfo keyInfo;

-        keyInfo.keyLength = 5;
-        keyInfo.keyIndex = 0;
-        keyInfo.flag = 0;
-        keyInfo.key = key;
-        zfiWlanSetKey(dev, keyInfo);
+      keyInfo.keyLength = 5;
+      keyInfo.keyIndex = 0;
+      keyInfo.flag = 0;
+      keyInfo.key = key;
+      zfiWlanSetKey(dev, keyInfo);

-        zfiWlanSetEncryMode(dev, ZM_WEP64);
+      zfiWlanSetEncryMode(dev, ZM_WEP64);
     }

     #if ZM_SHARE_AUTH == 1
@@ -443,1 +481,1 @@ int usbdrv_open(struct net_device *dev)
     zfiWlanEnable(dev);

 #ifdef ZM_ENABLE_CENC
-    macp->netlink_sk = netlink_kernel_create(NETLINK_USERSOCK, 1, NULL, THIS_MODULE);
+    macp->netlink_sk = netlink_kernel_create(NETLINK_USERSOCK, 1,
+					     NULL, THIS_MODULE);

     if (macp->netlink_sk == NULL)
-    {
-        printk(KERN_ERR "Can't create NETLINK socket\n");
-    }
+      printk(KERN_ERR "Can't create NETLINK socket\n");
 #endif

     macp->DeviceOpened = 1;
 exit:
-//#ifndef CONFIG_SMP
-//    read_unlock(&(macp->isolate_lock));
-//#endif
-    //zfRegisterWdsDev(dev, 0);
-    //zfLnxRegisterVapDev(dev, 0);
+    /* #ifndef CONFIG_SMP
+       read_unlock(&(macp->isolate_lock));
+#endif
+       zfRegisterWdsDev(dev, 0);
+       zfLnxRegisterVapDev(dev, 0); */

     return rc;
 }
@@ -476,2 +513,2 @@ exit:
  * locking is used.
  */

-struct net_device_stats * usbdrv_get_stats(struct net_device *dev)
+struct net_device_stats *usbdrv_get_stats(struct net_device *dev)
 {
     struct usbdrv_private *macp = dev->ml_priv;

     macp->drv_stats.net_stats.tx_errors =
-        macp->drv_stats.net_stats.tx_carrier_errors +
-        macp->drv_stats.net_stats.tx_aborted_errors;
+      macp->drv_stats.net_stats.tx_carrier_errors +
+      macp->drv_stats.net_stats.tx_aborted_errors;

     macp->drv_stats.net_stats.rx_errors =
-        macp->drv_stats.net_stats.rx_crc_errors +
-        macp->drv_stats.net_stats.rx_frame_errors +
-        macp->drv_stats.net_stats.rx_length_errors;
+      macp->drv_stats.net_stats.rx_crc_errors +
+      macp->drv_stats.net_stats.rx_frame_errors +
+      macp->drv_stats.net_stats.rx_length_errors;


     return &(macp->drv_stats.net_stats);
@@ -513,2 +550,2 @@ int usbdrv_set_mac(struct net_device *dev, void *addr)
     macp = dev->ml_priv;
     read_lock(&(macp->isolate_lock));

-    if (macp->driver_isolated) {
-        goto exit;
-    }
+    if (macp->driver_isolated)
+      goto exit;

     rc = 0;

@@ -538,2 +574,2 @@ usbdrv_isolate_driver(struct usbdrv_private *macp)
     write_unlock_irq(&(macp->isolate_lock));
 #endif

-    if (netif_running(macp->device))
-    {
-        netif_carrier_off(macp->device);
-        netif_stop_queue(macp->device);
+    if (netif_running(macp->device)) {
+      netif_carrier_off(macp->device);
+      netif_stop_queue(macp->device);
     }
 }

-#define VLAN_SIZE   	4
+#define VLAN_SIZE 4
 int usbdrv_change_mtu(struct net_device *dev, int new_mtu)
 {
     if ((new_mtu < 68) || (new_mtu > (ETH_DATA_LEN + VLAN_SIZE)))
-        return -EINVAL;
+      return -EINVAL;

     dev->mtu = new_mtu;
     return 0;
@@ -578,12 +613,12 @@ extern void zfHpLedCtrl(struct net_device *dev, u16_t ledId, u8_t mode);
     netif_carrier_off(macp->device);
 #ifdef ZM_ENABLE_CENC
     /* CENC */
-    if (macp->netlink_sk != NULL)
-    {
-    //    sock_release(macp->netlink_sk);
-        printk(KERN_ERR "usbdrv close netlink socket\n");
+    if (macp->netlink_sk != NULL) {
+      /*sock_release(macp->netlink_sk); */
+      printk(KERN_ERR "usbdrv close netlink socket\n");
     }
-#endif //ZM_ENABLE_CENC
+
+#endif /* ZM_ENABLE_CENC */
 #if (WLAN_HOSTIF == WLAN_PCI)
-    //free_irq(dev->irq, dev);
+    /* free_irq(dev->irq, dev); */
 #endif

     /* Turn off LED */
@@ -620,16 +655,16 @@ int usbdrv_xmit_frame(struct sk_buff *skb, struct net_device *dev)
 #if 0
     /* Test code */
     {
-        struct sk_buff* s;
-
-        s = skb_copy_expand(skb, 8, 0, GFP_ATOMIC);
-        skb_push(s, 8);
-        s->data[0] = 'z';
-        s->data[1] = 'y';
-        s->data[2] = 'd';
-        s->data[3] = 'a';
-        s->data[4] = 's';
-        printk("len1=%d, len2=%d", skb->len, s->len);
-        netlink_broadcast(rtnl, s, 0, RTMGRP_LINK, GFP_ATOMIC);
+      struct sk_buff *s;
+
+      s = skb_copy_expand(skb, 8, 0, GFP_ATOMIC);
+      skb_push(s, 8);
+      s->data[0] = 'z';
+      s->data[1] = 'y';
+      s->data[2] = 'd';
+      s->data[3] = 'a';
+      s->data[4] = 's';
+      printk("len1=%d, len2=%d", skb->len, s->len);
+      netlink_broadcast(rtnl, s, 0, RTMGRP_LINK, GFP_ATOMIC);
     }
 #endif

@@ -642,2 +677,2 @@ int usbdrv_xmit_frame(struct sk_buff *skb, struct net_device *dev)
     macp->drv_stats.net_stats.tx_bytes += skb->len;
     macp->drv_stats.net_stats.tx_packets++;

-    //dev_kfree_skb_irq(skb);
+    /* dev_kfree_skb_irq(skb); */

     if (notify_stop) {
-        netif_carrier_off(dev);
-        netif_stop_queue(dev);
+      netif_carrier_off(dev);
+      netif_stop_queue(dev);
     }

     return NETDEV_TX_OK;
@@ -660,0 +695,0 @@ void usbdrv_set_multi(struct net_device *dev)


     if (!(dev->flags & IFF_UP))
-        return;
+      return;

-        return;
+    return;

 }

@@ -701,0 +736,0 @@ void usbdrv_remove1(struct pci_dev *pcid)

     dev = (struct net_device *)pci_get_drvdata(pcid);
     if (!dev)
-        return;
+      return;

     macp = dev->ml_priv;
     unregister_netdev(dev);
@@ -710,1 +745,1 @@ void usbdrv_remove1(struct pci_dev *pcid)
 }


-void zfLnx10msTimer(struct net_device* dev)
+void zfLnx10msTimer(struct net_device *dev)
 {
     struct usbdrv_private *macp = dev->ml_priv;

-    mod_timer(&(macp->hbTimer10ms), jiffies + (1*HZ)/100);   //10 ms
+    mod_timer(&(macp->hbTimer10ms), jiffies + (1*HZ)/100);   /* 10 ms */
     zfiHeartBeat(dev);
     return;
 }
@@ -723,2 +758,2 @@ void zfLnxInitVapStruct(void)
 {
     u16_t i;

-    for (i = 0; i < ZM_VAP_PORT_NUMBER; i++)
-    {
-        vap[i].dev = NULL;
-        vap[i].openFlag = 0;
+    for (i = 0; i < ZM_VAP_PORT_NUMBER; i++) {
+      vap[i].dev = NULL;
+      vap[i].openFlag = 0;
     }
 }

@@ -736,0 +770,0 @@ int zfLnxVapOpen(struct net_device *dev)

     vapId = zfLnxGetVapId(dev);

-    if (vap[vapId].openFlag == 0)
-    {
-        vap[vapId].openFlag = 1;
-    	printk("zfLnxVapOpen : device name=%s, vap ID=%d\n", dev->name, vapId);
-    	zfiWlanSetSSID(dev, "vap1", 4);
-    	zfiWlanEnable(dev);
-    	netif_start_queue(dev);
-    }
-    else
-    {
-        printk("VAP opened error : vap ID=%d\n", vapId);
+    if (vap[vapId].openFlag == 0) {
+      vap[vapId].openFlag = 1;
+      printk("zfLnxVapOpen : device name=%s, vap ID=%d\n", dev->name, vapId);
+      zfiWlanSetSSID(dev, "vap1", 4);
+      zfiWlanEnable(dev);
+      netif_start_queue(dev);
+    } else {
+      printk("VAP opened error : vap ID=%d\n", vapId);
     }
-	return 0;
+    return 0;
 }

 int zfLnxVapClose(struct net_device *dev)
@@ -757,0 +788,0 @@ int zfLnxVapClose(struct net_device *dev)

     vapId = zfLnxGetVapId(dev);

-    if (vapId != 0xffff)
-    {
-        if (vap[vapId].openFlag == 1)
-        {
-            printk("zfLnxVapClose: device name=%s, vap ID=%d\n", dev->name, vapId);
-
-            netif_stop_queue(dev);
-            vap[vapId].openFlag = 0;
-        }
-        else
-        {
-            printk("VAP port was not opened : vap ID=%d\n", vapId);
-        }
+    if (vapId != 0xffff) {
+      if (vap[vapId].openFlag == 1) {
+	printk("zfLnxVapClose: device name=%s, vap ID=%d\n",
+	       dev->name, vapId);
+
+	netif_stop_queue(dev);
+	vap[vapId].openFlag = 0;
+      } else {
+	printk("VAP port was not opened : vap ID=%d\n", vapId);
+      }
     }
-	return 0;
+    return 0;
 }

 int zfLnxVapXmitFrame(struct sk_buff *skb, struct net_device *dev)
@@ -781,1 +809,1 @@ int zfLnxVapXmitFrame(struct sk_buff *skb, struct net_device *dev)
     u16_t vapId;

     vapId = zfLnxGetVapId(dev);
-    //printk("zfLnxVapXmitFrame: vap ID=%d\n", vapId);
-    //printk("zfLnxVapXmitFrame(), skb=%lxh\n", (u32_t)skb);
+    /* printk("zfLnxVapXmitFrame: vap ID=%d\n", vapId); */
+    /* printk("zfLnxVapXmitFrame(), skb=%lxh\n", (u32_t)skb); */

-    if (vapId >= ZM_VAP_PORT_NUMBER)
-    {
-        dev_kfree_skb_irq(skb);
-        return NETDEV_TX_OK;
+    if (vapId >= ZM_VAP_PORT_NUMBER) {
+      dev_kfree_skb_irq(skb);
+      return NETDEV_TX_OK;
     }
 #if 1
-    if (vap[vapId].openFlag == 0)
-    {
-        dev_kfree_skb_irq(skb);
-        return NETDEV_TX_OK;
+    if (vap[vapId].openFlag == 0) {
+      dev_kfree_skb_irq(skb);
+      return NETDEV_TX_OK;
     }
 #endif

@@ -803,2 +829,2 @@ int zfLnxVapXmitFrame(struct sk_buff *skb, struct net_device *dev)
     macp->drv_stats.net_stats.tx_bytes += skb->len;
     macp->drv_stats.net_stats.tx_packets++;

-    //dev_kfree_skb_irq(skb);
+    /* dev_kfree_skb_irq(skb); */

     if (notify_stop) {
-        netif_carrier_off(dev);
-        netif_stop_queue(dev);
+      netif_carrier_off(dev);
+      netif_stop_queue(dev);
     }

     return NETDEV_TX_OK;
@@ -828,2 +854,2 @@ static const struct net_device_ops vap_netdev_ops = {
 #endif
 };

-int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
+int zfLnxRegisterVapDev(struct net_device *parentDev, u16_t vapId)
 {
     /* Allocate net device structure */
     vap[vapId].dev = alloc_etherdev(0);
     printk("Register vap dev=%p\n", vap[vapId].dev);

-    if(vap[vapId].dev == NULL) {
-        printk("alloc_etherdev fail\n");
-        return -ENOMEM;
+    if (vap[vapId].dev == NULL) {
+      printk("alloc_etherdev fail\n");
+      return -ENOMEM;
     }

     /* Setup the default settings */
@@ -851,2 +877,2 @@ int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
     vap[vapId].dev->mem_end = parentDev->mem_end;
     vap[vapId].dev->ml_priv = parentDev->ml_priv;

-    //dev->hard_start_xmit = &zd1212_wds_xmit_frame;
+    /* dev->hard_start_xmit = &zd1212_wds_xmit_frame; */
     vap[vapId].dev->netdev_ops = &vap_netdev_ops;
     vap[vapId].dev->destructor = free_netdev;

@@ -870,2 +896,2 @@ int zfLnxRegisterVapDev(struct net_device* parentDev, u16_t vapId)
     sprintf(vap[vapId].dev->name, "vap%d", vapId);
     printk("Register VAP dev success : %s\n", vap[vapId].dev->name);

-    if(register_netdevice(vap[vapId].dev) != 0) {
-        printk("register VAP device fail\n");
-        vap[vapId].dev = NULL;
-        return -EINVAL;
+    if (register_netdevice(vap[vapId].dev) != 0) {
+      printk("register VAP device fail\n");
+      vap[vapId].dev = NULL;
+      return -EINVAL;
     }

     return 0;
 }

-int zfLnxUnregisterVapDev(struct net_device* parentDev, u16_t vapId)
+int zfLnxUnregisterVapDev(struct net_device *parentDev, u16_t vapId)
 {
     int ret = 0;

     printk("Unregister VAP dev : %s\n", vap[vapId].dev->name);

-    if(vap[vapId].dev != NULL) {
-        printk("Unregister vap dev=%p\n", vap[vapId].dev);
-        //
-        //unregister_netdevice(wds[wdsId].dev);
-        unregister_netdev(vap[vapId].dev);
+    if (vap[vapId].dev != NULL) {
+      printk("Unregister vap dev=%p\n", vap[vapId].dev);
+      /* unregister_netdevice(wds[wdsId].dev); */
+      unregister_netdev(vap[vapId].dev);

-        printk("VAP unregister_netdevice\n");
-        vap[vapId].dev = NULL;
-    }
-    else {
-        printk("unregister VAP device: %d fail\n", vapId);
-        ret = -EINVAL;
+      printk("VAP unregister_netdevice\n");
+      vap[vapId].dev = NULL;
+    } else {
+      printk("unregister VAP device: %d fail\n", vapId);
+      ret = -EINVAL;
     }

     return ret;
@@ -904,0 +928,0 @@ int zfLnxUnregisterVapDev(struct net_device* parentDev, u16_t vapId)



-#  define SUBMIT_URB(u,f)       usb_submit_urb(u,f)
-#  define USB_ALLOC_URB(u,f)    usb_alloc_urb(u,f)
+#  define SUBMIT_URB(u, f)       usb_submit_urb(u, f)
+#  define USB_ALLOC_URB(u, f)    usb_alloc_urb(u, f)

-//extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr);
+/* extern void zfiWlanQueryMacAddress(zdev_t* dev, u8_t* addr); */

 extern int usbdrv_open(struct net_device *dev);
 extern int usbdrv_close(struct net_device *dev);
@@ -916,6 +940,6 @@ extern int usbdrv_xmit_frame(struct sk_buff *skb, struct net_device *dev);
 extern int usbdrv_change_mtu(struct net_device *dev, int new_mtu);
 extern void usbdrv_set_multi(struct net_device *dev);
 extern int usbdrv_set_mac(struct net_device *dev, void *addr);
-extern struct net_device_stats * usbdrv_get_stats(struct net_device *dev);
+extern struct net_device_stats *usbdrv_get_stats(struct net_device *dev);
 extern int usbdrv_ioctl(struct net_device *dev, struct ifreq *ifr, int cmd);
 extern UsbTxQ_t *zfLnxGetUsbTxBuffer(struct net_device *dev);

@@ -930,0 +954,0 @@ int zfLnxAllocAllUrbs(struct usbdrv_private *macp)

     /* descriptor matches, let's find the endpoints needed */
     /* check out the endpoints */
-    for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i)
-    {
-        endpoint = &iface_desc->endpoint[i].desc;
-	 if (usb_endpoint_is_bulk_in(endpoint))
-        {
-            /* we found a bulk in endpoint */
-            printk(KERN_ERR "bulk in: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
-        }
-
-	 if (usb_endpoint_is_bulk_out(endpoint))
-        {
-            /* we found a bulk out endpoint */
-            printk(KERN_ERR "bulk out: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
-        }
-
-	 if (usb_endpoint_is_int_in(endpoint))
-        {
-            /* we found a interrupt in endpoint */
-            printk(KERN_ERR "interrupt in: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
-            printk(KERN_ERR "interrupt in: int_interval = %d\n", endpoint->bInterval);
-        }
-
-	 if (usb_endpoint_is_int_out(endpoint))
-        {
-            /* we found a interrupt out endpoint */
-            printk(KERN_ERR "interrupt out: wMaxPacketSize = %x\n", le16_to_cpu(endpoint->wMaxPacketSize));
-            printk(KERN_ERR "interrupt out: int_interval = %d\n", endpoint->bInterval);
-        }
+    for (i = 0; i < iface_desc->desc.bNumEndpoints; ++i) {
+      endpoint = &iface_desc->endpoint[i].desc;
+      if (usb_endpoint_is_bulk_in(endpoint)) {
+	/* we found a bulk in endpoint */
+	printk(KERN_ERR "bulk in: wMaxPacketSize = %x\n",
+	       le16_to_cpu(endpoint->wMaxPacketSize));
+      }
+
+      if (usb_endpoint_is_bulk_out(endpoint)) {
+	/* we found a bulk out endpoint */
+	printk(KERN_ERR "bulk out: wMaxPacketSize = %x\n",
+	       le16_to_cpu(endpoint->wMaxPacketSize));
+      }
+
+      if (usb_endpoint_is_int_in(endpoint)) {
+	/* we found a interrupt in endpoint */
+	printk(KERN_ERR "interrupt in: wMaxPacketSize = %x\n",
+	       le16_to_cpu(endpoint->wMaxPacketSize));
+	printk(KERN_ERR "interrupt in: int_interval = %d\n",
+	       endpoint->bInterval);
+      }
+
+      if (usb_endpoint_is_int_out(endpoint)) {
+	/* we found a interrupt out endpoint */
+	printk(KERN_ERR "interrupt out: wMaxPacketSize = %x\n",
+	       le16_to_cpu(endpoint->wMaxPacketSize));
+	printk(KERN_ERR "interrupt out: int_interval = %d\n",
+	       endpoint->bInterval);
+      }
     }

     /* Allocate all Tx URBs */
-    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++)
-    {
-        macp->WlanTxDataUrb[i] = USB_ALLOC_URB(0, GFP_KERNEL);
+    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++) {
+      macp->WlanTxDataUrb[i] = USB_ALLOC_URB(0, GFP_KERNEL);

-        if (macp->WlanTxDataUrb[i] == 0)
-        {
-            int j;
+      if (macp->WlanTxDataUrb[i] == 0) {
+	int j;

-            /* Free all urbs */
-            for (j = 0; j < i; j++)
-            {
-                usb_free_urb(macp->WlanTxDataUrb[j]);
-            }
+	/* Free all urbs */
+	for (j = 0; j < i; j++)
+	  usb_free_urb(macp->WlanTxDataUrb[j]);

-            return 0;
-        }
+	return 0;
+      }
     }

     /* Allocate all Rx URBs */
-    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++)
-    {
-        macp->WlanRxDataUrb[i] = USB_ALLOC_URB(0, GFP_KERNEL);
+    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++) {
+      macp->WlanRxDataUrb[i] = USB_ALLOC_URB(0, GFP_KERNEL);

-        if (macp->WlanRxDataUrb[i] == 0)
-        {
-            int j;
+      if (macp->WlanRxDataUrb[i] == 0) {
+	int j;

-            /* Free all urbs */
-            for (j = 0; j < i; j++)
-            {
-                usb_free_urb(macp->WlanRxDataUrb[j]);
-            }
+	/* Free all urbs */
+	for (j = 0; j < i; j++)
+	  usb_free_urb(macp->WlanRxDataUrb[j]);

-            for (j = 0; j < ZM_MAX_TX_URB_NUM; j++)
-            {
-                usb_free_urb(macp->WlanTxDataUrb[j]);
-            }
+	for (j = 0; j < ZM_MAX_TX_URB_NUM; j++)
+	  usb_free_urb(macp->WlanTxDataUrb[j]);

-            return 0;
-        }
+	return 0;
+      }
     }

     /* Allocate Register Read/Write USB */
@@ -1015,1 +1030,1 @@ void zfLnxFreeAllUrbs(struct usbdrv_private *macp)
     int i;

     /* Free all Tx URBs */
-    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++)
-    {
-        if (macp->WlanTxDataUrb[i] != NULL)
-        {
-            usb_free_urb(macp->WlanTxDataUrb[i]);
-        }
+    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++) {
+      if (macp->WlanTxDataUrb[i] != NULL)
+	usb_free_urb(macp->WlanTxDataUrb[i]);
     }

     /* Free all Rx URBs */
-    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++)
-    {
-        if (macp->WlanRxDataUrb[i] != NULL)
-        {
-            usb_free_urb(macp->WlanRxDataUrb[i]);
-        }
+    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++) {
+      if (macp->WlanRxDataUrb[i] != NULL)
+	usb_free_urb(macp->WlanRxDataUrb[i]);
     }

     /* Free USB Register Read/Write URB */
@@ -1042,1 +1051,1 @@ void zfLnxUnlinkAllUrbs(struct usbdrv_private *macp)
     int i;

     /* Unlink all Tx URBs */
-    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++)
-    {
-        if (macp->WlanTxDataUrb[i] != NULL)
-        {
-            usb_unlink_urb(macp->WlanTxDataUrb[i]);
-        }
+    for (i = 0; i < ZM_MAX_TX_URB_NUM; i++) {
+      if (macp->WlanTxDataUrb[i] != NULL)
+	usb_unlink_urb(macp->WlanTxDataUrb[i]);
     }

     /* Unlink all Rx URBs */
-    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++)
-    {
-        if (macp->WlanRxDataUrb[i] != NULL)
-        {
-            usb_unlink_urb(macp->WlanRxDataUrb[i]);
-        }
+    for (i = 0; i < ZM_MAX_RX_URB_NUM; i++) {
+      if (macp->WlanRxDataUrb[i] != NULL)
+	usb_unlink_urb(macp->WlanRxDataUrb[i]);
     }

     /* Unlink USB Register Read/Write URB */
@@ -1079,0 +1082,0 @@ static const struct net_device_ops otus_netdev_ops = {

 u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp)
 {
-    //unsigned char addr[6];
+  /* unsigned char addr[6]; */

-    //init_MUTEX(&macp->ps_sem);
-    //init_MUTEX(&macp->reg_sem);
-    //init_MUTEX(&macp->bcn_sem);
-    //init_MUTEX(&macp->config_sem);
+  /* init_MUTEX(&macp->ps_sem); */
+  /* init_MUTEX(&macp->reg_sem); */
+  /* init_MUTEX(&macp->bcn_sem); */
+  /* init_MUTEX(&macp->config_sem); */

     spin_lock_init(&(macp->cs_lock));
 #if 0
@@ -1116,1 +1119,1 @@ u8_t zfLnxInitSetup(struct net_device *dev, struct usbdrv_private *macp)
     macp->hbTimer10ms.function = (void *)&zfLnx10msTimer;

     /* Initialize WDS and VAP data structure */
-    //zfInitWdsStruct();
+    /* zfInitWdsStruct(); */
     zfLnxInitVapStruct();

     return 1;
@@ -1132,1 +1135,1 @@ u8_t zfLnxClearStructs(struct net_device *dev)
     printk(KERN_ERR "TxQCnt: %d\n", TxQCnt);

     for (ii = 0; ii < TxQCnt; ii++) {
-        UsbTxQ_t *TxQ = zfLnxGetUsbTxBuffer(dev);
+      UsbTxQ_t *TxQ = zfLnxGetUsbTxBuffer(dev);

-        printk(KERN_ERR "dev_kfree_skb_any\n");
-        /* Free buffer */
-        dev_kfree_skb_any(TxQ->buf);
+      printk(KERN_ERR "dev_kfree_skb_any\n");
+      /* Free buffer */
+      dev_kfree_skb_any(TxQ->buf);
     }

     return 0;
--
1.6.0.4

