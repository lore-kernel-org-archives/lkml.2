Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691Ab0EIRMA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 May 2010 13:12:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33455 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab0EIRL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 May 2010 13:11:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=TNsjJ3NfxU/gFdrDU6OWBzZJWC7keyZmk1yHlPAhd1ocN30JArtDfbO3QynNw622+D
         eRMZHKrx1vNwEFpWPRw05nOutm5Y/imwRgYTnGjEceMAQiTbSemO3dp/Oas1/HzQaACU
         CnCWxXWuKQjr/No/aLdUizXOUyKa07/wjUSw0=
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: akpm@linux-foundation.org, pe1dnn@amsat.org,
       ext-andriy.shevchenko@nokia.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       "Prashant P. Shah" <pshah.mumbai@gmail.com>
Subject: [PATCH] Staging: wlags49_h2: fixed unnecessary braces issues in wl_profile.c
Date: Sun,  9 May 2010 22:41:46 +0530
Message-Id: <1273425106-6721-1-git-send-email-pshah.mumbai@gmail.com>
X-Mailer: git-send-email 1.6.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the wl_profile.c file that fixes the unnecessary braces
style issues found by the checkpatch.pl tool.

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/wlags49_h2/wl_profile.c |  228 ++++++++++++-------------------
 1 files changed, 90 insertions(+), 138 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_profile.c b/drivers/staging/wlags49_h2/wl_profile.c
index e4e78a4..13ade70 100644
--- a/drivers/staging/wlags49_h2/wl_profile.c
+++ b/drivers/staging/wlags49_h2/wl_profile.c
@@ -189,9 +189,8 @@ void parse_config(struct net_device *dev)
 		DBG_TRACE(DbgInfo, "Wireless config file found. Parsing options...\n");
 
 		/* Read out the options */
-		while (readline(file_desc, buffer)) {
+		while (readline(file_desc, buffer))
 			translate_option(buffer, wvlan_config);
-		}
 		/* Close the file */
 		close(file_desc);	//;?even if file_desc == -1 ???
 	} else {
@@ -259,9 +258,8 @@ void parse_config(struct net_device *dev)
 				} else if (rc > 0) {
 					DBG_TRACE(DbgInfo, "read O.K.: %d bytes  %.12s\n", rc, cp);
 					rc = read(file_desc, &cp[rc], 1);
-					if (rc == 0) {
+					if (rc == 0)
 						DBG_TRACE(DbgInfo, "no more to read\n");
-					}
 				}
 				if (rc != 0) {
 					DBG_ERROR(DbgInfo, "file not read in one swoop or other error"\
@@ -320,11 +318,10 @@ int readline(int filedesc, char *buffer)
 	}
 
 	/* Return the number of bytes read */
-	if (result == -1) {
+	if (result == -1)
 		return result;
-	} else {
+	else
 		return bytes_read;
-	}
 } // readline
 /*============================================================================*/
 
@@ -366,9 +363,8 @@ void translate_option(char *buffer, struct wl_private *lp)
 
 	ParseConfigLine(buffer, &key, &value);
 
-	if (key == NULL || value == NULL) {
+	if (key == NULL || value == NULL)
 		return;
-	}
 
 	/* Determine which key it is and perform the appropriate action */
 
@@ -394,29 +390,26 @@ void translate_option(char *buffer, struct wl_private *lp)
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_AUTH_KEY_MGMT_SUITE, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_AUTH_KEY_MGMT_SUITE) || (value_convert <= PARM_MAX_AUTH_KEY_MGMT_SUITE)) {
+		if ((value_convert >= PARM_MIN_AUTH_KEY_MGMT_SUITE) || (value_convert <= PARM_MAX_AUTH_KEY_MGMT_SUITE))
 			lp->AuthKeyMgmtSuite = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_AUTH_KEY_MGMT_SUITE);
-		}
 	} else if (strcmp(key, PARM_NAME_BRSC_2GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_BRSC_2GHZ, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC)) {
+		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC))
 			lp->brsc[0] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_BRSC_2GHZ);
-		}
 	} else if (strcmp(key, PARM_NAME_BRSC_5GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_BRSC_5GHZ, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC)) {
+		if ((value_convert >= PARM_MIN_BRSC) || (value_convert <= PARM_MAX_BRSC))
 			lp->brsc[1] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_BRSC_5GHZ);
