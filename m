Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab0JJKUb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:20:31 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:47619 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755750Ab0JJKU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:20:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ObHRVKWw6yWJIiIl+kPz9ihyMlJQTk1HZDR4UTtlot6clgO90iGORsQKiNdLqLR57t
         1hemmmrPGbAbceNbTVnhgggRDZaDqhq9VEysw0opBIHNP/CAiV6PjKRwwnFXipnq9PLf
         v04vPS3BQSJI9vWARd/ODv6+4ZRkq0vKR+BIc=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCH 1/3] staging: brcm80211: clean up custom ctype library again
Date: Sun, 10 Oct 2010 13:20:11 +0300
Message-Id: <86dfcd5dfdee8ce5ca558634d4606922f05e96e1.1286705921.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar cleanup was done before for softmac implementation.  But the
fullmac driver brings this back. Remove it again.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/bcmutils.c |   56 ++----------------------
 drivers/staging/brcm80211/brcmfmac/wl_iw.h    |    1 -
 drivers/staging/brcm80211/include/bcmutils.h  |   30 -------------
 3 files changed, 5 insertions(+), 82 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmutils.c b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
index 7185943..f0685c1 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmutils.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmutils.c
@@ -28,8 +28,8 @@
 #if defined(BCMEXTSUP)
 #include <bcm_osl.h>
 #endif
-
 #endif				/* BCMDRIVER */
+#include <linux/ctype.h>
 #include <bcmendian.h>
 #include <bcmdevs.h>
 #include <bcmnvram.h>
@@ -484,52 +484,6 @@ void *pktq_mdeq(struct pktq *pq, uint prec_bmp, int *prec_out)
 }
 #endif				/* BCMDRIVER */
 
