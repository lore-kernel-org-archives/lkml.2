Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753402Ab0JPKLf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 06:11:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34135 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0JPKLc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 06:11:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tB4PhDR+XOu99Cc2mO4B6r7oHkoEZQXiySae8Bt1DBvo8p7AbsZRPDkOa6thv1Beku
         3pMjdL3HMR8FYEGOPWmLP0Bjf4iS9NasbA7NBVnijBdWXURJClQTDxgRY6IadkHNdDB7
         uYq48YZYgu2JxXnNcPbAm5DQyvNHjlmw02aEQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 3/3] staging: wlags49_h2: remove useless DbgHwAddr() method
Date: Sat, 16 Oct 2010 13:11:12 +0300
Message-Id: <474c67434fc73f5085d7793b8be5d36ea617663c.1287223789.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
In-Reply-To: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
References: <11c47095d961ba40ad95ecf995094e78e4d96fdf.1287223789.git.andy.shevchenko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no needs to prepare string for MAC addresses beforehand, due to
kernel's *printf() have '%pM' format option.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/wlags49_h2/wl_main.c   |   73 +++++++++++++++++++-------------
 drivers/staging/wlags49_h2/wl_netdev.c |    3 +-
 drivers/staging/wlags49_h2/wl_util.c   |   70 +++++++-----------------------
 drivers/staging/wlags49_h2/wl_util.h   |    5 --
 drivers/staging/wlags49_h2/wl_wext.c   |    9 ++--
 5 files changed, 66 insertions(+), 94 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_main.c b/drivers/staging/wlags49_h2/wl_main.c
index d0b5062..6d45ab3 100644
--- a/drivers/staging/wlags49_h2/wl_main.c
+++ b/drivers/staging/wlags49_h2/wl_main.c
@@ -466,7 +466,10 @@ int wl_insert( struct net_device *dev )
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_CREATE_IBSS, "\"%s\"", PARM_CREATE_IBSS );
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_MULTICAST_RX, "\"%s\"", PARM_MULTICAST_RX );
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_MAX_SLEEP, "%d", PARM_MAX_SLEEP );
-//;?        DBG_PARAM( DbgInfo, PARM_NAME_NETWORK_ADDR, "\"%s\"", DbgHwAddr( PARM_NETWORK_ADDR ));
+/*
+	DBG_PARAM(DbgInfo, PARM_NAME_NETWORK_ADDR, "\"%pM\"",
+			PARM_NETWORK_ADDR);
+ */
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_AUTHENTICATION, "%d", PARM_AUTHENTICATION );
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_OWN_ATIM_WINDOW, "%d", PARM_OWN_ATIM_WINDOW );
 //;?        DBG_PARAM( DbgInfo, PARM_NAME_PM_HOLDOVER_DURATION, "%d", PARM_PM_HOLDOVER_DURATION );
@@ -493,12 +496,18 @@ int wl_insert( struct net_device *dev )
 	DBG_PARAM( DbgInfo, PARM_NAME_TX_RATE4, "%d", PARM_TX_RATE4 );
 	DBG_PARAM( DbgInfo, PARM_NAME_TX_RATE5, "%d", PARM_TX_RATE5 );
 	DBG_PARAM( DbgInfo, PARM_NAME_TX_RATE6, "%d", PARM_TX_RATE6 );
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS1, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS1 ));
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS2, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS2 ));
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS3, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS3 ));
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS4, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS4 ));
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS5, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS5 ));
-	DBG_PARAM( DbgInfo, PARM_NAME_WDS_ADDRESS6, "\"%s\"", DbgHwAddr( PARM_WDS_ADDRESS6 ));
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS1, "\"%pM\"",
+			PARM_WDS_ADDRESS1);
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS2, "\"%pM\"",
+			PARM_WDS_ADDRESS2);
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS3, "\"%pM\"",
+			PARM_WDS_ADDRESS3);
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS4, "\"%pM\"",
+			PARM_WDS_ADDRESS4);
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS5, "\"%pM\"",
+			PARM_WDS_ADDRESS5);
+	DBG_PARAM(DbgInfo, PARM_NAME_WDS_ADDRESS6, "\"%pM\"",
+			PARM_WDS_ADDRESS6);
 #endif /* USE_WDS */
 #endif /* HCF_AP */
 
@@ -1170,7 +1179,7 @@ int 			rc;
 		return hcf_status;
 	}
 	memcpy( lp->MACAddress, &lp->ltvRecord.u.u8[0], ETH_ALEN );
