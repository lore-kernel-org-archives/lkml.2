Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193Ab2KPQy7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 11:54:59 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:60213 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2KPQy6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 11:54:58 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 2/3] staging: wlags49_h2: wl_if.h: fixes several coding style issues
Date: Fri, 16 Nov 2012 18:54:43 +0200
Message-Id: <1353084883-8860-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit sorts out several coding style issues, including the use of C99 // comments, spaces at the start of lines, spaces before tabs, incorrect brace placement, and macros with complex values that have not been wrapped in parentheses.  The only remaining issue is the use of typedefs in two instances, but that's something that the original author might need to have a look at.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_if.h |  143 ++++++++++++++++++------------------
 1 file changed, 70 insertions(+), 73 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_if.h b/drivers/staging/wlags49_h2/wl_if.h
index 6d66dab..dcd83cc 100644
--- a/drivers/staging/wlags49_h2/wl_if.h
+++ b/drivers/staging/wlags49_h2/wl_if.h
@@ -71,45 +71,49 @@
 #define MAX_LTV_BUF_SIZE            (512 - (sizeof(hcf_16) * 2))
 
 #define HCF_TALLIES_SIZE            (sizeof(CFG_HERMES_TALLIES_STRCT) + \
-                                     (sizeof(hcf_16) * 2))
+				    (sizeof(hcf_16) * 2))
 
 #define HCF_MAX_MULTICAST           16
 #define HCF_MAX_NAME_LEN            32
-#define MAX_LINE_SIZE   			256
+#define MAX_LINE_SIZE               256
 #define HCF_NUM_IO_PORTS            0x80
 #define TX_TIMEOUT                  ((800 * HZ) / 1000)
 
+/*
+#define HCF_MIN_COMM_QUALITY        0
+#define HCF_MAX_COMM_QUALITY        92
+#define HCF_MIN_SIGNAL_LEVEL        47
+#define HCF_MAX_SIGNAL_LEVEL        138
+#define HCF_MIN_NOISE_LEVEL         47
+#define HCF_MAX_NOISE_LEVEL         138
+#define HCF_0DBM_OFFSET             149
+*/
 
-//#define HCF_MIN_COMM_QUALITY        0
-//#define HCF_MAX_COMM_QUALITY        92
-//#define HCF_MIN_SIGNAL_LEVEL        47
-//#define HCF_MAX_SIGNAL_LEVEL        138
-//#define HCF_MIN_NOISE_LEVEL         47
-//#define HCF_MAX_NOISE_LEVEL         138
-//#define HCF_0DBM_OFFSET             149
-
-// PE1DNN
-// Better data from the real world. Not scientific but empirical data gathered
-// from a Thomson Speedtouch 110 which is identified as:
-// PCMCIA Info: "Agere Systems" "Wireless PC Card Model 0110"
-//              Manufacture ID: 0156,0003
-// Lowest measurment for noise floor seen is value 54
-// Highest signal strength in close proximity to the AP seen is value 118
-// Very good must be around 100 (otherwise its never "full scale"
-// All other constants are derrived from these. This makes the signal gauge
-// work for me...
+/*
+ * PE1DNN
+ * Better data from the real world. Not scientific but empirical data gathered
+ * from a Thomson Speedtouch 110 which is identified as:
+ * PCMCIA Info: "Agere Systems" "Wireless PC Card Model 0110"
+ *              Manufacture ID: 0156,0003
+ * Lowest measurment for noise floor seen is value 54
+ * Highest signal strength in close proximity to the AP seen is value 118
+ * Very good must be around 100 (otherwise its never "full scale"
+ * All other constants are derrived from these. This makes the signal gauge
+ * work for me...
+ */
 #define HCF_MIN_SIGNAL_LEVEL        54
 #define HCF_MAX_SIGNAL_LEVEL        100
 #define HCF_MIN_NOISE_LEVEL         HCF_MIN_SIGNAL_LEVEL
 #define HCF_MAX_NOISE_LEVEL         HCF_MAX_SIGNAL_LEVEL
 #define HCF_0DBM_OFFSET             (HCF_MAX_SIGNAL_LEVEL + 1)
 #define HCF_MIN_COMM_QUALITY        0
-#define HCF_MAX_COMM_QUALITY        (HCF_MAX_SIGNAL_LEVEL - HCF_MIN_NOISE_LEVEL + 1)
+#define HCF_MAX_COMM_QUALITY        (HCF_MAX_SIGNAL_LEVEL - \
+				    HCF_MIN_NOISE_LEVEL + 1)
 
 
 /* For encryption (WEP) */
-#define MIN_KEY_SIZE                5       // 40 bits RC4 - WEP
-#define MAX_KEY_SIZE                13      // 104 bits
+#define MIN_KEY_SIZE                5       /* 40 bits RC4 - WEP */
+#define MAX_KEY_SIZE                13      /* 104 bits */
 #define MAX_KEYS                    4
 
 #define RADIO_CHANNELS              14
@@ -121,12 +125,12 @@
 #define MAX_RTS_BYTES               2347
 
 #define MAX_RATES                   8
