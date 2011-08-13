Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1HMA3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 20:29:10 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:64949 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753650Ab1HMA1o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 20:27:44 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 04/10]drivers:atm Remove pointless "@" from various parts of the kernel
Date: Fri, 12 Aug 2011 17:27:09 -0700
Message-Id: <1313195235-4522-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
References: <1313195235-4522-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

The patch series below removes some pointless "@"'s in various parts of the kernel.
Note: some might be useful, but then again, some just seemed a waste of space.
(and since the kernel is become bloated, might as well diet! even if it's a few bits)

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/atm/atmtcp.c  |    2 +-
 drivers/atm/eni.c     |   16 ++++++++--------
 drivers/atm/horizon.c |    2 +-
 drivers/atm/iphase.c  |    2 +-
 drivers/atm/zatm.c    |   23 +++++++++++------------
 5 files changed, 22 insertions(+), 23 deletions(-)

diff --git a/drivers/atm/atmtcp.c b/drivers/atm/atmtcp.c
index b22d71c..63237bf 100644
--- a/drivers/atm/atmtcp.c
+++ b/drivers/atm/atmtcp.c
@@ -409,7 +409,7 @@ static int atmtcp_attach(struct atm_vcc *vcc,int itf)
 	set_bit(ATM_VF_META,&vcc->flags);
 	set_bit(ATM_VF_READY,&vcc->flags);
 	vcc->dev_data = dev;
-	(void) atm_init_aal5(vcc); /* @@@ losing AAL in transit ... */
+	(void) atm_init_aal5(vcc); /* losing AAL in transit... */
 	vcc->stats = &atmtcp_control_dev.stats.aal5;
 	return dev->number;
 }
diff --git a/drivers/atm/eni.c b/drivers/atm/eni.c
index 9307141..3921c8eb 100644
--- a/drivers/atm/eni.c
+++ b/drivers/atm/eni.c
@@ -370,7 +370,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 		ATM_SKB(skb)->vcc = vcc;
 	}
 	j = 0;
