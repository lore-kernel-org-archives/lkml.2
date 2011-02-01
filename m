Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756826Ab1BAMsZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 07:48:25 -0500
Received: from coyote.quickmin.net ([217.14.112.24]:53317 "EHLO
	coyote.quickmin.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754664Ab1BAMsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 07:48:23 -0500
Comment: DomainKeys? See http://antispam.yahoo.com/domainkeys
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=default; d=telemotive.de;
  b=uxfto2muoM5UJssinGu+fVa08lI3E1JyocihGjoaRx3sp9zbKrc6fny6QPTf4fMh0r7AnC0SJ81+j8QGhrQojZNDCn3g2EF7Wq2+A6Cp7XYV44Yd5plCO68VKABIkggIRQNEKnl6CLLwsMmqelYRMKNHbIyy/frRGmDCQRSQlSo=  ;
From: Roman Fietze <roman.fietze@telemotive.de>
Organization: Telemotive AG
To: Joe Perches <realty@perches.com>
Subject: Re: [PATCH 2/2] hex_dump_dbg: replace all calls to print_hex_dump with level KERN_DEBUG
User-Agent: KMail/1.13.5 (Linux/2.6.34.7-0.7-default; KDE/4.5.5; x86_64; ; )
Cc: Jason Baron <jbaron@redhat.com>, linux-kernel@vger.kernel.org
References: <201012031517.35062.roman.fietze@telemotive.de> <1295029146.4099.71.camel@Joe-Laptop> <201102011345.30618.roman.fietze@telemotive.de>
In-Reply-To: <201102011345.30618.roman.fietze@telemotive.de>
MIME-Version: 1.0
X-TNEFEvaluated: 1
Message-ID: <201102011348.18978.roman.fietze@telemotive.de>
Date: Tue, 1 Feb 2011 13:48:18 +0100
X-MIMETrack: Itemize by SMTP Server on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:48:18,
	Serialize by Router on muc/Telemotive(Release 8.0.2FP1|January 12, 2009) at
 01.02.2011 13:48:19,
	Serialize complete at 01.02.2011 13:48:19
Content-Transfer-Encoding: 8BIT
Content-Type: Text/Plain;
  charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Joe,

And here, just in case it's wanted or needed, a bigger patch replacing
all print_hex_dump calls using KERN_DEBUG.


>From 153d27fd07a01989f6e0ecc8dbfede132c47610f Mon Sep 17 00:00:00 2001
From: Roman Fietze <roman.fietze@telemotive.de>
Date: Tue, 1 Feb 2011 13:30:04 +0100
Subject: [PATCH 2/2] hex_dump_dbg: replace all calls to print_hex_dump with level KERN_DEBUG

Replaces all calls to print_hex_dump with log level KERN_DEBUG by
hex_dump_dbg. This allows for debugging using the dynamic printk
feature, or to save code an const data code space, depending on the
kernel config and/or local DEBUG defines.

Signed-off-by: Roman Fietze <roman.fietze@telemotive.de>
---
 drivers/ata/libata-core.c                 |    4 ++--
 drivers/misc/iwmc3200top/log.h            |    6 +++---
 drivers/misc/ti-st/st_core.c              |    2 +-
 drivers/mtd/tests/mtd_nandecctest.c       |    8 ++++----
 drivers/mtd/ubi/debug.c                   |   10 +++++-----
 drivers/mtd/ubi/io.c                      |   12 ++++++------
 drivers/net/8139too.c                     |    6 +++---
 drivers/net/a2065.c                       |    4 ++--
 drivers/net/arcnet/arcnet.c               |    8 ++++----
 drivers/net/enc28j60.c                    |    4 ++--
 drivers/net/greth.c                       |   16 ++++++++--------
 drivers/net/wireless/iwlwifi/iwl-debug.h  |    4 ++--
 drivers/net/wireless/ray_cs.c             |    6 +++---
 drivers/net/wireless/wl1251/wl1251.h      |   20 ++++++++++----------
 drivers/net/wireless/wl12xx/wl12xx.h      |   20 ++++++++++----------
 drivers/nfc/pn544.c                       |   24 ++++++++++++------------
 drivers/staging/bcm/Debug.h               |    4 ++--
 drivers/staging/bcm/HandleControlPacket.c |    4 ++--
 drivers/staging/bcm/Transmit.c            |    4 ++--
 drivers/staging/usbip/usbip_common.c      |    4 ++--
 drivers/usb/c67x00/c67x00-sched.c         |    4 ++--
 drivers/usb/core/devio.c                  |    2 +-
 drivers/usb/gadget/storage_common.c       |    8 ++++----
 fs/ceph/mdsmap.c                          |    6 +++---
 fs/ubifs/debug.c                          |    8 ++++----
 fs/ubifs/scan.c                           |    2 +-
 net/atm/br2684.c                          |    4 ++--
 net/atm/lec.c                             |    4 ++--
 net/ceph/messenger.c                      |   26 +++++++++++++-------------
 net/ceph/osdmap.c                         |    6 +++---
 30 files changed, 120 insertions(+), 120 deletions(-)

diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
index d4e52e2..d10a683 100644
--- a/drivers/ata/libata-core.c
+++ b/drivers/ata/libata-core.c
@@ -1956,8 +1956,8 @@ retry:
 		ata_dev_printk(dev, KERN_DEBUG, "dumping IDENTIFY data, "
 			       "class=%d may_fallback=%d tried_spinup=%d\n",
 			       class, may_fallback, tried_spinup);
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,
-			       16, 2, id, ATA_ID_WORDS * sizeof(*id), true);
+		hex_dump_dbg("", DUMP_PREFIX_OFFSET,
+			     16, 2, id, ATA_ID_WORDS * sizeof(*id), true);
 	}
 
 	/* Falling back doesn't make sense if ID data was read
diff --git a/drivers/misc/iwmc3200top/log.h b/drivers/misc/iwmc3200top/log.h
index 4434bb1..609fbfd 100644
--- a/drivers/misc/iwmc3200top/log.h
+++ b/drivers/misc/iwmc3200top/log.h
@@ -126,9 +126,9 @@ do {									\
 
 #define LOG_HEXDUMP(src, ptr, len)					\
 do {									\
-	if (iwmct_logdefs[LOG_SRC_ ## src] & BIT(LOG_SEV_DUMP))	\
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_NONE,	\
-				16, 1, ptr, len, false);		\
+	if (iwmct_logdefs[LOG_SRC_ ## src] & BIT(LOG_SEV_DUMP))		\
+		hex_dump_dbg("", DUMP_PREFIX_NONE,			\
+			     16, 1, ptr, len, false);			\
 } while (0)
 
 void iwmct_log_top_message(struct iwmct_priv *priv, u8 *buf, int len);
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f9aad06..00f8184 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -71,7 +71,7 @@ int st_int_write(struct st_data_s *st_gdata,
 	}
 	tty = st_gdata->tty;
 #ifdef VERBOSE
-	print_hex_dump(KERN_DEBUG, "<out<", DUMP_PREFIX_NONE,
+	hex_dump_dbg("<out<", DUMP_PREFIX_NONE,
 		16, 1, data, count, 0);
 #endif
 	return tty->ops->write(tty, data, count);
diff --git a/drivers/mtd/tests/mtd_nandecctest.c b/drivers/mtd/tests/mtd_nandecctest.c
index 70d6d7d..a2ddd7b 100644
--- a/drivers/mtd/tests/mtd_nandecctest.c
+++ b/drivers/mtd/tests/mtd_nandecctest.c
@@ -46,11 +46,11 @@ static int nand_ecc_test(const size_t size)
 	printk(KERN_ERR "mtd_nandecctest: not ok - %s\n", testname);
 
 	printk(KERN_DEBUG "hexdump of data:\n");
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
-			data, size, false);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 16, 4,
+		     data, size, false);
 	printk(KERN_DEBUG "hexdump of error data:\n");
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 4,
-			error_data, size, false);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 16, 4,
+		     error_data, size, false);
 
 	return -1;
 }
diff --git a/drivers/mtd/ubi/debug.c b/drivers/mtd/ubi/debug.c
index 4876977..98781f2 100644
--- a/drivers/mtd/ubi/debug.c
+++ b/drivers/mtd/ubi/debug.c
@@ -49,8 +49,8 @@ void ubi_dbg_dump_ec_hdr(const struct ubi_ec_hdr *ec_hdr)
 	printk(KERN_DEBUG "\thdr_crc        %#08x\n",
 	       be32_to_cpu(ec_hdr->hdr_crc));
 	printk(KERN_DEBUG "erase counter header hexdump:\n");
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-		       ec_hdr, UBI_EC_HDR_SIZE, 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+		     ec_hdr, UBI_EC_HDR_SIZE, 1);
 }
 
 /**
@@ -74,8 +74,8 @@ void ubi_dbg_dump_vid_hdr(const struct ubi_vid_hdr *vid_hdr)
 		(unsigned long long)be64_to_cpu(vid_hdr->sqnum));
 	printk(KERN_DEBUG "\thdr_crc   %08x\n", be32_to_cpu(vid_hdr->hdr_crc));
 	printk(KERN_DEBUG "Volume identifier header hexdump:\n");
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-		       vid_hdr, UBI_VID_HDR_SIZE, 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+		     vid_hdr, UBI_VID_HDR_SIZE, 1);
 }
 
 /**
@@ -222,7 +222,7 @@ void ubi_dbg_dump_flash(struct ubi_device *ubi, int pnum, int offset, int len)
 
 	dbg_msg("dumping %d bytes of data from PEB %d, offset %d",
 		len, pnum, offset);
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1, buf, len, 1);
 out:
 	vfree(buf);
 	return;
diff --git a/drivers/mtd/ubi/io.c b/drivers/mtd/ubi/io.c
index 811775a..bd62bf4 100644
--- a/drivers/mtd/ubi/io.c
+++ b/drivers/mtd/ubi/io.c
@@ -1314,12 +1314,12 @@ int ubi_dbg_check_write(struct ubi_device *ubi, const void *buf, int pnum,
 		dump_len = max_t(int, 128, len - i);
 		ubi_msg("hex dump of the original buffer from %d to %d",
 			i, i + dump_len);
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-			       buf + i, dump_len, 1);
+		hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+			     buf + i, dump_len, 1);
 		ubi_msg("hex dump of the read buffer from %d to %d",
 			i, i + dump_len);
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-			       ubi->dbg_peb_buf + i, dump_len, 1);
+		hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+			     ubi->dbg_peb_buf + i, dump_len, 1);
 		ubi_dbg_dump_stack();
 		err = -EINVAL;
 		goto out_unlock;
@@ -1371,8 +1371,8 @@ int ubi_dbg_check_all_ff(struct ubi_device *ubi, int pnum, int offset, int len)
 fail:
 	ubi_err("paranoid check failed for PEB %d", pnum);
 	ubi_msg("hex dump of the %d-%d region", offset, offset + len);
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-		       ubi->dbg_peb_buf, len, 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+		     ubi->dbg_peb_buf, len, 1);
 	err = -EINVAL;
 error:
 	ubi_dbg_dump_stack();
diff --git a/drivers/net/8139too.c b/drivers/net/8139too.c
index 98517a3..ac53ce3 100644
--- a/drivers/net/8139too.c
+++ b/drivers/net/8139too.c
@@ -1944,9 +1944,9 @@ static int rtl8139_rx(struct net_device *dev, struct rtl8139_private *tp,
 		netif_dbg(tp, rx_status, dev, "%s() status %04x, size %04x, cur %04x\n",
 			  __func__, rx_status, rx_size, cur_rx);
 #if RTL8139_DEBUG > 2
-		print_hex_dump(KERN_DEBUG, "Frame contents: ",
-			       DUMP_PREFIX_OFFSET, 16, 1,
-			       &rx_ring[ring_offset], 70, true);
+		hex_dump_dbg("Frame contents: ",
+			     DUMP_PREFIX_OFFSET, 16, 1,
+			     &rx_ring[ring_offset], 70, true);
 #endif
 
 		/* Packet copy from FIFO still in progress.
diff --git a/drivers/net/a2065.c b/drivers/net/a2065.c
index f142cc2..c0fff77 100644
--- a/drivers/net/a2065.c
+++ b/drivers/net/a2065.c
@@ -569,8 +569,8 @@ static netdev_tx_t lance_start_xmit (struct sk_buff *skb,
 
 #ifdef DEBUG_DRIVER
 	/* dump the packet */
