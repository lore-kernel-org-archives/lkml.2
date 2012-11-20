Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab2KTR3m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:42 -0500
Received: from mail-wi0-f172.google.com ([209.85.212.172]:38304 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752245Ab2KTR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:40 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 06/10] staging: cxt1e1: musycc.c: fixes placement of parentheses
Date: Tue, 20 Nov 2012 19:28:48 +0200
Message-Id: <1353432532-21203-6-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes several incorrect placements of parantheses, as
identified by the checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c |  490 +++++++++++++++++++--------------------
 1 file changed, 245 insertions(+), 245 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 42e1ca4..b2cc68a 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -60,21 +60,21 @@ extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
 
 /*******************************************************************/
 /* forward references */
-void        c4_fifo_free (mpi_t *, int);
-void        c4_wk_chan_restart (mch_t *);
-void        musycc_bh_tx_eom (mpi_t *, int);
-int         musycc_chan_up (ci_t *, int);
-status_t __init musycc_init (ci_t *);
-STATIC void __init musycc_init_port (mpi_t *);
-void        musycc_intr_bh_tasklet (ci_t *);
-void        musycc_serv_req (mpi_t *, u_int32_t);
-void        musycc_update_timeslots (mpi_t *);
+void        c4_fifo_free(mpi_t *, int);
+void        c4_wk_chan_restart(mch_t *);
+void        musycc_bh_tx_eom(mpi_t *, int);
+int         musycc_chan_up(ci_t *, int);
+status_t __init musycc_init(ci_t *);
+STATIC void __init musycc_init_port(mpi_t *);
+void        musycc_intr_bh_tasklet(ci_t *);
+void        musycc_serv_req(mpi_t *, u_int32_t);
+void        musycc_update_timeslots(mpi_t *);
 
 /*******************************************************************/
 
 #if 1
 STATIC int
-musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
+musycc_dump_rxbuffer_ring(mch_t * ch, int lockit)
 {
     struct mdesc *m;
     unsigned long flags = 0;
@@ -83,14 +83,14 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
     int         n;
 
     if (lockit)
-	spin_lock_irqsave (&ch->ch_rxlock, flags);
+	spin_lock_irqsave(&ch->ch_rxlock, flags);
     if (ch->rxd_num == 0)
 	pr_info("  ZERO receive buffers allocated for this channel.");
     else {
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_READ();
 	m = &ch->mdr[ch->rxix_irq_srv];
 	for (n = ch->rxd_num; n; n--) {
-	    status = le32_to_cpu (m->status);
+	    status = le32_to_cpu(m->status);
 	    {
 		pr_info("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
 			(m == &ch->mdr[ch->rxix_irq_srv]) ? 'F' : ' ',
@@ -101,7 +101,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
 			status & EOBIRQ_ENABLE ? 'b' : '-',
 			status & EOMIRQ_ENABLE ? 'm' : '-',
 			status & LENGTH_MASK,
-			le32_to_cpu (m->data), le32_to_cpu (m->next));
+			le32_to_cpu(m->data), le32_to_cpu(m->next));
 #ifdef RLD_DUMP_BUFDATA
 		{
 		    u_int32_t  *dp;
@@ -114,7 +114,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
 				     * data */
 #endif
 		    {
-			dp = (u_int32_t *) OS_phystov ((void *) (le32_to_cpu (m->data)));
+			dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
 			if (len >= 0x10)
 			    pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
 				    *dp, *(dp + 1), *(dp + 2), *(dp + 3));
@@ -133,14 +133,14 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
     pr_info("\n");
 
     if (lockit)
-	spin_unlock_irqrestore (&ch->ch_rxlock, flags);
+	spin_unlock_irqrestore(&ch->ch_rxlock, flags);
     return 0;
 }
 #endif
 
 #if 1
 STATIC int
-musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
+musycc_dump_txbuffer_ring(mch_t * ch, int lockit)
 {
     struct mdesc *m;
     unsigned long flags = 0;
@@ -148,14 +148,14 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
     int         n;
 
     if (lockit)
-	spin_lock_irqsave (&ch->ch_txlock, flags);
+	spin_lock_irqsave(&ch->ch_txlock, flags);
     if (ch->txd_num == 0)
 	pr_info("  ZERO transmit buffers allocated for this channel.");
     else {
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_READ();
 	m = ch->txd_irq_srv;
 	for (n = ch->txd_num; n; n--) {
-	    status = le32_to_cpu (m->status);
+	    status = le32_to_cpu(m->status);
 	    {
 		pr_info("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
 			(m == ch->txd_usr_add) ? 'F' : ' ',
@@ -167,14 +167,14 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
 			status & EOBIRQ_ENABLE ? 'b' : '-',
 			status & EOMIRQ_ENABLE ? 'm' : '-',
 			status & LENGTH_MASK,
-			le32_to_cpu (m->data), le32_to_cpu (m->next));
+			le32_to_cpu(m->data), le32_to_cpu(m->next));
 #ifdef RLD_DUMP_BUFDATA
 		{
 		    u_int32_t  *dp;
 		    int         len = status & LENGTH_MASK;
 
 		    if (m->data) {
-			dp = (u_int32_t *) OS_phystov ((void *) (le32_to_cpu (m->data)));
+			dp = (u_int32_t *) OS_phystov((void *) (le32_to_cpu(m->data)));
 			if (len >= 0x10)
 			    pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
 				    *dp, *(dp + 1), *(dp + 2), *(dp + 3));
@@ -193,7 +193,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
     pr_info("\n");
 
     if (lockit)
-	spin_unlock_irqrestore (&ch->ch_txlock, flags);
+	spin_unlock_irqrestore(&ch->ch_txlock, flags);
     return 0;
 }
 #endif
@@ -205,7 +205,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
  */
 
 status_t
-musycc_dump_ring (ci_t * ci, unsigned int chan)
+musycc_dump_ring(ci_t * ci, unsigned int chan)
 {
     mch_t      *ch;
 
@@ -214,7 +214,7 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
     {
 	int         bh;
 
-	bh = atomic_read (&ci->bh_pending);
+	bh = atomic_read(&ci->bh_pending);
 	pr_info(">> bh_pend %d [%d] ihead %d itail %d [%d] th_cnt %d bh_cnt %d wdcnt %d note %d\n",
 		bh, max_bh, ci->iqp_headx, ci->iqp_tailx, max_intcnt,
 		ci->intlog.drvr_intr_thcount,
@@ -224,7 +224,7 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
 	max_intcnt = 0;             /* reset counter */
     }
 
-    if (!(ch = sd_find_chan (dummy, chan))) {
+    if (!(ch = sd_find_chan(dummy, chan))) {
 	pr_info(">> musycc_dump_ring: channel %d not up.\n", chan);
 	return ENOENT;
     }
@@ -232,28 +232,28 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
 	    ch->status, ch->p.status);
     pr_info("--------------------------------\nTX Buffer Ring - Channel %d, txd_num %d. (bd/ch pend %d %d), TXD required %d, txpkt %lu\n",
 	    chan, ch->txd_num,
-	    (u_int32_t) atomic_read (&ci->tx_pending), (u_int32_t) atomic_read (&ch->tx_pending), ch->txd_required, ch->s.tx_packets);
+	    (u_int32_t) atomic_read(&ci->tx_pending), (u_int32_t) atomic_read(&ch->tx_pending), ch->txd_required, ch->s.tx_packets);
     pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
 	    ch->user, ch->txd_irq_srv, ch->txd_usr_add,
-	    sd_queue_stopped (ch->user),
+	    sd_queue_stopped(ch->user),
 	    ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
-    musycc_dump_txbuffer_ring (ch, 1);
+    musycc_dump_txbuffer_ring(ch, 1);
     pr_info("RX Buffer Ring - Channel %d, rxd_num %d. IRQ_SRV[%d] 0x%p, start_rx %x rxpkt %lu\n",
 	    chan, ch->rxd_num, ch->rxix_irq_srv,
 	    &ch->mdr[ch->rxix_irq_srv], ch->ch_start_rx, ch->s.rx_packets);
-    musycc_dump_rxbuffer_ring (ch, 1);
+    musycc_dump_rxbuffer_ring(ch, 1);
 
     return SBE_DRVR_SUCCESS;
 }
 
 
 status_t
-musycc_dump_rings (ci_t * ci, unsigned int start_chan)
+musycc_dump_rings(ci_t * ci, unsigned int start_chan)
 {
     unsigned int chan;
 
     for (chan = start_chan; chan < (start_chan + 5); chan++)
-	musycc_dump_ring (ci, chan);
+	musycc_dump_ring(ci, chan);
     return SBE_DRVR_SUCCESS;
 }
 
@@ -264,7 +264,7 @@ musycc_dump_rings (ci_t * ci, unsigned int start_chan)
  */
 
 void
-musycc_init_mdt (mpi_t * pi)
+musycc_init_mdt(mpi_t * pi)
 {
     u_int32_t  *addr, cfg;
     int         i;
@@ -281,28 +281,28 @@ musycc_init_mdt (mpi_t * pi)
     cfg = CFG_CH_FLAG_7E << IDLE_CODE;
 
     for (i = 0; i < 32; addr++, i++)
-	pci_write_32 (addr, cfg);
+	pci_write_32(addr, cfg);
 }
 
 
 /* Set TX thp to the next unprocessed md */
 
 void
-musycc_update_tx_thp (mch_t * ch)
+musycc_update_tx_thp(mch_t * ch)
 {
     struct mdesc *md;
     unsigned long flags;
 
-    spin_lock_irqsave (&ch->ch_txlock, flags);
+    spin_lock_irqsave(&ch->ch_txlock, flags);
     while (1) {
 	md = ch->txd_irq_srv;
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_READ();
 	if (!md->data) {
 	    /* No MDs with buffers to process */
-	    spin_unlock_irqrestore (&ch->ch_txlock, flags);
+	    spin_unlock_irqrestore(&ch->ch_txlock, flags);
 	    return;
 	}
-	if ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED) {
+	if ((le32_to_cpu(md->status)) & MUSYCC_TX_OWNED) {
 	    /* this is the MD to restart TX with */
 	    break;
 	}
@@ -312,19 +312,19 @@ musycc_update_tx_thp (mch_t * ch)
 	 * so... process this MD, it's owned by the host.  (This might give
 	 * as a new, updated txd_irq_srv.)
 	 */
-	musycc_bh_tx_eom (ch->up, ch->gchan);
+	musycc_bh_tx_eom(ch->up, ch->gchan);
     }
     md = ch->txd_irq_srv;
-    ch->up->regram->thp[ch->gchan] = cpu_to_le32 (OS_vtophys (md));
-    FLUSH_MEM_WRITE ();
+    ch->up->regram->thp[ch->gchan] = cpu_to_le32(OS_vtophys(md));
+    FLUSH_MEM_WRITE();
 
     if (ch->tx_full) {
 	ch->tx_full = 0;
 	ch->txd_required = 0;
-	sd_enable_xmit (ch->user);  /* re-enable to catch flow controlled
+	sd_enable_xmit(ch->user);  /* re-enable to catch flow controlled
 				     * channel */
     }
-    spin_unlock_irqrestore (&ch->ch_txlock, flags);
+    spin_unlock_irqrestore(&ch->ch_txlock, flags);
 
 #ifdef RLD_TRANS_DEBUG
     pr_info("++ musycc_update_tx_thp[%d]: setting thp = %p, sts %x\n", ch->channum, md, md->status);
@@ -342,7 +342,7 @@ musycc_update_tx_thp (mch_t * ch)
  */
 
 void
-musycc_wq_chan_restart (void *arg)      /* channel private structure */
+musycc_wq_chan_restart(void *arg)      /* channel private structure */
 {
     mch_t      *ch;
     mpi_t      *pi;
@@ -376,19 +376,19 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 #ifdef RLD_TRANS_DEBUG
 		md = &ch->mdr[ch->rxix_irq_srv];
 		pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-		ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status),
+		ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
 			ch->s.rx_packets);
 #elif defined(RLD_RXACT_DEBUG)
 		md = &ch->mdr[ch->rxix_irq_srv];
 		pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
-		ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status),
+		ch->channum, ch->rxix_irq_srv, md, le32_to_cpu(md->status),
 			ch->s.rx_packets);
-		musycc_dump_rxbuffer_ring (ch, 1);      /* RLD DEBUG */
+		musycc_dump_rxbuffer_ring(ch, 1);      /* RLD DEBUG */
 #endif
 	    }
 	}
 #endif
-	musycc_serv_req (pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | ch->gchan);
+	musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | ch->gchan);
     }
     /**********************************/
     /** check for TX restart request **/
