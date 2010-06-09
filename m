Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757705Ab0FIPqT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 11:46:19 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:56938 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab0FIPqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 11:46:16 -0400
X-MXL-Hash: 4c0fb748085a6b6b-4ab084405278ac59b04b834a0a3f0f68a9d17134
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>
CC: Greg KH <gregkh@suse.de>
Date: Wed, 9 Jun 2010 10:45:43 -0500
Subject: [PATCH] Staging: rtl8192e/ieee80211: remove kernel version
 compatibility wrappers
Thread-Topic: [PATCH] Staging: rtl8192e/ieee80211: remove kernel version
 compatibility wrappers
Thread-Index: AcsH6tHPolJwGIVSQJWLyvA52j/mCw==
Message-ID: <0D753D10438DA54287A00B02708426976370DCE440@AUSP01VMBX24.collaborationhost.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010052801)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [(unknown)]
X-AnalysisOut: [v=1.0 c=1 a=DXQ3UbbhBKEA:10 a=UBIxAjGgU1YA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=MfCJKx98tC58LqYwCYfhJw==:17 a=i0]
X-AnalysisOut: [0gxMtYAAAA:8 a=9Xc12ASM8xBtLh3b09oA:9 a=Z5vfbTSggNMzBK6ls_]
X-AnalysisOut: [QA:7 a=oLyGlzyRqZ5cpKLV7yl75NHDUaQA:4 a=QEXdDO2ut3YA:10 a=]
X-AnalysisOut: [x1WnkoZAwusA:10 a=0kPLrQdw3YYA:10 a=h4sKLe1zKo3LJFhV:21 a=]
X-AnalysisOut: [6aCYwqyTpDX3QNL7:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o59FkVim014380

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>

---

 drivers/staging/rtl8192e/ieee80211/dot11d.c        |   10 -
 drivers/staging/rtl8192e/ieee80211/ieee80211.h     |  116 -----------
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.c   |   10 -
 .../staging/rtl8192e/ieee80211/ieee80211_crypt.h   |    7 -
 .../rtl8192e/ieee80211/ieee80211_crypt_ccmp.c      |   47 +-----
 .../rtl8192e/ieee80211/ieee80211_crypt_tkip.c      |  203 +-------------------
 .../rtl8192e/ieee80211/ieee80211_crypt_wep.c       |   87 +--------
 .../staging/rtl8192e/ieee80211/ieee80211_module.c  |   44 -----
 drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c  |    9 -
 .../staging/rtl8192e/ieee80211/ieee80211_softmac.c |  159 +---------------
 .../rtl8192e/ieee80211/ieee80211_softmac_wx.c      |   43 ----
 drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c  |    8 -
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c  |  106 ----------
 .../staging/rtl8192e/ieee80211/rtl819x_HTProc.c    |    9 -
 14 files changed, 15 insertions(+), 843 deletions(-)

diff --git a/drivers/staging/rtl8192e/ieee80211/dot11d.c b/drivers/staging/rtl8192e/ieee80211/dot11d.c
index 908f605..b9fdd2a 100644
--- a/drivers/staging/rtl8192e/ieee80211/dot11d.c
+++ b/drivers/staging/rtl8192e/ieee80211/dot11d.c
@@ -218,7 +218,6 @@ int ToLegalChannel(

        return default_chn;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(Dot11d_Init);
 //EXPORT_SYMBOL(Dot11d_Reset);
 //EXPORT_SYMBOL(Dot11d_UpdateCountryIe);
@@ -226,14 +225,5 @@ int ToLegalChannel(
 //EXPORT_SYMBOL(DOT11D_ScanComplete);
 //EXPORT_SYMBOL(IsLegalChannel);
 //EXPORT_SYMBOL(ToLegalChannel);
-#else
-EXPORT_SYMBOL_NOVERS(Dot11d_Init);
-EXPORT_SYMBOL_NOVERS(Dot11d_Reset);
-EXPORT_SYMBOL_NOVERS(Dot11d_UpdateCountryIe);
-EXPORT_SYMBOL_NOVERS(DOT11D_GetMaxTxPwrInDbm);
-EXPORT_SYMBOL_NOVERS(DOT11D_ScanComplete);
-EXPORT_SYMBOL_NOVERS(IsLegalChannel);
-EXPORT_SYMBOL_NOVERS(ToLegalChannel);
-#endif

 #endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211.h b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
index 50728f6..4795043 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
@@ -27,12 +27,7 @@
 #include <linux/kernel.h>   /* ARRAY_SIZE */
 #include <linux/version.h>
 #include <linux/module.h>
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 #include <linux/jiffies.h>
-#else
-#include <linux/jffs.h>
-#include <linux/tqueue.h>
-#endif
 #include <linux/timer.h>
 #include <linux/sched.h>
 #include <linux/semaphore.h>
@@ -44,12 +39,6 @@
 #include "rtl819x_BA.h"
 #include "rtl819x_TS.h"

-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20))
-#ifndef bool
-typedef enum{false = 0, true} bool;
-#endif
-#endif
-
 #ifndef IW_MODE_MONITOR
 #define IW_MODE_MONITOR 6
 #endif
@@ -58,25 +47,6 @@ typedef enum{false = 0, true} bool;
 #define IWEVCUSTOM 0x8c02
 #endif

-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#ifndef __bitwise
-#define __bitwise __attribute__((bitwise))
-#endif
-typedef __u16  __le16;
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,27))
-struct iw_spy_data{
-       /* --- Standard spy support --- */
-       int                     spy_number;
-       u_char                  spy_address[IW_MAX_SPY][ETH_ALEN];
-       struct iw_quality       spy_stat[IW_MAX_SPY];
-       /* --- Enhanced spy support (event) */
-       struct iw_quality       spy_thr_low; /* Low threshold */
-       struct iw_quality       spy_thr_high; /* High threshold */
-       u_char                  spy_thr_under[IW_MAX_SPY];
-};
-#endif
-#endif
-
 #ifndef container_of
 /**
  * container_of - cast a member of a structure out to the containing structure
@@ -428,46 +398,8 @@ typedef struct ieee_param {
 #define IW_QUAL_NOISE_UPDATED  0x4
 #endif

-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static inline void tq_init(struct tq_struct * task, void(*func)(void *), void *data)
-{
-       task->routine = func;
-       task->data      = data;
-       //task->next = NULL;
-       INIT_LIST_HEAD(&task->list);
-       task->sync = 0;
-}
-#endif
-
-// linux under 2.6.9 release may not support it, so modify it for common use
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,6,9))
-//#define MSECS(t)     (1000 * ((t) / HZ) + 1000 * ((t) % HZ) / HZ)
-#define MSECS(t)       (HZ * ((t) / 1000) + (HZ * ((t) % 1000)) / 1000)
-static inline unsigned long msleep_interruptible_rsl(unsigned int msecs)
-{
-         unsigned long timeout = MSECS(msecs) + 1;
-
-         while (timeout) {
-                 set_current_state(TASK_INTERRUPTIBLE);
-                 timeout = schedule_timeout(timeout);
-         }
-         return timeout;
-}
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,31))
-static inline void msleep(unsigned int msecs)
-{
-         unsigned long timeout = MSECS(msecs) + 1;
-
-         while (timeout) {
-                 set_current_state(TASK_UNINTERRUPTIBLE);
-                 timeout = schedule_timeout(timeout);
-         }
-}
-#endif
-#else
 #define MSECS(t) msecs_to_jiffies(t)
 #define msleep_interruptible_rsl  msleep_interruptible
-#endif

 #define IEEE80211_DATA_LEN             2304
 /* Maximum size for the MA-UNITDATA primitive, 802.11 standard section
@@ -1747,21 +1679,6 @@ enum ieee80211_state {
 #define IEEE80211_52GHZ_CHANNELS (IEEE80211_52GHZ_MAX_CHANNEL - \
                                   IEEE80211_52GHZ_MIN_CHANNEL + 1)

-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,11))
-extern inline int is_multicast_ether_addr(const u8 *addr)
-{
-        return ((addr[0] != 0xff) && (0x01 & addr[0]));
-}
-#endif
-
-#if (LINUX_VERSION_CODE <= KERNEL_VERSION(2,6,13))
-extern inline int is_broadcast_ether_addr(const u8 *addr)
-{
-       return ((addr[0] == 0xff) && (addr[1] == 0xff) && (addr[2] == 0xff) &&   \
-               (addr[3] == 0xff) && (addr[4] == 0xff) && (addr[5] == 0xff));
-}
-#endif
-
 typedef struct tx_pending_t{
        int frag;
        struct ieee80211_txb *txb;
@@ -1838,11 +1755,7 @@ typedef struct _RT_POWER_SAVE_CONTROL
        bool                            bIPSModeBackup;
        bool                            bSwRfProcessing;
        RT_RF_POWER_STATE       eInactivePowerState;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        struct work_struct      InactivePsWorkItem;
-#else
-       struct tq_struct        InactivePsWorkItem;
-#endif
        struct timer_list       InactivePsTimer;

        // Return point for join action
@@ -2329,36 +2242,16 @@ struct ieee80211_device {

        /* used if IEEE_SOFTMAC_BEACONS is set */
        struct timer_list beacon_timer;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
         struct work_struct associate_complete_wq;
         struct work_struct associate_procedure_wq;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
         struct delayed_work softmac_scan_wq;
         struct delayed_work associate_retry_wq;
         struct delayed_work start_ibss_wq;
         struct delayed_work hw_wakeup_wq;
        struct delayed_work hw_sleep_wq;