-	DBG_TRACE( DbgInfo, "Card MAC Address: %s\n", DbgHwAddr( lp->MACAddress ));
+	DBG_TRACE(DbgInfo, "Card MAC Address: %pM\n", lp->MACAddress);
 
 	/* Write out configuration to the device, enable, and reconnect. However,
 	   only reconnect if in AP mode. For STA mode, need to wait for passive scan
@@ -1921,8 +1930,10 @@ int wl_put_ltv( struct wl_private *lp )
 	}
 
 	/* Own MAC Address */
-	//DBG_TRACE( DbgInfo, "MAC Address                       : %s\n",
-	//           DbgHwAddr( lp->MACAddress ));
+/*
+	DBG_TRACE(DbgInfo, "MAC Address                       : %pM\n",
+			lp->MACAddress);
+ */
 
 	if ( WVLAN_VALID_MAC_ADDRESS( lp->MACAddress )) {
 		/* Make the MAC address valid by:
@@ -3033,8 +3044,8 @@ void wl_process_mailbox( struct wl_private *lp )
 						   aps[num_aps].capability );
 				DBG_TRACE( DbgInfo, "SSID Length     : 0x%04x\n",
 						   aps[num_aps].ssid_len );
-				DBG_TRACE( DbgInfo, "BSSID           : %s\n",
-						   DbgHwAddr( aps[num_aps].bssid ));
+				DBG_TRACE(DbgInfo, "BSSID           : %pM\n",
+						   aps[num_aps].bssid);
 
 				if ( aps[num_aps].ssid_len != 0 ) {
 					DBG_TRACE( DbgInfo, "SSID            : %s.\n",
@@ -3093,29 +3104,29 @@ void wl_process_mailbox( struct wl_private *lp )
 				DBG_TRACE( DbgInfo, "(%s) durID       : 0x%04x.\n",
 						   lp->dev->name, probe_rsp->durID );
 
-				DBG_TRACE( DbgInfo, "(%s) address1    : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->address1 ));
+				DBG_TRACE(DbgInfo, "(%s) address1    : %pM\n",
+					lp->dev->name, probe_rsp->address1);
 
-				DBG_TRACE( DbgInfo, "(%s) address2    : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->address2 ));
+				DBG_TRACE(DbgInfo, "(%s) address2    : %pM\n",
+					lp->dev->name, probe_rsp->address2);
 
-				DBG_TRACE( DbgInfo, "(%s) BSSID       : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->BSSID ));
+				DBG_TRACE(DbgInfo, "(%s) BSSID       : %pM\n",
+					lp->dev->name, probe_rsp->BSSID);
 
 				DBG_TRACE( DbgInfo, "(%s) sequence    : 0x%04x.\n",
 						   lp->dev->name, probe_rsp->sequence );
 
-				DBG_TRACE( DbgInfo, "(%s) address4    : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->address4 ));
+				DBG_TRACE(DbgInfo, "(%s) address4    : %pM\n",
+					lp->dev->name, probe_rsp->address4);
 
 				DBG_TRACE( DbgInfo, "(%s) datalength  : 0x%04x.\n",
 						   lp->dev->name, probe_rsp->dataLength );
 
-				DBG_TRACE( DbgInfo, "(%s) DA          : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->DA ));
+				DBG_TRACE(DbgInfo, "(%s) DA          : %pM\n",
+					lp->dev->name, probe_rsp->DA);
 
-				DBG_TRACE( DbgInfo, "(%s) SA          : %s\n",
-						   lp->dev->name, DbgHwAddr( probe_rsp->SA ));
+				DBG_TRACE(DbgInfo, "(%s) SA          : %pM\n",
+					lp->dev->name, probe_rsp->SA);
 
 				//DBG_TRACE( DbgInfo, "(%s) lenType     : 0x%04x.\n",
 				//           lp->dev->name, probe_rsp->lenType );
@@ -3283,12 +3294,12 @@ void wl_process_mailbox( struct wl_private *lp )
 				break;
 			}
 
-			DBG_TRACE( DbgInfo, "STA Address        : %s\n",
-					   DbgHwAddr( as->staAddr ));
+			DBG_TRACE(DbgInfo, "STA Address        : %pM\n",
+					   as->staAddr);
 
 			if (( as->assocStatus == 2 )  && ( as->len == 8 )) {
-				DBG_TRACE( DbgInfo, "Old AP Address     : %s\n",
-						   DbgHwAddr( as->oldApAddr ));
+				DBG_TRACE(DbgInfo, "Old AP Address     : %pM\n",
+						   as->oldApAddr);
 			}
 		}
 
@@ -3327,9 +3338,11 @@ void wl_process_mailbox( struct wl_private *lp )
 				break;
 			}
 
-			DBG_TRACE( DbgInfo, "STA Address     : %s\n", DbgHwAddr( ss->staAddr ));
+			DBG_TRACE(DbgInfo, "STA Address     : %pM\n",
+					ss->staAddr);
 
-			DBG_TRACE( DbgInfo, "Reason          : 0x%04x \n", ss->reason );
+			DBG_TRACE(DbgInfo, "Reason          : 0x%04x\n",
+					ss->reason);
 		}
 
 		break;
diff --git a/drivers/staging/wlags49_h2/wl_netdev.c b/drivers/staging/wlags49_h2/wl_netdev.c
index 954bece..cf917e6 100644
--- a/drivers/staging/wlags49_h2/wl_netdev.c
+++ b/drivers/staging/wlags49_h2/wl_netdev.c
@@ -1071,8 +1071,7 @@ void wl_multicast( struct net_device *dev )
         DBG_PRINT( "  mc_count: %d\n", netdev_mc_count(dev));
 
 	netdev_for_each_mc_addr(ha, dev)
-            DBG_PRINT("    %s (%d)\n", DbgHwAddr(ha->addr),
-		      dev->addr_len);
+	DBG_PRINT("    %pM (%d)\n", ha->addr, dev->addr_len);
     }
 #endif /* DBG */
 
diff --git a/drivers/staging/wlags49_h2/wl_util.c b/drivers/staging/wlags49_h2/wl_util.c
index 4521c9f..3b6f5a5 100644
--- a/drivers/staging/wlags49_h2/wl_util.c
+++ b/drivers/staging/wlags49_h2/wl_util.c
@@ -315,40 +315,6 @@ void key_string2key( char *ks, KEY_STRCT *key )
 
 
 
-#if DBG
-/*******************************************************************************
- *	DbgHwAddr()
- *******************************************************************************
- *
- *  DESCRIPTION:
- *
- *      Convert a hardware ethernet address to a character string
- *
- *  PARAMETERS:
- *
- *      hwAddr  - an ethernet address
- *
- *  RETURNS:
- *
- *      a pointer to a string representing the ethernet address
- *
- ******************************************************************************/
-const char *DbgHwAddr(unsigned char *hwAddr)
-{
-    static char     buffer[18];
-    /*------------------------------------------------------------------------*/
-
-	sprintf(buffer, "%pM", hwAddr);
-
-    return buffer;
-} // DbgHwAddr
-/*============================================================================*/
-
-#endif /* DBG */
-
-
-
-
 /*******************************************************************************
  *	wl_has_wep()
  *******************************************************************************
@@ -1132,29 +1098,29 @@ void wl_process_probe_response( struct wl_private *lp )
             DBG_TRACE( DbgInfo, "(%s) durID       : 0x%04x.\n", lp->dev->name,
                     probe_rsp->durID );
 
-            DBG_TRACE( DbgInfo, "(%s) address1    : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->address1 ));
+		DBG_TRACE(DbgInfo, "(%s) address1    : %pM\n", lp->dev->name,
+			probe_rsp->address1);
 
-            DBG_TRACE( DbgInfo, "(%s) address2    : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->address2 ));
+		DBG_TRACE(DbgInfo, "(%s) address2    : %pM\n", lp->dev->name,
+			probe_rsp->address2);
 
-            DBG_TRACE( DbgInfo, "(%s) BSSID       : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->BSSID ));
+		DBG_TRACE(DbgInfo, "(%s) BSSID       : %pM\n", lp->dev->name,
+			probe_rsp->BSSID);
 
             DBG_TRACE( DbgInfo, "(%s) sequence    : 0x%04x.\n", lp->dev->name,
                     probe_rsp->sequence );
 
-            DBG_TRACE( DbgInfo, "(%s) address4    : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->address4 ));
+		DBG_TRACE(DbgInfo, "(%s) address4    : %pM\n", lp->dev->name,
+			probe_rsp->address4);
 
             DBG_TRACE( DbgInfo, "(%s) datalength  : 0x%04x.\n", lp->dev->name,
                     probe_rsp->dataLength );
 
-            DBG_TRACE( DbgInfo, "(%s) DA          : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->DA ));
+		DBG_TRACE(DbgInfo, "(%s) DA          : %pM\n", lp->dev->name,
+			probe_rsp->DA);
 
-            DBG_TRACE( DbgInfo, "(%s) SA          : %s\n", lp->dev->name,
-                    DbgHwAddr( probe_rsp->SA ));
+		DBG_TRACE(DbgInfo, "(%s) SA          : %pM\n", lp->dev->name,
+			probe_rsp->SA);
 
 #ifdef WARP
 
@@ -1382,12 +1348,11 @@ void wl_process_assoc_status( struct wl_private *lp )
             break;
         }
 
-        DBG_TRACE( DbgInfo, "STA Address        : %s\n",
-                    DbgHwAddr( assoc_stat->staAddr ));
+	DBG_TRACE(DbgInfo, "STA Address        : %pM\n", assoc_stat->staAddr);
 
         if(( assoc_stat->assocStatus == 2 )  && ( assoc_stat->len == 8 )) {
-            DBG_TRACE( DbgInfo, "Old AP Address     : %s\n",
-                        DbgHwAddr( assoc_stat->oldApAddr ));
+		DBG_TRACE(DbgInfo, "Old AP Address     : %pM\n",
+			assoc_stat->oldApAddr);
         }
     }
 
@@ -1458,9 +1423,8 @@ void wl_process_security_status( struct wl_private *lp )
             break;
         }
 
-        DBG_TRACE( DbgInfo, "STA Address     : %s\n",
-                   DbgHwAddr( sec_stat->staAddr ));
-        DBG_TRACE( DbgInfo, "Reason          : 0x%04x \n", sec_stat->reason );
+	DBG_TRACE(DbgInfo, "STA Address     : %pM\n", sec_stat->staAddr);
+	DBG_TRACE(DbgInfo, "Reason          : 0x%04x\n", sec_stat->reason);
 
     }
 
diff --git a/drivers/staging/wlags49_h2/wl_util.h b/drivers/staging/wlags49_h2/wl_util.h
index ba537a6..2661bcd 100644
--- a/drivers/staging/wlags49_h2/wl_util.h
+++ b/drivers/staging/wlags49_h2/wl_util.h
@@ -77,11 +77,6 @@ void wl_endian_translate_event( ltv_t *pLtv );
 
 int wl_has_wep( IFBP ifbp );
 
-
-#if DBG
-const char *DbgHwAddr( unsigned char *hwAddr );
-#endif // DBG
-
 hcf_8   wl_parse_ds_ie( PROBE_RESP *probe_rsp );
 hcf_8 * wl_parse_wpa_ie( PROBE_RESP *probe_rsp, hcf_16 *length );
 hcf_8 * wl_print_wpa_ie( hcf_8 *buffer, int length );
diff --git a/drivers/staging/wlags49_h2/wl_wext.c b/drivers/staging/wlags49_h2/wl_wext.c
index 06467f1..9e5da08 100644
--- a/drivers/staging/wlags49_h2/wl_wext.c
+++ b/drivers/staging/wlags49_h2/wl_wext.c
@@ -789,7 +789,8 @@ static int wireless_get_ap_list (struct net_device *dev, struct iw_request_info
 				memcpy( hwa[count].sa_data,
 						(*p)/*lp->scan_results*/.APTable[count].bssid, ETH_ALEN );
 #else  //;?why use BSSID and bssid as names in seemingly very comparable situations
-				DBG_PRINT( "BSSID: %s\n", DbgHwAddr( (*p)/*lp->probe_results*/.ProbeTable[count].BSSID ));
+				DBG_PRINT("BSSID: %pM\n",
+						(*p).ProbeTable[count].BSSID);
 				memcpy( hwa[count].sa_data,
 						(*p)/*lp->probe_results*/.ProbeTable[count].BSSID, ETH_ALEN );
 #endif // WARP
@@ -3937,9 +3938,9 @@ void wl_wext_event_mic_failed( struct net_device *dev )
 			 a problem in future versions of the supplicant, if they ever
 			 actually parse these parameters */
 #if DBG
-	sprintf( msg, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast addr="
-			 "%s)", key_idx, addr1[0] & 0x01 ? "broad" : "uni",
-			 DbgHwAddr( addr2 ));
+	sprintf(msg, "MLME-MICHAELMICFAILURE.indication(keyid=%d %scast "
+			"addr=%pM)", key_idx, addr1[0] & 0x01 ? "broad" : "uni",
+			addr2);
 #endif
 	wrqu.data.length = strlen( msg );
 	wireless_send_event( dev, IWEVCUSTOM, &wrqu, msg );
-- 
1.7.2.3