@@ -396,10 +396,10 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 
     if ((ch->ch_start_tx) && (ch->status & TX_ENABLED)) {
 	/* find next unprocessed message, then set TX thp to it */
-	musycc_update_tx_thp (ch);
+	musycc_update_tx_thp(ch);
 
 #if 0
-	spin_lock_irqsave (&ch->ch_txlock, flags);
+	spin_lock_irqsave(&ch->ch_txlock, flags);
 #endif
 	md = ch->txd_irq_srv;
 	if (!md) {
@@ -407,29 +407,29 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 	    pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
 #endif
 #if 0
-	    spin_unlock_irqrestore (&ch->ch_txlock, flags);
+	    spin_unlock_irqrestore(&ch->ch_txlock, flags);
 #endif
-	} else if (md->data && ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED)) {
+	} else if (md->data && ((le32_to_cpu(md->status)) & MUSYCC_TX_OWNED)) {
 	    ch->ch_start_tx = 0;
 #if 0
-	    spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow interrupts for service request */
+	    spin_unlock_irqrestore(&ch->ch_txlock, flags);   /* allow interrupts for service request */
 #endif
 #ifdef RLD_TRANS_DEBUG
 	    pr_info("++ musycc_wq_chan_restart() CHAN TX ACTIVATE: chan %d txd_irq_srv %p = sts %x, txpkt %lu\n",
 		    ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status, ch->s.tx_packets);
 #endif
-	    musycc_serv_req (pi, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | ch->gchan);
+	    musycc_serv_req(pi, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | ch->gchan);
 	}
 #ifdef RLD_RESTART_DEBUG
 	else {
 	    /* retain request to start until retried and we have data to xmit */
 	    pr_info("-- musycc_wq_chan_restart[%d]: DELAYED due to md %p sts %x data %x, start_tx %x\n",
 		    ch->channum, md,
-		    le32_to_cpu (md->status),
-		    le32_to_cpu (md->data), ch->ch_start_tx);
-	    musycc_dump_txbuffer_ring (ch, 0);
+		    le32_to_cpu(md->status),
+		    le32_to_cpu(md->data), ch->ch_start_tx);
+	    musycc_dump_txbuffer_ring(ch, 0);
 #if 0