-#else
-        struct work_struct softmac_scan_wq;
-        struct work_struct associate_retry_wq;
-       struct work_struct start_ibss_wq;
-       struct work_struct hw_wakeup_wq;
-       struct work_struct hw_sleep_wq;
-#endif
         struct work_struct wx_sync_scan_wq;
         struct workqueue_struct *wq;
-#else
-       /* used for periodly scan */
-       struct timer_list scan_timer;

-       struct tq_struct associate_complete_wq;
-       struct tq_struct associate_retry_wq;
-       struct tq_struct start_ibss_wq;
-       struct tq_struct associate_procedure_wq;
-       struct tq_struct softmac_scan_wq;
-       struct tq_struct wx_sync_scan_wq;
-
-#endif
         // Qos related. Added by Annie, 2005-11-01.
         //STA_QOS  StaQos;

@@ -2557,11 +2450,7 @@ struct ieee80211_device {

 static inline void *ieee80211_priv(struct net_device *dev)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        return ((struct ieee80211_device *)netdev_priv(dev))->priv;
-#else
-       return ((struct ieee80211_device *)dev->priv)->priv;
-#endif
 }

 extern inline int ieee80211_is_empty_essid(const char *essid, int essid_len)
@@ -2814,12 +2703,7 @@ extern int ieee80211_wx_get_freq(struct ieee80211_device *ieee, struct iw_reques
                             union iwreq_data *wrqu, char *b);

 //extern void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 extern void ieee80211_wx_sync_scan_wq(struct work_struct *work);
-#else
- extern void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee);
-#endif
-

 extern int ieee80211_wx_set_rawtx(struct ieee80211_device *ieee,
                               struct iw_request_info *info,
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
index d5aa9af..996d39d 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
@@ -243,7 +243,6 @@ void ieee80211_crypto_deinit(void)
        kfree(hcrypt);
 }

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_crypt_deinit_entries);
 //EXPORT_SYMBOL(ieee80211_crypt_deinit_handler);
 //EXPORT_SYMBOL(ieee80211_crypt_delayed_deinit);
@@ -251,15 +250,6 @@ void ieee80211_crypto_deinit(void)
 //EXPORT_SYMBOL(ieee80211_register_crypto_ops);
 //EXPORT_SYMBOL(ieee80211_unregister_crypto_ops);
 //EXPORT_SYMBOL(ieee80211_get_crypto_ops);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_deinit_entries);
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_deinit_handler);
-EXPORT_SYMBOL_NOVERS(ieee80211_crypt_delayed_deinit);
-
-EXPORT_SYMBOL_NOVERS(ieee80211_register_crypto_ops);
-EXPORT_SYMBOL_NOVERS(ieee80211_unregister_crypto_ops);
-EXPORT_SYMBOL_NOVERS(ieee80211_get_crypto_ops);
-#endif

 //module_init(ieee80211_crypto_init);
 //module_exit(ieee80211_crypto_deinit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
index a84df4b..b58a3bc 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.h
@@ -82,12 +82,5 @@ void ieee80211_crypt_deinit_entries(struct ieee80211_device *, int);
 void ieee80211_crypt_deinit_handler(unsigned long);
 void ieee80211_crypt_delayed_deinit(struct ieee80211_device *ieee,
                                    struct ieee80211_crypt_data **crypt);
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#define offset_in_page(p) ((unsigned long)(p) & ~PAGE_MASK)
-#endif
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,4,31))
-#define crypto_alloc_tfm crypto_alloc_tfm_rsl
-#define crypto_free_tfm crypto_free_tfm_rsl
-#endif

 #endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
index 7165c4c..b85ebfa 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
@@ -24,17 +24,8 @@

 #include "ieee80211.h"

-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
-    #include <linux/scatterlist.h>
-#endif
+#include <linux/scatterlist.h>
 //#include <asm/scatterlist.h>

 MODULE_AUTHOR("Jouni Malinen");
@@ -75,21 +66,7 @@ struct ieee80211_ccmp_data {
 void ieee80211_ccmp_aes_encrypt(struct crypto_tfm *tfm,
                             const u8 pt[16], u8 ct[16])
 {
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       struct scatterlist src, dst;
-
-       src.page = virt_to_page(pt);
-       src.offset = offset_in_page(pt);
-       src.length = AES_BLOCK_LEN;
-
-       dst.page = virt_to_page(ct);
-       dst.offset = offset_in_page(ct);
-       dst.length = AES_BLOCK_LEN;
-
-       crypto_cipher_encrypt(tfm, &dst, &src, AES_BLOCK_LEN);
-#else
        crypto_cipher_encrypt_one((void*)tfm, ct, pt);
-#endif
 }

 static void * ieee80211_ccmp_init(int key_idx)
@@ -101,14 +78,6 @@ static void * ieee80211_ccmp_init(int key_idx)
                goto fail;
        priv->key_idx = key_idx;

-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       priv->tfm = crypto_alloc_tfm("aes", 0);
-       if (priv->tfm == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
-                      "crypto API aes\n");
-               goto fail;
-       }
-       #else
        priv->tfm = (void*)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
        if (IS_ERR(priv->tfm)) {
                printk(KERN_DEBUG "ieee80211_crypt_ccmp: could not allocate "
@@ -116,17 +85,13 @@ static void * ieee80211_ccmp_init(int key_idx)
                priv->tfm = NULL;
                goto fail;
        }
-       #endif
+
        return priv;

 fail:
        if (priv) {
                if (priv->tfm)
-                       #if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
-                       crypto_free_tfm(priv->tfm);
-                    #else
                        crypto_free_cipher((void*)priv->tfm);
-                     #endif
                kfree(priv);
        }

@@ -138,11 +103,7 @@ static void ieee80211_ccmp_deinit(void *priv)
 {
        struct ieee80211_ccmp_data *_priv = priv;
        if (_priv && _priv->tfm)
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21))
-               crypto_free_tfm(_priv->tfm);
-#else
                crypto_free_cipher((void*)_priv->tfm);
-#endif
        kfree(priv);
 }

@@ -528,11 +489,7 @@ void ieee80211_crypto_ccmp_exit(void)
        ieee80211_unregister_crypto_ops(&ieee80211_crypt_ccmp);
 }

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_ccmp_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_ccmp_null);
-#endif

 //module_init(ieee80211_crypto_ccmp_init);
 //module_exit(ieee80211_crypto_ccmp_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
index 65f4889..96d2bf6 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
@@ -24,18 +24,9 @@
 #include "ieee80211.h"


-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
 //#include <asm/scatterlist.h>
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
-        #include <linux/scatterlist.h>
-#endif
-
+#include <linux/scatterlist.h>
 #include <linux/crc32.h>

 MODULE_AUTHOR("Jouni Malinen");
@@ -68,17 +59,11 @@ struct ieee80211_tkip_data {
        u32 dot11RSNAStatsTKIPLocalMICFailures;

        int key_idx;
-#if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
        struct crypto_blkcipher *rx_tfm_arc4;
        struct crypto_hash *rx_tfm_michael;
        struct crypto_blkcipher *tx_tfm_arc4;
        struct crypto_hash *tx_tfm_michael;
-#else
-       struct crypto_tfm *tx_tfm_arc4;
-       struct crypto_tfm *tx_tfm_michael;
-       struct crypto_tfm *rx_tfm_arc4;
-       struct crypto_tfm *rx_tfm_michael;
-#endif
+
        /* scratch buffers for virt_to_page() (crypto API) */
        u8 rx_hdr[16], tx_hdr[16];
 };