-		}
 	} else if ((strcmp(key, PARM_NAME_DESIRED_SSID) == 0) || (strcmp(key, PARM_NAME_OWN_SSID) == 0)) {
 		DBG_TRACE(DbgInfo, "SSID, value: %s\n", value);
 
@@ -437,22 +430,20 @@ void translate_option(char *buffer, struct wl_private *lp)
 		memset(lp->fw_image_filename, 0, (MAX_LINE_SIZE + 1));
 		/* Make sure the value isn't too long */
 		string_length = strlen(value);
-		if (string_length > MAX_LINE_SIZE) {
+		if (string_length > MAX_LINE_SIZE)
 			DBG_WARNING(DbgInfo, "F/W image file name too long; will be ignored\n");
-		} else {
+		else
 			memcpy(lp->fw_image_filename, value, string_length);
-		}
 	}
 #endif
 	else if (strcmp(key, PARM_NAME_ENABLE_ENCRYPTION) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_ENABLE_ENCRYPTION, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_ENABLE_ENCRYPTION) && (value_convert <= PARM_MAX_ENABLE_ENCRYPTION)) {
+		if ((value_convert >= PARM_MIN_ENABLE_ENCRYPTION) && (value_convert <= PARM_MAX_ENABLE_ENCRYPTION))
 			lp->EnableEncryption = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_ENABLE_ENCRYPTION);
-		}
 	} else if (strcmp(key, PARM_NAME_ENCRYPTION) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_ENCRYPTION, value);
 
@@ -522,19 +513,17 @@ void translate_option(char *buffer, struct wl_private *lp)
 
 		value_convert = simple_strtoul(value, NULL, 0);
 
-		if ((value_convert >= PARM_MIN_MULTICAST_RATE) && (value_convert <= PARM_MAX_MULTICAST_RATE)) {
+		if ((value_convert >= PARM_MIN_MULTICAST_RATE) && (value_convert <= PARM_MAX_MULTICAST_RATE))
 			lp->MulticastRate[0] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MULTICAST_RATE);
-		}
 	} else if (strcmp(key, PARM_NAME_OWN_CHANNEL) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_OWN_CHANNEL, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
 		if (wl_is_a_valid_chan(value_convert)) {
-			if (value_convert > 14) {
+			if (value_convert > 14)
 				value_convert = value_convert | 0x100;
-			}
 			lp->Channel = value_convert;
 		} else {
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_OWN_CHANNEL);
@@ -556,65 +545,58 @@ void translate_option(char *buffer, struct wl_private *lp)
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+		if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 			lp->RTSThreshold = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD);
-		}
 	} else if (strcmp(key, PARM_NAME_SRSC_2GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_SRSC_2GHZ, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC)) {
+		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC))
 			lp->srsc[0] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_SRSC_2GHZ);
-		}
 	} else if (strcmp(key, PARM_NAME_SRSC_5GHZ) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_SRSC_5GHZ, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC)) {
+		if ((value_convert >= PARM_MIN_SRSC) || (value_convert <= PARM_MAX_SRSC))
 			lp->srsc[1] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invaid; will be ignored\n", PARM_NAME_SRSC_5GHZ);
-		}
 	} else if (strcmp(key, PARM_NAME_SYSTEM_SCALE) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_SYSTEM_SCALE, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_SYSTEM_SCALE) && (value_convert <= PARM_MAX_SYSTEM_SCALE)) {
+		if ((value_convert >= PARM_MIN_SYSTEM_SCALE) && (value_convert <= PARM_MAX_SYSTEM_SCALE))
 			lp->DistanceBetweenAPs = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_SYSTEM_SCALE);
-		}
 	} else if (strcmp(key, PARM_NAME_TX_KEY) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_KEY, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_TX_KEY) && (value_convert <= PARM_MAX_TX_KEY)) {
+		if ((value_convert >= PARM_MIN_TX_KEY) && (value_convert <= PARM_MAX_TX_KEY))
 			lp->TransmitKeyID = simple_strtoul(value, NULL, 0);
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_KEY);
-		}
 	} else if (strcmp(key, PARM_NAME_TX_RATE) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+		if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 			lp->TxRateControl[0] = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE);
