Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031214Ab2K3REY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:04:24 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:62685 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031203Ab2K3RER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:04:17 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 28/32] staging: wlags49_h2: wl_priv: converts indentation to tabs
Date: Fri, 30 Nov 2012 18:58:53 +0200
Message-Id: <1354294737-5735-28-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts instances of space-based indentation to tabs.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_priv.c |  194 +++++++++++++++++-----------------
 1 file changed, 97 insertions(+), 97 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_priv.c b/drivers/staging/wlags49_h2/wl_priv.c
index b49ef87..193b3cd 100644
--- a/drivers/staging/wlags49_h2/wl_priv.c
+++ b/drivers/staging/wlags49_h2/wl_priv.c
@@ -1152,9 +1152,9 @@ int wvlan_uil_put_info(struct uilreq *urq, struct wl_private *lp)
 					}
 					break;
 				default:
-    					wl_act_int_off(lp);
+					wl_act_int_off(lp);
 					urq->result = hcf_put_info(&(lp->hcfCtx), (LTVP) pLtv);
-    					wl_act_int_on(lp);
+					wl_act_int_on(lp);
 					break;
 				}
 
@@ -1315,9 +1315,9 @@ int wvlan_uil_get_info(struct uilreq *urq, struct wl_private *lp)
 					pLtv = &(lp->ltvRecord);
 				}
 
-    				wl_act_int_off(lp);
+				wl_act_int_off(lp);
 				urq->result = hcf_get_info(&(lp->hcfCtx), (LTVP) pLtv);
-    				wl_act_int_on(lp);
+				wl_act_int_on(lp);
 
 				// Copy the LTV into the user's buffer.
 				//copy_to_user(urq->data, pLtv, urq->len);