@@ -91,35 +76,6 @@ static void * ieee80211_tkip_init(int key_idx)
        if (priv == NULL)
                goto fail;
        priv->key_idx = key_idx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       priv->tx_tfm_arc4 = crypto_alloc_tfm("arc4", 0);
-       if (priv->tx_tfm_arc4 == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-                               "crypto API arc4\n");
-               goto fail;
-       }
-
-       priv->tx_tfm_michael = crypto_alloc_tfm("michael_mic", 0);
-       if (priv->tx_tfm_michael == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-                               "crypto API michael_mic\n");
-               goto fail;
-       }
-
-       priv->rx_tfm_arc4 = crypto_alloc_tfm("arc4", 0);
-       if (priv->rx_tfm_arc4 == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-                               "crypto API arc4\n");
-               goto fail;
-       }
-
-       priv->rx_tfm_michael = crypto_alloc_tfm("michael_mic", 0);
-       if (priv->rx_tfm_michael == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_tkip: could not allocate "
-                               "crypto API michael_mic\n");
-               goto fail;
-       }
-#else
        priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
                        CRYPTO_ALG_ASYNC);
        if (IS_ERR(priv->tx_tfm_arc4)) {
@@ -155,22 +111,11 @@ static void * ieee80211_tkip_init(int key_idx)
                priv->rx_tfm_michael = NULL;
                goto fail;
        }
-#endif
+
        return priv;

 fail:
        if (priv) {
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               if (priv->tx_tfm_michael)
-                       crypto_free_tfm(priv->tx_tfm_michael);
-               if (priv->tx_tfm_arc4)
-                       crypto_free_tfm(priv->tx_tfm_arc4);
-               if (priv->rx_tfm_michael)
-                       crypto_free_tfm(priv->rx_tfm_michael);
-               if (priv->rx_tfm_arc4)
-                       crypto_free_tfm(priv->rx_tfm_arc4);
-
-#else
                if (priv->tx_tfm_michael)
                        crypto_free_hash(priv->tx_tfm_michael);
                if (priv->tx_tfm_arc4)
@@ -179,7 +124,6 @@ fail:
                        crypto_free_hash(priv->rx_tfm_michael);
                if (priv->rx_tfm_arc4)
                        crypto_free_blkcipher(priv->rx_tfm_arc4);
-#endif
                kfree(priv);
        }

@@ -190,16 +134,7 @@ fail:
 static void ieee80211_tkip_deinit(void *priv)
 {
        struct ieee80211_tkip_data *_priv = priv;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       if (_priv->tx_tfm_michael)
-               crypto_free_tfm(_priv->tx_tfm_michael);
-       if (_priv->tx_tfm_arc4)
-               crypto_free_tfm(_priv->tx_tfm_arc4);
-       if (_priv->rx_tfm_michael)
-               crypto_free_tfm(_priv->rx_tfm_michael);
-       if (_priv->rx_tfm_arc4)
-               crypto_free_tfm(_priv->rx_tfm_arc4);
-#else
+
        if (_priv) {
                if (_priv->tx_tfm_michael)
                        crypto_free_hash(_priv->tx_tfm_michael);
@@ -210,7 +145,6 @@ static void ieee80211_tkip_deinit(void *priv)
                if (_priv->rx_tfm_arc4)
                        crypto_free_blkcipher(_priv->rx_tfm_arc4);
        }
-#endif
        kfree(priv);
 }

@@ -381,10 +315,8 @@ static int ieee80211_tkip_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
        struct ieee80211_hdr_4addr *hdr;
        cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);

-       #if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
        struct blkcipher_desc desc = {.tfm = tkey->tx_tfm_arc4};
        int ret = 0;
-       #endif
        u8 rc4key[16],  *icv;
        u32 crc;
        struct scatterlist sg;
@@ -447,33 +379,14 @@ printk("%x\n", ((u32*)tkey->key)[7]);
        if (!tcb_desc->bHwSec)
        {
                icv = skb_put(skb, 4);
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
                crc = ~crc32_le(~0, pos, len);
-#else
-               crc = ~ether_crc_le(len, pos);
-#endif
                icv[0] = crc;
                icv[1] = crc >> 8;
                icv[2] = crc >> 16;
                icv[3] = crc >> 24;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               crypto_cipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = len + 4;
-               crypto_cipher_encrypt(tkey->tx_tfm_arc4, &sg, &sg, len + 4);
-#else
                crypto_blkcipher_setkey(tkey->tx_tfm_arc4, rc4key, 16);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = len + 4;
-#else
                sg_init_one(&sg, pos, len+4);
-#endif
                ret= crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
-#endif
-
        }

        tkey->tx_iv16++;
@@ -483,15 +396,9 @@ printk("%x\n", ((u32*)tkey->key)[7]);
        }

        if (!tcb_desc->bHwSec)
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               return 0;
-       #else
                return ret;
-       #endif
        else
                return 0;
-
-
 }

 static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
@@ -502,9 +409,7 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
        u16 iv16;
        struct ieee80211_hdr_4addr *hdr;
        cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-       #if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
        struct blkcipher_desc desc = {.tfm = tkey->rx_tfm_arc4};
-       #endif
        u8 rc4key[16];
        u8 icv[4];
        u32 crc;
@@ -563,21 +468,9 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)

                plen = skb->len - hdr_len - 12;

-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               crypto_cipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = plen + 4;
-               crypto_cipher_decrypt(tkey->rx_tfm_arc4, &sg, &sg, plen + 4);
-#else
                crypto_blkcipher_setkey(tkey->rx_tfm_arc4, rc4key, 16);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = plen + 4;
-#else
                sg_init_one(&sg, pos, plen+4);
-#endif
+
                if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4)) {
                        if (net_ratelimit()) {
                                printk(KERN_DEBUG ": TKIP: failed to decrypt "
@@ -586,13 +479,8 @@ static int ieee80211_tkip_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
                        }
                        return -7;
                }
-#endif

-       #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
                crc = ~crc32_le(~0, pos, plen);
-       #else
-               crc = ~ether_crc_le(plen, pos);
-       #endif
                icv[0] = crc;
                icv[1] = crc >> 8;
                icv[2] = crc >> 16;
@@ -641,47 +529,6 @@ if( ((u16*)skb->data)[0] & 0x4000){
 }


-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-static int michael_mic(struct crypto_tfm * tfm_michael, u8 *key, u8 *hdr,
-                      u8 *data, size_t data_len, u8 *mic)
-{
-       struct scatterlist sg[2];
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
-        struct hash_desc desc;
-        int ret = 0;
-#endif
-
-       if (tfm_michael == NULL){
-               printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
-               return -1;
-       }
-       sg[0].page = virt_to_page(hdr);
-       sg[0].offset = offset_in_page(hdr);
-       sg[0].length = 16;
-
-       sg[1].page = virt_to_page(data);
-       sg[1].offset = offset_in_page(data);
-       sg[1].length = data_len;
-
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-       crypto_digest_init(tfm_michael);
-        crypto_digest_setkey(tfm_michael, key, 8);
-        crypto_digest_update(tfm_michael, sg, 2);
-        crypto_digest_final(tfm_michael, mic);
-        return 0;
-#else
-if (crypto_hash_setkey(tkey->tfm_michael, key, 8))
-                return -1;
-
-//      return 0;
-              desc.tfm = tkey->tfm_michael;
-              desc.flags = 0;
-              ret = crypto_hash_digest(&desc, sg, data_len + 16, mic);
-              return ret;
-#endif
-}
-#else
 static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
                        u8 * data, size_t data_len, u8 * mic)
 {
@@ -692,19 +539,10 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
                 printk(KERN_WARNING "michael_mic: tfm_michael == NULL\n");
                 return -1;
         }
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24)
-        sg[0].page = virt_to_page(hdr);
-        sg[0].offset = offset_in_page(hdr);
-        sg[0].length = 16;
-
-        sg[1].page = virt_to_page(data);
-        sg[1].offset = offset_in_page(data);
-        sg[1].length = data_len;
-#else
+
         sg_init_table(sg, 2);
         sg_set_buf(&sg[0], hdr, 16);
         sg_set_buf(&sg[1], data, data_len);
-#endif

         if (crypto_hash_setkey(tfm_michael, key, 8))
                 return -1;
@@ -713,7 +551,6 @@ static int michael_mic(struct crypto_hash *tfm_michael, u8 * key, u8 * hdr,
         desc.flags = 0;
         return crypto_hash_digest(&desc, sg, data_len + 16, mic);
 }
-#endif