-		}
 	} else if (strcmp(key, PARM_NAME_TX_POW_LEVEL) == 0) {
 		DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_POW_LEVEL, value);
 
 		value_convert = simple_strtoul(value, NULL, 0);
-		if ((value_convert >= PARM_MIN_TX_POW_LEVEL) || (value_convert <= PARM_MAX_TX_POW_LEVEL)) {
+		if ((value_convert >= PARM_MIN_TX_POW_LEVEL) || (value_convert <= PARM_MAX_TX_POW_LEVEL))
 			lp->txPowLevel = value_convert;
-		} else {
+		else
 			DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_POW_LEVEL);
-		}
 	}
 
 	/* Need to add? : Country code, Short/Long retry */
@@ -628,11 +610,10 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_PORT_TYPE, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert == PARM_MIN_PORT_TYPE) || (value_convert == PARM_MAX_PORT_TYPE)) {
+			if ((value_convert == PARM_MIN_PORT_TYPE) || (value_convert == PARM_MAX_PORT_TYPE))
 				lp->PortType = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_PORT_TYPE);
-			}
 		} else if (strcmp(key, PARM_NAME_PM_ENABLED) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_PM_ENABLED, value);
 			value_convert = simple_strtoul(value, NULL, 0);
@@ -656,46 +637,41 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_MAX_SLEEP, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= 0) && (value_convert <= 65535)) {
+			if ((value_convert >= 0) && (value_convert <= 65535))
 				lp->MaxSleepDuration = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_MAX_SLEEP);
-			}
 		} else if (strcmp(key, PARM_NAME_NETWORK_ADDR) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_NETWORK_ADDR, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->MACAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_NETWORK_ADDR);
-			}
 		} else if (strcmp(key, PARM_NAME_AUTHENTICATION) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_AUTHENTICATION, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_AUTHENTICATION) && (value_convert <= PARM_MAX_AUTHENTICATION)) {
+			if ((value_convert >= PARM_MIN_AUTHENTICATION) && (value_convert <= PARM_MAX_AUTHENTICATION))
 				lp->authentication = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_AUTHENTICATION);
-			}
 		} else if (strcmp(key, PARM_NAME_OWN_ATIM_WINDOW) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_OWN_ATIM_WINDOW, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_OWN_ATIM_WINDOW) && (value_convert <= PARM_MAX_OWN_ATIM_WINDOW)) {
+			if ((value_convert >= PARM_MIN_OWN_ATIM_WINDOW) && (value_convert <= PARM_MAX_OWN_ATIM_WINDOW))
 				lp->atimWindow = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_OWN_ATIM_WINDOW);
-			}
 		} else if (strcmp(key, PARM_NAME_PM_HOLDOVER_DURATION) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_PM_HOLDOVER_DURATION, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_PM_HOLDOVER_DURATION) && (value_convert <= PARM_MAX_PM_HOLDOVER_DURATION)) {
+			if ((value_convert >= PARM_MIN_PM_HOLDOVER_DURATION) && (value_convert <= PARM_MAX_PM_HOLDOVER_DURATION))
 				lp->holdoverDuration = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_PM_HOLDOVER_DURATION);
-			}
 		} else if (strcmp(key, PARM_NAME_PROMISCUOUS_MODE) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_PROMISCUOUS_MODE, value);
 			lp->promiscuousMode = parse_yes_no(value);
@@ -703,11 +679,10 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_CONNECTION_CONTROL, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_CONNECTION_CONTROL) && (value_convert <= PARM_MAX_CONNECTION_CONTROL)) {
+			if ((value_convert >= PARM_MIN_CONNECTION_CONTROL) && (value_convert <= PARM_MAX_CONNECTION_CONTROL))
 				lp->connectionControl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_CONNECTION_CONTROL);
-			}
 		}
 
 		/* Need to add? : Probe Data Rate */
@@ -722,11 +697,10 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_OWN_DTIM_PERIOD, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if (value_convert >= PARM_MIN_OWN_DTIM_PERIOD) {
+			if (value_convert >= PARM_MIN_OWN_DTIM_PERIOD)
 				lp->DTIMPeriod = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_OWN_DTIM_PERIOD);