-	    spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow interrupts for service request */
+	    spin_unlock_irqrestore(&ch->ch_txlock, flags);   /* allow interrupts for service request */
 #endif
 	}
 #endif
@@ -443,7 +443,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
   */
 
 void
-musycc_chan_restart (mch_t * ch)
+musycc_chan_restart(mch_t * ch)
 {
 #ifdef RLD_RESTART_DEBUG
     pr_info("++ musycc_chan_restart[%d]: txd_irq_srv @ %p = sts %x\n",
@@ -454,14 +454,14 @@ musycc_chan_restart (mch_t * ch)
 #ifdef RLD_RESTART_DEBUG
     pr_info(">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n", ch->channum, &ch->ch_work);
 #endif
-    c4_wk_chan_restart (ch);        /* work queue mechanism fires off: Ref:
+    c4_wk_chan_restart(ch);        /* work queue mechanism fires off: Ref:
 				     * musycc_wq_chan_restart () */
 
 }
 
 
 void
-rld_put_led (mpi_t * pi, u_int32_t ledval)
+rld_put_led(mpi_t * pi, u_int32_t ledval)
 {
     static u_int32_t led = 0;
 
@@ -470,14 +470,14 @@ rld_put_led (mpi_t * pi, u_int32_t ledval)
     else
 	led |= ledval;
 
-    pci_write_32 ((u_int32_t *) &pi->up->cpldbase->leds, led);  /* RLD DEBUG TRANHANG */
+    pci_write_32((u_int32_t *) &pi->up->cpldbase->leds, led);  /* RLD DEBUG TRANHANG */
 }
 
 
 #define MUSYCC_SR_RETRY_CNT  9
 
 void
-musycc_serv_req (mpi_t * pi, u_int32_t req)
+musycc_serv_req(mpi_t * pi, u_int32_t req)
 {
     volatile u_int32_t r;
     int         rcnt;
@@ -490,7 +490,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
      * acknowledged."
      */
 
-    SD_SEM_TAKE (&pi->sr_sem_busy, "serv");     /* only 1 thru here, per
+    SD_SEM_TAKE(&pi->sr_sem_busy, "serv");     /* only 1 thru here, per
 						 * group */
 
     if (pi->sr_last == req) {
@@ -512,24 +512,24 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
 #ifdef RLD_TRANS_DEBUG
 	    pr_info(">> same CHAN ACT SR, Port %d Req %x => issue SR_NOOP CMD\n", pi->portnum, req);
 #endif
-	    SD_SEM_GIVE (&pi->sr_sem_busy);     /* allow this next request */
-	    musycc_serv_req (pi, SR_NOOP);
-	    SD_SEM_TAKE (&pi->sr_sem_busy, "serv");     /* relock & continue w/
+	    SD_SEM_GIVE(&pi->sr_sem_busy);     /* allow this next request */
+	    musycc_serv_req(pi, SR_NOOP);
+	    SD_SEM_TAKE(&pi->sr_sem_busy, "serv");     /* relock & continue w/
 							 * original req */
 	} else if (req == SR_NOOP) {
 	    /* no need to issue back-to-back SR_NOOP commands at this time */
 #ifdef RLD_TRANS_DEBUG
 	    pr_info(">> same Port SR_NOOP skipped, Port %d\n", pi->portnum);
 #endif
-	    SD_SEM_GIVE (&pi->sr_sem_busy);     /* allow this next request */
+	    SD_SEM_GIVE(&pi->sr_sem_busy);     /* allow this next request */
 	    return;
 	}
     }
     rcnt = 0;
     pi->sr_last = req;
 rewrite:
-    pci_write_32 ((u_int32_t *) &pi->reg->srd, req);
-    FLUSH_MEM_WRITE ();
+    pci_write_32((u_int32_t *) &pi->reg->srd, req);
+    FLUSH_MEM_WRITE();
 
     /*
      * Per MUSYCC Manual, Section 6.1,2 - "When writing an SCR service
@@ -539,7 +539,7 @@ rewrite:
      * the host follow any SCR write with another operation which reads from
      * the same address."
      */
-    r = pci_read_32 ((u_int32_t *) &pi->reg->srd);      /* adhere to write
+    r = pci_read_32((u_int32_t *) &pi->reg->srd);      /* adhere to write
 							 * timing imposition */
 
 
@@ -548,14 +548,14 @@ rewrite:
 	    pr_info("%s: %d - reissue srv req/last %x/%x (hdw reads %x), Chan %d.\n",
 		    pi->up->devname, rcnt, req, pi->sr_last, r,
 		    (pi->portnum * MUSYCC_NCHANS) + (req & 0x1f));
-	OS_uwait_dummy ();          /* this delay helps reduce reissue counts
+	OS_uwait_dummy();          /* this delay helps reduce reissue counts
 				     * (reason not yet researched) */
 	goto rewrite;
     }
     if (rcnt > MUSYCC_SR_RETRY_CNT) {
 	pr_warning("%s: failed service request (#%d)= %x, group %d.\n",
 		   pi->up->devname, MUSYCC_SR_RETRY_CNT, req, pi->portnum);
-	SD_SEM_GIVE (&pi->sr_sem_busy); /* allow any next request */
+	SD_SEM_GIVE(&pi->sr_sem_busy); /* allow any next request */
 	return;
     }
     if (req == SR_CHIP_RESET) {
@@ -566,22 +566,22 @@ rewrite:
 	 * unclear what CPU/BUS clock speeds might have been assumed when
 	 * suggesting this 'lack of ACK' workaround.  Thus the use of uwait.
 	 */
-	OS_uwait (100000, "icard"); /* 100ms */
+	OS_uwait(100000, "icard"); /* 100ms */
     } else {
-	FLUSH_MEM_READ ();
-	SD_SEM_TAKE (&pi->sr_sem_wait, "sakack");       /* sleep until SACK
+	FLUSH_MEM_READ();
+	SD_SEM_TAKE(&pi->sr_sem_wait, "sakack");       /* sleep until SACK
 							 * interrupt occurs */
     }
-    SD_SEM_GIVE (&pi->sr_sem_busy); /* allow any next request */
+    SD_SEM_GIVE(&pi->sr_sem_busy); /* allow any next request */
 }
 
 
 #ifdef  SBE_PMCC4_ENABLE
 void
-musycc_update_timeslots (mpi_t * pi)
+musycc_update_timeslots(mpi_t * pi)
 {
     int         i, ch;
-    char        e1mode = IS_FRAME_ANY_E1 (pi->p.port_mode);
+    char        e1mode = IS_FRAME_ANY_E1(pi->p.port_mode);
 
     for (i = 0; i < 32; i++) {
 	int         usedby = 0, last = 0, ts, j, bits[8];
@@ -628,19 +628,19 @@ musycc_update_timeslots (mpi_t * pi)
 	pi->regram->rtsm[i] = ts;
 	pi->regram->ttsm[i] = ts;
     }
-    FLUSH_MEM_WRITE ();
+    FLUSH_MEM_WRITE();
 
-    musycc_serv_req (pi, SR_TIMESLOT_MAP | SR_RX_DIRECTION);
-    musycc_serv_req (pi, SR_TIMESLOT_MAP | SR_TX_DIRECTION);
-    musycc_serv_req (pi, SR_SUBCHANNEL_MAP | SR_RX_DIRECTION);
-    musycc_serv_req (pi, SR_SUBCHANNEL_MAP | SR_TX_DIRECTION);
+    musycc_serv_req(pi, SR_TIMESLOT_MAP | SR_RX_DIRECTION);
+    musycc_serv_req(pi, SR_TIMESLOT_MAP | SR_TX_DIRECTION);
+    musycc_serv_req(pi, SR_SUBCHANNEL_MAP | SR_RX_DIRECTION);
+    musycc_serv_req(pi, SR_SUBCHANNEL_MAP | SR_TX_DIRECTION);
 }
 #endif
 
 
 #ifdef SBE_WAN256T3_ENABLE
 void