@@ -772,13 +609,8 @@ static int ieee80211_michael_mic_add(struct sk_buff *skb, int hdr_len, void *pri
        }
        // }
        pos = skb_put(skb, 8);
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
        if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
                                skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
-#else
-       if (michael_mic(tkey->tx_tfm_michael, &tkey->key[16], tkey->tx_hdr,
-                               skb->data + hdr_len, skb->len - 8 - hdr_len, pos))
-#endif
                return -1;

        return 0;
@@ -850,13 +682,8 @@ static int ieee80211_michael_mic_verify(struct sk_buff *skb, int keyidx,
        }
        // }

-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
-                               skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
-#else
        if (michael_mic(tkey->rx_tfm_michael, &tkey->key[24], tkey->rx_hdr,
                                skb->data + hdr_len, skb->len - 8 - hdr_len, mic))
-#endif
                return -1;
        if (memcmp(mic, skb->data + skb->len - 8, 8) != 0) {
                struct ieee80211_hdr_4addr *hdr;
@@ -886,32 +713,18 @@ static int ieee80211_tkip_set_key(void *key, int len, u8 *seq, void *priv)
 {
        struct ieee80211_tkip_data *tkey = priv;
        int keyidx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       struct crypto_tfm *tfm = tkey->tx_tfm_michael;
-       struct crypto_tfm *tfm2 = tkey->tx_tfm_arc4;
-       struct crypto_tfm *tfm3 = tkey->rx_tfm_michael;
-       struct crypto_tfm *tfm4 = tkey->rx_tfm_arc4;
-#else
        struct crypto_hash *tfm = tkey->tx_tfm_michael;
        struct crypto_blkcipher *tfm2 = tkey->tx_tfm_arc4;
        struct crypto_hash *tfm3 = tkey->rx_tfm_michael;
        struct crypto_blkcipher *tfm4 = tkey->rx_tfm_arc4;
-#endif

        keyidx = tkey->key_idx;
        memset(tkey, 0, sizeof(*tkey));
        tkey->key_idx = keyidx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       tkey->tx_tfm_michael = tfm;
-       tkey->tx_tfm_arc4 = tfm2;
-       tkey->rx_tfm_michael = tfm3;
-       tkey->rx_tfm_arc4 = tfm4;
-#else
        tkey->tx_tfm_michael = tfm;
        tkey->tx_tfm_arc4 = tfm2;
        tkey->rx_tfm_michael = tfm3;
        tkey->rx_tfm_arc4 = tfm4;
-#endif

        if (len == TKIP_KEY_LEN) {
                memcpy(tkey->key, key, TKIP_KEY_LEN);
@@ -1021,11 +834,7 @@ void ieee80211_tkip_null(void)
 //    printk("============>%s()\n", __FUNCTION__);
         return;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_tkip_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_tkip_null);
-#endif

 //module_init(ieee80211_crypto_tkip_init);
 //module_exit(ieee80211_crypto_tkip_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
index c4bbc8d..af4f1a2 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -21,26 +21,13 @@
 #include "ieee80211.h"


-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif
-
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,20)
-    #include <asm/scatterlist.h>
-#else
-    #include <linux/scatterlist.h>
-#endif
+#include <linux/scatterlist.h>
 //#include <asm/scatterlist.h>
 #include <linux/crc32.h>
 //
 /*
-#if (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-#include "rtl_crypto.h"
-#else
 #include <linux/crypto.h>
-#endif

 #include <asm/scatterlist.h>
 #include <linux/crc32.h>
@@ -58,12 +45,8 @@ struct prism2_wep_data {
        u8 key[WEP_KEY_LEN + 1];
        u8 key_len;
        u8 key_idx;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       struct crypto_tfm *tfm;
-       #else
         struct crypto_blkcipher *tx_tfm;
         struct crypto_blkcipher *rx_tfm;
-        #endif
 };


@@ -76,14 +59,6 @@ static void * prism2_wep_init(int keyidx)
                goto fail;
        priv->key_idx = keyidx;

-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       priv->tfm = crypto_alloc_tfm("arc4", 0);
-       if (priv->tfm == NULL) {
-               printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
-                      "crypto API arc4\n");
-               goto fail;
-       }
-       #else
        priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
         if (IS_ERR(priv->tx_tfm)) {
                 printk(KERN_DEBUG "ieee80211_crypt_wep: could not allocate "
@@ -98,7 +73,6 @@ static void * prism2_wep_init(int keyidx)
                 priv->rx_tfm = NULL;
                 goto fail;
         }
-        #endif

        /* start WEP IV from a random value */
        get_random_bytes(&priv->iv, 4);
@@ -106,13 +80,6 @@ static void * prism2_wep_init(int keyidx)
        return priv;

 fail:
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       if (priv) {
-               if (priv->tfm)
-                       crypto_free_tfm(priv->tfm);
-               kfree(priv);
-       }
-       #else
        if (priv) {
                 if (priv->tx_tfm)
                         crypto_free_blkcipher(priv->tx_tfm);
@@ -120,7 +87,6 @@ fail:
                         crypto_free_blkcipher(priv->rx_tfm);
                 kfree(priv);
         }
-        #endif
        return NULL;
 }

@@ -128,17 +94,13 @@ fail:
 static void prism2_wep_deinit(void *priv)
 {
        struct prism2_wep_data *_priv = priv;
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-       if (_priv && _priv->tfm)
-               crypto_free_tfm(_priv->tfm);
-       #else
+
        if (_priv) {
                 if (_priv->tx_tfm)
                         crypto_free_blkcipher(_priv->tx_tfm);
                 if (_priv->rx_tfm)
                         crypto_free_blkcipher(_priv->rx_tfm);
         }
-        #endif
        kfree(priv);
 }

@@ -155,9 +117,7 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
        u8 key[WEP_KEY_LEN + 3];
        u8 *pos;
        cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-       #if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
        struct blkcipher_desc desc = {.tfm = wep->tx_tfm};
-       #endif
        u32 crc;
        u8 *icv;
        struct scatterlist sg;
@@ -196,35 +156,16 @@ static int prism2_wep_encrypt(struct sk_buff *skb, int hdr_len, void *priv)
        {

                /* Append little-endian CRC32 and encrypt it to produce ICV */
-       #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
                crc = ~crc32_le(~0, pos, len);
-       #else
-               crc = ~ether_crc_le(len, pos);
-       #endif
                icv = skb_put(skb, 4);
                icv[0] = crc;
                icv[1] = crc >> 8;
                icv[2] = crc >> 16;
                icv[3] = crc >> 24;

-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               crypto_cipher_setkey(wep->tfm, key, klen);
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = len + 4;
-               crypto_cipher_encrypt(wep->tfm, &sg, &sg, len + 4);
-               return 0;
-       #else
                crypto_blkcipher_setkey(wep->tx_tfm, key, klen);
-       #if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = len + 4;
-       #else
                sg_init_one(&sg, pos, len+4);
-       #endif
                return crypto_blkcipher_encrypt(&desc, &sg, &sg, len + 4);
-       #endif
        }

        return 0;
@@ -245,9 +186,7 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)
        u8 key[WEP_KEY_LEN + 3];
        u8 keyidx, *pos;
        cb_desc *tcb_desc = (cb_desc *)(skb->cb + MAX_DEV_ADDR_SIZE);
-       #if((LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,21)) || (OPENSUSE_SLED))
        struct blkcipher_desc desc = {.tfm = wep->rx_tfm};
-       #endif
        u32 crc;
        u8 icv[4];
        struct scatterlist sg;
@@ -272,29 +211,11 @@ static int prism2_wep_decrypt(struct sk_buff *skb, int hdr_len, void *priv)

        if (!tcb_desc->bHwSec)
        {
-#if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
-               crypto_cipher_setkey(wep->tfm, key, klen);
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = plen + 4;
-               crypto_cipher_decrypt(wep->tfm, &sg, &sg, plen + 4);
-       #else
                crypto_blkcipher_setkey(wep->rx_tfm, key, klen);
-       #if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               sg.page = virt_to_page(pos);
-               sg.offset = offset_in_page(pos);
-               sg.length = plen + 4;
-       #else
                sg_init_one(&sg, pos, plen+4);
-       #endif
                if (crypto_blkcipher_decrypt(&desc, &sg, &sg, plen + 4))
                        return -7;
-       #endif
-       #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
                crc = ~crc32_le(~0, pos, plen);
-       #else
-               crc = ~ether_crc_le(plen, pos);
-       #endif
                icv[0] = crc;
                icv[1] = crc >> 8;
                icv[2] = crc >> 16;
@@ -382,11 +303,7 @@ void ieee80211_wep_null(void)
 //     printk("============>%s()\n", __FUNCTION__);
         return;
 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_wep_null);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_wep_null);