-			}
 		} else if (strcmp(key, PARM_NAME_REJECT_ANY) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_REJECT_ANY, value);
 			lp->RejectAny = parse_yes_no(value);
@@ -743,20 +717,18 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_OWN_BEACON_INTERVAL, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if (value_convert >= PARM_MIN_OWN_BEACON_INTERVAL) {
+			if (value_convert >= PARM_MIN_OWN_BEACON_INTERVAL)
 				lp->ownBeaconInterval = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_OWN_BEACON_INTERVAL);
-			}
 		} else if (strcmp(key, PARM_NAME_COEXISTENCE) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_COEXISTENCE, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if (value_convert >= PARM_MIN_COEXISTENCE) {
+			if (value_convert >= PARM_MIN_COEXISTENCE)
 				lp->coexistence = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_COEXISTENCE);
-			}
 		}
 
 #ifdef USE_WDS
@@ -764,158 +736,140 @@ void translate_option(char *buffer, struct wl_private *lp)
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD1, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[0].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD1);
-			}
 		} else if (strcmp(key, PARM_NAME_RTS_THRESHOLD2) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD2, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[1].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD2);
-			}
 		} else if (strcmp(key, PARM_NAME_RTS_THRESHOLD3) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD3, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[2].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD3);
-			}
 		} else if (strcmp(key, PARM_NAME_RTS_THRESHOLD4) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD4, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[3].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD4);
-			}
 		} else if (strcmp(key, PARM_NAME_RTS_THRESHOLD5) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD5, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[4].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD5);
-			}
 		} else if (strcmp(key, PARM_NAME_RTS_THRESHOLD6) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_RTS_THRESHOLD6, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD)) {
+			if ((value_convert >= PARM_MIN_RTS_THRESHOLD) && (value_convert <= PARM_MAX_RTS_THRESHOLD))
 				lp->wds_port[5].rtsThreshold = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_RTS_THRESHOLD6);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE1) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE1, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[0].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE1);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE2) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE2, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[1].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE2);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE3) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE3, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[2].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE3);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE4) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE4, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[3].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE4);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE5) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE5, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[4].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE5);
-			}
 		} else if (strcmp(key, PARM_NAME_TX_RATE6) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_TX_RATE6, value);
 
 			value_convert = simple_strtoul(value, NULL, 0);
-			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE)) {
+			if ((value_convert >= PARM_MIN_TX_RATE) && (value_convert <= PARM_MAX_TX_RATE))
 				lp->wds_port[5].txRateCntl = value_convert;
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_TX_RATE6);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS1) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS1, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[0].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS1);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS2) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS2, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[1].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS2);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS3) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS3, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[2].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS3);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS4) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS4, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[3].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS4);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS5) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS5, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[4].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS5);
-			}
 		} else if (strcmp(key, PARM_NAME_WDS_ADDRESS6) == 0) {
 			DBG_TRACE(DbgInfo, "%s, value: %s\n", PARM_NAME_WDS_ADDRESS6, value);
 
-			if (parse_mac_address(value, mac_value) == ETH_ALEN) {
+			if (parse_mac_address(value, mac_value) == ETH_ALEN)
 				memcpy(lp->wds_port[5].wdsAddress, mac_value, ETH_ALEN);
-			} else {
+			else
 				DBG_WARNING(DbgInfo, "%s invalid; will be ignored\n", PARM_NAME_WDS_ADDRESS6);
-			}
 		}
 #endif  /* USE_WDS */
 	}
@@ -1045,12 +999,10 @@ void ParseConfigLine(char *pszLine, char **ppszLVal, char **ppszRVal)
 		}
 		/* make the line ending character(s) a NULL */
 		for (i++; i < size; i++) {
-			if (pszLine[i] == '\n') {
+			if (pszLine[i] == '\n')
 				pszLine[i] = '\0';
-			}
-			if ((pszLine[i] == '\r') && (pszLine[i+1] == '\n')) {
+			if ((pszLine[i] == '\r') && (pszLine[i+1] == '\n'))
 				pszLine[i] = '\0';
-			}
 		}
 	}
 	DBG_LEAVE(DbgInfo);
-- 
1.6.0.4