-	print_hex_dump(KERN_DEBUG, "skb->data: ", DUMP_PREFIX_NONE,
-		       16, 1, skb->data, 64, true);
+	hex_dump_dbg("skb->data: ", DUMP_PREFIX_NONE,
+		     16, 1, skb->data, 64, true);
 #endif
 	entry = lp->tx_new & lp->tx_ring_mod_mask;
 	ib->btx_ring [entry].length = (-skblen) | 0xf000;
diff --git a/drivers/net/arcnet/arcnet.c b/drivers/net/arcnet/arcnet.c
index a746ba2..5784200 100644
--- a/drivers/net/arcnet/arcnet.c
+++ b/drivers/net/arcnet/arcnet.c
@@ -162,8 +162,8 @@ void arcnet_dump_skb(struct net_device *dev,
 
 	/* dump the packet */
 	snprintf(hdr, sizeof(hdr), "%6s:%s skb->data:", dev->name, desc);
-	print_hex_dump(KERN_DEBUG, hdr, DUMP_PREFIX_OFFSET,
-		       16, 1, skb->data, skb->len, true);
+	hex_dump_dbg(hdr, DUMP_PREFIX_OFFSET,
+		     16, 1, skb->data, skb->len, true);
 }
 
 EXPORT_SYMBOL(arcnet_dump_skb);