-#endif

 //module_init(ieee80211_crypto_wep_init);
 //module_exit(ieee80211_crypto_wep_exit);
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
index 614a8b6..9609314 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -110,11 +110,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
                goto failed;
        }

-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
        ieee = netdev_priv(dev);
-#else
-       ieee = (struct ieee80211_device *)dev->priv;
-#endif
 #if 0
        dev->hard_start_xmit = ieee80211_rtl_xmit;
 #endif
@@ -166,12 +162,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)

        ieee80211_softmac_init(ieee);

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,13))
        ieee->pHTInfo = kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
-#else
-       ieee->pHTInfo = (RT_HIGH_THROUGHPUT*)kmalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
-       memset(ieee->pHTInfo,0,sizeof(RT_HIGH_THROUGHPUT));
-#endif
        if (ieee->pHTInfo == NULL)
        {
                IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for HTInfo\n");
@@ -181,11 +172,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
        HTInitializeHTInfo(ieee); //may move to other place.
        TSInitialize(ieee);
 #if 0
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
        INIT_WORK(&ieee->ht_onAssRsp, (void(*)(void*)) HTOnAssocRsp_wq);
-#else
-       INIT_WORK(&ieee->ht_onAssRsp, (void(*)(void*)) HTOnAssocRsp_wq, ieee);
-#endif
 #endif
        for (i = 0; i < IEEE_IBSS_MAC_HASH_SIZE; i++)
                INIT_LIST_HEAD(&ieee->ibss_mac_hash[i]);
@@ -205,22 +192,14 @@ struct net_device *alloc_ieee80211(int sizeof_priv)

  failed:
        if (dev)
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
                free_netdev(dev);
-#else
-               kfree(dev);
-#endif
        return NULL;
 }


 void free_ieee80211(struct net_device *dev)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
        struct ieee80211_device *ieee = netdev_priv(dev);
-#else
-       struct ieee80211_device *ieee = (struct ieee80211_device *)dev->priv;
-#endif
        int i;
        //struct list_head *p, *q;
 //     del_timer_sync(&ieee->SwBwTimer);
@@ -256,11 +235,7 @@ void free_ieee80211(struct net_device *dev)
        }

 #endif
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
        free_netdev(dev);
-#else
-       kfree(dev);
-#endif
 }

 #ifdef CONFIG_IEEE80211_DEBUG
@@ -358,11 +333,7 @@ int __init ieee80211_rtl_init(void)
        }

        ieee80211_debug_level = debug;
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-       ieee80211_proc = create_proc_entry(DRV_NAME, S_IFDIR, proc_net);
-#else
        ieee80211_proc = create_proc_entry(DRV_NAME, S_IFDIR, init_net.proc_net);
-#endif
        if (ieee80211_proc == NULL) {
                IEEE80211_ERROR("Unable to create " DRV_NAME
                                " proc directory\n");
@@ -371,11 +342,7 @@ int __init ieee80211_rtl_init(void)
        e = create_proc_entry("debug_level", S_IFREG | S_IRUGO | S_IWUSR,
                              ieee80211_proc);
        if (!e) {
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               remove_proc_entry(DRV_NAME, proc_net);
-#else
                remove_proc_entry(DRV_NAME, init_net.proc_net);
-#endif
                ieee80211_proc = NULL;
                return -EIO;
        }
@@ -390,11 +357,7 @@ void __exit ieee80211_rtl_exit(void)
 {
        if (ieee80211_proc) {
                remove_proc_entry("debug_level", ieee80211_proc);
-#if(LINUX_VERSION_CODE < KERNEL_VERSION(2,6,24))
-               remove_proc_entry(DRV_NAME, proc_net);
-#else
                remove_proc_entry(DRV_NAME, init_net.proc_net);
-#endif
                ieee80211_proc = NULL;
        }
        ieee80211_crypto_wep_exit();
@@ -403,7 +366,6 @@ void __exit ieee80211_rtl_exit(void)
        ieee80211_crypto_deinit();
 }

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 #include <linux/moduleparam.h>
 module_param(debug, int, 0444);
 MODULE_PARM_DESC(debug, "debug output mask");
@@ -412,12 +374,6 @@ MODULE_PARM_DESC(debug, "debug output mask");
 //module_exit(ieee80211_rtl_exit);
 //module_init(ieee80211_rtl_init);
 #endif
-#endif

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(alloc_ieee80211);
 //EXPORT_SYMBOL(free_ieee80211);
-#else
-EXPORT_SYMBOL_NOVERS(alloc_ieee80211);
-EXPORT_SYMBOL_NOVERS(free_ieee80211);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
index da10067..add5a83 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
@@ -55,11 +55,7 @@ static inline void ieee80211_monitor_rx(struct ieee80211_device *ieee,
        u16 fc = le16_to_cpu(hdr->frame_ctl);

        skb->dev = ieee->dev;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22)
         skb_reset_mac_header(skb);
-#else
-        skb->mac.raw = skb->data;
-#endif

        skb_pull(skb, ieee80211_get_hdrlen(fc));
        skb->pkt_type = PACKET_OTHERHOST;
@@ -2881,10 +2877,5 @@ void ieee80211_rx_mgt(struct ieee80211_device *ieee,
        }
 }

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_rx_mgt);
 //EXPORT_SYMBOL(ieee80211_rx);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_rx_mgt);
-EXPORT_SYMBOL_NOVERS(ieee80211_rx);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
index 46b6e8c..c79e484 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -510,34 +510,10 @@ out:
 }
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-/* called both by wq with ieee->lock held */
-void ieee80211_softmac_scan(struct ieee80211_device *ieee)
-{
-#if 0
-       short watchdog = 0;
-       do{
-               ieee->current_network.channel =
-                       (ieee->current_network.channel + 1) % MAX_CHANNEL_NUMBER;
-               if (watchdog++ > MAX_CHANNEL_NUMBER)
-                               return; /* no good chans */
-
-       }while(!ieee->channel_map[ieee->current_network.channel]);
-#endif
-
-       schedule_task(&ieee->softmac_scan_wq);
-}
-#endif
-
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_softmac_scan_wq(struct work_struct *work)
 {
         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, softmac_scan_wq);
-#else
-void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
-{
-#endif
        static short watchdog = 0;
        u8 last_channel = ieee->current_network.channel;
 #ifdef ENABLE_DOT11D
@@ -575,13 +551,7 @@ void ieee80211_softmac_scan_wq(struct ieee80211_device *ieee)
        ieee80211_send_probe_requests(ieee);


-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, IEEE80211_SOFTMAC_SCAN_TIME);
-#else
-       //ieee->scan_timer.expires = jiffies + MSECS(IEEE80211_SOFTMAC_SCAN_TIME);
-       if (ieee->scanning == 1)
-               mod_timer(&ieee->scan_timer,(jiffies + MSECS(IEEE80211_SOFTMAC_SCAN_TIME)));
-#endif

        up(&ieee->scan_sem);
        return;
@@ -597,18 +567,6 @@ out:
        up(&ieee->scan_sem);
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-void ieee80211_softmac_scan_cb(unsigned long _dev)
-{
-       unsigned long flags;
-       struct ieee80211_device *ieee = (struct ieee80211_device *)_dev;
-
-       spin_lock_irqsave(&ieee->lock, flags);
-       ieee80211_softmac_scan(ieee);
-       spin_unlock_irqrestore(&ieee->lock, flags);
-}
-#endif
-

 void ieee80211_beacons_start(struct ieee80211_device *ieee)
 {
@@ -665,11 +623,7 @@ void ieee80211_softmac_stop_scan(struct ieee80211_device *ieee)
        if (ieee->scanning == 1){
                ieee->scanning = 0;

-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
                cancel_delayed_work(&ieee->softmac_scan_wq);
-#else
-               del_timer_sync(&ieee->scan_timer);
-#endif
        }

 //     spin_unlock_irqrestore(&ieee->lock, flags);
@@ -704,16 +658,7 @@ void ieee80211_rtl_start_scan(struct ieee80211_device *ieee)
        if (ieee->softmac_features & IEEE_SOFTMAC_SCAN){
                if (ieee->scanning == 0){
                        ieee->scanning = 1;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
                        queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, 0);
-#else
-
-                       queue_work(ieee->wq, &ieee->softmac_scan_wq);
-#endif
-#else
-                       ieee80211_softmac_scan(ieee);
-#endif
                }
        }else
                ieee->start_scan(ieee->dev);
