Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab0EMUAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:00:16 -0400
Received: from mgw2.diku.dk ([130.225.96.92]:50697 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932121Ab0EMUAL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:00:11 -0400
Date: Thu, 13 May 2010 22:00:05 +0200 (CEST)
From: Julia Lawall <julia@diku.dk>
To: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 5/20] drivers/staging: Use kcalloc or kzalloc
Message-ID: <Pine.LNX.4.64.1005132159330.6282@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kcalloc or kzalloc rather than the combination of kmalloc and memset.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression x,y,flags;
statement S;
type T;
@@

x = 
-   kmalloc
+   kcalloc
           (
-           y * sizeof(T),
+           y, sizeof(T),
                flags);
 if (x == NULL) S
-memset(x, 0, y * sizeof(T));

@@
expression x,size,flags;
statement S;
@@

-x = kmalloc(size,flags);
+x = kzalloc(size,flags);
 if (x == NULL) S
-memset(x, 0, size);
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h |    4 +---
 drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h   |    4 +---
 drivers/staging/comedi/drivers/icp_multi.h                 |    3 +--
 drivers/staging/dream/pmem.c                               |    5 +----
 drivers/staging/dream/smd/smd_rpcrouter.c                  |    9 +++------
 drivers/staging/go7007/go7007-fw.c                         |   12 ++++--------
 drivers/staging/go7007/go7007-usb.c                        |    3 +--
 drivers/staging/go7007/go7007-v4l2.c                       |    4 +---
 drivers/staging/go7007/saa7134-go7007.c                    |    3 +--
 drivers/staging/otus/zdusb.c                               |    5 +----
 drivers/staging/panel/panel.c                              |    3 +--
 drivers/staging/pohmelfs/config.c                          |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c      |    6 ++----
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c  |    3 +--
 drivers/staging/rtl8187se/ieee80211/ieee80211_module.c     |    7 ++-----
 drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c         |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c       |    6 ++----
 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c  |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c  |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c   |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_module.c      |    7 ++-----
 drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c     |    3 +--
 drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c          |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c      |    6 ++----
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c  |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_module.c     |    7 ++-----
 drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c    |    3 +--
 drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c         |    3 +--
 drivers/staging/rtl8192u/ieee80211/api.c                   |    4 +---
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c       |    6 ++----
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c  |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c  |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c   |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_module.c      |    7 ++-----
 drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c     |    3 +--
 drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c          |    3 +--
 drivers/staging/rtl8192u/r8192U_core.c                     |    4 +---
 drivers/staging/sm7xx/smtcfb.c                             |    4 +---
 drivers/staging/vme/bridges/vme_ca91cx42.c                 |    8 ++------
 drivers/staging/vme/bridges/vme_tsi148.c                   |    8 ++------
 drivers/staging/vt6655/hostap.c                            |    3 +--
 drivers/staging/vt6655/wpactl.c                            |    3 +--
 drivers/staging/vt6656/hostap.c                            |    3 +--
 drivers/staging/vt6656/wpactl.c                            |    3 +--
 drivers/staging/wlan-ng/p80211conv.c                       |    3 +--
 drivers/staging/wlan-ng/prism2fw.c                         |    3 +--
 50 files changed, 65 insertions(+), 148 deletions(-)