-	if ((eff && skip) || 1) { /* @@@ actually, skip is always == 1 ... */
+	if ((eff && skip) || 1) { /* actually, skip is always == 1... */
 		here = (eni_vcc->descr+skip) & (eni_vcc->words-1);
 		dma[j++] = (here << MID_DMA_COUNT_SHIFT) | (vcc->vci
 		    << MID_DMA_VCI_SHIFT) | MID_DT_JK;
@@ -461,7 +461,7 @@ static int do_rx_dma(struct atm_vcc *vcc,struct sk_buff *skb,
 	 * Can I move the dma_wr pointer by 2j+1 positions without overwriting
 	 * data that hasn't been read (position of dma_rd) yet ?
 	 */
-	if (!NEPMOK(dma_wr,j+j+1,dma_rd,NR_DMA_RX)) { /* @@@ +1 is ugly */
+	if (!NEPMOK(dma_wr,j+j+1,dma_rd,NR_DMA_RX)) { /* +1 is ugly */
 		printk(KERN_WARNING DEV_LABEL "(itf %d): RX DMA full\n",
 		    vcc->dev->number);
 		goto trouble;
@@ -694,7 +694,7 @@ static void get_service(struct atm_dev *dev)
 			printk(KERN_CRIT DEV_LABEL "(itf %d): VCI %ld not "
 			    "found\n",dev->number,vci);
 			continue; /* nasty but we try to go on anyway */
-			/* @@@ nope, doesn't work */
+			/* nope, doesn't work */
 		}
 		EVENT("getting from service\n",0,0);
 		if (ENI_VCC(vcc)->next != ENI_VCC_NOS) {
@@ -1126,7 +1126,7 @@ DPRINTK("iovcnt = %d\n",skb_shinfo(skb)->nr_frags);
 		if (aal5) put_dma(tx->index,eni_dev->dma,&j,paddr,skb->len);
 		else put_dma(tx->index,eni_dev->dma,&j,paddr+4,skb->len-4);
 	else {
-DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
+DPRINTK("doing direct send\n"); /* well, this doesn't work anyway */
 		for (i = -1; i < skb_shinfo(skb)->nr_frags; i++)
 			if (i == -1)
 				put_dma(tx->index,eni_dev->dma,&j,(unsigned long)
@@ -1150,7 +1150,7 @@ DPRINTK("doing direct send\n"); /* @@@ well, this doesn't work anyway */
 	    (aal5 ? MID_SEG_AAL5 : 0) | (tx->prescaler << MID_SEG_PR_SHIFT) |
 	    (tx->resolution << MID_SEG_RATE_SHIFT) |
 	    (size/(ATM_CELL_PAYLOAD/4)),tx->send+tx->tx_pos*4);
-/*printk("dsc = 0x%08lx\n",(unsigned long) readl(tx->send+tx->tx_pos*4));*/
+	/*printk("dsc = 0x%08lx\n",(unsigned long) readl(tx->send+tx->tx_pos*4));*/
 	writel((vcc->vci << MID_SEG_VCI_SHIFT) |
             (aal5 ? 0 : (skb->data[3] & 0xf)) |
 	    (ATM_SKB(skb)->atm_options & ATM_ATMOPT_CLP ? MID_SEG_CLP : 0),
@@ -1728,7 +1728,7 @@ static int __devinit eni_do_init(struct atm_dev *dev)
 		return error;
 	}
 	eni_dev->base_diff = real_base - (unsigned long) base;
-	/* id may not be present in ASIC Tonga boards - check this @@@ */
+	/* id may not be present in ASIC Tonga boards - check this */
 	if (!eni_dev->asic) {
 		eprom = (base+EPROM_SIZE-sizeof(struct midway_eprom));
 		if (readl(&eprom->magic) != ENI155_MAGIC) {
@@ -1936,7 +1936,7 @@ static int eni_open(struct atm_vcc *vcc)
 		return error;
 	}
 	set_bit(ATM_VF_READY,&vcc->flags);
-	/* should power down SUNI while !ref_count @@@ */
+	/* should power down SUNI while !ref_count */
 	return 0;
 }
 
@@ -2300,6 +2300,6 @@ static int __init eni_init(void)
 
 
 module_init(eni_init);
-/* @@@ since exit routine not defined, this module can not be unloaded */
+/* since exit routine not defined, this module can not be unloaded */
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/atm/horizon.c b/drivers/atm/horizon.c
index b812103..5f78419 100644
--- a/drivers/atm/horizon.c
+++ b/drivers/atm/horizon.c
@@ -1729,7 +1729,7 @@ static int hrz_send (struct atm_vcc * atm_vcc, struct sk_buff * skb) {
     if (tx_iovcnt) {
       // scatter gather transfer
       dev->tx_regions = tx_iovcnt;
-      dev->tx_iovec = NULL;		/* @@@ needs rewritten */
+      dev->tx_iovec = NULL;		/* needs rewritten */
       dev->tx_bytes = 0;
       PRINTD (DBG_TX|DBG_BUS, "TX start scatter-gather transfer (iovec %p, len %d)",
 	      skb->data, tx_len);
diff --git a/drivers/atm/iphase.c b/drivers/atm/iphase.c
index cb90f7a..2794343 100644
--- a/drivers/atm/iphase.c
+++ b/drivers/atm/iphase.c
@@ -2482,7 +2482,7 @@ static int __devinit ia_start(struct atm_dev *dev)
 		error = -EAGAIN;
 		goto err_out;
         }  
-        /* @@@ should release IRQ on error */  
+        /* should release IRQ on error */  
 	/* enabling memory + master */  
         if ((error = pci_write_config_word(iadev->pci,   
 				PCI_COMMAND,   
diff --git a/drivers/atm/zatm.c b/drivers/atm/zatm.c
index d889f56..8d975b7 100644
--- a/drivers/atm/zatm.c
+++ b/drivers/atm/zatm.c
@@ -544,7 +544,7 @@ static int open_rx_second(struct atm_vcc *vcc)
 	zatm_vcc = ZATM_VCC(vcc);
 	if (!zatm_vcc->rx_chan) return 0;
 	spin_lock_irqsave(&zatm_dev->lock, flags);
-	/* should also handle VPI @@@ */
+	/* should also handle VPI */
 	pos = vcc->vci >> 1;
 	shift = (1-(vcc->vci & 1)) << 4;
 	zpokel(zatm_dev,(zpeekl(zatm_dev,pos) & ~(0xffff << shift)) |
@@ -677,7 +677,7 @@ printk("NONONONOO!!!!\n");
 				dev_kfree_skb_irq(skb);
 			return -EAGAIN;
 		}
-		/* @@@ should check alignment */
+		/* should check alignment */
 		put = dsc+8;
 		dsc[0] = uPD98401_TXPD_V | uPD98401_TXPD_DP |
 		    (vcc->aal == ATM_AAL5 ? uPD98401_TXPD_AAL5 : 0 |
@@ -720,10 +720,10 @@ static inline void dequeue_tx(struct atm_vcc *vcc)
 		    "txing\n",vcc->dev->number);
 		return;
 	}
-#if 0 /* @@@ would fail on CLP */
-if (*ZATM_PRV_DSC(skb) != (uPD98401_TXPD_V | uPD98401_TXPD_DP |
-  uPD98401_TXPD_SM | uPD98401_TXPD_AAL5)) printk("@#*$!!!!  (%08x)\n",
-  *ZATM_PRV_DSC(skb));
+#if 0 /* would fail on CLP */
+	if (*ZATM_PRV_DSC(skb) != (uPD98401_TXPD_V | uPD98401_TXPD_DP |
+  		uPD98401_TXPD_SM | uPD98401_TXPD_AAL5)) printk("@#*$!!!!  (%08x)\n",
+  		*ZATM_PRV_DSC(skb));
 #endif
 	*ZATM_PRV_DSC(skb) = 0; /* mark as invalid */
 	zatm_vcc->txing--;
@@ -831,7 +831,7 @@ static int alloc_shaper(struct atm_dev *dev,int *pcr,int min,int max,int ubr)
 			m = i;
 		}
 		*pcr = i*ATM_OC3_PCR/m;
-		c = 20; /* @@@ should use max_cdv ! */
+		c = 20; /* should use max_cdv! */
 		if ((min && *pcr < min) || (max && *pcr > max)) return -EINVAL;
 		if (zatm_dev->tx_bw < *pcr) return -EAGAIN;
 		zatm_dev->tx_bw -= *pcr;
@@ -1078,7 +1078,7 @@ static irqreturn_t zatm_int(int irq,void *dev_id)
 			    "(0x%x)\n",dev->number,(reason & uPD98401_INT_MF)
 			    >> uPD98401_INT_MF_SHIFT);
 			event_dump();
-			    /* @@@ should try to recover */
+			    /* should try to recover */
 		}
 		if (reason & uPD98401_INT_MM) {
 			if (reason & 1) poll_rx(dev,0);
@@ -1086,7 +1086,7 @@ static irqreturn_t zatm_int(int irq,void *dev_id)
 			if (reason & 4) poll_tx(dev,2);
 			if (reason & 8) poll_tx(dev,3);
 		}
-		/* @@@ handle RCRn */
+		/* handle RCRn */
 	}
 	return IRQ_RETVAL(handled);
 }
@@ -1284,7 +1284,7 @@ static int __devinit zatm_start(struct atm_dev *dev)
 	    (2*VC_SIZE+RX_SIZE);
 	ld = -1;
 	for (rx = 1; rx < vccs; rx <<= 1) ld++;
-	dev->ci_range.vpi_bits = 0; /* @@@ no VPI for now */
+	dev->ci_range.vpi_bits = 0; /* no VPI for now */
 	dev->ci_range.vci_bits = ld;
 	dev->link_rate = ATM_OC3_PCR;
 	zatm_dev->chans = vccs; /* ??? */
@@ -1395,7 +1395,7 @@ static int zatm_open(struct atm_vcc *vcc)
 		vcc->dev_data = NULL;
 	if (vci != ATM_VPI_UNSPEC && vpi != ATM_VCI_UNSPEC)
 		set_bit(ATM_VF_ADDR,&vcc->flags);
-	if (vcc->qos.aal != ATM_AAL5) return -EINVAL; /* @@@ AAL0 */
+	if (vcc->qos.aal != ATM_AAL5) return -EINVAL; /* AAL0 */
 	DPRINTK(DEV_LABEL "(itf %d): open %d.%d\n",vcc->dev->number,vcc->vpi,
 	    vcc->vci);
 	if (!test_bit(ATM_VF_PARTIAL,&vcc->flags)) {
@@ -1433,7 +1433,6 @@ static int zatm_change_qos(struct atm_vcc *vcc,struct atm_qos *qos,int flags)
 {
 	printk("Not yet implemented\n");
 	return -ENOSYS;
-	/* @@@ */
 }
 
 
-- 
1.7.6