@@ -1428,12 +1373,8 @@ void ieee80211_associate_abort(struct ieee80211_device *ieee)

        ieee->state = IEEE80211_ASSOCIATING_RETRY;

-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        queue_delayed_work(ieee->wq, &ieee->associate_retry_wq, \
                            IEEE80211_SOFTMAC_ASSOC_RETRY_TIME);
-#else
-       schedule_task(&ieee->associate_retry_wq);
-#endif

        spin_unlock_irqrestore(&ieee->lock, flags);
 }
@@ -1527,14 +1468,11 @@ void ieee80211_associate_step2(struct ieee80211_device *ieee)
                //dev_kfree_skb_any(skb);//edit by thomas
        }
 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+
 void ieee80211_associate_complete_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_complete_wq);
-#else
-void ieee80211_associate_complete_wq(struct ieee80211_device *ieee)
-{
-#endif
+
        printk(KERN_INFO "Associated successfully\n");
        ieee->is_roaming = false;
        if(ieee80211_is_54g(ieee->current_network) &&
@@ -1606,21 +1544,13 @@ void ieee80211_associate_complete(struct ieee80211_device *ieee)
        }
 #endif
        //ieee->UpdateHalRATRTableHandler(dev, ieee->dot11HTOperationalRateSet);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        queue_work(ieee->wq, &ieee->associate_complete_wq);
-#else
-       schedule_task(&ieee->associate_complete_wq);
-#endif
 }

-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_procedure_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, associate_procedure_wq);
-#else
-void ieee80211_associate_procedure_wq(struct ieee80211_device *ieee)
-{
-#endif
+
        ieee->sync_scan_hurryup = 1;
 #ifdef ENABLE_IPS
        if(ieee->ieee80211_ips_leave != NULL)
@@ -1734,11 +1664,7 @@ inline void ieee80211_softmac_new_net(struct ieee80211_device *ieee, struct ieee
                                        }

                                        ieee->state = IEEE80211_ASSOCIATING;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
                                        queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-                                       schedule_task(&ieee->associate_procedure_wq);
-#endif
                                }else{
                                        if(ieee80211_is_54g(ieee->current_network) &&
                                                (ieee->modulation & IEEE80211_OFDM_MODULATION)){
@@ -2332,11 +2258,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
                                                "Association response status code 0x%x\n",
                                                errcode);
                                        if(ieee->AsocRetryCount < RT_ASOC_RETRY_LIMIT) {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
                                                queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-                                               schedule_task(&ieee->associate_procedure_wq);
-#endif
                                        } else {
                                                ieee80211_associate_abort(ieee);
                                        }
@@ -2446,11 +2368,7 @@ ieee80211_rx_frame_softmac(struct ieee80211_device *ieee, struct sk_buff *skb,
                        //      notify_wx_assoc_event(ieee);
                                //HTSetConnectBwMode(ieee, HT_CHANNEL_WIDTH_20, HT_EXTCHNL_OFFSET_NO_EXT);
                                RemovePeerTS(ieee, header->addr2);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
                                queue_work(ieee->wq, &ieee->associate_procedure_wq);
-#else
-                               schedule_task(&ieee->associate_procedure_wq);
-#endif
                        }
                        break;
                case IEEE80211_STYPE_MANAGE_ACT:
@@ -2687,16 +2605,13 @@ void ieee80211_start_monitor_mode(struct ieee80211_device *ieee)
                netif_carrier_on(ieee->dev);
        }
 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
+
 void ieee80211_start_ibss_wq(struct work_struct *work)
 {

         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, start_ibss_wq);
-#else
-void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)
-{
-#endif
+
        /* iwconfig mode ad-hoc will schedule this and return
         * on the other hand this will block further iwconfig SET
         * operations because of the wx_sem hold.
@@ -2807,11 +2722,7 @@ void ieee80211_start_ibss_wq(struct ieee80211_device *ieee)

 inline void ieee80211_start_ibss(struct ieee80211_device *ieee)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        queue_delayed_work(ieee->wq, &ieee->start_ibss_wq, 150);
-#else
-       schedule_task(&ieee->start_ibss_wq);
-#endif
 }

 /* this is called only in user context, with wx_sem held */
@@ -2880,15 +2791,10 @@ void ieee80211_disassociate(struct ieee80211_device *ieee)
        notify_wx_assoc_event(ieee);

 }
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void ieee80211_associate_retry_wq(struct work_struct *work)
 {
         struct delayed_work *dwork = container_of(work, struct delayed_work, work);
         struct ieee80211_device *ieee = container_of(dwork, struct ieee80211_device, associate_retry_wq);
-#else
-void ieee80211_associate_retry_wq(struct ieee80211_device *ieee)
-{
-#endif
        unsigned long flags;

        down(&ieee->wx_sem);
@@ -2990,10 +2896,8 @@ void ieee80211_stop_protocol(struct ieee80211_device *ieee, u8 shutdown)

        ieee80211_stop_send_beacons(ieee);
        del_timer_sync(&ieee->associate_timer);
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        cancel_delayed_work(&ieee->associate_retry_wq);
        cancel_delayed_work(&ieee->start_ibss_wq);
-#endif
        ieee80211_stop_scan(ieee);

        ieee80211_disassociate(ieee);
@@ -3114,11 +3018,6 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
        ieee->sta_edca_param[3] = 0x002F3262;
        ieee->aggregation = true;
        ieee->enable_rx_imm_BA = 1;
-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-       init_timer(&ieee->scan_timer);
-       ieee->scan_timer.data = (unsigned long)ieee;
-       ieee->scan_timer.function = ieee80211_softmac_scan_cb;
-#endif
        ieee->tx_pending.txb = NULL;

        init_timer(&ieee->associate_timer);
@@ -3129,16 +3028,12 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
        ieee->beacon_timer.data = (unsigned long) ieee;
        ieee->beacon_timer.function = ieee80211_send_beacon_cb;

-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 #ifdef PF_SYNCTHREAD
        ieee->wq = create_workqueue(DRV_NAME,0);
 #else
        ieee->wq = create_workqueue(DRV_NAME);
 #endif
-#endif

-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
         INIT_DELAYED_WORK(&ieee->start_ibss_wq,ieee80211_start_ibss_wq);
         INIT_WORK(&ieee->associate_complete_wq, ieee80211_associate_complete_wq);
         INIT_WORK(&ieee->associate_procedure_wq, ieee80211_associate_procedure_wq);
@@ -3146,23 +3041,6 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
         INIT_DELAYED_WORK(&ieee->associate_retry_wq, ieee80211_associate_retry_wq);
         INIT_WORK(&ieee->wx_sync_scan_wq,ieee80211_wx_sync_scan_wq);

-#else
-       INIT_WORK(&ieee->start_ibss_wq,(void(*)(void*)) ieee80211_start_ibss_wq,ieee);
-       INIT_WORK(&ieee->associate_retry_wq,(void(*)(void*)) ieee80211_associate_retry_wq,ieee);
-       INIT_WORK(&ieee->associate_complete_wq,(void(*)(void*)) ieee80211_associate_complete_wq,ieee);
-       INIT_WORK(&ieee->associate_procedure_wq,(void(*)(void*)) ieee80211_associate_procedure_wq,ieee);
-       INIT_WORK(&ieee->softmac_scan_wq,(void(*)(void*)) ieee80211_softmac_scan_wq,ieee);
-       INIT_WORK(&ieee->wx_sync_scan_wq,(void(*)(void*)) ieee80211_wx_sync_scan_wq,ieee);
-#endif
-
-#else
-       tq_init(&ieee->start_ibss_wq,(void(*)(void*)) ieee80211_start_ibss_wq,ieee);
-       tq_init(&ieee->associate_retry_wq,(void(*)(void*)) ieee80211_associate_retry_wq,ieee);
-       tq_init(&ieee->associate_complete_wq,(void(*)(void*)) ieee80211_associate_complete_wq,ieee);
-       tq_init(&ieee->associate_procedure_wq,(void(*)(void*)) ieee80211_associate_procedure_wq,ieee);
-       tq_init(&ieee->softmac_scan_wq,(void(*)(void*)) ieee80211_softmac_scan_wq,ieee);
-       tq_init(&ieee->wx_sync_scan_wq,(void(*)(void*)) ieee80211_wx_sync_scan_wq,ieee);
-#endif
        sema_init(&ieee->wx_sem, 1);
        sema_init(&ieee->scan_sem, 1);
 #ifdef ENABLE_IPS
@@ -3189,10 +3067,8 @@ void ieee80211_softmac_free(struct ieee80211_device *ieee)
 #endif
        del_timer_sync(&ieee->associate_timer);

-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        cancel_delayed_work(&ieee->associate_retry_wq);
        destroy_workqueue(ieee->wq);
-#endif

        up(&ieee->wx_sem);
 }
@@ -3648,7 +3524,6 @@ void notify_wx_assoc_event(struct ieee80211_device *ieee)
        wireless_send_event(ieee->dev, SIOCGIWAP, &wrqu, NULL);
 }

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_get_beacon);
 //EXPORT_SYMBOL(ieee80211_rtl_wake_queue);
 //EXPORT_SYMBOL(ieee80211_rtl_stop_queue);