@@ -1680,8 +1680,8 @@ int wvlan_set_netname(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
 	int ret = 0;
 	/*------------------------------------------------------------------------*/
 
@@ -1689,14 +1689,14 @@ int wvlan_set_netname(struct net_device *dev,
 	DBG_FUNC("wvlan_set_netname");
 	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        memset(lp->NetworkName, 0, sizeof(lp->NetworkName));
-        memcpy(lp->NetworkName, extra, wrqu->data.length);
+	memset(lp->NetworkName, 0, sizeof(lp->NetworkName));
+	memcpy(lp->NetworkName, extra, wrqu->data.length);
 
 	/* Commit the adapter parameters */
 	wl_apply(lp);
-        wl_unlock(lp, &flags);
+	wl_unlock(lp, &flags);
 
 	DBG_LEAVE(DbgInfo);
 	return ret;
@@ -1730,40 +1730,40 @@ int wvlan_get_netname(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
-        int         ret = 0;
-        int         status = -1;
-        wvName_t   *pName;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
+	int         ret = 0;
+	int         status = -1;
+	wvName_t   *pName;
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC("wvlan_get_netname");
-        DBG_ENTER(DbgInfo);
+	DBG_FUNC("wvlan_get_netname");
+	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        /* Get the current network name */
-        lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
-        lp->ltvRecord.typ = CFG_CUR_SSID;
+	/* Get the current network name */
+	lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
+	lp->ltvRecord.typ = CFG_CUR_SSID;
 
-        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
+	status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if (status == HCF_SUCCESS) {
-                pName = (wvName_t *)&(lp->ltvRecord.u.u32);
+	if (status == HCF_SUCCESS) {
+		pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
 		wrqu->data.length = pName->length;
 
-                memcpy(extra, pName->name, pName->length);
-        } else {
-                ret = -EFAULT;
+		memcpy(extra, pName->name, pName->length);
+	} else {
+		ret = -EFAULT;
 	}
 
-        wl_unlock(lp, &flags);
+	wl_unlock(lp, &flags);
 
-        DBG_LEAVE(DbgInfo);
-        return ret;
+	DBG_LEAVE(DbgInfo);
+	return ret;
 } // wvlan_get_netname
 /*============================================================================*/
 
@@ -1794,27 +1794,27 @@ int wvlan_set_station_nickname(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
-        int         ret = 0;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
+	int         ret = 0;
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC("wvlan_set_station_nickname");
-        DBG_ENTER(DbgInfo);
+	DBG_FUNC("wvlan_set_station_nickname");
+	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        memset(lp->StationName, 0, sizeof(lp->StationName));
+	memset(lp->StationName, 0, sizeof(lp->StationName));
 
-        memcpy(lp->StationName, extra, wrqu->data.length);
+	memcpy(lp->StationName, extra, wrqu->data.length);
 
-        /* Commit the adapter parameters */
-        wl_apply(lp);
-        wl_unlock(lp, &flags);
+	/* Commit the adapter parameters */
+	wl_apply(lp);
+	wl_unlock(lp, &flags);
 
-        DBG_LEAVE(DbgInfo);
-        return ret;
+	DBG_LEAVE(DbgInfo);
+	return ret;
 } // wvlan_set_station_nickname
 /*============================================================================*/
 
@@ -1845,39 +1845,39 @@ int wvlan_get_station_nickname(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
 	int         ret = 0;
 	int         status = -1;
 	wvName_t   *pName;
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC("wvlan_get_station_nickname");
-        DBG_ENTER(DbgInfo);
+	DBG_FUNC("wvlan_get_station_nickname");
+	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        /* Get the current station name */
-        lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
-        lp->ltvRecord.typ = CFG_CNF_OWN_NAME;
+	/* Get the current station name */
+	lp->ltvRecord.len = 1 + (sizeof(*pName) / sizeof(hcf_16));
+	lp->ltvRecord.typ = CFG_CNF_OWN_NAME;
 
-        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
+	status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if (status == HCF_SUCCESS) {
-                pName = (wvName_t *)&(lp->ltvRecord.u.u32);
+	if (status == HCF_SUCCESS) {
+		pName = (wvName_t *)&(lp->ltvRecord.u.u32);
 
 		memset(extra, '\0', HCF_MAX_NAME_LEN);
 		wrqu->data.length = pName->length;
 		memcpy(extra, pName->name, pName->length);
-        } else {
-                ret = -EFAULT;
-        }
+	} else {
+		ret = -EFAULT;
+	}
 
-        wl_unlock(lp, &flags);
+	wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE(DbgInfo);
+	DBG_LEAVE(DbgInfo);
 	return ret;
 } // wvlan_get_station_nickname
 /*============================================================================*/
@@ -1909,37 +1909,37 @@ int wvlan_set_porttype(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
-        int     ret = 0;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
+	int     ret = 0;
 	hcf_16  portType;
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC("wvlan_set_porttype");
-        DBG_ENTER(DbgInfo);
+	DBG_FUNC("wvlan_set_porttype");
+	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        /* Validate the new value */
-        portType = *((__u32 *)extra);
+	/* Validate the new value */
+	portType = *((__u32 *)extra);
 
-        if (!((portType == 1) || (portType == 3))) {
-                ret = -EINVAL;
+	if (!((portType == 1) || (portType == 3))) {
+		ret = -EINVAL;
 		goto out_unlock;
-        }
+	}
 
-        lp->PortType = portType;
+	lp->PortType = portType;
 
-        /* Commit the adapter parameters */
-        wl_apply(lp);
+	/* Commit the adapter parameters */
+	wl_apply(lp);
 
 out_unlock:
-        wl_unlock(lp, &flags);
+	wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE(DbgInfo);
-        return ret;
+	DBG_LEAVE(DbgInfo);
+	return ret;
 }
 
 /*============================================================================*/
@@ -1969,39 +1969,39 @@ int wvlan_get_porttype(struct net_device *dev,
 		      union iwreq_data *wrqu,
 		      char *extra)
 {
-        struct wl_private *lp = wl_priv(dev);
-        unsigned long flags;
-        int     ret = 0;
-        int     status = -1;
-        hcf_16  *pPortType;
-        __u32 *pData = (__u32 *)extra;
+	struct wl_private *lp = wl_priv(dev);
+	unsigned long flags;
+	int     ret = 0;
+	int     status = -1;
+	hcf_16  *pPortType;
+	__u32 *pData = (__u32 *)extra;
 	/*------------------------------------------------------------------------*/
 
 
-        DBG_FUNC("wvlan_get_porttype");
-        DBG_ENTER(DbgInfo);
+	DBG_FUNC("wvlan_get_porttype");
+	DBG_ENTER(DbgInfo);
 
-        wl_lock(lp, &flags);
+	wl_lock(lp, &flags);
 
-        /* Get the current port type */
-        lp->ltvRecord.len = 1 + (sizeof(*pPortType) / sizeof(hcf_16));
-        lp->ltvRecord.typ = CFG_CNF_PORT_TYPE;
+	/* Get the current port type */
+	lp->ltvRecord.len = 1 + (sizeof(*pPortType) / sizeof(hcf_16));
+	lp->ltvRecord.typ = CFG_CNF_PORT_TYPE;
 
-        status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
+	status = hcf_get_info(&(lp->hcfCtx), (LTVP)&(lp->ltvRecord));
 
-        if (status == HCF_SUCCESS) {
-                pPortType = (hcf_16 *)&(lp->ltvRecord.u.u32);
+	if (status == HCF_SUCCESS) {
+		pPortType = (hcf_16 *)&(lp->ltvRecord.u.u32);
 
-                *pData = CNV_LITTLE_TO_INT(*pPortType);
-        } else {
-            ret = -EFAULT;
+		*pData = CNV_LITTLE_TO_INT(*pPortType);
+	} else {
+	    ret = -EFAULT;
 	}
 
-        wl_unlock(lp, &flags);
+	wl_unlock(lp, &flags);
 
 //out:
-        DBG_LEAVE(DbgInfo);
-        return ret;
+	DBG_LEAVE(DbgInfo);
+	return ret;
 } // wvlan_get_porttype
 /*============================================================================*/
 
-- 
1.7.10.4