-musycc_update_timeslots (mpi_t * pi)
+musycc_update_timeslots(mpi_t * pi)
 {
     mch_t      *ch;
 
@@ -665,9 +665,9 @@ musycc_update_timeslots (mpi_t * pi)
 	pi->regram->rtsm[i] = ts;
 	pi->regram->ttsm[i] = ts;
     }
-    FLUSH_MEM_WRITE ();
-    musycc_serv_req (pi, SR_TIMESLOT_MAP | SR_RX_DIRECTION);
-    musycc_serv_req (pi, SR_TIMESLOT_MAP | SR_TX_DIRECTION);
+    FLUSH_MEM_WRITE();
+    musycc_serv_req(pi, SR_TIMESLOT_MAP | SR_RX_DIRECTION);
+    musycc_serv_req(pi, SR_TIMESLOT_MAP | SR_TX_DIRECTION);
 }
 #endif
 
@@ -677,7 +677,7 @@ musycc_update_timeslots (mpi_t * pi)
   * into a hardware specific register value (IE. MUSYCC CCD Register).
   */
 u_int32_t
-musycc_chan_proto (int proto)
+musycc_chan_proto(int proto)
 {
     int         reg;
 
@@ -703,12 +703,12 @@ musycc_chan_proto (int proto)
 
 #ifdef SBE_WAN256T3_ENABLE
 STATIC void __init
-musycc_init_port (mpi_t * pi)
+musycc_init_port(mpi_t * pi)
 {
-    pci_write_32 ((u_int32_t *) &pi->reg->gbp, OS_vtophys (pi->regram));
+    pci_write_32((u_int32_t *) &pi->reg->gbp, OS_vtophys(pi->regram));
 
     pi->regram->grcd =
-	__constant_cpu_to_le32 (MUSYCC_GRCD_RX_ENABLE |
+	__constant_cpu_to_le32(MUSYCC_GRCD_RX_ENABLE |
 				MUSYCC_GRCD_TX_ENABLE |
 				MUSYCC_GRCD_SF_ALIGN |
 				MUSYCC_GRCD_SUBCHAN_DISABLE |
@@ -718,31 +718,31 @@ musycc_init_port (mpi_t * pi)
 		       (MUSYCC_GRCD_POLLTH_32 << MUSYCC_GRCD_POLLTH_SHIFT));
 
     pi->regram->pcd =
-	__constant_cpu_to_le32 (MUSYCC_PCD_E1X4_MODE |
+	__constant_cpu_to_le32(MUSYCC_PCD_E1X4_MODE |
 				MUSYCC_PCD_TXDATA_RISING |
 				MUSYCC_PCD_TX_DRIVEN);
 
     /* Message length descriptor */
-       pi->regram->mld = __constant_cpu_to_le32 (cxt1e1_max_mru | (cxt1e1_max_mru << 16));
-    FLUSH_MEM_WRITE ();
+       pi->regram->mld = __constant_cpu_to_le32(cxt1e1_max_mru | (cxt1e1_max_mru << 16));
+    FLUSH_MEM_WRITE();
 
-    musycc_serv_req (pi, SR_GROUP_INIT | SR_RX_DIRECTION);
-    musycc_serv_req (pi, SR_GROUP_INIT | SR_TX_DIRECTION);
+    musycc_serv_req(pi, SR_GROUP_INIT | SR_RX_DIRECTION);
+    musycc_serv_req(pi, SR_GROUP_INIT | SR_TX_DIRECTION);
 
-    musycc_init_mdt (pi);
+    musycc_init_mdt(pi);
 
-    musycc_update_timeslots (pi);
+    musycc_update_timeslots(pi);
 }
 #endif
 
 
 status_t    __init
-musycc_init (ci_t * ci)
+musycc_init(ci_t * ci)
 {
     char       *regaddr;        /* temp for address boundary calculations */
     int         i, gchan;
 
-    OS_sem_init (&ci->sem_wdbusy, SEM_AVAILABLE);       /* watchdog exclusion */
+    OS_sem_init(&ci->sem_wdbusy, SEM_AVAILABLE);       /* watchdog exclusion */
 
     /*
      * Per MUSYCC manual, Section 6.3.4 - "The host must allocate a dword
@@ -751,7 +751,7 @@ musycc_init (ci_t * ci)
 
 #define INT_QUEUE_BOUNDARY  4
 
-    regaddr = OS_kmalloc ((INT_QUEUE_SIZE + 1) * sizeof (u_int32_t));
+    regaddr = OS_kmalloc((INT_QUEUE_SIZE + 1) * sizeof(u_int32_t));
     if (regaddr == 0)
 	return ENOMEM;
     ci->iqd_p_saved = regaddr;      /* save orig value for free's usage */
@@ -760,7 +760,7 @@ musycc_init (ci_t * ci)
 								 * closest boundary */
 
     for (i = 0; i < INT_QUEUE_SIZE; i++)
-	ci->iqd_p[i] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
+	ci->iqd_p[i] = __constant_cpu_to_le32(INT_EMPTY_ENTRY);
 
     for (i = 0; i < ci->max_port; i++) {
 	mpi_t      *pi = &ci->port[i];
@@ -772,11 +772,11 @@ musycc_init (ci_t * ci)
 
 #define GROUP_BOUNDARY   0x800
 
-	regaddr = OS_kmalloc (sizeof (struct musycc_groupr) + GROUP_BOUNDARY);
+	regaddr = OS_kmalloc(sizeof(struct musycc_groupr) + GROUP_BOUNDARY);
 	if (regaddr == 0) {
 	    for (gchan = 0; gchan < i; gchan++) {
 		pi = &ci->port[gchan];
-		OS_kfree (pi->reg);
+		OS_kfree(pi->reg);
 		pi->reg = 0;
 	    }
 	    return ENOMEM;
@@ -789,26 +789,26 @@ musycc_init (ci_t * ci)
 
     /* any board centric MUSYCC commands will use group ZERO as its "home" */
     ci->regram = ci->port[0].regram;
-    musycc_serv_req (&ci->port[0], SR_CHIP_RESET);
+    musycc_serv_req(&ci->port[0], SR_CHIP_RESET);
 
-    pci_write_32 ((u_int32_t *) &ci->reg->gbp, OS_vtophys (ci->regram));
-    pci_flush_write (ci);
+    pci_write_32((u_int32_t *) &ci->reg->gbp, OS_vtophys(ci->regram));
+    pci_flush_write(ci);
 #ifdef CONFIG_SBE_PMCC4_NCOMM
-    ci->regram->__glcd = __constant_cpu_to_le32 (GCD_MAGIC);
+    ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC);
 #else
     /* standard driver POLLS for INTB via CPLD register */
-    ci->regram->__glcd = __constant_cpu_to_le32 (GCD_MAGIC | MUSYCC_GCD_INTB_DISABLE);
+    ci->regram->__glcd = __constant_cpu_to_le32(GCD_MAGIC | MUSYCC_GCD_INTB_DISABLE);
 #endif
 
-    ci->regram->__iqp = cpu_to_le32 (OS_vtophys (&ci->iqd_p[0]));
-    ci->regram->__iql = __constant_cpu_to_le32 (INT_QUEUE_SIZE - 1);
-    pci_write_32 ((u_int32_t *) &ci->reg->dacbp, 0);
-    FLUSH_MEM_WRITE ();
+    ci->regram->__iqp = cpu_to_le32(OS_vtophys(&ci->iqd_p[0]));
+    ci->regram->__iql = __constant_cpu_to_le32(INT_QUEUE_SIZE - 1);
+    pci_write_32((u_int32_t *) &ci->reg->dacbp, 0);
+    FLUSH_MEM_WRITE();
 
     ci->state = C_RUNNING;          /* mark as full interrupt processing
 				     * available */
 
-    musycc_serv_req (&ci->port[0], SR_GLOBAL_INIT);     /* FIRST INTERRUPT ! */
+    musycc_serv_req(&ci->port[0], SR_GLOBAL_INIT);     /* FIRST INTERRUPT ! */
 
     /* sanity check settable parameters */
 
@@ -824,7 +824,7 @@ musycc_init (ci_t * ci)
     }
 #ifdef SBE_WAN256T3_ENABLE
     for (i = 0; i < MUSYCC_NPORTS; i++)
-	musycc_init_port (&ci->port[i]);
+	musycc_init_port(&ci->port[i]);
 #endif
 
     return SBE_DRVR_SUCCESS;        /* no error */
@@ -832,7 +832,7 @@ musycc_init (ci_t * ci)
 
 
 void
-musycc_bh_tx_eom (mpi_t * pi, int gchan)
+musycc_bh_tx_eom(mpi_t * pi, int gchan)
 {
     mch_t      *ch;
     struct mdesc *md;
@@ -857,15 +857,15 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 
 #if 0
 #ifdef SBE_ISR_INLINE
-    spin_lock_irq (&ch->ch_txlock);
+    spin_lock_irq(&ch->ch_txlock);
 #else
-    spin_lock_irqsave (&ch->ch_txlock, flags);
+    spin_lock_irqsave(&ch->ch_txlock, flags);
 #endif
 #endif
     do {
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_READ();
 	md = ch->txd_irq_srv;
-	status = le32_to_cpu (md->status);
+	status = le32_to_cpu(md->status);
 
 	/*
 	 * Note: Per MUSYCC Ref 6.4.9, the host does not poll a host-owned
@@ -886,10 +886,10 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	    readCount = 0;
 	    while (status & MUSYCC_TX_OWNED) {
 		for (loopCount = 0; loopCount < 0x30; loopCount++)
-		    OS_uwait_dummy ();  /* use call to avoid optimization
+		    OS_uwait_dummy();  /* use call to avoid optimization
 					 * removal of dummy delay */
-		FLUSH_MEM_READ ();
-		status = le32_to_cpu (md->status);
+		FLUSH_MEM_READ();
+		status = le32_to_cpu(md->status);
 		if (readCount++ > 40)
 		    break;          /* don't wait any longer */
 	    }
@@ -900,9 +900,9 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 			    md, status);
 		    pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
 			    ch->user, ch->txd_irq_srv, ch->txd_usr_add,
-			    sd_queue_stopped (ch->user),
+			    sd_queue_stopped(ch->user),
 			    ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
-		    musycc_dump_txbuffer_ring (ch, 0);
+		    musycc_dump_txbuffer_ring(ch, 0);
 		}
 		break;              /* Not our mdesc, done */
 	    } else {
@@ -916,12 +916,12 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	md->data = 0;
 	if (md->mem_token != 0)	{
 	    /* upcount channel */
-	    atomic_sub (OS_mem_token_tlen (md->mem_token), &ch->tx_pending);
+	    atomic_sub(OS_mem_token_tlen(md->mem_token), &ch->tx_pending);
 	    /* upcount card */
-	    atomic_sub (OS_mem_token_tlen (md->mem_token), &pi->up->tx_pending);
+	    atomic_sub(OS_mem_token_tlen(md->mem_token), &pi->up->tx_pending);
 #ifdef SBE_WAN256T3_ENABLE
-	    if (!atomic_read (&pi->up->tx_pending))
-		wan256t3_led (pi->up, LED_TX, 0);
+	    if (!atomic_read(&pi->up->tx_pending))
+		wan256t3_led(pi->up, LED_TX, 0);
 #endif
 
 #ifdef CONFIG_SBE_WAN256T3_NCOMM
@@ -932,12 +932,12 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 		if (hdlcnum >= 228) {
 		    if (nciProcess_TX_complete)
 			(*nciProcess_TX_complete) (hdlcnum,
-						   getuserbychan (gchan));
+						   getuserbychan(gchan));
 		}
 	    }
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
-	    OS_mem_token_free_irq (md->mem_token);
+	    OS_mem_token_free_irq(md->mem_token);
 	    md->mem_token = 0;
 	}
 	md->status = 0;
@@ -947,7 +947,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 		    ch->tx_full, ch->txd_free, ch->txd_free + 1);
 #endif
 	++ch->txd_free;