@@ -3669,27 +3544,3 @@ void notify_wx_assoc_event(struct ieee80211_device *ieee)
 //EXPORT_SYMBOL(ieee80211_send_probe_requests);
 //EXPORT_SYMBOL(ieee80211_softmac_scan_syncro);
 //EXPORT_SYMBOL(ieee80211_start_scan_syncro);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_get_beacon);
-EXPORT_SYMBOL_NOVERS(ieee80211_rtl_wake_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_rtl_stop_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_reset_queue);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_stop_protocol);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_start_protocol);
-EXPORT_SYMBOL_NOVERS(ieee80211_is_shortslot);
-EXPORT_SYMBOL_NOVERS(ieee80211_is_54g);
-EXPORT_SYMBOL_NOVERS(ieee80211_wpa_supplicant_ioctl);
-EXPORT_SYMBOL_NOVERS(ieee80211_ps_tx_ack);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_xmit);
-EXPORT_SYMBOL_NOVERS(ieee80211_stop_send_beacons);
-EXPORT_SYMBOL_NOVERS(notify_wx_assoc_event);
-EXPORT_SYMBOL_NOVERS(SendDisassociation);
-EXPORT_SYMBOL_NOVERS(ieee80211_disassociate);
-EXPORT_SYMBOL_NOVERS(ieee80211_start_send_beacons);
-EXPORT_SYMBOL_NOVERS(ieee80211_stop_scan);
-EXPORT_SYMBOL_NOVERS(ieee80211_send_probe_requests);
-EXPORT_SYMBOL_NOVERS(ieee80211_softmac_scan_syncro);
-EXPORT_SYMBOL_NOVERS(ieee80211_start_scan_syncro);
-EXPORT_SYMBOL_NOVERS(ieee80211_sta_ps_send_null_frame);
-EXPORT_SYMBOL_NOVERS(ieee80211_sta_ps_send_pspoll_frame);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
index 1bbd49f..b054d42 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac_wx.c
@@ -312,14 +312,9 @@ out:
        return 0;
 }

-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
 void ieee80211_wx_sync_scan_wq(struct work_struct *work)
 {
         struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wx_sync_scan_wq);
-#else
-void ieee80211_wx_sync_scan_wq(struct ieee80211_device *ieee)
-{
-#endif
        short chan;
        HT_EXTCHNL_OFFSET chan_offset=0;
        HT_CHANNEL_WIDTH bandwidth=0;
@@ -408,11 +403,7 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
        }

        if ( ieee->state == IEEE80211_LINKED){
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
                queue_work(ieee->wq, &ieee->wx_sync_scan_wq);
-#else
-               schedule_task(&ieee->wx_sync_scan_wq);
-#endif
                /* intentionally forget to up sem */
                return 0;
        }
@@ -459,18 +450,6 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
        if (wrqu->essid.flags && wrqu->essid.length) {
                //first flush current network.ssid
                len = ((wrqu->essid.length-1) < IW_ESSID_MAX_SIZE) ? (wrqu->essid.length-1) : IW_ESSID_MAX_SIZE;
-#if LINUX_VERSION_CODE <  KERNEL_VERSION(2,6,20)
-               strncpy(ieee->current_network.ssid, extra, len);
-               ieee->current_network.ssid_len = len;
-#if 0
-               {
-                       int i;
-                       for (i=0; i<len; i++)
-                               printk("%c ", extra[i]);
-                       printk("\n");
-               }
-#endif
-#else
                strncpy(ieee->current_network.ssid, extra, len+1);
                ieee->current_network.ssid_len = len+1;
 #if 0
@@ -481,7 +460,6 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
                        printk("\n");
                }
 #endif
-#endif
                ieee->ssid_set = 1;
        }
        else{
@@ -659,7 +637,6 @@ exit:
        return ret;

 }
-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_wx_get_essid);
 //EXPORT_SYMBOL(ieee80211_wx_set_essid);
 //EXPORT_SYMBOL(ieee80211_wx_set_rate);
@@ -678,23 +655,3 @@ exit:
 //EXPORT_SYMBOL(ieee80211_wlan_frequencies);
 //EXPORT_SYMBOL(ieee80211_wx_set_rts);
 //EXPORT_SYMBOL(ieee80211_wx_get_rts);
-#else
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_essid);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_essid);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rate);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_rate);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_wap);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_wap);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_mode);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_mode);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_scan);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_freq);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_freq);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rawtx);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_name);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_power);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_power);
-EXPORT_SYMBOL_NOVERS(ieee80211_wlan_frequencies);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_rts);
-EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_rts);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
index a75f366..b0d8f23 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_tx.c
@@ -287,11 +287,7 @@ ieee80211_classify(struct sk_buff *skb, struct ieee80211_network *network)
                return 0;

 //     IEEE80211_DEBUG_DATA(IEEE80211_DL_DATA, skb->data, skb->len);
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,22))
        ip = ip_hdr(skb);
-#else
-       ip = (struct iphdr*)(skb->data + sizeof(struct ether_header));
-#endif
        switch (ip->tos & 0xfc) {
                case 0x20:
                        return 2;
@@ -613,11 +609,7 @@ void ieee80211_query_seqnum(struct ieee80211_device*ieee, struct sk_buff* skb, u

 int ieee80211_rtl_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,5,0))
        struct ieee80211_device *ieee = netdev_priv(dev);
-#else
-       struct ieee80211_device *ieee = (struct ieee80211_device *)dev->priv;
-#endif
        struct ieee80211_txb *txb = NULL;
        struct ieee80211_hdr_3addrqos *frag_hdr;
        int i, bytes_per_frag, nr_frags, bytes_last_frag, frag_size;
diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
index 4971b1c..0a2bc36 100644
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -54,25 +54,7 @@ struct modes_unit ieee80211_modes[] = {
        {"N-5G",4},
 };

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,4,20)) && (LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0))
-static inline char *
-iwe_stream_add_event_rsl(char *     stream,         /* Stream of events */
-                     char *     ends,           /* End of stream */
-                     struct iw_event *iwe,      /* Payload */
-                     int        event_len)      /* Real size of payload */
-{
-        /* Check if it's possible */
-        if((stream + event_len) < ends) {
-                iwe->len = event_len;
-               ndelay(1);   //new
-                memcpy(stream, (char *) iwe, event_len);
-                stream += event_len;
-        }
-        return stream;
-}
-#else
 #define iwe_stream_add_event_rsl iwe_stream_add_event
-#endif

 #define MAX_CUSTOM_LEN 64
 static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
@@ -93,11 +75,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        iwe.cmd = SIOCGIWAP;
        iwe.u.ap_addr.sa_family = ARPHRD_ETHER;
        memcpy(iwe.u.ap_addr.sa_data, network->bssid, ETH_ALEN);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
        start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_ADDR_LEN);
-#else
-       start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_ADDR_LEN);
-#endif
        /* Remaining entries will be displayed in the order we provide them */

        /* Add the ESSID */
@@ -106,18 +84,10 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
 //     if (network->flags & NETWORK_EMPTY_ESSID) {
        if (network->ssid_len == 0) {
                iwe.u.data.length = sizeof("<hidden>");
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, "<hidden>");
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, "<hidden>");
-#endif
         } else {
                iwe.u.data.length = min(network->ssid_len, (u8)32);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, network->ssid);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, network->ssid);
-#endif
         }
        /* Add the protocol name */
        iwe.cmd = SIOCGIWNAME;
@@ -129,11 +99,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        }
        *pname = '\0';
        snprintf(iwe.u.name, IFNAMSIZ, "IEEE802.11%s", proto_name);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_CHAR_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_CHAR_LEN);
-#endif
         /* Add mode */
         iwe.cmd = SIOCGIWMODE;
         if (network->capability &
@@ -142,11 +108,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                        iwe.u.mode = IW_MODE_MASTER;
                else
                        iwe.u.mode = IW_MODE_ADHOC;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_UINT_LEN);