-const unsigned char bcm_ctype[] = {
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,
-	_BCM_C, _BCM_C | _BCM_S, _BCM_C | _BCM_S, _BCM_C | _BCM_S,
-	_BCM_C | _BCM_S, _BCM_C | _BCM_S, _BCM_C,
-	_BCM_C,			/* 8-15 */
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,
-	_BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C, _BCM_C,
-	_BCM_S | _BCM_SP, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P,
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D, _BCM_D,
-	_BCM_D, _BCM_D, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_U | _BCM_X, _BCM_U | _BCM_X, _BCM_U | _BCM_X,
-	_BCM_U | _BCM_X, _BCM_U | _BCM_X,
-	_BCM_U | _BCM_X, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_L | _BCM_X, _BCM_L | _BCM_X, _BCM_L | _BCM_X,
-	_BCM_L | _BCM_X, _BCM_L | _BCM_X,
-	_BCM_L | _BCM_X, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_C,
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 128-143 */
-	0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,	/* 144-159 */
-	_BCM_S | _BCM_SP, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 160-175 */
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,
-	_BCM_P, _BCM_P,
-	_BCM_P, _BCM_P, _BCM_P, _BCM_P, _BCM_P,	/* 176-191 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,
-	_BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U,	/* 192-207 */
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_P, _BCM_U,
-	_BCM_U, _BCM_U,
-	_BCM_U, _BCM_U, _BCM_U, _BCM_U, _BCM_L,	/* 208-223 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,
-	_BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L,	/* 224-239 */
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_P, _BCM_L,
-	_BCM_L, _BCM_L,
-	_BCM_L, _BCM_L, _BCM_L, _BCM_L, _BCM_L	/* 240-255 */
-};
-
 unsigned long bcm_strtoul(char *cp, char **endp, uint base)
 {
 	unsigned long result, last_result = 0, value;
@@ -537,7 +491,7 @@ unsigned long bcm_strtoul(char *cp, char **endp, uint base)
 
 	minus = FALSE;
 
-	while (bcm_isspace(*cp))
+	while (isspace(*cp))
 		cp++;
 
 	if (cp[0] == '+')
@@ -565,9 +519,9 @@ unsigned long bcm_strtoul(char *cp, char **endp, uint base)
 
 	result = 0;
 
-	while (bcm_isxdigit(*cp) &&
+	while (isxdigit(*cp) &&
 	       (value =
-		bcm_isdigit(*cp) ? *cp - '0' : bcm_toupper(*cp) - 'A' + 10) <
+		isdigit(*cp) ? *cp - '0' : toupper(*cp) - 'A' + 10) <
 	       base) {
 		result = result * base + value;
 		/* Detected overflow */
@@ -1796,7 +1750,7 @@ int bcm_format_ssid(char *buf, const unsigned char ssid[], uint ssid_len)
 		if (c == '\\') {
 			*p++ = '\\';
 			*p++ = '\\';
-		} else if (bcm_isprint((unsigned char) c)) {
+		} else if (isprint((unsigned char) c)) {
 			*p++ = (char)c;
 		} else {
 			p += snprintf(p, (endp - p), "\\x%02X", c);
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index cca4fd7..3416597 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -58,7 +58,6 @@ typedef struct wl_iw_extra_params {
 #define	WL_IW_RSSI_EXCELLENT	-57
 #define	WL_IW_RSSI_INVALID	 0
 #define MAX_WX_STRING 80
-#define isprint(c) bcm_isprint(c)
 #define WL_IW_SET_ACTIVE_SCAN	(SIOCIWFIRSTPRIV+1)
 #define WL_IW_GET_RSSI			(SIOCIWFIRSTPRIV+3)
 #define WL_IW_SET_PASSIVE_SCAN	(SIOCIWFIRSTPRIV+5)
diff --git a/drivers/staging/brcm80211/include/bcmutils.h b/drivers/staging/brcm80211/include/bcmutils.h
index 7dd9210..d0960b7 100644
--- a/drivers/staging/brcm80211/include/bcmutils.h
+++ b/drivers/staging/brcm80211/include/bcmutils.h
@@ -21,36 +21,6 @@
 extern "C" {
 #endif
 
-#ifdef BRCM_FULLMAC
-/* ctype replacement */
-#define _BCM_U	0x01		/* upper */
-#define _BCM_L	0x02		/* lower */
-#define _BCM_D	0x04		/* digit */
-#define _BCM_C	0x08		/* cntrl */
-#define _BCM_P	0x10		/* punct */
-#define _BCM_S	0x20		/* white space (space/lf/tab) */
-#define _BCM_X	0x40		/* hex digit */
-#define _BCM_SP	0x80		/* hard space (0x20) */
-
-	extern const unsigned char bcm_ctype[];
-#define bcm_ismask(x)	(bcm_ctype[(int)(unsigned char)(x)])
-
-#define bcm_isalnum(c)	((bcm_ismask(c)&(_BCM_U|_BCM_L|_BCM_D)) != 0)
-#define bcm_isalpha(c)	((bcm_ismask(c)&(_BCM_U|_BCM_L)) != 0)
-#define bcm_iscntrl(c)	((bcm_ismask(c)&(_BCM_C)) != 0)
-#define bcm_isdigit(c)	((bcm_ismask(c)&(_BCM_D)) != 0)
-#define bcm_isgraph(c)	((bcm_ismask(c)&(_BCM_P|_BCM_U|_BCM_L|_BCM_D)) != 0)
-#define bcm_islower(c)	((bcm_ismask(c)&(_BCM_L)) != 0)
-#define bcm_isprint(c)	\
-	((bcm_ismask(c)&(_BCM_P|_BCM_U|_BCM_L|_BCM_D|_BCM_SP)) != 0)
-#define bcm_ispunct(c)	((bcm_ismask(c)&(_BCM_P)) != 0)
-#define bcm_isspace(c)	((bcm_ismask(c)&(_BCM_S)) != 0)
-#define bcm_isupper(c)	((bcm_ismask(c)&(_BCM_U)) != 0)
-#define bcm_isxdigit(c)	((bcm_ismask(c)&(_BCM_D|_BCM_X)) != 0)
-#define bcm_tolower(c)	(bcm_isupper((c)) ? ((c) + 'a' - 'A') : (c))
-#define bcm_toupper(c)	(bcm_islower((c)) ? ((c) + 'A' - 'a') : (c))
-#endif /* BRCM_FULLMAC */
-
 /* Buffer structure for collecting string-formatted data
 * using bcm_bprintf() API.
 * Use bcm_binit() to initialize before use
-- 
1.7.2.3