@@ -197,8 +197,8 @@ static void arcnet_dump_packet(struct net_device *dev, int bufnum,
 
 	/* dump the packet */
 	snprintf(hdr, sizeof(hdr), "%6s:%s packet dump:", dev->name, desc);
-	print_hex_dump(KERN_DEBUG, hdr, DUMP_PREFIX_OFFSET,
-		       16, 1, buf, length, true);
+	hex_dump_dbg(hdr, DUMP_PREFIX_OFFSET,
+		     16, 1, buf, length, true);
 }
 
 #else
diff --git a/drivers/net/enc28j60.c b/drivers/net/enc28j60.c
index 112c5aa..0c6c201 100644
--- a/drivers/net/enc28j60.c
+++ b/drivers/net/enc28j60.c
@@ -887,8 +887,8 @@ static void enc28j60_dump_rsv(struct enc28j60_net *priv, const char *msg,
 static void dump_packet(const char *msg, int len, const char *data)
 {
 	printk(KERN_DEBUG DRV_NAME ": %s - packet len:%d\n", msg, len);
-	print_hex_dump(KERN_DEBUG, "pk data: ", DUMP_PREFIX_OFFSET, 16, 1,
-			data, len, true);
+	hex_dump_dbg("pk data: ", DUMP_PREFIX_OFFSET, 16, 1,
+		     data, len, true);
 }
 
 /*
diff --git a/drivers/net/greth.c b/drivers/net/greth.c
index fdb0333..b88930a 100644
--- a/drivers/net/greth.c
+++ b/drivers/net/greth.c
@@ -91,8 +91,8 @@ static void greth_set_multicast_list(struct net_device *dev);
 
 static void greth_print_rx_packet(void *addr, int len)
 {
-	print_hex_dump(KERN_DEBUG, "RX: ", DUMP_PREFIX_OFFSET, 16, 1,
-			addr, len, true);
+	hex_dump_dbg("RX: ", DUMP_PREFIX_OFFSET, 16, 1,
+		     addr, len, true);
 }
 
 static void greth_print_tx_packet(struct sk_buff *skb)
@@ -105,15 +105,15 @@ static void greth_print_tx_packet(struct sk_buff *skb)
 	else
 		length = skb_headlen(skb);
 
-	print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
-			skb->data, length, true);
+	hex_dump_dbg("TX: ", DUMP_PREFIX_OFFSET, 16, 1,
+		     skb->data, length, true);
 
 	for (i = 0; i < skb_shinfo(skb)->nr_frags; i++) {
 
-		print_hex_dump(KERN_DEBUG, "TX: ", DUMP_PREFIX_OFFSET, 16, 1,
-			       phys_to_virt(page_to_phys(skb_shinfo(skb)->frags[i].page)) +
-			       skb_shinfo(skb)->frags[i].page_offset,
-			       length, true);
+		hex_dump_dbg("TX: ", DUMP_PREFIX_OFFSET, 16, 1,
+			     phys_to_virt(page_to_phys(skb_shinfo(skb)->frags[i].page)) +
+			     skb_shinfo(skb)->frags[i].page_offset,
+			     length, true);
 	}
 }
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-debug.h b/drivers/net/wireless/iwlwifi/iwl-debug.h
index ebdea3b..d159579 100644
--- a/drivers/net/wireless/iwlwifi/iwl-debug.h
+++ b/drivers/net/wireless/iwlwifi/iwl-debug.h
@@ -63,8 +63,8 @@ do {									\
 #define iwl_print_hex_dump(priv, level, p, len) 			\
 do {                                            			\
 	if (iwl_get_debug_level(priv) & level) 				\
-		print_hex_dump(KERN_DEBUG, "iwl data: ",		\
-			       DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
+		hex_dump_dbg("iwl data: ",				\
+			     DUMP_PREFIX_OFFSET, 16, 1, p, len, 1);	\
 } while (0)
 
 #else
diff --git a/drivers/net/wireless/ray_cs.c b/drivers/net/wireless/ray_cs.c
index 0764d1a..3ba76e0 100644
--- a/drivers/net/wireless/ray_cs.c
+++ b/drivers/net/wireless/ray_cs.c
@@ -2288,9 +2288,9 @@ static void untranslate(ray_dev_t *local, struct sk_buff *skb, int len)
 
 #if 0
 	if {
-		print_hex_dump(KERN_DEBUG, "skb->data before untranslate: ",
-			       DUMP_PREFIX_NONE, 16, 1,
-			       skb->data, 64, true);
+		hex_dump_dbg("skb->data before untranslate: ",
+			     DUMP_PREFIX_NONE, 16, 1,
+			     skb->data, 64, true);
 		printk(KERN_DEBUG
 		       "type = %08x, xsap = %02x%02x%02x, org = %02x02x02x\n",
 		       ntohs(type), psnap->dsap, psnap->ssap, psnap->ctrl,
diff --git a/drivers/net/wireless/wl1251/wl1251.h b/drivers/net/wireless/wl1251/wl1251.h
index c0ce2c8..b3910d4 100644
--- a/drivers/net/wireless/wl1251/wl1251.h
+++ b/drivers/net/wireless/wl1251/wl1251.h
@@ -75,21 +75,21 @@ enum {
 #define wl1251_dump(level, prefix, buf, len)	\
 	do { \
 		if (level & DEBUG_LEVEL) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       0);				\
+			hex_dump_dbg(DRIVER_PREFIX prefix,		\
+				     DUMP_PREFIX_OFFSET, 16, 1,		\
+				     buf,				\
+				     min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				     0);				\
 	} while (0)
 
 #define wl1251_dump_ascii(level, prefix, buf, len)	\
 	do { \
 		if (level & DEBUG_LEVEL) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       true);				\
+			hex_dump_dbg(DRIVER_PREFIX prefix,		\
+				     DUMP_PREFIX_OFFSET, 16, 1,		\
+				     buf,				\
+				     min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				     true);				\
 	} while (0)
 
 #define WL1251_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
diff --git a/drivers/net/wireless/wl12xx/wl12xx.h b/drivers/net/wireless/wl12xx/wl12xx.h
index 9050dd9..8dab1f3 100644
--- a/drivers/net/wireless/wl12xx/wl12xx.h
+++ b/drivers/net/wireless/wl12xx/wl12xx.h
@@ -86,21 +86,21 @@ extern u32 wl12xx_debug_level;
 #define wl1271_dump(level, prefix, buf, len)	\
 	do { \
 		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       0);				\
+			hex_dump_dbg(DRIVER_PREFIX prefix,		\
+				     DUMP_PREFIX_OFFSET, 16, 1,		\
+				     buf,				\
+				     min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				     0);				\
 	} while (0)
 
 #define wl1271_dump_ascii(level, prefix, buf, len)	\
 	do { \
 		if (level & wl12xx_debug_level) \
-			print_hex_dump(KERN_DEBUG, DRIVER_PREFIX prefix, \
-				       DUMP_PREFIX_OFFSET, 16, 1,	\
-				       buf,				\
-				       min_t(size_t, len, DEBUG_DUMP_LIMIT), \
-				       true);				\
+			hex_dump_dbg(DRIVER_PREFIX prefix,		\
+				     DUMP_PREFIX_OFFSET, 16, 1,		\
+				     buf,				\
+				     min_t(size_t, len, DEBUG_DUMP_LIMIT), \
+				     true);				\
 	} while (0)
 
 #define WL1271_DEFAULT_RX_CONFIG (CFG_UNI_FILTER_EN |	\
diff --git a/drivers/nfc/pn544.c b/drivers/nfc/pn544.c
index bae6472..f87e085 100644
--- a/drivers/nfc/pn544.c
+++ b/drivers/nfc/pn544.c
@@ -143,8 +143,8 @@ static int check_crc(u8 *buf, int buflen)
 	if (len < 4 || len != buflen || len > PN544_MSG_MAX_SIZE) {
 		pr_err(PN544_DRIVER_NAME
 		       ": CRC; corrupt packet len %u (%d)\n", len, buflen);
-		print_hex_dump(KERN_DEBUG, "crc: ", DUMP_PREFIX_NONE,
-			       16, 2, buf, buflen, false);
+		hex_dump_dbg("crc: ", DUMP_PREFIX_NONE,
+			     16, 2, buf, buflen, false);
 		return -EPERM;
 	}
 	crc = crc_ccitt(0xffff, buf, len - 2);
@@ -154,8 +154,8 @@ static int check_crc(u8 *buf, int buflen)
 		pr_err(PN544_DRIVER_NAME ": CRC error 0x%x != 0x%x 0x%x\n",
 		       crc, buf[len-1], buf[len-2]);
 
-		print_hex_dump(KERN_DEBUG, "crc: ", DUMP_PREFIX_NONE,
-			       16, 2, buf, buflen, false);
+		hex_dump_dbg("crc: ", DUMP_PREFIX_NONE,
+			     16, 2, buf, buflen, false);
 		return -EPERM;
 	}
 	return 0;
@@ -365,8 +365,8 @@ static ssize_t pn544_read(struct file *file, char __user *buf,
 			goto out;
 		}
 
-		print_hex_dump(KERN_DEBUG, "FW read: ", DUMP_PREFIX_NONE,
-			       16, 2, info->buf, r, false);
+		hex_dump_dbg("FW read: ", DUMP_PREFIX_NONE,
+			     16, 2, info->buf, r, false);
 
 		*offset += r;
 		if (copy_to_user(buf, info->buf, r)) {
@@ -385,8 +385,8 @@ static ssize_t pn544_read(struct file *file, char __user *buf,
 			dev_err(&info->i2c_dev->dev, "read failed (%d)\n", r);
 			goto out;
 		}
-		print_hex_dump(KERN_DEBUG, "read: ", DUMP_PREFIX_NONE,
-			       16, 2, info->buf, r, false);
+		hex_dump_dbg("read: ", DUMP_PREFIX_NONE,
+			     16, 2, info->buf, r, false);
 
 		*offset += r;
 		if (copy_to_user(buf, info->buf, r)) {
@@ -466,8 +466,8 @@ static ssize_t pn544_write(struct file *file, const char __user *buf,
 			goto out;
 		}
 
-		print_hex_dump(KERN_DEBUG, "FW write: ", DUMP_PREFIX_NONE,
-			       16, 2, info->buf, len, false);
+		hex_dump_dbg("FW write: ", DUMP_PREFIX_NONE,
+			     16, 2, info->buf, len, false);
 
 		fw_len = PN544_FW_HEADER_SIZE + (info->buf[1] << 8) +
 			info->buf[2];
@@ -488,8 +488,8 @@ static ssize_t pn544_write(struct file *file, const char __user *buf,
 			goto out;
 		}
 
-		print_hex_dump(KERN_DEBUG, "write: ", DUMP_PREFIX_NONE,
-			       16, 2, info->buf, len, false);
+		hex_dump_dbg("write: ", DUMP_PREFIX_NONE,
+			     16, 2, info->buf, len, false);
 
 		if (len > (info->buf[0] + 1)) /* 1 msg at a time */
 			len  = info->buf[0] + 1;
diff --git a/drivers/staging/bcm/Debug.h b/drivers/staging/bcm/Debug.h
index 3138729..93bdea1 100644
--- a/drivers/staging/bcm/Debug.h
+++ b/drivers/staging/bcm/Debug.h
@@ -237,8 +237,8 @@ typedef struct _S_BCM_DEBUG_STATE {
 	     (Type & Adapter->stDebugState.type) &&			\
 	     (SubType & Adapter->stDebugState.subtype[Type]))) {	\
 		printk(KERN_DEBUG "%s:\n", __func__);			\
-		print_hex_dump(KERN_DEBUG, " ", DUMP_PREFIX_OFFSET,	\
-			       16, 1, buffer, bufferlen, false);	\
+		hex_dump_dbg(" ", DUMP_PREFIX_OFFSET,			\
+			     16, 1, buffer, bufferlen, false);		\
 	}								\
 } while(0)
 