-	FLUSH_MEM_WRITE ();
+	FLUSH_MEM_WRITE();
 
 	if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && (status & EOBIRQ_ENABLE)) {
 	    if (cxt1e1_log_level >= LOG_MONITOR)
@@ -964,7 +964,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
      * buffer.
      */
 
-    FLUSH_MEM_READ ();
+    FLUSH_MEM_READ();
     /*
      * Smooth flow control hysterisis by maintaining task stoppage until half
      * the available write buffers are available.
@@ -985,7 +985,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 #endif
 	    ch->tx_full = 0;
 	    ch->txd_required = 0;
-	    sd_enable_xmit (ch->user);  /* re-enable to catch flow controlled
+	    sd_enable_xmit(ch->user);  /* re-enable to catch flow controlled
 					 * channel */
 	}
     }
@@ -998,19 +998,19 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
     }
 #endif
 
-    FLUSH_MEM_WRITE ();
+    FLUSH_MEM_WRITE();
 #if 0
 #ifdef SBE_ISR_INLINE
-    spin_unlock_irq (&ch->ch_txlock);
+    spin_unlock_irq(&ch->ch_txlock);
 #else
-    spin_unlock_irqrestore (&ch->ch_txlock, flags);
+    spin_unlock_irqrestore(&ch->ch_txlock, flags);
 #endif
 #endif
 }
 
 
 STATIC void