diff -u -p a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
--- a/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
+++ b/drivers/staging/comedi/drivers/addi-data/addi_amcc_s5933.h
@@ -260,12 +260,10 @@ void v_pci_card_list_init(unsigned short
 		for (i_Count = 0; i_Count < 2; i_Count++) {
 			pci_vendor = i_ADDIDATADeviceID[i_Count];
 			if (pcidev->vendor == pci_vendor) {
-				amcc = kmalloc(sizeof(*amcc), GFP_KERNEL);
+				amcc = kzalloc(sizeof(*amcc), GFP_KERNEL);
 				if (amcc == NULL)
 					continue;
 
-				memset(amcc, 0, sizeof(*amcc));
-
 				amcc->pcidev = pcidev;
 				if (last)
 					last->next = amcc;
diff -u -p a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h b/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
--- a/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
+++ b/drivers/staging/comedi/drivers/addi-data/amcc_s5933_58.h
@@ -253,12 +253,10 @@ void v_pci_card_list_init(unsigned short
 
 	pci_for_each_dev(pcidev) {
 		if (pcidev->vendor == pci_vendor) {
-			amcc = kmalloc(sizeof(*amcc), GFP_KERNEL);
+			amcc = kzalloc(sizeof(*amcc), GFP_KERNEL);
 			if (amcc == NULL)
 				continue;
 
-			memset(amcc, 0, sizeof(*amcc));
-
 			amcc->pcidev = pcidev;
 			if (last) {
 				last->next = amcc;
diff -u -p a/drivers/staging/comedi/drivers/icp_multi.h b/drivers/staging/comedi/drivers/icp_multi.h
--- a/drivers/staging/comedi/drivers/icp_multi.h
+++ b/drivers/staging/comedi/drivers/icp_multi.h
@@ -73,14 +73,13 @@ static void pci_card_list_init(unsigned 
 	     pcidev != NULL;
 	     pcidev = pci_get_device(PCI_ANY_ID, PCI_ANY_ID, pcidev)) {
 		if (pcidev->vendor == pci_vendor) {
-			inova = kmalloc(sizeof(*inova), GFP_KERNEL);
+			inova = kzalloc(sizeof(*inova), GFP_KERNEL);
 			if (!inova) {
 				printk
 				    ("icp_multi: pci_card_list_init: allocation failed\n");
 				pci_dev_put(pcidev);
 				break;
 			}
-			memset(inova, 0, sizeof(*inova));
 
 			inova->pcidev = pci_dev_get(pcidev);
 			if (last) {
diff -u -p a/drivers/staging/dream/smd/smd_rpcrouter.c b/drivers/staging/dream/smd/smd_rpcrouter.c
--- a/drivers/staging/dream/smd/smd_rpcrouter.c
+++ b/drivers/staging/dream/smd/smd_rpcrouter.c
@@ -172,11 +172,10 @@ static struct rr_server *rpcrouter_creat
 	unsigned long flags;
 	int rc;
 
-	server = kmalloc(sizeof(struct rr_server), GFP_KERNEL);
+	server = kzalloc(sizeof(struct rr_server), GFP_KERNEL);
 	if (!server)
 		return ERR_PTR(-ENOMEM);
 
-	memset(server, 0, sizeof(struct rr_server));
 	server->pid = pid;
 	server->cid = cid;
 	server->prog = prog;
@@ -249,10 +248,9 @@ struct msm_rpc_endpoint *msm_rpcrouter_c
 	struct msm_rpc_endpoint *ept;
 	unsigned long flags;
 
-	ept = kmalloc(sizeof(struct msm_rpc_endpoint), GFP_KERNEL);
+	ept = kzalloc(sizeof(struct msm_rpc_endpoint), GFP_KERNEL);
 	if (!ept)
 		return NULL;
-	memset(ept, 0, sizeof(struct msm_rpc_endpoint));
 
 	/* mark no reply outstanding */
 	ept->reply_pid = 0xffffffff;
@@ -319,10 +317,9 @@ static int rpcrouter_create_remote_endpo
 	struct rr_remote_endpoint *new_c;
 	unsigned long flags;
 
-	new_c = kmalloc(sizeof(struct rr_remote_endpoint), GFP_KERNEL);
+	new_c = kzalloc(sizeof(struct rr_remote_endpoint), GFP_KERNEL);
 	if (!new_c)
 		return -ENOMEM;
-	memset(new_c, 0, sizeof(struct rr_remote_endpoint));
 
 	new_c->cid = cid;
 	new_c->pid = RPCROUTER_PID_REMOTE;
diff -u -p a/drivers/staging/go7007/go7007-fw.c b/drivers/staging/go7007/go7007-fw.c
--- a/drivers/staging/go7007/go7007-fw.c
+++ b/drivers/staging/go7007/go7007-fw.c
@@ -380,13 +380,12 @@ static int gen_mjpeghdr_to_package(struc
 	unsigned int addr = 0x19;
 	int size = 0, i, off = 0, chunk;
 
-	buf = kmalloc(4096, GFP_KERNEL);
+	buf = kzalloc(4096, GFP_KERNEL);
 	if (buf == NULL) {
 		printk(KERN_ERR "go7007: unable to allocate 4096 bytes for "
 				"firmware construction\n");
 		return -1;
 	}
-	memset(buf, 0, 4096);
 
 	for (i = 1; i < 32; ++i) {
 		mjpeg_frame_header(go, buf + size, i);
@@ -651,13 +650,12 @@ static int gen_mpeg1hdr_to_package(struc
 	unsigned int addr = 0x19;
 	int i, off = 0, chunk;
 
-	buf = kmalloc(5120, GFP_KERNEL);
+	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL) {
 		printk(KERN_ERR "go7007: unable to allocate 5120 bytes for "
 				"firmware construction\n");
 		return -1;
 	}
-	memset(buf, 0, 5120);
 	framelen[0] = mpeg1_frame_header(go, buf, 0, 1, PFRAME);
 	if (go->interlace_coding)
 		framelen[0] += mpeg1_frame_header(go, buf + framelen[0] / 8,
@@ -839,13 +837,12 @@ static int gen_mpeg4hdr_to_package(struc
 	unsigned int addr = 0x19;
 	int i, off = 0, chunk;
 
-	buf = kmalloc(5120, GFP_KERNEL);
+	buf = kzalloc(5120, GFP_KERNEL);
 	if (buf == NULL) {
 		printk(KERN_ERR "go7007: unable to allocate 5120 bytes for "
 				"firmware construction\n");
 		return -1;
 	}
-	memset(buf, 0, 5120);
 	framelen[0] = mpeg4_frame_header(go, buf, 0, PFRAME);
 	i = 368;
 	framelen[1] = mpeg4_frame_header(go, buf + i, 0, BFRAME_PRE);
@@ -1585,13 +1582,12 @@ int go7007_construct_fw_image(struct go7
 			go->board_info->firmware);
 		return -1;
 	}
-	code = kmalloc(codespace * 2, GFP_KERNEL);
+	code = kzalloc(codespace * 2, GFP_KERNEL);
 	if (code == NULL) {
 		printk(KERN_ERR "go7007: unable to allocate %d bytes for "
 				"firmware construction\n", codespace * 2);
 		goto fw_failed;
 	}
-	memset(code, 0, codespace * 2);
 	src = (__le16 *)fw_entry->data;
 	srclen = fw_entry->size / 2;
 	while (srclen >= 2) {
diff -u -p a/drivers/staging/go7007/go7007-usb.c b/drivers/staging/go7007/go7007-usb.c
--- a/drivers/staging/go7007/go7007-usb.c
+++ b/drivers/staging/go7007/go7007-usb.c
@@ -670,10 +670,9 @@ static int go7007_usb_onboard_write_inte
 		"go7007-usb: WriteInterrupt: %04x %04x\n", addr, data);
 #endif
 
-	tbuf = kmalloc(8, GFP_KERNEL);
+	tbuf = kzalloc(8, GFP_KERNEL);
 	if (tbuf == NULL)
 		return -ENOMEM;
-	memset(tbuf, 0, 8);
 	tbuf[0] = data & 0xff;
 	tbuf[1] = data >> 8;
 	tbuf[2] = addr & 0xff;
diff -u -p a/drivers/staging/go7007/go7007-v4l2.c b/drivers/staging/go7007/go7007-v4l2.c
--- a/drivers/staging/go7007/go7007-v4l2.c
+++ b/drivers/staging/go7007/go7007-v4l2.c
@@ -720,7 +720,7 @@ static int vidioc_reqbufs(struct file *f
 		if (count > 32)
 			count = 32;
 
-		gofh->bufs = kmalloc(count * sizeof(struct go7007_buffer),
+		gofh->bufs = kcalloc(count, sizeof(struct go7007_buffer),
 				     GFP_KERNEL);
 
 		if (!gofh->bufs) {
@@ -728,8 +728,6 @@ static int vidioc_reqbufs(struct file *f
 			goto unlock_and_return;
 		}
 
-		memset(gofh->bufs, 0, count * sizeof(struct go7007_buffer));
-
 		for (i = 0; i < count; ++i) {
 			gofh->bufs[i].go = go;
 			gofh->bufs[i].index = i;
diff -u -p a/drivers/staging/go7007/saa7134-go7007.c b/drivers/staging/go7007/saa7134-go7007.c
--- a/drivers/staging/go7007/saa7134-go7007.c
+++ b/drivers/staging/go7007/saa7134-go7007.c
@@ -440,10 +440,9 @@ static int saa7134_go7007_init(struct sa
 
 	printk(KERN_DEBUG "saa7134-go7007: probing new SAA713X board\n");
 
-	saa = kmalloc(sizeof(struct saa7134_go7007), GFP_KERNEL);
+	saa = kzalloc(sizeof(struct saa7134_go7007), GFP_KERNEL);
 	if (saa == NULL)
 		return -ENOMEM;
-	memset(saa, 0, sizeof(struct saa7134_go7007));
 
 	/* Allocate a couple pages for receiving the compressed stream */
 	saa->top = (u8 *)get_zeroed_page(GFP_KERNEL);
diff -u -p a/drivers/staging/otus/zdusb.c b/drivers/staging/otus/zdusb.c
--- a/drivers/staging/otus/zdusb.c
+++ b/drivers/staging/otus/zdusb.c
@@ -95,7 +95,7 @@ static int zfLnxProbe(struct usb_interfa
         printk(KERN_NOTICE "USB 1.1 Host\n");
 #endif
 
-    macp = kmalloc(sizeof(struct usbdrv_private), GFP_KERNEL);
+    macp = kzalloc(sizeof(struct usbdrv_private), GFP_KERNEL);
     if (!macp)
     {
         printk(KERN_ERR "out of memory allocating device structure\n");
@@ -103,9 +103,6 @@ static int zfLnxProbe(struct usb_interfa
         goto fail;
     }
 
-    /* Zero the memory */
-    memset(macp, 0, sizeof(struct usbdrv_private));
-
     net = alloc_etherdev(0);
 
     if (net == NULL)
diff -u -p a/drivers/staging/panel/panel.c b/drivers/staging/panel/panel.c
--- a/drivers/staging/panel/panel.c
+++ b/drivers/staging/panel/panel.c
@@ -1906,12 +1906,11 @@ static struct logical_input *panel_bind_
 {
 	struct logical_input *key;
 
-	key = kmalloc(sizeof(struct logical_input), GFP_KERNEL);
+	key = kzalloc(sizeof(struct logical_input), GFP_KERNEL);
 	if (!key) {
 		printk(KERN_ERR "panel: not enough memory\n");
 		return NULL;
 	}
-	memset(key, 0, sizeof(struct logical_input));
 	if (!input_name2mask(name, &key->mask, &key->value, &scan_mask_i,
 			     &scan_mask_o))
 		return NULL;
diff -u -p a/drivers/staging/pohmelfs/config.c b/drivers/staging/pohmelfs/config.c
--- a/drivers/staging/pohmelfs/config.c
+++ b/drivers/staging/pohmelfs/config.c
@@ -238,11 +238,10 @@ static int pohmelfs_send_reply(int err, 
 {
 	struct pohmelfs_cn_ack *ack;
 
-	ack = kmalloc(sizeof(struct pohmelfs_cn_ack), GFP_KERNEL);
+	ack = kzalloc(sizeof(struct pohmelfs_cn_ack), GFP_KERNEL);
 	if (!ack)
 		return -ENOMEM;
 
-	memset(ack, 0, sizeof(struct pohmelfs_cn_ack));
 	memcpy(&ack->msg, msg, sizeof(struct cn_msg));
 
 	if (action == POHMELFS_CTLINFO_ACK)
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt.c
@@ -109,11 +109,10 @@ int ieee80211_register_crypto_ops(struct
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -207,11 +206,10 @@ int ieee80211_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_ccmp.c
@@ -69,10 +69,9 @@ static void * ieee80211_ccmp_init(int ke
 {
 	struct ieee80211_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_tkip.c
@@ -70,10 +70,9 @@ static void * ieee80211_tkip_init(int ke
 {
 	struct ieee80211_tkip_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_crypt_wep.c
@@ -45,10 +45,9 @@ static void * prism2_wep_init(int keyidx
 {
 	struct prism2_wep_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = keyidx;
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
 	if (IS_ERR(priv->tx_tfm)) {
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_module.c
@@ -66,8 +66,8 @@ static inline int ieee80211_networks_all
 	if (ieee->networks)
 		return 0;
 
-	ieee->networks = kmalloc(
-		MAX_NETWORK_COUNT * sizeof(struct ieee80211_network),
+	ieee->networks = kcalloc(
+		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
@@ -75,9 +75,6 @@ static inline int ieee80211_networks_all
 		return -ENOMEM;
 	}
 
-	memset(ieee->networks, 0,
-	       MAX_NETWORK_COUNT * sizeof(struct ieee80211_network));
-
 	return 0;
 }
 
diff -u -p a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_wx.c
@@ -325,11 +325,10 @@ int ieee80211_wx_set_encode(struct ieee8
 		struct ieee80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops)
 			new_crypt->ops = ieee80211_get_crypto_ops("WEP");
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt.c
@@ -109,11 +109,10 @@ int ieee80211_register_crypto_ops(struct
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -207,11 +206,10 @@ int __init ieee80211_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_ccmp.c
@@ -96,10 +96,9 @@ static void * ieee80211_ccmp_init(int ke
 {
 	struct ieee80211_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 #if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_tkip.c
@@ -87,10 +87,9 @@ static void * ieee80211_tkip_init(int ke
 {
 	struct ieee80211_tkip_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 #if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
 	priv->tx_tfm_arc4 = crypto_alloc_tfm("arc4", 0);
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_crypt_wep.c
@@ -71,10 +71,9 @@ static void * prism2_wep_init(int keyidx
 {
 	struct prism2_wep_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = keyidx;
 
 #if((LINUX_VERSION_CODE < KERNEL_VERSION(2,6,21)) && (!OPENSUSE_SLED))
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
@@ -65,8 +65,8 @@ static inline int ieee80211_networks_all
 	if (ieee->networks)
 		return 0;
 
-	ieee->networks = kmalloc(
-		MAX_NETWORK_COUNT * sizeof(struct ieee80211_network),
+	ieee->networks = kcalloc(
+		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
@@ -74,9 +74,6 @@ static inline int ieee80211_networks_all
 		return -ENOMEM;
 	}
 
-	memset(ieee->networks, 0,
-	       MAX_NETWORK_COUNT * sizeof(struct ieee80211_network));
-
 	return 0;
 }
 
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
@@ -3079,10 +3079,9 @@ void ieee80211_softmac_init(struct ieee8
 	  ieee->seq_ctrl[i] = 0;
 	}
 #ifdef ENABLE_DOT11D
-	ieee->pDot11dInfo = kmalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
+	ieee->pDot11dInfo = kzalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for DOT11D\n");
-	memset(ieee->pDot11dInfo, 0, sizeof(RT_DOT11D_INFO));
 #endif
 	//added for  AP roaming
 	ieee->LinkDetectInfo.SlotNum = 2;
diff -u -p a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_wx.c
@@ -477,11 +477,10 @@ int ieee80211_wx_set_encode(struct ieee8
 		struct ieee80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops)
 			new_crypt->ops = ieee80211_get_crypto_ops("WEP");
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt.c
@@ -109,11 +109,10 @@ int ieee80211_register_crypto_ops(struct
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -206,11 +205,10 @@ int __init ieee80211_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_ccmp.c
@@ -68,10 +68,9 @@ static void * ieee80211_ccmp_init(int ke
 {
 	struct ieee80211_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tfm = (void *)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_tkip.c
@@ -67,10 +67,9 @@ static void * ieee80211_tkip_init(int ke
 {
 	struct ieee80211_tkip_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_crypt_wep.c
@@ -43,10 +43,9 @@ static void * prism2_wep_init(int keyidx
 {
 	struct prism2_wep_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = keyidx;
 
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
@@ -65,8 +65,8 @@ static inline int ieee80211_networks_all
 	if (ieee->networks)
 		return 0;
 
-	ieee->networks = kmalloc(
-		MAX_NETWORK_COUNT * sizeof(struct ieee80211_network),
+	ieee->networks = kcalloc(
+		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
@@ -74,9 +74,6 @@ static inline int ieee80211_networks_all
 		return -ENOMEM;
 	}
 
-	memset(ieee->networks, 0,
-	       MAX_NETWORK_COUNT * sizeof(struct ieee80211_network));
-
 	return 0;
 }
 
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
@@ -2699,10 +2699,9 @@ void ieee80211_softmac_init(struct ieee8
 	for(i = 0; i < 5; i++) {
 	  ieee->seq_ctrl[i] = 0;
 	}
-	ieee->pDot11dInfo = kmalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
+	ieee->pDot11dInfo = kzalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for DOT11D\n");
-	memset(ieee->pDot11dInfo, 0, sizeof(RT_DOT11D_INFO));
 	//added for  AP roaming
 	ieee->LinkDetectInfo.SlotNum = 2;
 	ieee->LinkDetectInfo.NumRecvBcnInPeriod=0;
diff -u -p a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_wx.c
@@ -352,11 +352,10 @@ int ieee80211_wx_set_encode(struct ieee8
 		struct ieee80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops)
 			new_crypt->ops = ieee80211_get_crypto_ops("WEP");
diff -u -p a/drivers/staging/rtl8192u/ieee80211/api.c b/drivers/staging/rtl8192u/ieee80211/api.c
--- a/drivers/staging/rtl8192u/ieee80211/api.c
+++ b/drivers/staging/rtl8192u/ieee80211/api.c
@@ -131,12 +131,10 @@ struct crypto_tfm *crypto_alloc_tfm(cons
 	if (alg == NULL)
 		goto out;
 
-	tfm = kmalloc(sizeof(*tfm) + alg->cra_ctxsize, GFP_KERNEL);
+	tfm = kzalloc(sizeof(*tfm) + alg->cra_ctxsize, GFP_KERNEL);
 	if (tfm == NULL)
 		goto out_put;
 
-	memset(tfm, 0, sizeof(*tfm) + alg->cra_ctxsize);
-
 	tfm->__crt_alg = alg;
 
 	if (crypto_init_flags(tfm, flags))
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt.c
@@ -109,11 +109,10 @@ int ieee80211_register_crypto_ops(struct
 	if (hcrypt == NULL)
 		return -1;
 
-	alg = kmalloc(sizeof(*alg), GFP_KERNEL);
+	alg = kzalloc(sizeof(*alg), GFP_KERNEL);
 	if (alg == NULL)
 		return -ENOMEM;
 
-	memset(alg, 0, sizeof(*alg));
 	alg->ops = ops;
 
 	spin_lock_irqsave(&hcrypt->lock, flags);
@@ -206,11 +205,10 @@ int __init ieee80211_crypto_init(void)
 {
 	int ret = -ENOMEM;
 
-	hcrypt = kmalloc(sizeof(*hcrypt), GFP_KERNEL);
+	hcrypt = kzalloc(sizeof(*hcrypt), GFP_KERNEL);
 	if (!hcrypt)
 		goto out;
 
-	memset(hcrypt, 0, sizeof(*hcrypt));
 	INIT_LIST_HEAD(&hcrypt->algs);
 	spin_lock_init(&hcrypt->lock);
 
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_ccmp.c
@@ -68,10 +68,9 @@ static void * ieee80211_ccmp_init(int ke
 {
 	struct ieee80211_ccmp_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
        priv->tfm = (void*)crypto_alloc_cipher("aes", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_tkip.c
@@ -67,10 +67,9 @@ static void * ieee80211_tkip_init(int ke
 {
 	struct ieee80211_tkip_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = key_idx;
 
 	priv->tx_tfm_arc4 = crypto_alloc_blkcipher("ecb(arc4)", 0,
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_crypt_wep.c
@@ -43,10 +43,9 @@ static void * prism2_wep_init(int keyidx
 {
 	struct prism2_wep_data *priv;
 
-	priv = kmalloc(sizeof(*priv), GFP_ATOMIC);
+	priv = kzalloc(sizeof(*priv), GFP_ATOMIC);
 	if (priv == NULL)
 		goto fail;
-	memset(priv, 0, sizeof(*priv));
 	priv->key_idx = keyidx;
 
 	priv->tx_tfm = crypto_alloc_blkcipher("ecb(arc4)", 0, CRYPTO_ALG_ASYNC);
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_module.c
@@ -65,8 +65,8 @@ static inline int ieee80211_networks_all
 	if (ieee->networks)
 		return 0;
 
-	ieee->networks = kmalloc(
-		MAX_NETWORK_COUNT * sizeof(struct ieee80211_network),
+	ieee->networks = kcalloc(
+		MAX_NETWORK_COUNT, sizeof(struct ieee80211_network),
 		GFP_KERNEL);
 	if (!ieee->networks) {
 		printk(KERN_WARNING "%s: Out of memory allocating beacons\n",
@@ -74,9 +74,6 @@ static inline int ieee80211_networks_all
 		return -ENOMEM;
 	}
 
-	memset(ieee->networks, 0,
-	       MAX_NETWORK_COUNT * sizeof(struct ieee80211_network));
-
 	return 0;
 }
 
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c
@@ -2723,10 +2723,9 @@ void ieee80211_softmac_init(struct ieee8
 	  ieee->seq_ctrl[i] = 0;
 	}
 #ifdef ENABLE_DOT11D
-	ieee->pDot11dInfo = kmalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
+	ieee->pDot11dInfo = kzalloc(sizeof(RT_DOT11D_INFO), GFP_ATOMIC);
 	if (!ieee->pDot11dInfo)
 		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for DOT11D\n");
-	memset(ieee->pDot11dInfo, 0, sizeof(RT_DOT11D_INFO));
 #endif
 	//added for  AP roaming
 	ieee->LinkDetectInfo.SlotNum = 2;
diff -u -p a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
--- a/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
+++ b/drivers/staging/rtl8192u/ieee80211/ieee80211_wx.c
@@ -379,11 +379,10 @@ int ieee80211_wx_set_encode(struct ieee8
 		struct ieee80211_crypt_data *new_crypt;
 
 		/* take WEP into use */
-		new_crypt = kmalloc(sizeof(struct ieee80211_crypt_data),
+		new_crypt = kzalloc(sizeof(struct ieee80211_crypt_data),
 				    GFP_KERNEL);
 		if (new_crypt == NULL)
 			return -ENOMEM;
-		memset(new_crypt, 0, sizeof(struct ieee80211_crypt_data));
 		new_crypt->ops = ieee80211_get_crypto_ops("WEP");
 		if (!new_crypt->ops) {
 			request_module("ieee80211_crypt_wep");
diff -u -p a/drivers/staging/rtl8192u/r8192U_core.c b/drivers/staging/rtl8192u/r8192U_core.c
--- a/drivers/staging/rtl8192u/r8192U_core.c
+++ b/drivers/staging/rtl8192u/r8192U_core.c
@@ -2251,13 +2251,11 @@ short rtl8192_usb_initendpoints(struct n
 #endif
 
 	memset(priv->rx_urb, 0, sizeof(struct urb*) * MAX_RX_URB);
-	priv->pp_rxskb = kmalloc(sizeof(struct sk_buff *) * MAX_RX_URB,
+	priv->pp_rxskb = kcalloc(MAX_RX_URB, sizeof(struct sk_buff *),
 				 GFP_KERNEL);
 	if (priv->pp_rxskb == NULL)
 		goto destroy;
 
-	memset(priv->pp_rxskb, 0, sizeof(struct sk_buff*) * MAX_RX_URB);
-
 	goto _middle;
 
 
diff -u -p a/drivers/staging/sm7xx/smtcfb.c b/drivers/staging/sm7xx/smtcfb.c
--- a/drivers/staging/sm7xx/smtcfb.c
+++ b/drivers/staging/sm7xx/smtcfb.c
@@ -688,13 +688,11 @@ static struct smtcfb_info *smtc_alloc_fb
 {
 	struct smtcfb_info *sfb;
 
-	sfb = kmalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
+	sfb = kzalloc(sizeof(struct smtcfb_info), GFP_KERNEL);
 
 	if (!sfb)
 		return NULL;
 
-	memset(sfb, 0, sizeof(struct smtcfb_info));
-
 	sfb->currcon = -1;
 	sfb->dev = dev;
 
diff -u -p a/drivers/staging/vme/bridges/vme_ca91cx42.c b/drivers/staging/vme/bridges/vme_ca91cx42.c
--- a/drivers/staging/vme/bridges/vme_ca91cx42.c
+++ b/drivers/staging/vme/bridges/vme_ca91cx42.c
@@ -1494,7 +1494,7 @@ static int ca91cx42_probe(struct pci_dev
 	/* We want to support more than one of each bridge so we need to
 	 * dynamically allocate the bridge structure
 	 */
-	ca91cx42_bridge = kmalloc(sizeof(struct vme_bridge), GFP_KERNEL);
+	ca91cx42_bridge = kzalloc(sizeof(struct vme_bridge), GFP_KERNEL);
 
 	if (ca91cx42_bridge == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for device "
@@ -1503,9 +1503,7 @@ static int ca91cx42_probe(struct pci_dev
 		goto err_struct;
 	}
 
-	memset(ca91cx42_bridge, 0, sizeof(struct vme_bridge));
-
-	ca91cx42_device = kmalloc(sizeof(struct ca91cx42_driver), GFP_KERNEL);
+	ca91cx42_device = kzalloc(sizeof(struct ca91cx42_driver), GFP_KERNEL);
 
 	if (ca91cx42_device == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for device "
@@ -1514,8 +1512,6 @@ static int ca91cx42_probe(struct pci_dev
 		goto err_driver;
 	}
 
-	memset(ca91cx42_device, 0, sizeof(struct ca91cx42_driver));
-
 	ca91cx42_bridge->driver_priv = ca91cx42_device;
 
 	/* Enable the device */
diff -u -p a/drivers/staging/vme/bridges/vme_tsi148.c b/drivers/staging/vme/bridges/vme_tsi148.c
--- a/drivers/staging/vme/bridges/vme_tsi148.c
+++ b/drivers/staging/vme/bridges/vme_tsi148.c
@@ -2230,7 +2230,7 @@ static int tsi148_probe(struct pci_dev *
 	/* If we want to support more than one of each bridge, we need to
 	 * dynamically generate this so we get one per device
 	 */
-	tsi148_bridge = kmalloc(sizeof(struct vme_bridge), GFP_KERNEL);
+	tsi148_bridge = kzalloc(sizeof(struct vme_bridge), GFP_KERNEL);
 	if (tsi148_bridge == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for device "
 			"structure\n");
@@ -2238,9 +2238,7 @@ static int tsi148_probe(struct pci_dev *
 		goto err_struct;
 	}
 
-	memset(tsi148_bridge, 0, sizeof(struct vme_bridge));
-
-	tsi148_device = kmalloc(sizeof(struct tsi148_driver), GFP_KERNEL);
+	tsi148_device = kzalloc(sizeof(struct tsi148_driver), GFP_KERNEL);
 	if (tsi148_device == NULL) {
 		dev_err(&pdev->dev, "Failed to allocate memory for device "
 			"structure\n");
@@ -2248,8 +2246,6 @@ static int tsi148_probe(struct pci_dev *
 		goto err_driver;
 	}
 
-	memset(tsi148_device, 0, sizeof(struct tsi148_driver));
-
 	tsi148_bridge->driver_priv = tsi148_device;
 
 	/* Enable the device */
diff -u -p a/drivers/staging/vt6655/hostap.c b/drivers/staging/vt6655/hostap.c
--- a/drivers/staging/vt6655/hostap.c
+++ b/drivers/staging/vt6655/hostap.c
@@ -90,10 +90,9 @@ static int hostap_enable_hostapd(PSDevic
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Enabling hostapd mode\n", dev->name);
 
-	pDevice->apdev = kmalloc(sizeof(struct net_device), GFP_KERNEL);
+	pDevice->apdev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
 	if (pDevice->apdev == NULL)
 		return -ENOMEM;
-	memset(pDevice->apdev, 0, sizeof(struct net_device));
 
     apdev_priv = netdev_priv(pDevice->apdev);
     *apdev_priv = *pDevice;
diff -u -p a/drivers/staging/vt6655/wpactl.c b/drivers/staging/vt6655/wpactl.c
--- a/drivers/staging/vt6655/wpactl.c
+++ b/drivers/staging/vt6655/wpactl.c
@@ -681,13 +681,12 @@ static int wpa_get_scan(PSDevice pDevice
         count++;
     };
 
-    pBuf = kmalloc(sizeof(struct viawget_scan_result) * count, (int)GFP_ATOMIC);
+    pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
 
     if (pBuf == NULL) {
         ret = -ENOMEM;
         return ret;
     }
-   	memset(pBuf, 0, sizeof(struct viawget_scan_result) * count);
     scan_buf = (struct viawget_scan_result *)pBuf;
 	pBSS = &(pMgmt->sBSSList[0]);
     for (ii = 0, jj = 0; ii < MAX_BSS_NUM ; ii++) {
diff -u -p a/drivers/staging/vt6656/hostap.c b/drivers/staging/vt6656/hostap.c
--- a/drivers/staging/vt6656/hostap.c
+++ b/drivers/staging/vt6656/hostap.c
@@ -91,10 +91,9 @@ static int hostap_enable_hostapd(PSDevic
 
     DBG_PRT(MSG_LEVEL_DEBUG, KERN_INFO "%s: Enabling hostapd mode\n", dev->name);
 
-	pDevice->apdev = kmalloc(sizeof(struct net_device), GFP_KERNEL);
+	pDevice->apdev = kzalloc(sizeof(struct net_device), GFP_KERNEL);
 	if (pDevice->apdev == NULL)
 		return -ENOMEM;
-	memset(pDevice->apdev, 0, sizeof(struct net_device));
 
     apdev_priv = netdev_priv(pDevice->apdev);
     *apdev_priv = *pDevice;
diff -u -p a/drivers/staging/vt6656/wpactl.c b/drivers/staging/vt6656/wpactl.c
--- a/drivers/staging/vt6656/wpactl.c
+++ b/drivers/staging/vt6656/wpactl.c
@@ -678,13 +678,12 @@ static int wpa_get_scan(PSDevice pDevice
         count++;
     };
 
-    pBuf = kmalloc(sizeof(struct viawget_scan_result) * count, (int)GFP_ATOMIC);
+    pBuf = kcalloc(count, sizeof(struct viawget_scan_result), (int)GFP_ATOMIC);
 
     if (pBuf == NULL) {
         ret = -ENOMEM;
         return ret;
     }
-   	memset(pBuf, 0, sizeof(struct viawget_scan_result) * count);
     scan_buf = (struct viawget_scan_result *)pBuf;
 	pBSS = &(pMgmt->sBSSList[0]);
     for (ii = 0, jj = 0; ii < MAX_BSS_NUM ; ii++) {
diff -u -p a/drivers/staging/wlan-ng/p80211conv.c b/drivers/staging/wlan-ng/p80211conv.c
--- a/drivers/staging/wlan-ng/p80211conv.c
+++ b/drivers/staging/wlan-ng/p80211conv.c
@@ -601,7 +601,7 @@ int p80211skb_rxmeta_attach(struct wland
 	}
 
 	/* Allocate the rxmeta */
-	rxmeta = kmalloc(sizeof(p80211_rxmeta_t), GFP_ATOMIC);
+	rxmeta = kzalloc(sizeof(p80211_rxmeta_t), GFP_ATOMIC);
 
 	if (rxmeta == NULL) {
 		printk(KERN_ERR "%s: Failed to allocate rxmeta.\n",
@@ -611,7 +611,6 @@ int p80211skb_rxmeta_attach(struct wland
 	}
 
 	/* Initialize the rxmeta */
-	memset(rxmeta, 0, sizeof(p80211_rxmeta_t));
 	rxmeta->wlandev = wlandev;
 	rxmeta->hosttime = jiffies;
 
diff -u -p a/drivers/staging/wlan-ng/prism2fw.c b/drivers/staging/wlan-ng/prism2fw.c
--- a/drivers/staging/wlan-ng/prism2fw.c
+++ b/drivers/staging/wlan-ng/prism2fw.c
@@ -536,13 +536,12 @@ int mkimage(imgchunk_t *clist, unsigned 
 
 	/* Allocate buffer space for chunks */
 	for (i = 0; i < *ccnt; i++) {
-		clist[i].data = kmalloc(clist[i].len, GFP_KERNEL);
+		clist[i].data = kzalloc(clist[i].len, GFP_KERNEL);
 		if (clist[i].data == NULL) {
 			printk(KERN_ERR
 			       "failed to allocate image space, exitting.\n");
 			return 1;
 		}
-		memset(clist[i].data, 0, clist[i].len);
 		pr_debug("chunk[%d]: addr=0x%06x len=%d\n",
 			 i, clist[i].addr, clist[i].len);
 	}
diff --git a/drivers/staging/dream/pmem.c b/drivers/staging/dream/pmem.c
--- a/drivers/staging/dream/pmem.c
+++ b/drivers/staging/dream/pmem.c
@@ -1245,14 +1245,11 @@ int pmem_setup(struct android_pmem_platform_data *pdata,
 	}
 	pmem[id].num_entries = pmem[id].size / PMEM_MIN_ALLOC;
 
-	pmem[id].bitmap = kmalloc(pmem[id].num_entries *
+	pmem[id].bitmap = kcalloc(pmem[id].num_entries,
 				  sizeof(struct pmem_bits), GFP_KERNEL);
 	if (!pmem[id].bitmap)
 		goto err_no_mem_for_metadata;
 
-	memset(pmem[id].bitmap, 0, sizeof(struct pmem_bits) *
-					  pmem[id].num_entries);
-
 	for (i = sizeof(pmem[id].num_entries) * 8 - 1; i >= 0; i--) {
 		if ((pmem[id].num_entries) &  1<<i) {
 			PMEM_ORDER(id, index) = i;