diff --git a/drivers/staging/bcm/HandleControlPacket.c b/drivers/staging/bcm/HandleControlPacket.c
index 2b1e9e1..3ba0b46 100644
--- a/drivers/staging/bcm/HandleControlPacket.c
+++ b/drivers/staging/bcm/HandleControlPacket.c
@@ -21,8 +21,8 @@ static VOID handle_rx_control_packet(PMINI_ADAPTER Adapter, struct sk_buff *skb)
 	USHORT usStatus = *(PUSHORT)(skb->data);
 
 	if (netif_msg_pktdata(Adapter))
-		print_hex_dump(KERN_DEBUG, PFX "rx control: ", DUMP_PREFIX_NONE,
-			       16, 1, skb->data, skb->len, 0);
+		hex_dump_dbg(PFX "rx control: ", DUMP_PREFIX_NONE,
+			     16, 1, skb->data, skb->len, 0);
 
 	switch(usStatus)
 	{
diff --git a/drivers/staging/bcm/Transmit.c b/drivers/staging/bcm/Transmit.c
index d5e4a74..0f587bc 100644
--- a/drivers/staging/bcm/Transmit.c
+++ b/drivers/staging/bcm/Transmit.c
@@ -67,8 +67,8 @@ INT SendControlPacket(PMINI_ADAPTER Adapter, char *pControlPacket)
 		return 0;
 
 	if (netif_msg_pktdata(Adapter))
-		print_hex_dump(KERN_DEBUG, PFX "tx control: ", DUMP_PREFIX_NONE,
-			       16, 1, pControlPacket, PLeader->PLength + LEADER_SIZE, 0);
+		hex_dump_dbg(PFX "tx control: ", DUMP_PREFIX_NONE,
+			     16, 1, pControlPacket, PLeader->PLength + LEADER_SIZE, 0);
 
 	Adapter->interface_transmit(Adapter->pvInterfaceAdapter,
 					pControlPacket, (PLeader->PLength + LEADER_SIZE));
diff --git a/drivers/staging/usbip/usbip_common.c b/drivers/staging/usbip/usbip_common.c
index 210ef16..d7f1767 100644
--- a/drivers/staging/usbip/usbip_common.c
+++ b/drivers/staging/usbip/usbip_common.c
@@ -64,8 +64,8 @@ DEVICE_ATTR(usbip_debug, (S_IRUGO | S_IWUSR), show_flag, store_flag);
 
 static void usbip_dump_buffer(char *buff, int bufflen)
 {
-	print_hex_dump(KERN_DEBUG, "usb-ip", DUMP_PREFIX_OFFSET, 16, 4,
-		       buff, bufflen, false);
+	hex_dump_dbg("usb-ip", DUMP_PREFIX_OFFSET, 16, 4,
+		     buff, bufflen, false);
 }
 
 static void usbip_dump_pipe(unsigned int p)
diff --git a/drivers/usb/c67x00/c67x00-sched.c b/drivers/usb/c67x00/c67x00-sched.c
index f6b3c25..cedeee9 100644
--- a/drivers/usb/c67x00/c67x00-sched.c
+++ b/drivers/usb/c67x00/c67x00-sched.c
@@ -167,8 +167,8 @@ static void dbg_td(struct c67x00_hcd *c67x00, struct c67x00_td *td, char *msg)
 	dev_dbg(dev, "residue:        0x%02x\n", td->residue);
 	dev_dbg(dev, "next_td_addr: 0x%04x\n", td_next_td_addr(td));
 	dev_dbg(dev, "data:");
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 16, 1,
-		       td->data, td_length(td), 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 16, 1,
+		     td->data, td_length(td), 1);
 }
 #else				/* DEBUG */
 