-musycc_bh_rx_eom (mpi_t * pi, int gchan)
+musycc_bh_rx_eom(mpi_t * pi, int gchan)
 {
     mch_t      *ch;
     void       *m, *m2;
@@ -1029,9 +1029,9 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 	return;                     /* can this happen ? */
 
     for (;;) {
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_READ();
 	md = &ch->mdr[ch->rxix_irq_srv];
-	status = le32_to_cpu (md->status);
+	status = le32_to_cpu(md->status);
 	if (!(status & HOST_RX_OWNED))
 	    break;                  /* Not our mdesc, done */
 	m = md->mem_token;
@@ -1051,13 +1051,13 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
 	    {
-		if ((m2 = OS_mem_token_alloc (cxt1e1_max_mru))) {
+		if ((m2 = OS_mem_token_alloc(cxt1e1_max_mru))) {
 		    /* substitute the mbuf+cluster */
 		    md->mem_token = m2;
-		    md->data = cpu_to_le32 (OS_vtophys (OS_mem_token_data (m2)));
+		    md->data = cpu_to_le32(OS_vtophys(OS_mem_token_data(m2)));
 
 		    /* pass the received mbuf upward */
-		    sd_recv_consume (m, status & LENGTH_MASK, ch->user);
+		    sd_recv_consume(m, status & LENGTH_MASK, ch->user);
 		    ch->s.rx_packets++;
 		    ch->s.rx_bytes += status & LENGTH_MASK;
 		} else
@@ -1073,22 +1073,22 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 	    ch->s.rx_length_errors++;
 	else if (error == ERR_SHT)
 	    ch->s.rx_length_errors++;
-	FLUSH_MEM_WRITE ();
+	FLUSH_MEM_WRITE();
 	       status = cxt1e1_max_mru;
 	if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
 	    status |= EOBIRQ_ENABLE;
-	md->status = cpu_to_le32 (status);
+	md->status = cpu_to_le32(status);
 
 	/* Check next mdesc in the ring */
 	if (++ch->rxix_irq_srv >= ch->rxd_num)
 	    ch->rxix_irq_srv = 0;
-	FLUSH_MEM_WRITE ();
+	FLUSH_MEM_WRITE();
     }
 }
 
 
 irqreturn_t
-musycc_intr_th_handler (void *devp)
+musycc_intr_th_handler(void *devp)
 {
     ci_t       *ci = (ci_t *) devp;
     volatile u_int32_t status, currInt = 0;
@@ -1106,18 +1106,18 @@ musycc_intr_th_handler (void *devp)
      */
 
     if (ci->state == C_IDLE) {
-	status = pci_read_32 ((u_int32_t *) &ci->reg->isd);
+	status = pci_read_32((u_int32_t *) &ci->reg->isd);
 
 	/* clear the interrupt but process nothing else */
-	pci_write_32 ((u_int32_t *) &ci->reg->isd, status);
+	pci_write_32((u_int32_t *) &ci->reg->isd, status);
 	return IRQ_HANDLED;
     }
-    FLUSH_PCI_READ ();
-    FLUSH_MEM_READ ();
+    FLUSH_PCI_READ();
+    FLUSH_MEM_READ();
 
-    status = pci_read_32 ((u_int32_t *) &ci->reg->isd);
-    nextInt = INTRPTS_NEXTINT (status);
-    intCnt = INTRPTS_INTCNT (status);
+    status = pci_read_32((u_int32_t *) &ci->reg->isd);
+    nextInt = INTRPTS_NEXTINT(status);
+    intCnt = INTRPTS_INTCNT(status);
     ci->intlog.drvr_intr_thcount++;
 
     /*********************************************************/
@@ -1134,7 +1134,7 @@ musycc_intr_th_handler (void *devp)
     /* incorrect ISD's are encountered.                      */
     /*********************************************************/
 
-    if (nextInt != INTRPTS_NEXTINT (ci->intlog.this_status_new)) {
+    if (nextInt != INTRPTS_NEXTINT(ci->intlog.this_status_new)) {
 	if (cxt1e1_log_level >= LOG_MONITOR) {
 	    pr_info("%s: note - updated ISD from %08x to %08x\n",
 		    ci->devname, status,
@@ -1147,7 +1147,7 @@ musycc_intr_th_handler (void *devp)
 	 * INTFULL bit is correctly reported or not.
 	 */
 	status = (status & (~INTRPTS_NEXTINT_M)) | (ci->intlog.this_status_new);
-	nextInt = INTRPTS_NEXTINT (status);
+	nextInt = INTRPTS_NEXTINT(status);
     }
     /**********************************************/
     /* Cn847x Bug Fix                             */
@@ -1206,19 +1206,19 @@ musycc_intr_th_handler (void *devp)
 		ci->devname, &ci->reg->isd,
 	status, nextInt, intCnt, (intCnt + nextInt) & (INT_QUEUE_SIZE - 1));
 
-    FLUSH_MEM_WRITE ();
+    FLUSH_MEM_WRITE();
 #if defined(SBE_ISR_TASKLET)
-    pci_write_32 ((u_int32_t *) &ci->reg->isd, currInt);
-    atomic_inc (&ci->bh_pending);
-    tasklet_schedule (&ci->ci_musycc_isr_tasklet);
+    pci_write_32((u_int32_t *) &ci->reg->isd, currInt);
+    atomic_inc(&ci->bh_pending);
+    tasklet_schedule(&ci->ci_musycc_isr_tasklet);
 #elif defined(SBE_ISR_IMMEDIATE)
-    pci_write_32 ((u_int32_t *) &ci->reg->isd, currInt);
-    atomic_inc (&ci->bh_pending);
-    queue_task (&ci->ci_musycc_isr_tq, &tq_immediate);
-    mark_bh (IMMEDIATE_BH);
+    pci_write_32((u_int32_t *) &ci->reg->isd, currInt);
+    atomic_inc(&ci->bh_pending);
+    queue_task(&ci->ci_musycc_isr_tq, &tq_immediate);
+    mark_bh(IMMEDIATE_BH);
 #elif defined(SBE_ISR_INLINE)
-    (void) musycc_intr_bh_tasklet (ci);
-    pci_write_32 ((u_int32_t *) &ci->reg->isd, currInt);
+    (void) musycc_intr_bh_tasklet(ci);
+    pci_write_32((u_int32_t *) &ci->reg->isd, currInt);
 #endif
     return IRQ_HANDLED;
 }
@@ -1229,7 +1229,7 @@ unsigned long
 #else
 void
 #endif
-musycc_intr_bh_tasklet (ci_t * ci)
+musycc_intr_bh_tasklet(ci_t * ci)
 {
     mpi_t      *pi;
     mch_t      *ch;
@@ -1265,18 +1265,18 @@ musycc_intr_bh_tasklet (ci_t * ci)
 #endif
 
     ci->intlog.drvr_intr_bhcount++;
-    FLUSH_MEM_READ ();
+    FLUSH_MEM_READ();
     {
-	unsigned int bh = atomic_read (&ci->bh_pending);
+	unsigned int bh = atomic_read(&ci->bh_pending);
 
-	max_bh = max (bh, max_bh);
+	max_bh = max(bh, max_bh);
     }
-    atomic_set (&ci->bh_pending, 0);/* if here, no longer pending */
+    atomic_set(&ci->bh_pending, 0);/* if here, no longer pending */
     while ((headx = ci->iqp_headx) != (tailx = ci->iqp_tailx)) {
 	intCnt = (tailx >= headx) ? (tailx - headx) : (tailx - headx + INT_QUEUE_SIZE);
-	currInt = le32_to_cpu (ci->iqd_p[headx]);
+	currInt = le32_to_cpu(ci->iqd_p[headx]);
 
-	max_intcnt = max (intCnt, max_intcnt);  /* RLD DEBUG */
+	max_intcnt = max(intCnt, max_intcnt);  /* RLD DEBUG */
 
 	/**************************************************/
 	/* HW Bug Fix                                     */
@@ -1293,10 +1293,10 @@ musycc_intr_bh_tasklet (ci_t * ci)
 
 	while ((currInt == badInt) || (currInt == badInt2)) {
 	    for (loopCount = 0; loopCount < 0x30; loopCount++)
-		OS_uwait_dummy ();  /* use call to avoid optimization removal
+		OS_uwait_dummy();  /* use call to avoid optimization removal
 				     * of dummy delay */
-	    FLUSH_MEM_READ ();
-	    currInt = le32_to_cpu (ci->iqd_p[headx]);
+	    FLUSH_MEM_READ();
+	    currInt = le32_to_cpu(ci->iqd_p[headx]);
 	    if (readCount++ > 20)
 		break;
 	}
@@ -1318,22 +1318,22 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	     */
 
 	    if (currInt == badInt)
-		ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY2);
+		ci->iqd_p[headx] = __constant_cpu_to_le32(INT_EMPTY_ENTRY2);
 	    else
-		ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
+		ci->iqd_p[headx] = __constant_cpu_to_le32(INT_EMPTY_ENTRY);
 	    ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
-	    FLUSH_MEM_WRITE ();
-	    FLUSH_MEM_READ ();
+	    FLUSH_MEM_WRITE();
+	    FLUSH_MEM_READ();
 	    continue;
 	}
-	group = INTRPT_GRP (currInt);
-	gchan = INTRPT_CH (currInt);
-	event = INTRPT_EVENT (currInt);
-	err = INTRPT_ERROR (currInt);
+	group = INTRPT_GRP(currInt);
+	gchan = INTRPT_CH(currInt);
+	event = INTRPT_EVENT(currInt);
+	err = INTRPT_ERROR(currInt);
 	tx = currInt & INTRPT_DIR_M;
 
-	ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
-	FLUSH_MEM_WRITE ();
+	ci->iqd_p[headx] = __constant_cpu_to_le32(INT_EMPTY_ENTRY);
+	FLUSH_MEM_WRITE();
 
 	if (cxt1e1_log_level >= LOG_DEBUG) {
 	    if (err != 0)
@@ -1350,10 +1350,10 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	    if (cxt1e1_log_level >= LOG_DEBUG) {
 		volatile u_int32_t r;
 
-		r = pci_read_32 ((u_int32_t *) &pi->reg->srd);
+		r = pci_read_32((u_int32_t *) &pi->reg->srd);
 		pr_info("- SACK cmd: %08x (hdw= %08x)\n", pi->sr_last, r);
 	    }
-	    SD_SEM_GIVE (&pi->sr_sem_wait);     /* wake up waiting process */
+	    SD_SEM_GIVE(&pi->sr_sem_wait);     /* wake up waiting process */
 	    break;
 	case EVE_CHABT:     /* Change To Abort Code (0x7e -> 0xff) */
 	case EVE_CHIC:              /* Change To Idle Code (0xff -> 0x7e) */
@@ -1361,9 +1361,9 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	case EVE_EOM:               /* End Of Message */
 	case EVE_EOB:               /* End Of Buffer (Transparent mode) */
 	    if (tx)
-		musycc_bh_tx_eom (pi, gchan);
+		musycc_bh_tx_eom(pi, gchan);
 	    else
-		musycc_bh_rx_eom (pi, gchan);
+		musycc_bh_rx_eom(pi, gchan);
 #if 0
 	    break;
 #else
@@ -1421,15 +1421,15 @@ musycc_intr_bh_tasklet (ci_t * ci)
 #endif
 		    {
 			pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
-				ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped (ch->user), ch->txd_free);
+				ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped(ch->user), ch->txd_free);
 #ifdef RLD_DEBUG
 			if (ch->p.chan_mode == 2) {     /* problem = ONR on HDLC
 							 * mode */
 			    pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
 				    (u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
-				    sd_queue_stopped (ch->user),
+				    sd_queue_stopped(ch->user),
 				    ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
-			    musycc_dump_txbuffer_ring (ch, 0);
+			    musycc_dump_txbuffer_ring(ch, 0);
 			}
 #endif
 		    }
@@ -1451,7 +1451,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 		    //musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
 		}
 	    }
-	    musycc_chan_restart (ch);
+	    musycc_chan_restart(ch);
 	    break;
 	case ERR_BUF:
 	    if (tx) {
@@ -1488,7 +1488,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	    }
 
 	    if (tx || (ch->p.chan_mode == CFG_CH_PROTO_TRANS))
-		musycc_chan_restart (ch);
+		musycc_chan_restart(ch);
 	    break;
 	default:
 	    break;
@@ -1499,13 +1499,13 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	    pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
 		    ci->devname);
 	ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);     /* insure wrapness */