-#else
-                start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_UINT_LEN);
-#endif
         }

         /* Add frequency/channel */
@@ -156,11 +118,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        iwe.u.freq.m = network->channel;
        iwe.u.freq.e = 0;
        iwe.u.freq.i = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_FREQ_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_FREQ_LEN);
-#endif
        /* Add encryption capability */
        iwe.cmd = SIOCGIWENCODE;
        if (network->capability & WLAN_CAPABILITY_PRIVACY)
@@ -168,11 +126,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        else
                iwe.u.data.flags = IW_ENCODE_DISABLED;
        iwe.u.data.length = 0;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_point(info, start, stop, &iwe, network->ssid);
-#else
-        start = iwe_stream_add_point(start, stop, &iwe, network->ssid);
-#endif
        /* Add basic and extended rates */
        max_rate = 0;
        p = custom;
@@ -228,21 +182,12 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        iwe.cmd = SIOCGIWRATE;
        iwe.u.bitrate.fixed = iwe.u.bitrate.disabled = 0;
        iwe.u.bitrate.value = max_rate * 500000;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe,
                                     IW_EV_PARAM_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe,
-                                    IW_EV_PARAM_LEN);
-#endif
        iwe.cmd = IWEVCUSTOM;
        iwe.u.data.length = p - custom;
        if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-        start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif
        /* Add quality statistics */
        /* TODO: Fix these values... */
        iwe.cmd = IWEVQUAL;
@@ -257,21 +202,13 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
        if (!(network->stats.mask & IEEE80211_STATMASK_SIGNAL))
                iwe.u.qual.updated |= IW_QUAL_QUAL_INVALID;
        iwe.u.qual.updated = 7;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
         start = iwe_stream_add_event_rsl(info, start, stop, &iwe, IW_EV_QUAL_LEN);
-#else
-        start = iwe_stream_add_event_rsl(start, stop, &iwe, IW_EV_QUAL_LEN);
-#endif
        iwe.cmd = IWEVCUSTOM;
        p = custom;

        iwe.u.data.length = p - custom;
        if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
             start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-            start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif
 #if (WIRELESS_EXT < 18)
        if (ieee->wpa_enabled && network->wpa_ie_len){
                char buf[MAX_WPA_IE_LEN * 2 + 30];
@@ -285,11 +222,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                memset(&iwe, 0, sizeof(iwe));
                iwe.cmd = IWEVCUSTOM;
                iwe.u.data.length = strlen(buf);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }

        if (ieee->wpa_enabled && network->rsn_ie_len){
@@ -304,11 +237,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                memset(&iwe, 0, sizeof(iwe));
                iwe.cmd = IWEVCUSTOM;
                iwe.u.data.length = strlen(buf);
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 #else
        memset(&iwe, 0, sizeof(iwe));
@@ -318,11 +247,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                memcpy(buf, network->wpa_ie, network->wpa_ie_len);
                iwe.cmd = IWEVGENIE;
                iwe.u.data.length = network->wpa_ie_len;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
        memset(&iwe, 0, sizeof(iwe));
        if (network->rsn_ie_len)
@@ -331,11 +256,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                memcpy(buf, network->rsn_ie, network->rsn_ie_len);
                iwe.cmd = IWEVGENIE;
                iwe.u.data.length = network->rsn_ie_len;
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
                 start = iwe_stream_add_point(info, start, stop, &iwe, buf);
-#else
-                start = iwe_stream_add_point(start, stop, &iwe, buf);
-#endif
         }
 #endif

@@ -348,11 +269,7 @@ static inline char *rtl819x_translate_scan(struct ieee80211_device *ieee,
                      " Last beacon: %lums ago", (jiffies - network->last_scanned) / (HZ / 100));
        iwe.u.data.length = p - custom;
        if (iwe.u.data.length)
-#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,27)
             start = iwe_stream_add_point(info, start, stop, &iwe, custom);
-#else
-            start = iwe_stream_add_point(start, stop, &iwe, custom);
-#endif

        return start;
 }
@@ -632,7 +549,6 @@ int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,
                                union iwreq_data *wrqu, char *extra)
 {
        int ret = 0;
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        struct net_device *dev = ieee->dev;
         struct iw_point *encoding = &wrqu->encoding;
         struct iw_encode_ext *ext = (struct iw_encode_ext *)extra;
@@ -736,12 +652,7 @@ int ieee80211_wx_set_encode_ext(struct ieee80211_device *ieee,

                 ieee80211_crypt_delayed_deinit(ieee, crypt);

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,13))
                 new_crypt = kzalloc(sizeof(*new_crypt), GFP_KERNEL);
-#else
-                new_crypt = kmalloc(sizeof(*new_crypt), GFP_KERNEL);
-               memset(new_crypt,0,sizeof(*new_crypt));
-#endif
                 if (new_crypt == NULL) {
                         ret = -ENOMEM;
                         goto done;
@@ -807,7 +718,6 @@ done:
                 IEEE80211_DEBUG_WX("%s: reset_port failed\n", dev->name);
                 return -EINVAL;
         }
-#endif
         return ret;
 }

@@ -870,7 +780,6 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
                                struct iw_request_info *info,
                                union iwreq_data *wrqu, char *extra)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        struct iw_mlme *mlme = (struct iw_mlme *) extra;
        switch (mlme->cmd) {
         case IW_MLME_DEAUTH:
@@ -880,7 +789,6 @@ int ieee80211_wx_set_mlme(struct ieee80211_device *ieee,
         default:
                 return -EOPNOTSUPP;
         }
-#endif
        return 0;
 }

@@ -888,7 +796,6 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
                                struct iw_request_info *info,
                                struct iw_param *data, char *extra)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
        switch (data->flags & IW_AUTH_INDEX) {
         case IW_AUTH_WPA_VERSION:
             /*need to support wpa2 here*/
@@ -946,14 +853,12 @@ int ieee80211_wx_set_auth(struct ieee80211_device *ieee,
        default:
                 return -EOPNOTSUPP;
        }
-#endif
        return 0;
 }
 #endif
 #if 1
 int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 {
-#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
 #if 0
        printk("====>%s()\n", __FUNCTION__);
        {
@@ -992,13 +897,11 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
                ieee->wpa_ie = NULL;
                ieee->wpa_ie_len = 0;
        }
-#endif
        return 0;

 }
 #endif

-#if (LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0))
 //EXPORT_SYMBOL(ieee80211_wx_set_gen_ie);
 #if (WIRELESS_EXT >= 18)
 //EXPORT_SYMBOL(ieee80211_wx_set_mlme);
@@ -1009,12 +912,3 @@ int ieee80211_wx_set_gen_ie(struct ieee80211_device *ieee, u8 *ie, size_t len)
 //EXPORT_SYMBOL(ieee80211_wx_get_scan);
 //EXPORT_SYMBOL(ieee80211_wx_set_encode);
 //EXPORT_SYMBOL(ieee80211_wx_get_encode);
-#else
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_gen_ie);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_mlme);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_auth);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_encode_ext);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_scan);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_set_encode);
-//EXPORT_SYMBOL_NOVERS(ieee80211_wx_get_encode);
-#endif
diff --git a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
index 4c4b1df..0d750a5 100644
--- a/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
+++ b/drivers/staging/rtl8192e/ieee80211/rtl819x_HTProc.c
@@ -1026,14 +1026,9 @@ u8 HTFilterMCSRate( struct ieee80211_device* ieee, u8* pSupportMCS, u8* pOperate
 void HTSetConnectBwMode(struct ieee80211_device* ieee, HT_CHANNEL_WIDTH        Bandwidth, HT_EXTCHNL_OFFSET    Offset);
 #if 0
 //I need move this function to other places, such as rx?
-#if (LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20))
 void HTOnAssocRsp_wq(struct work_struct *work)
 {
        struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, ht_onAssRsp);
-#else
-void HTOnAssocRsp_wq(struct ieee80211_device *ieee)
-{
-#endif
 #endif
 void HTOnAssocRsp(struct ieee80211_device *ieee)
 {
@@ -1761,8 +1756,4 @@ void HTSetConnectBwModeCallback(struct ieee80211_device* ieee)
        pHTInfo->bSwBwInProgress = false;
 }

-#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-//EXPORT_SYMBOL_NOVERS(HTUpdateSelfAndPeerSetting);
-#else
 //EXPORT_SYMBOL(HTUpdateSelfAndPeerSetting);
-#endif
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éÝ¶¥Šwÿº{.nÇ+‰·¥Š{±þG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŽŠÝ¢j"ú¶m§ÿÿ¾«þG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