diff --git a/drivers/usb/core/devio.c b/drivers/usb/core/devio.c
index a7131ad..e571b58 100644
--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -345,7 +345,7 @@ static void snoop_urb(struct usb_device *udev,
 	}
 
 	if (data && data_len > 0) {
-		print_hex_dump(KERN_DEBUG, "data: ", DUMP_PREFIX_NONE, 32, 1,
+		hex_dump_dbg("data: ", DUMP_PREFIX_NONE, 32, 1,
 			data, data_len, 1);
 	}
 }
diff --git a/drivers/usb/gadget/storage_common.c b/drivers/usb/gadget/storage_common.c
index b015561..45d4f11 100644
--- a/drivers/usb/gadget/storage_common.c
+++ b/drivers/usb/gadget/storage_common.c
@@ -122,8 +122,8 @@
 		   /* const u8 * */ buf, /* unsigned */ length) do {	\
 	if (length < 512) {						\
 		DBG(fsg, "%s, length %u:\n", label, length);		\
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET,	\
-			       16, 1, buf, length, 0);			\
+		hex_dump_dbg("", DUMP_PREFIX_OFFSET,			\
+			     16, 1, buf, length, 0);			\
 	}								\
 } while (0)
 
@@ -137,8 +137,8 @@
 #  ifdef VERBOSE_DEBUG
 
 #    define dump_cdb(fsg)						\