-	FLUSH_MEM_WRITE ();
-	FLUSH_MEM_READ ();
+	FLUSH_MEM_WRITE();
+	FLUSH_MEM_READ();
     }                               /* while */
     if ((cxt1e1_log_level >= LOG_MONITOR2) && (ci->iqp_headx != ci->iqp_tailx)) {
 	int         bh;
 
-	bh = atomic_read (&CI->bh_pending);
+	bh = atomic_read(&CI->bh_pending);
 	pr_info("_bh_: late arrivals, head %d != tail %d, pending %d\n",
 		ci->iqp_headx, ci->iqp_tailx, bh);
     }
@@ -1517,7 +1517,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 
 #if 0
 int         __init
-musycc_new_chan (ci_t * ci, int channum, void *user)
+musycc_new_chan(ci_t * ci, int channum, void *user)
 {
     mch_t      *ch;
 
@@ -1536,8 +1536,8 @@ musycc_new_chan (ci_t * ci, int channum, void *user)
     ch->p.chan_mode = CFG_CH_PROTO_HDLC_FCS16;
     ch->p.idlecode = CFG_CH_FLAG_7E;
     ch->p.pad_fill_count = 2;
-    spin_lock_init (&ch->ch_rxlock);
-    spin_lock_init (&ch->ch_txlock);
+    spin_lock_init(&ch->ch_rxlock);
+    spin_lock_init(&ch->ch_txlock);
 
     return 0;
 }
@@ -1546,21 +1546,21 @@ musycc_new_chan (ci_t * ci, int channum, void *user)
 
 #ifdef SBE_PMCC4_ENABLE
 status_t
-musycc_chan_down (ci_t * dummy, int channum)
+musycc_chan_down(ci_t * dummy, int channum)
 {
     mpi_t      *pi;
     mch_t      *ch;
     int         i, gchan;
 
-    if (!(ch = sd_find_chan (dummy, channum)))
+    if (!(ch = sd_find_chan(dummy, channum)))
 	return EINVAL;
     pi = ch->up;
     gchan = ch->gchan;
 
     /* Deactivate the channel */
-    musycc_serv_req (pi, SR_CHANNEL_DEACTIVATE | SR_RX_DIRECTION | gchan);
+    musycc_serv_req(pi, SR_CHANNEL_DEACTIVATE | SR_RX_DIRECTION | gchan);
     ch->ch_start_rx = 0;
-    musycc_serv_req (pi, SR_CHANNEL_DEACTIVATE | SR_TX_DIRECTION | gchan);
+    musycc_serv_req(pi, SR_CHANNEL_DEACTIVATE | SR_TX_DIRECTION | gchan);
     ch->ch_start_tx = 0;
 
     if (ch->state == DOWN)
@@ -1571,24 +1571,24 @@ musycc_chan_down (ci_t * dummy, int channum)
     pi->regram->tmp[gchan] = 0;
     pi->regram->rhp[gchan] = 0;
     pi->regram->rmp[gchan] = 0;
-    FLUSH_MEM_WRITE ();
+    FLUSH_MEM_WRITE();
     for (i = 0; i < ch->txd_num; i++)
 	if (ch->mdt[i].mem_token != 0)
-	    OS_mem_token_free (ch->mdt[i].mem_token);
+	    OS_mem_token_free(ch->mdt[i].mem_token);
 
     for (i = 0; i < ch->rxd_num; i++)
 	if (ch->mdr[i].mem_token != 0)
-	    OS_mem_token_free (ch->mdr[i].mem_token);
+	    OS_mem_token_free(ch->mdr[i].mem_token);
 
-    OS_kfree (ch->mdr);
+    OS_kfree(ch->mdr);
     ch->mdr = 0;
     ch->rxd_num = 0;
-    OS_kfree (ch->mdt);
+    OS_kfree(ch->mdt);
     ch->mdt = 0;
     ch->txd_num = 0;
 
-    musycc_update_timeslots (pi);
-    c4_fifo_free (pi, ch->gchan);
+    musycc_update_timeslots(pi);
+    c4_fifo_free(pi, ch->gchan);
 
     pi->openchans--;
     return 0;
@@ -1597,38 +1597,38 @@ musycc_chan_down (ci_t * dummy, int channum)
 
 
 int
-musycc_del_chan (ci_t * ci, int channum)
+musycc_del_chan(ci_t * ci, int channum)
 {
     mch_t      *ch;
 
     if ((channum < 0) || (channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS)))  /* sanity chk param */
 	return ECHRNG;
-    if (!(ch = sd_find_chan (ci, channum)))
+    if (!(ch = sd_find_chan(ci, channum)))
 	return ENOENT;
     if (ch->state == UP)
-	musycc_chan_down (ci, channum);
+	musycc_chan_down(ci, channum);
     ch->state = UNASSIGNED;
     return 0;
 }
 
 
 int
