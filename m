Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031050Ab2K3RAt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:00:49 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2K3RAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:00:46 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 08/32] staging: wlags49_h2: wl_enc: corrects spacing around parentheses
Date: Fri, 30 Nov 2012 18:58:33 +0200
Message-Id: <1354294737-5735-8-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects various instances where the use of spaces
around parentheses was incorrect.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_enc.c |   46 +++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_enc.c b/drivers/staging/wlags49_h2/wl_enc.c
index a62db46..1d143cd 100644
--- a/drivers/staging/wlags49_h2/wl_enc.c
+++ b/drivers/staging/wlags49_h2/wl_enc.c
@@ -105,7 +105,7 @@ extern dbg_info_t *DbgInfo;
  *      OK
  *
  ******************************************************************************/
-int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
+int wl_wep_code(char *szCrypt, char *szDest, void *Data, int nLen)
 {
 	int     i;
 	int     t;
@@ -115,16 +115,16 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
 	/*------------------------------------------------------------------------*/
 
 
-	for( i = bits = 0 ; i < MACADDRESS_STR_LEN; i++ ) {
+	for (i = bits = 0; i < MACADDRESS_STR_LEN; i++) {
 		bits ^= szCrypt[i];
 		bits += szCrypt[i];
 	}
 
-	for( i = t = *szDest = 0; i < nLen; i++, t++ ) {
-		k = szData[i] ^ ( bits + i );
+	for (i = t = *szDest = 0; i < nLen; i++, t++) {
+		k = szData[i] ^ (bits + i);
 
 
-	switch( i % 3 ) {
+	switch (i % 3) {
 
 	case 0 :
 
@@ -137,8 +137,8 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
 
 	case 1 :
 
-		szDest[t]  += (( k & 0xF0 ) >> 4 );
-		szDest[t+1] = (( k & 0x0F ) << 2 ) + CH_START ;
+		szDest[t]  += ((k & 0xF0) >> 4);
+		szDest[t+1] = ((k & 0x0F) << 2) + CH_START ;
 		szDest[t+2] = '\0';
 
 		break;
@@ -146,8 +146,8 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
 
 	case 2 :
 
-		szDest[t]  += (( k & 0xC0 ) >> 6 );
-		szDest[t+1] = ( k & 0x3F ) + CH_START ;
+		szDest[t]  += ((k & 0xC0) >> 6);
+		szDest[t+1] = (k & 0x3F) + CH_START ;
 		szDest[t+2] = '\0';
 		t++;
 
@@ -155,7 +155,7 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
 	}
 	}
 
-	return( strlen( szDest )) ;
+	return(strlen(szDest)) ;
 
 }
 /*============================================================================*/
@@ -182,7 +182,7 @@ int wl_wep_code( char *szCrypt, char *szDest, void *Data, int nLen )
  *      OK
  *
  ******************************************************************************/
-int wl_wep_decode( char *szCrypt, void *Dest, char *szData )
+int wl_wep_decode(char *szCrypt, void *Dest, char *szData)
 {
 	int     i;
 	int     t;
@@ -192,40 +192,40 @@ int wl_wep_decode( char *szCrypt, void *Dest, char *szData )
 	/*------------------------------------------------------------------------*/
 
 
-	for( i = bits = 0 ; i < 12; i++ ) {
+	for (i = bits = 0; i < 12; i++) {
 		bits ^= szCrypt[i] ;
 		bits += szCrypt[i] ;
 	}
 
-	nLen = ( strlen( szData ) * 3) / 4 ;
+	nLen = (strlen(szData) * 3) / 4 ;
 
-	for( i = t = 0; i < nLen; i++, t++ ) {
-		switch( i % 3 ) {
+	for (i = t = 0; i < nLen; i++, t++) {
+		switch (i % 3) {
 		case 0 :
 
-			szDest[i] = ((( szData[t]-CH_START ) & 0x3f ) << 2 ) +
-				    ((( szData[t+1]-CH_START ) & 0x30 ) >> 4 );
+			szDest[i] = (((szData[t] - CH_START) & 0x3f) << 2) +
+				    (((szData[t+1] - CH_START) & 0x30) >> 4);
 			break;
 
 
 		case 1 :
-			szDest[i] = ((( szData[t]-CH_START ) & 0x0f ) << 4 ) +
-				    ((( szData[t+1]-CH_START ) & 0x3c ) >> 2 );
+			szDest[i] = (((szData[t] - CH_START) & 0x0f) << 4) +
+				    (((szData[t+1] - CH_START) & 0x3c) >> 2);
 			break;
 
 
 		case 2 :
-			szDest[i] = ((( szData[t]-CH_START ) & 0x03 ) << 6 ) +
-				     (( szData[t+1]-CH_START ) & 0x3f );
+			szDest[i] = (((szData[t] - CH_START) & 0x03) << 6) +
+				     ((szData[t+1] - CH_START) & 0x3f);
 			t++;
 			break;
 		}
 
-		szDest[i] ^= ( bits + i ) ;
+		szDest[i] ^= (bits + i);
 
 	}
 
-	return( i ) ;
+	return(i) ;
 
 }
 /*============================================================================*/
-- 
1.7.10.4