-	print_hex_dump(KERN_DEBUG, "SCSI CDB: ", DUMP_PREFIX_NONE,	\
-		       16, 1, (fsg)->cmnd, (fsg)->cmnd_size, 0)		\
+	hex_dump_dbg("SCSI CDB: ", DUMP_PREFIX_NONE,			\
+		     16, 1, (fsg)->cmnd, (fsg)->cmnd_size, 0)		\
 
 #  else
 
diff --git a/fs/ceph/mdsmap.c b/fs/ceph/mdsmap.c
index 73b7d44..1b78c8f 100644
--- a/fs/ceph/mdsmap.c
+++ b/fs/ceph/mdsmap.c
@@ -160,9 +160,9 @@ badmem:
 	err = -ENOMEM;
 bad:
 	pr_err("corrupt mdsmap\n");
-	print_hex_dump(KERN_DEBUG, "mdsmap: ",
-		       DUMP_PREFIX_OFFSET, 16, 1,
-		       start, end - start, true);
+	hex_dump_dbg("mdsmap: ",
+		     DUMP_PREFIX_OFFSET, 16, 1,
+		     start, end - start, true);
 	ceph_mdsmap_destroy(m);
 	return ERR_PTR(-EINVAL);
 }
diff --git a/fs/ubifs/debug.c b/fs/ubifs/debug.c
index 0bee4db..7596ed1 100644
--- a/fs/ubifs/debug.c
+++ b/fs/ubifs/debug.c
@@ -288,8 +288,8 @@ void dbg_dump_node(const struct ubifs_info *c, const void *node)
 	/* If the magic is incorrect, just hexdump the first bytes */
 	if (le32_to_cpu(ch->magic) != UBIFS_NODE_MAGIC) {
 		printk(KERN_DEBUG "Not a node, first %zu bytes:", UBIFS_CH_SZ);
-		print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 1,
-			       (void *)node, UBIFS_CH_SZ, 1);
+		hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 1,
+			     (void *)node, UBIFS_CH_SZ, 1);
 		return;
 	}
 