-musycc_del_chan_stats (ci_t * ci, int channum)
+musycc_del_chan_stats(ci_t * ci, int channum)
 {
     mch_t      *ch;
 
     if (channum < 0 || channum >= (MUSYCC_NPORTS * MUSYCC_NCHANS))      /* sanity chk param */
 	return ECHRNG;
-    if (!(ch = sd_find_chan (ci, channum)))
+    if (!(ch = sd_find_chan(ci, channum)))
 	return ENOENT;
 
-    memset (&ch->s, 0, sizeof (struct sbecom_chan_stats));
+    memset(&ch->s, 0, sizeof(struct sbecom_chan_stats));
     return 0;
 }
 
 
 int
-musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
+musycc_start_xmit(ci_t * ci, int channum, void *mem_token)
 {
     mch_t      *ch;
     struct mdesc *md;
@@ -1639,7 +1639,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     int         txd_need_cnt;
     u_int32_t   len;
 
-    if (!(ch = sd_find_chan (ci, channum)))
+    if (!(ch = sd_find_chan(ci, channum)))
 	return -ENOENT;
 
     if (ci->state != C_RUNNING)     /* full interrupt processing available */
@@ -1658,25 +1658,25 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     {
 	pr_info("++ start_xmt[%d]: state %x start %x full %d free %d required %d stopped %x\n",
 		channum, ch->state, ch->ch_start_tx, ch->tx_full,
-		ch->txd_free, ch->txd_required, sd_queue_stopped (ch->user));
+		ch->txd_free, ch->txd_required, sd_queue_stopped(ch->user));
     }
     /***********************************************/
     /** Determine total amount of data to be sent **/
     /***********************************************/
     m2 = mem_token;
     txd_need_cnt = 0;
-    for (len = OS_mem_token_tlen (m2); len > 0;
-	 m2 = (void *) OS_mem_token_next (m2)) {
-	if (!OS_mem_token_len (m2))
+    for (len = OS_mem_token_tlen(m2); len > 0;
+	 m2 = (void *) OS_mem_token_next(m2)) {
+	if (!OS_mem_token_len(m2))
 	    continue;
 	txd_need_cnt++;
-	len -= OS_mem_token_len (m2);
+	len -= OS_mem_token_len(m2);
     }
 
     if (txd_need_cnt == 0) {
 	if (cxt1e1_log_level >= LOG_MONITOR2)
 	    pr_info("%s channel %d: no TX data in User buffer\n", ci->devname, channum);
-	OS_mem_token_free (mem_token);
+	OS_mem_token_free(mem_token);
 	return 0;                   /* no data to send */
     }
     /*************************************************/
@@ -1688,11 +1688,11 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 	    pr_info("start_xmit: discarding buffer, insufficient descriptor cnt %d, need %d.\n",
 		    ch->txd_num, txd_need_cnt + 1);
 	ch->s.tx_dropped++;
-	OS_mem_token_free (mem_token);
+	OS_mem_token_free(mem_token);
 	return 0;
     }
 #if 0
-    spin_lock_irqsave (&ch->ch_txlock, flags);
+    spin_lock_irqsave(&ch->ch_txlock, flags);
 #endif
     /************************************************************/
     /** flow control the line if not enough descriptors remain **/
@@ -1703,9 +1703,9 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 		    channum, ch->txd_free, ch->txd_num, txd_need_cnt);
 	ch->tx_full = 1;
 	ch->txd_required = txd_need_cnt;
-	sd_disable_xmit (ch->user);
+	sd_disable_xmit(ch->user);
 #if 0
-	spin_unlock_irqrestore (&ch->ch_txlock, flags);
+	spin_unlock_irqrestore(&ch->ch_txlock, flags);
 #endif
 	return -EBUSY;               /* tell user to try again later */
     }
@@ -1715,8 +1715,8 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     m2 = mem_token;
     md = ch->txd_usr_add;           /* get current available descriptor */
 
-    for (len = OS_mem_token_tlen (m2); len > 0; m2 = OS_mem_token_next (m2)) {
-	int         u = OS_mem_token_len (m2);
+    for (len = OS_mem_token_tlen(m2); len > 0; m2 = OS_mem_token_next(m2)) {
+	int         u = OS_mem_token_len(m2);
 
 	if (!u)
 	    continue;
@@ -1760,26 +1760,26 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 						 * segments have been
 						 * transmitted. */
 
-	md->data = cpu_to_le32 (OS_vtophys (OS_mem_token_data (m2)));
-	FLUSH_MEM_WRITE ();
-	md->status = cpu_to_le32 (u);
+	md->data = cpu_to_le32(OS_vtophys(OS_mem_token_data(m2)));
+	FLUSH_MEM_WRITE();
+	md->status = cpu_to_le32(u);
 	--ch->txd_free;
 	md = md->snext;
     }
-    FLUSH_MEM_WRITE ();
+    FLUSH_MEM_WRITE();
 
 
     /*
      * Now transfer ownership of first chunk from HOST to MUSYCC in order to
      * fire-off this XMIT.
      */
-    ch->txd_usr_add->status |= __constant_cpu_to_le32 (MUSYCC_TX_OWNED);
-    FLUSH_MEM_WRITE ();
+    ch->txd_usr_add->status |= __constant_cpu_to_le32(MUSYCC_TX_OWNED);
+    FLUSH_MEM_WRITE();
     ch->txd_usr_add = md;
 
-    len = OS_mem_token_tlen (mem_token);
-    atomic_add (len, &ch->tx_pending);
-    atomic_add (len, &ci->tx_pending);
+    len = OS_mem_token_tlen(mem_token);
+    atomic_add(len, &ch->tx_pending);
+    atomic_add(len, &ci->tx_pending);
     ch->s.tx_packets++;
     ch->s.tx_bytes += len;
     /*
@@ -1787,9 +1787,9 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
      * transmission.
      */
     if (ch->ch_start_tx)
-	musycc_chan_restart (ch);
+	musycc_chan_restart(ch);
 #ifdef SBE_WAN256T3_ENABLE
-    wan256t3_led (ci, LED_TX, LEDV_G);
+    wan256t3_led(ci, LED_TX, LEDV_G);
 #endif
     return 0;
 }
-- 
1.7.10.4