-#define MEGABIT                     1024*1024
+#define MEGABIT                     (1024 * 1024)
 
 #define HCF_FAILURE                 0xFF
 #define UIL_FAILURE		            0xFF
-#define CFG_UIL_CONNECT             0xA123          // Define differently?
-#define CFG_UIL_CONNECT_ACK_CODE    0x5653435A      // VSCZ
+#define CFG_UIL_CONNECT             0xA123          /* Define differently? */
+#define CFG_UIL_CONNECT_ACK_CODE    0x5653435A      /* VSCZ */
 #define WVLAN2_UIL_CONNECTED        (0x01L << 0)
 #define WVLAN2_UIL_BUSY             (0x01L << 1)
 
@@ -154,15 +158,15 @@ UIL_FUN_GET_INFO
 UIL_FUN_PUT_INFO
 */
 
-#define SIOCSIWNETNAME              SIOCDEVPRIVATE+1
-#define SIOCGIWNETNAME              SIOCDEVPRIVATE+2
-#define SIOCSIWSTANAME              SIOCDEVPRIVATE+3
-#define SIOCGIWSTANAME              SIOCDEVPRIVATE+4
-#define SIOCSIWPORTTYPE             SIOCDEVPRIVATE+5
-#define SIOCGIWPORTTYPE             SIOCDEVPRIVATE+6
+#define SIOCSIWNETNAME              (SIOCDEVPRIVATE+1)
+#define SIOCGIWNETNAME              (SIOCDEVPRIVATE+2)
+#define SIOCSIWSTANAME              (SIOCDEVPRIVATE+3)
+#define SIOCGIWSTANAME              (SIOCDEVPRIVATE+4)
+#define SIOCSIWPORTTYPE             (SIOCDEVPRIVATE+5)
+#define SIOCGIWPORTTYPE             (SIOCDEVPRIVATE+6)
 
 /* IOCTL code for the RTS interface */
-#define WL_IOCTL_RTS                SIOCDEVPRIVATE+7
+#define WL_IOCTL_RTS                (SIOCDEVPRIVATE+7)
 
 /* IOCTL subcodes for WL_IOCTL_RTS */
 #define WL_IOCTL_RTS_READ           1
@@ -174,61 +178,54 @@ UIL_FUN_PUT_INFO
 /*******************************************************************************
  * STRUCTURE DEFINITIONS
  ******************************************************************************/
-typedef struct
-{
-    __u16   length;
-    __u8    name[HCF_MAX_NAME_LEN];
+typedef struct {
+	__u16   length;
+	__u8    name[HCF_MAX_NAME_LEN];
 }
 wvName_t;
 
 
-typedef struct
-{
-    hcf_16      len;
-    hcf_16      typ;
-    union
-    {
-        hcf_8       u8[MAX_LTV_BUF_SIZE / sizeof(hcf_8)];
-        hcf_16      u16[MAX_LTV_BUF_SIZE / sizeof(hcf_16)];
-        hcf_32      u32[MAX_LTV_BUF_SIZE / sizeof(hcf_32)];
-    } u;
+typedef struct {
+	hcf_16      len;
+	hcf_16      typ;
+	union {
+		hcf_8       u8[MAX_LTV_BUF_SIZE / sizeof(hcf_8)];
+		hcf_16      u16[MAX_LTV_BUF_SIZE / sizeof(hcf_16)];
+		hcf_32      u32[MAX_LTV_BUF_SIZE / sizeof(hcf_32)];
+	} u;
 }
 ltv_t;
 
 
-struct uilreq
-{
-    union
-    {
-        char    ifrn_name[IFNAMSIZ];
-    } ifr_ifrn;
+struct uilreq {
+	union {
+		char    ifrn_name[IFNAMSIZ];
+	} ifr_ifrn;
 
-    IFBP        hcfCtx;
-    __u8        command;
-    __u8        result;
+	IFBP        hcfCtx;
+	__u8        command;
+	__u8        result;
 
-    /* The data field in this structure is typically an LTV of some type. The
-       len field is the size of the buffer in bytes, as opposed to words (like
-       the L-field in the LTV */
-    __u16       len;
-    void       *data;
+	/* The data field in this structure is typically an LTV of some type.
+	Thel en field is the size of the buffer in bytes, as opposed to words
+	(like the L-field in the LTV) */
+	__u16       len;
+	void       *data;
 };
 
 
-struct rtsreq
-{
-    union
-    {
-        char    ifrn_name[IFNAMSIZ];
-    }
-    ifr_ifrn;
+struct rtsreq {
+	union {
+		char    ifrn_name[IFNAMSIZ];
+	}
+	ifr_ifrn;
 
-    __u16   typ;
-    __u16   reg;
-    __u16   len;
-    __u16   *data;
+	__u16   typ;
+	__u16   reg;
+	__u16   len;
+	__u16   *data;
 };
 
 
-#endif  // __WAVELAN2_IF_H__
+#endif  /* __WAVELAN2_IF_H__ */
 
-- 
1.7.10.4

