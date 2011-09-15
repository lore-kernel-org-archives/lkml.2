Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935426Ab1IOXXY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:23:24 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:44687 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935367Ab1IOXWU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:22:20 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 07/13] staging: wlags49_h2: Remove some unused defines
Date: Fri, 16 Sep 2011 00:20:51 +0100
Message-Id: <1316128857-9781-8-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HCF_INT_OFF, _TCHAR_DEFINED, HCF_LITTLE_ENDIAN, HCF_TALLIES_EXTRA
HCF_ENTRY, HCF_EXIT, OUTPUTDEBUGMSG, ASSERTDEBUGMSG

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/hcf.c    |    6 +-----
 drivers/staging/wlags49_h2/hcf.h    |    2 --
 drivers/staging/wlags49_h2/hcfcfg.h |   30 ------------------------------
 drivers/staging/wlags49_h2/hcfdef.h |    6 ++----
 4 files changed, 3 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index e1d391a..0ec0229 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -437,7 +437,7 @@ static struct /*CFG_HCF_OPT_STRCT*/ {
 	hcf_16  v17;                        // HCF_NIC_TAL_CNT
 	hcf_16  v18;                        // HCF_HCF_TAL_CNT
 	hcf_16  v19;                        // offset tallies
-	TCHAR   val[sizeof(HCF_VERSION)];
+	char    val[sizeof(HCF_VERSION)];
 } BASED cfg_hcf_opt = {
 	sizeof(cfg_hcf_opt)/sizeof(hcf_16) -1,
 	CFG_HCF_OPT,                // (0x082C)
@@ -473,10 +473,6 @@ static struct /*CFG_HCF_OPT_STRCT*/ {
 }; // cfg_hcf_opt
 #endif // MSF_COMPONENT_ID
 
-#if defined HCF_TALLIES_EXTRA
-	replaced by HCF_EXT_TALLIES_FW ;
-#endif // HCF_TALLIES_EXTRA
-
 #if defined MSF_COMPONENT_ID || (HCF_EXT) & HCF_EXT_MB
 #if (HCF_EXT) & HCF_EXT_MB
 HCF_STATIC LTV_STRCT BASED cfg_null = { 1, CFG_NULL, {0} };
diff --git a/drivers/staging/wlags49_h2/hcf.h b/drivers/staging/wlags49_h2/hcf.h
index 4fd62cd..fc8c355 100644
--- a/drivers/staging/wlags49_h2/hcf.h
+++ b/drivers/staging/wlags49_h2/hcf.h
@@ -335,9 +335,7 @@ typedef struct  {
    CFG_FW_PRINTF_BUFFER_LOCATION_STRCT IFB_FwPfBuff;
 #endif // HCF_ASSERT_PRINTF
 #endif // HCF_ASSERT
-#if ! defined HCF_INT_OFF
   hcf_16 volatile IFB_IntOffCnt;		// 0xFFFF based HCF_ACT_INT_OFF nesting counter, DeepSleep flag
-#endif // HCF_INT_OFF
 #if (HCF_TYPE) & HCF_TYPE_CCX
   hcf_16         IFB_CKIPStat;			// CKIP Status flag
 #endif // HCF_TYPE_CCX
diff --git a/drivers/staging/wlags49_h2/hcfcfg.h b/drivers/staging/wlags49_h2/hcfcfg.h
index 764ad9a..825550e 100644
--- a/drivers/staging/wlags49_h2/hcfcfg.h
+++ b/drivers/staging/wlags49_h2/hcfcfg.h
@@ -447,16 +447,6 @@ typedef unsigned long			hcf_32;
 #define  IN_PORT_STRING_8_16(port, addr, len)	IN_PORT_STRING_16(port, addr, len)
 #define  OUT_PORT_STRING_8_16(port, addr, len)	OUT_PORT_STRING_16(port, addr, len)
 
-
-#ifndef OUTPUTDEBUGMSG
-#define OUTPUTDEBUGMSG(dprintf_exp)
-#endif
-
-
-#ifndef ASSERTDEBUGMSG
-#define ASSERTDEBUGMSG(cond, dprintf_exp)
-#endif
-
 #ifndef CFG_SCAN_CHANNELS_2GHZ
 #define CFG_SCAN_CHANNELS_2GHZ 0xFCC2
 #endif /* CFG_SCAN_CHANNELS_2GHZ */
@@ -487,14 +477,6 @@ typedef unsigned long			hcf_32;
 #define			HCF_ENCAP			HCF_ENC
 #endif //		HCF_ENCAP
 
-#if ! defined	HCF_ENTRY
-#define			HCF_ENTRY( ifbp )
-#endif //		HCF_ENTRY
-
-#if ! defined	HCF_EXIT
-#define			HCF_EXIT( ifbp )
-#endif //		HCF_EXIT
-
 #if ! defined	HCF_EXT
 #define			HCF_EXT				0
 #endif //		HCF_EXT
@@ -711,21 +693,9 @@ err: primary variants 1 and 2 correspond with H-I only;
 #define			TEXT(x)	x
 #endif //		TEXT
 
-#if !defined	_TCHAR_DEFINED
-#define 		TCHAR	char
-#endif //		_TCHAR_DEFINED
-
 /************************************************************************************************************/
 /*********************** C O N F L I C T   D E T E C T I O N  &  R E S O L U T I O N ************************/
 /************************************************************************************************************/
-#if defined HCF_LITTLE_ENDIAN
-err: HCF_LITTLE_ENDIAN is obsolete;
-#endif // 	HCF_LITTLE_ENDIAN
-
-#if defined HCF_INT_OFF
-err: HCF_INT_OFF is obsolete;
-#endif //HCF_INT_OFF
-
 #if HCF_ALIGN != 1 && HCF_ALIGN != 2 && HCF_ALIGN != 4 && HCF_ALIGN != 8
 err: invalid value for HCF_ALIGN;
 #endif // HCF_ALIGN
diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index 8e08d7b..fe003ed 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -686,7 +686,6 @@ err: someone redefined these macros while the implemenation assumes they are equ
 
 #define HCFLOGENTRY( where, what ) do {					\
 		if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {		\
-			HCF_ENTRY( ifbp );				\
 			HCFASSERT( (ifbp->IFB_AssertTrace & 1<<((where)&0xF)) == 0, ifbp->IFB_AssertTrace ); \
 			ifbp->IFB_AssertTrace |= 1<<((where)&0xF);	\
 		}							\
@@ -696,7 +695,6 @@ err: someone redefined these macros while the implemenation assumes they are equ
 
 #define HCFLOGEXIT( where ) do {					\
 		if ( (ifbp->IFB_AssertWhere = where) <= 15 ) {		\
-			HCF_EXIT( ifbp );				\
 			ifbp->IFB_AssertTrace &= ~(1<<((where)&0xF));	\
 		}							\
 		HCFTRACE(ifbp, (where)|HCF_TRACE_EXIT );		\
@@ -705,8 +703,8 @@ err: someone redefined these macros while the implemenation assumes they are equ
 #else // HCF_ASSERT
 #define HCFASSERT( x, q ) do { } while(0)
 #define MMDASSERT( x, q )
-#define HCFLOGENTRY( where, what )      do {HCF_ENTRY( ifbp );} while (0)
-#define HCFLOGEXIT( where )             do {HCF_EXIT( ifbp );} while(0)
+#define HCFLOGENTRY( where, what ) do { } while(0)
+#define HCFLOGEXIT( where )        do { } while(0)
 #endif // HCF_ASSERT
 
 #if HCF_INT_ON
-- 
1.7.4.1