@@ -509,8 +509,8 @@ void dbg_dump_node(const struct ubifs_info *c, const void *node)
 		printk(KERN_DEBUG "\tdata size      %d\n",
 		       dlen);
 		printk(KERN_DEBUG "\tdata:\n");
-		print_hex_dump(KERN_DEBUG, "\t", DUMP_PREFIX_OFFSET, 32, 1,
-			       (void *)&dn->data, dlen, 0);
+		hex_dump_dbg("\t", DUMP_PREFIX_OFFSET, 32, 1,
+			     (void *)&dn->data, dlen, 0);
 		break;
 	}
 	case UBIFS_TRUN_NODE:
diff --git a/fs/ubifs/scan.c b/fs/ubifs/scan.c
index 3e1ee57..fa2d0a9 100644
--- a/fs/ubifs/scan.c
+++ b/fs/ubifs/scan.c
@@ -246,7 +246,7 @@ void ubifs_scanned_corruption(const struct ubifs_info *c, int lnum, int offs,
 	if (len > 8192)
 		len = 8192;
 	dbg_err("first %d bytes from LEB %d:%d", len, lnum, offs);
-	print_hex_dump(KERN_DEBUG, "", DUMP_PREFIX_OFFSET, 32, 4, buf, len, 1);
+	hex_dump_dbg("", DUMP_PREFIX_OFFSET, 32, 4, buf, len, 1);
 }
 
 /**
diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index fce2eae..667698d 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -33,8 +33,8 @@ static void skb_debug(const struct sk_buff *skb)
 {
 #ifdef SKB_DEBUG
 #define NUM2PRINT 50
-	print_hex_dump(KERN_DEBUG, "br2684: skb: ", DUMP_OFFSET,
-		       16, 1, skb->data, min(NUM2PRINT, skb->len), true);
+	hex_dump_dbg("br2684: skb: ", DUMP_OFFSET,
+		     16, 1, skb->data, min(NUM2PRINT, skb->len), true);
 #endif
 }
 
diff --git a/net/atm/lec.c b/net/atm/lec.c
index 38754fd..6be1be1 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -318,8 +318,8 @@ static netdev_tx_t lec_start_xmit(struct sk_buff *skb,
 #if DUMP_PACKETS >= 1
 	printk(KERN_DEBUG "%s: send datalen:%ld lecid:%4.4x\n",
 	       dev->name, skb->len, priv->lecid);
-	print_hex_dump(KERN_DEBUG, "", DUMP_OFFSET, 16, 1,
-		       skb->data, min(skb->len, MAX_DUMP_SKB), true);
+	hex_dump_dbg("", DUMP_OFFSET, 16, 1,
+		     skb->data, min(skb->len, MAX_DUMP_SKB), true);
 #endif /* DUMP_PACKETS >= 1 */
 
 	/* Minimum ethernet-frame size */
diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
index dff633d..8471f97 100644
--- a/net/ceph/messenger.c
+++ b/net/ceph/messenger.c
@@ -2390,19 +2390,19 @@ void ceph_msg_dump(struct ceph_msg *msg)
 {
 	pr_debug("msg_dump %p (front_max %d nr_pages %d)\n", msg,
 		 msg->front_max, msg->nr_pages);
-	print_hex_dump(KERN_DEBUG, "header: ",
-		       DUMP_PREFIX_OFFSET, 16, 1,
-		       &msg->hdr, sizeof(msg->hdr), true);
-	print_hex_dump(KERN_DEBUG, " front: ",
-		       DUMP_PREFIX_OFFSET, 16, 1,
-		       msg->front.iov_base, msg->front.iov_len, true);
+	hex_dump_dbg("header: ",
+		     DUMP_PREFIX_OFFSET, 16, 1,
+		     &msg->hdr, sizeof(msg->hdr), true);
+	hex_dump_dbg(" front: ",
+		     DUMP_PREFIX_OFFSET, 16, 1,
+		     msg->front.iov_base, msg->front.iov_len, true);
 	if (msg->middle)
-		print_hex_dump(KERN_DEBUG, "middle: ",
-			       DUMP_PREFIX_OFFSET, 16, 1,
-			       msg->middle->vec.iov_base,
-			       msg->middle->vec.iov_len, true);
-	print_hex_dump(KERN_DEBUG, "footer: ",
-		       DUMP_PREFIX_OFFSET, 16, 1,
-		       &msg->footer, sizeof(msg->footer), true);
+		hex_dump_dbg("middle: ",
+			     DUMP_PREFIX_OFFSET, 16, 1,
+			     msg->middle->vec.iov_base,
+			     msg->middle->vec.iov_len, true);
+	hex_dump_dbg("footer: ",
+		     DUMP_PREFIX_OFFSET, 16, 1,
+		     &msg->footer, sizeof(msg->footer), true);
 }
 EXPORT_SYMBOL(ceph_msg_dump);
diff --git a/net/ceph/osdmap.c b/net/ceph/osdmap.c
index 71603ac..e70967d 100644
--- a/net/ceph/osdmap.c
+++ b/net/ceph/osdmap.c
@@ -917,9 +917,9 @@ struct ceph_osdmap *osdmap_apply_incremental(void **p, void *end,
 bad:
 	pr_err("corrupt inc osdmap epoch %d off %d (%p of %p-%p)\n",
 	       epoch, (int)(*p - start), *p, start, end);
-	print_hex_dump(KERN_DEBUG, "osdmap: ",
-		       DUMP_PREFIX_OFFSET, 16, 1,
-		       start, end - start, true);
+	hex_dump_dbg("osdmap: ",
+		     DUMP_PREFIX_OFFSET, 16, 1,
+		     start, end - start, true);
 	if (newcrush)
 		crush_destroy(newcrush);
 	return ERR_PTR(err);
-- 
1.7.3.4


-- 
Roman Fietze              Telemotive AG Buero Muehlhausen
Breitwiesen                             73347 Muehlhausen
Tel.: +49(0)7335/18493-45        http://www.telemotive.de
