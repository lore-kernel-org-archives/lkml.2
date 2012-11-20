Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2KTR3h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:29:37 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910Ab2KTR3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:29:33 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: gregkh@linuxfoundation.org, a.beregalov@gmail.com, devendra.aaru@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 05/10] staging: cxt1e1: musycc.c: fixes brace placement
Date: Tue, 20 Nov 2012 19:28:47 +0200
Message-Id: <1353432532-21203-5-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
References: <1353432532-21203-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes incorrect brace placement as reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/cxt1e1/musycc.c |  314 +++++++++++----------------------------
 1 file changed, 90 insertions(+), 224 deletions(-)

diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 5feac8a..42e1ca4 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -83,18 +83,13 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
     int         n;
 
     if (lockit)
-    {
 	spin_lock_irqsave (&ch->ch_rxlock, flags);
-    }
     if (ch->rxd_num == 0)
-    {
 	pr_info("  ZERO receive buffers allocated for this channel.");
-    } else
-    {
+    else {
 	FLUSH_MEM_READ ();
 	m = &ch->mdr[ch->rxix_irq_srv];
-	for (n = ch->rxd_num; n; n--)
-	{
+	for (n = ch->rxd_num; n; n--) {
 	    status = le32_to_cpu (m->status);
 	    {
 		pr_info("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
@@ -138,9 +133,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
     pr_info("\n");
 
     if (lockit)
-    {
 	spin_unlock_irqrestore (&ch->ch_rxlock, flags);
-    }
     return 0;
 }
 #endif
@@ -155,18 +148,13 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
     int         n;
 
     if (lockit)
-    {
 	spin_lock_irqsave (&ch->ch_txlock, flags);
-    }
     if (ch->txd_num == 0)
-    {
 	pr_info("  ZERO transmit buffers allocated for this channel.");
-    } else
-    {
+    else {
 	FLUSH_MEM_READ ();
 	m = ch->txd_irq_srv;
-	for (n = ch->txd_num; n; n--)
-	{
+	for (n = ch->txd_num; n; n--) {
 	    status = le32_to_cpu (m->status);
 	    {
 		pr_info("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
@@ -185,8 +173,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
 		    u_int32_t  *dp;
 		    int         len = status & LENGTH_MASK;
 
-		    if (m->data)
-		    {
+		    if (m->data) {
 			dp = (u_int32_t *) OS_phystov ((void *) (le32_to_cpu (m->data)));
 			if (len >= 0x10)
 			    pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
@@ -206,9 +193,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
     pr_info("\n");
 
     if (lockit)
-    {
 	spin_unlock_irqrestore (&ch->ch_txlock, flags);
-    }
     return 0;
 }
 #endif
@@ -225,9 +210,7 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
     mch_t      *ch;
 
     if (chan >= MAX_CHANS_USED)
-    {
 	return SBE_DRVR_FAIL;       /* E2BIG */
-    }
     {
 	int         bh;
 
@@ -241,8 +224,7 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
 	max_intcnt = 0;             /* reset counter */
     }
 
-    if (!(ch = sd_find_chan (dummy, chan)))
-    {
+    if (!(ch = sd_find_chan (dummy, chan))) {
 	pr_info(">> musycc_dump_ring: channel %d not up.\n", chan);
 	return ENOENT;
     }
@@ -299,9 +281,7 @@ musycc_init_mdt (mpi_t * pi)
     cfg = CFG_CH_FLAG_7E << IDLE_CODE;
 
     for (i = 0; i < 32; addr++, i++)
-    {
 	pci_write_32 (addr, cfg);
-    }
 }
 
 
@@ -314,18 +294,15 @@ musycc_update_tx_thp (mch_t * ch)
     unsigned long flags;
 
     spin_lock_irqsave (&ch->ch_txlock, flags);
-    while (1)
-    {
+    while (1) {
 	md = ch->txd_irq_srv;
 	FLUSH_MEM_READ ();
-	if (!md->data)
-	{
+	if (!md->data) {
 	    /* No MDs with buffers to process */
 	    spin_unlock_irqrestore (&ch->ch_txlock, flags);
 	    return;
 	}
-	if ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED)
-	{
+	if ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED) {
 	    /* this is the MD to restart TX with */
 	    break;
 	}
@@ -341,8 +318,7 @@ musycc_update_tx_thp (mch_t * ch)
     ch->up->regram->thp[ch->gchan] = cpu_to_le32 (OS_vtophys (md));
     FLUSH_MEM_WRITE ();
 
-    if (ch->tx_full)
-    {
+    if (ch->tx_full) {
 	ch->tx_full = 0;
 	ch->txd_required = 0;
 	sd_enable_xmit (ch->user);  /* re-enable to catch flow controlled
@@ -388,16 +364,14 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
     /** check for RX restart request **/
     /**********************************/
 
-    if ((ch->ch_start_rx) && (ch->status & RX_ENABLED))
-    {
+    if ((ch->ch_start_rx) && (ch->status & RX_ENABLED)) {
 
 	ch->ch_start_rx = 0;
 #if defined(RLD_TRANS_DEBUG) || defined(RLD_RXACT_DEBUG)
 	{
 	    static int  hereb4 = 7;
 
-	    if (hereb4)             /* RLD DEBUG */
-	    {
+	    if (hereb4) {            /* RLD DEBUG */
 		hereb4--;
 #ifdef RLD_TRANS_DEBUG
 		md = &ch->mdr[ch->rxix_irq_srv];
@@ -420,8 +394,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
     /** check for TX restart request **/
     /**********************************/
 
-    if ((ch->ch_start_tx) && (ch->status & TX_ENABLED))
-    {
+    if ((ch->ch_start_tx) && (ch->status & TX_ENABLED)) {
 	/* find next unprocessed message, then set TX thp to it */
 	musycc_update_tx_thp (ch);
 
@@ -429,16 +402,14 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 	spin_lock_irqsave (&ch->ch_txlock, flags);
 #endif
 	md = ch->txd_irq_srv;
-	if (!md)
-	{
+	if (!md) {
 #ifdef RLD_TRANS_DEBUG
 	    pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
 #endif
 #if 0
 	    spin_unlock_irqrestore (&ch->ch_txlock, flags);
 #endif
-	} else if (md->data && ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED))
-	{
+	} else if (md->data && ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED)) {
 	    ch->ch_start_tx = 0;
 #if 0
 	    spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow interrupts for service request */
@@ -450,8 +421,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
 	    musycc_serv_req (pi, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | ch->gchan);
 	}
 #ifdef RLD_RESTART_DEBUG
-	else
-	{
+	else {
 	    /* retain request to start until retried and we have data to xmit */
 	    pr_info("-- musycc_wq_chan_restart[%d]: DELAYED due to md %p sts %x data %x, start_tx %x\n",
 		    ch->channum, md,
@@ -523,8 +493,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
     SD_SEM_TAKE (&pi->sr_sem_busy, "serv");     /* only 1 thru here, per
 						 * group */
 
-    if (pi->sr_last == req)
-    {
+    if (pi->sr_last == req) {
 #ifdef RLD_TRANS_DEBUG
 	pr_info(">> same SR, Port %d Req %x\n", pi->portnum, req);
 #endif
@@ -539,8 +508,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
 
 	r = (pi->sr_last & ~SR_GCHANNEL_MASK);
 	if ((r == (SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION)) ||
-	    (r == (SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION)))
-	{
+	    (r == (SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION))) {
 #ifdef RLD_TRANS_DEBUG
 	    pr_info(">> same CHAN ACT SR, Port %d Req %x => issue SR_NOOP CMD\n", pi->portnum, req);
 #endif
@@ -548,8 +516,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
 	    musycc_serv_req (pi, SR_NOOP);
 	    SD_SEM_TAKE (&pi->sr_sem_busy, "serv");     /* relock & continue w/
 							 * original req */
-	} else if (req == SR_NOOP)
-	{
+	} else if (req == SR_NOOP) {
 	    /* no need to issue back-to-back SR_NOOP commands at this time */
 #ifdef RLD_TRANS_DEBUG
 	    pr_info(">> same Port SR_NOOP skipped, Port %d\n", pi->portnum);
@@ -576,8 +543,7 @@ rewrite:
 							 * timing imposition */
 
 
-    if ((r != req) && (req != SR_CHIP_RESET) && (++rcnt <= MUSYCC_SR_RETRY_CNT))
-    {
+    if ((r != req) && (req != SR_CHIP_RESET) && (++rcnt <= MUSYCC_SR_RETRY_CNT)) {
 	if (cxt1e1_log_level >= LOG_MONITOR)
 	    pr_info("%s: %d - reissue srv req/last %x/%x (hdw reads %x), Chan %d.\n",
 		    pi->up->devname, rcnt, req, pi->sr_last, r,
@@ -586,15 +552,13 @@ rewrite:
 				     * (reason not yet researched) */
 	goto rewrite;
     }
-    if (rcnt > MUSYCC_SR_RETRY_CNT)
-    {
+    if (rcnt > MUSYCC_SR_RETRY_CNT) {
 	pr_warning("%s: failed service request (#%d)= %x, group %d.\n",
 		   pi->up->devname, MUSYCC_SR_RETRY_CNT, req, pi->portnum);
 	SD_SEM_GIVE (&pi->sr_sem_busy); /* allow any next request */
 	return;
     }
-    if (req == SR_CHIP_RESET)
-    {
+    if (req == SR_CHIP_RESET) {
 	/*
 	 * PORT NOTE: the CHIP_RESET command is NOT ack'd by the MUSYCC, thus
 	 * the upcoming delay is used.  Though the MUSYCC documentation
@@ -603,8 +567,7 @@ rewrite:
 	 * suggesting this 'lack of ACK' workaround.  Thus the use of uwait.
 	 */
 	OS_uwait (100000, "icard"); /* 100ms */
-    } else
-    {
+    } else {
 	FLUSH_MEM_READ ();
 	SD_SEM_TAKE (&pi->sr_sem_wait, "sakack");       /* sleep until SACK
 							 * interrupt occurs */
@@ -620,8 +583,7 @@ musycc_update_timeslots (mpi_t * pi)
     int         i, ch;
     char        e1mode = IS_FRAME_ANY_E1 (pi->p.port_mode);
 
-    for (i = 0; i < 32; i++)
-    {
+    for (i = 0; i < 32; i++) {
 	int         usedby = 0, last = 0, ts, j, bits[8];
 
 	u_int8_t lastval = 0;
@@ -629,18 +591,13 @@ musycc_update_timeslots (mpi_t * pi)
 	if (((i == 0) && e1mode) || /* disable if  E1 mode */
 	    ((i == 16) && ((pi->p.port_mode == CFG_FRAME_E1CRC_CAS) || (pi->p.port_mode == CFG_FRAME_E1CRC_CAS_AMI)))
 	    || ((i > 23) && (!e1mode))) /* disable if T1 mode */
-	{
 	    pi->tsm[i] = 0xff;      /* make tslot unavailable for this mode */
-	} else
-	{
+	else
 	    pi->tsm[i] = 0x00;      /* make tslot available for assignment */
-	}
 	for (j = 0; j < 8; j++)
 	    bits[j] = -1;
-	for (ch = 0; ch < MUSYCC_NCHANS; ch++)
-	{
-	    if ((pi->chan[ch]->state == UP) && (pi->chan[ch]->p.bitmask[i]))
-	    {
+	for (ch = 0; ch < MUSYCC_NCHANS; ch++) {
+	    if ((pi->chan[ch]->state == UP) && (pi->chan[ch]->p.bitmask[i])) {
 		usedby++;
 		last = ch;
 		lastval = pi->chan[ch]->p.bitmask[i];
@@ -656,16 +613,14 @@ musycc_update_timeslots (mpi_t * pi)
 	    ts = (4 << 5) | last;
 	else if ((usedby == 1) && (lastval == 0x7f))
 	    ts = (5 << 5) | last;
-	else
-	{
+	else {
 	    int         idx;
 
 	    if (bits[0] < 0)
 		ts = (6 << 5) | (idx = last);
 	    else
 		ts = (7 << 5) | (idx = bits[0]);
-	    for (j = 1; j < 8; j++)
-	    {
+	    for (j = 1; j < 8; j++) {
 		pi->regram->rscm[idx * 8 + j] = (bits[j] < 0) ? 0 : (0x80 | bits[j]);
 		pi->regram->tscm[idx * 8 + j] = (bits[j] < 0) ? 0 : (0x80 | bits[j]);
 	    }
@@ -699,8 +654,7 @@ musycc_update_timeslots (mpi_t * pi)
 #ifdef SBE_WAN256T3_ENABLE
     hmask = (0x1f << hyperdummy) & 0x1f;
 #endif
-    for (i = 0; i < 128; i++)
-    {
+    for (i = 0; i < 128; i++) {
 	gchan = ((pi->portnum * MUSYCC_NCHANS) + (i & hmask)) % MUSYCC_NCHANS;
 	ch = pi->chan[gchan];
 	if (ch->p.mode_56k)
@@ -727,8 +681,7 @@ musycc_chan_proto (int proto)
 {
     int         reg;
 
-    switch (proto)
-    {
+    switch (proto) {
     case CFG_CH_PROTO_TRANS:        /* 0 */
 	reg = MUSYCC_CCD_TRANS;
 	break;
@@ -807,12 +760,9 @@ musycc_init (ci_t * ci)
 								 * closest boundary */
 
     for (i = 0; i < INT_QUEUE_SIZE; i++)
-    {
 	ci->iqd_p[i] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
-    }
 
-    for (i = 0; i < ci->max_port; i++)
-    {
+    for (i = 0; i < ci->max_port; i++) {
 	mpi_t      *pi = &ci->port[i];
 
 	/*
@@ -823,10 +773,8 @@ musycc_init (ci_t * ci)
 #define GROUP_BOUNDARY   0x800
 
 	regaddr = OS_kmalloc (sizeof (struct musycc_groupr) + GROUP_BOUNDARY);
-	if (regaddr == 0)
-	{
-	    for (gchan = 0; gchan < i; gchan++)
-	    {
+	if (regaddr == 0) {
+	    for (gchan = 0; gchan < i; gchan++) {
 		pi = &ci->port[gchan];
 		OS_kfree (pi->reg);
 		pi->reg = 0;
@@ -864,14 +812,12 @@ musycc_init (ci_t * ci)
 
     /* sanity check settable parameters */
 
-       if (cxt1e1_max_mru > 0xffe)
-    {
+       if (cxt1e1_max_mru > 0xffe) {
 	pr_warning("Maximum allowed MRU exceeded, resetting %d to %d.\n",
 				  cxt1e1_max_mru, 0xffe);
 	       cxt1e1_max_mru = 0xffe;
     }
-       if (cxt1e1_max_mtu > 0xffe)
-    {
+       if (cxt1e1_max_mtu > 0xffe) {
 	pr_warning("Maximum allowed MTU exceeded, resetting %d to %d.\n",
 				  cxt1e1_max_mtu, 0xffe);
 	       cxt1e1_max_mtu = 0xffe;
@@ -900,8 +846,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
     volatile u_int32_t status;
 
     ch = pi->chan[gchan];
-    if (ch == 0 || ch->state != UP)
-    {
+    if (ch == 0 || ch->state != UP) {
 	if (cxt1e1_log_level >= LOG_ERROR)
 	    pr_info("%s: intr: xmit EOM on uninitialized channel %d\n",
 		    pi->up->devname, gchan);
@@ -917,8 +862,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
     spin_lock_irqsave (&ch->ch_txlock, flags);
 #endif
 #endif
-    do
-    {
+    do {
 	FLUSH_MEM_READ ();
 	md = ch->txd_irq_srv;
 	status = le32_to_cpu (md->status);
@@ -927,8 +871,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	 * Note: Per MUSYCC Ref 6.4.9, the host does not poll a host-owned
 	 * Transmit Buffer Descriptor during Transparent Mode.
 	 */
-	if (status & MUSYCC_TX_OWNED)
-	{
+	if (status & MUSYCC_TX_OWNED) {
 	    int         readCount, loopCount;
 
 	    /***********************************************************/
@@ -941,8 +884,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	    /***********************************************************/
 
 	    readCount = 0;
-	    while (status & MUSYCC_TX_OWNED)
-	    {
+	    while (status & MUSYCC_TX_OWNED) {
 		for (loopCount = 0; loopCount < 0x30; loopCount++)
 		    OS_uwait_dummy ();  /* use call to avoid optimization
 					 * removal of dummy delay */
@@ -951,10 +893,8 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 		if (readCount++ > 40)
 		    break;          /* don't wait any longer */
 	    }
-	    if (status & MUSYCC_TX_OWNED)
-	    {
-		if (cxt1e1_log_level >= LOG_MONITOR)
-		{
+	    if (status & MUSYCC_TX_OWNED) {
+		if (cxt1e1_log_level >= LOG_MONITOR) {
 		    pr_info("%s: Port %d Chan %2d - unexpected TX msg ownership intr (md %p sts %x)\n",
 			    pi->up->devname, pi->portnum, ch->channum,
 			    md, status);
@@ -965,8 +905,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 		    musycc_dump_txbuffer_ring (ch, 0);
 		}
 		break;              /* Not our mdesc, done */
-	    } else
-	    {
+	    } else {
 		if (cxt1e1_log_level >= LOG_MONITOR)
 		    pr_info("%s: Port %d Chan %2d - recovered TX msg ownership [%d] (md %p sts %x)\n",
 			    pi->up->devname, pi->portnum, ch->channum, readCount, md, status);
@@ -975,8 +914,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	ch->txd_irq_srv = md->snext;
 
 	md->data = 0;
-	if (md->mem_token != 0)
-	{
+	if (md->mem_token != 0)	{
 	    /* upcount channel */
 	    atomic_sub (OS_mem_token_tlen (md->mem_token), &ch->tx_pending);
 	    /* upcount card */
@@ -991,8 +929,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	    {
 		int         hdlcnum = (pi->portnum * 32 + gchan);
 
-		if (hdlcnum >= 228)
-		{
+		if (hdlcnum >= 228) {
 		    if (nciProcess_TX_complete)
 			(*nciProcess_TX_complete) (hdlcnum,
 						   getuserbychan (gchan));
@@ -1012,16 +949,14 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	++ch->txd_free;
 	FLUSH_MEM_WRITE ();
 
-	if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && (status & EOBIRQ_ENABLE))
-	{
+	if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && (status & EOBIRQ_ENABLE)) {
 	    if (cxt1e1_log_level >= LOG_MONITOR)
 		pr_info("%s: Mode (%x) incorrect EOB status (%x)\n",
 			pi->up->devname, ch->p.chan_mode, status);
 	    if ((status & EOMIRQ_ENABLE) == 0)
 		break;
 	}
-    }
-    while ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && ((status & EOMIRQ_ENABLE) == 0));
+    } while ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && ((status & EOMIRQ_ENABLE) == 0));
     /*
      * NOTE: (The above 'while' is coupled w/ previous 'do', way above.) Each
      * Transparent data buffer has the EOB bit, and NOT the EOM bit, set and
@@ -1034,15 +969,13 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
      * Smooth flow control hysterisis by maintaining task stoppage until half
      * the available write buffers are available.
      */
-    if (ch->tx_full && (ch->txd_free >= (ch->txd_num / 2)))
-    {
+    if (ch->tx_full && (ch->txd_free >= (ch->txd_num / 2))) {
 	/*
 	 * Then, only releave task stoppage if we actually have enough
 	 * buffers to service the last requested packet.  It may require MORE
 	 * than half the available!
 	 */
-	if (ch->txd_free >= ch->txd_required)
-	{
+	if (ch->txd_free >= ch->txd_required) {
 
 #ifdef RLD_TXFULL_DEBUG
 	    if (cxt1e1_log_level >= LOG_MONITOR2)
@@ -1057,8 +990,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 	}
     }
 #ifdef RLD_TXFULL_DEBUG
-    else if (ch->tx_full)
-    {
+    else if (ch->tx_full) {
 	if (cxt1e1_log_level >= LOG_MONITOR2)
 	    pr_info("tx_eom[%d]: bypass TX enable though room available? (txd_free %d txd_num/2 %d)\n",
 		    ch->channum,
@@ -1087,8 +1019,7 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
     u_int32_t   error;
 
     ch = pi->chan[gchan];
-    if (ch == 0 || ch->state != UP)
-    {
+    if (ch == 0 || ch->state != UP) {
 	if (cxt1e1_log_level > LOG_ERROR)
 	    pr_info("%s: intr: receive EOM on uninitialized channel %d\n",
 		    pi->up->devname, gchan);
@@ -1097,8 +1028,7 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
     if (ch->mdr == 0)
 	return;                     /* can this happen ? */
 
-    for (;;)
-    {
+    for (;;) {
 	FLUSH_MEM_READ ();
 	md = &ch->mdr[ch->rxix_irq_srv];
 	status = le32_to_cpu (md->status);
@@ -1106,8 +1036,7 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 	    break;                  /* Not our mdesc, done */
 	m = md->mem_token;
 	error = (status >> 16) & 0xf;
-	if (error == 0)
-	{
+	if (error == 0) {
 #ifdef CONFIG_SBE_WAN256T3_NCOMM
 	    int         hdlcnum = (pi->portnum * 32 + gchan);
 
@@ -1115,16 +1044,14 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 	     * if the packet number belongs to NCOMM, then send it to the TMS
 	     * driver
 	     */
-	    if (hdlcnum >= 228)
-	    {
+	    if (hdlcnum >= 228) {
 		if (nciProcess_RX_packet)
 		    (*nciProcess_RX_packet) (hdlcnum, status & 0x3fff, m, ch->user);
 	    } else
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/
 
 	    {
-			       if ((m2 = OS_mem_token_alloc (cxt1e1_max_mru)))
-		{
+		if ((m2 = OS_mem_token_alloc (cxt1e1_max_mru))) {
 		    /* substitute the mbuf+cluster */
 		    md->mem_token = m2;
 		    md->data = cpu_to_le32 (OS_vtophys (OS_mem_token_data (m2)));
@@ -1134,26 +1061,18 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 		    ch->s.rx_packets++;
 		    ch->s.rx_bytes += status & LENGTH_MASK;
 		} else
-		{
 		    ch->s.rx_dropped++;
-		}
 	    }
 	} else if (error == ERR_FCS)
-	{
 	    ch->s.rx_crc_errors++;
-	} else if (error == ERR_ALIGN)
-	{
+	else if (error == ERR_ALIGN)
 	    ch->s.rx_missed_errors++;
-	} else if (error == ERR_ABT)
-	{
+	else if (error == ERR_ABT)
 	    ch->s.rx_missed_errors++;
-	} else if (error == ERR_LNG)
-	{
+	else if (error == ERR_LNG)
 	    ch->s.rx_length_errors++;
-	} else if (error == ERR_SHT)
-	{
+	else if (error == ERR_SHT)
 	    ch->s.rx_length_errors++;
-	}
 	FLUSH_MEM_WRITE ();
 	       status = cxt1e1_max_mru;
 	if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
@@ -1180,16 +1099,13 @@ musycc_intr_th_handler (void *devp)
      * might be shared, just return.
      */
     if (ci->state == C_INIT)
-    {
 	return IRQ_NONE;
-    }
     /*
      * Marked as hardware available. Don't service interrupts, just clear the
      * event.
      */
 
-    if (ci->state == C_IDLE)
-    {
+    if (ci->state == C_IDLE) {
 	status = pci_read_32 ((u_int32_t *) &ci->reg->isd);
 
 	/* clear the interrupt but process nothing else */
@@ -1218,10 +1134,8 @@ musycc_intr_th_handler (void *devp)
     /* incorrect ISD's are encountered.                      */
     /*********************************************************/
 
-    if (nextInt != INTRPTS_NEXTINT (ci->intlog.this_status_new))
-    {
-	if (cxt1e1_log_level >= LOG_MONITOR)
-	{
+    if (nextInt != INTRPTS_NEXTINT (ci->intlog.this_status_new)) {
+	if (cxt1e1_log_level >= LOG_MONITOR) {
 	    pr_info("%s: note - updated ISD from %08x to %08x\n",
 		    ci->devname, status,
 	      (status & (~INTRPTS_NEXTINT_M)) | ci->intlog.this_status_new);
@@ -1243,9 +1157,8 @@ musycc_intr_th_handler (void *devp)
     /**********************************************/
 
     if (intCnt == INT_QUEUE_SIZE)
-    {
 	currInt = ((intCnt - 1) + nextInt) & (INT_QUEUE_SIZE - 1);
-    } else
+    else
 	/************************************************/
 	/* Interrupt Write Location Issues              */
 	/* -------------------------------              */
@@ -1263,10 +1176,8 @@ musycc_intr_th_handler (void *devp)
 	/************************************************/
 
     if (intCnt)
-    {
 	currInt = (intCnt + nextInt) & (INT_QUEUE_SIZE - 1);
-    } else
-    {
+    else {
 	/*
 	 * NOTE: Servicing an interrupt whose ISD contains a count of ZERO
 	 * can be indicative of a Shared Interrupt chain.  Our driver can be
@@ -1289,9 +1200,7 @@ musycc_intr_th_handler (void *devp)
     ci->intlog.this_status_new = currInt;
 
     if ((cxt1e1_log_level >= LOG_WARN) && (status & INTRPTS_INTFULL_M))
-    {
 	pr_info("%s: Interrupt queue full condition occurred\n", ci->devname);
-    }
     if (cxt1e1_log_level >= LOG_DEBUG)
 	pr_info("%s: interrupts pending, isd @ 0x%p: %x curr %d cnt %d NEXT %d\n",
 		ci->devname, &ci->reg->isd,
@@ -1336,8 +1245,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
      * Hardware not available, potential interrupt hang.  But since interrupt
      * might be shared, just return.
      */
-    if ((drvr_state != SBE_DRVR_AVAILABLE) || (ci->state == C_INIT))
-    {
+    if ((drvr_state != SBE_DRVR_AVAILABLE) || (ci->state == C_INIT)) {
 #if defined(SBE_ISR_IMMEDIATE)
 	return 0L;
 #else
@@ -1345,8 +1253,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 #endif
     }
 #if defined(SBE_ISR_TASKLET) || defined(SBE_ISR_IMMEDIATE)
-    if (drvr_state != SBE_DRVR_AVAILABLE)
-    {
+    if (drvr_state != SBE_DRVR_AVAILABLE) {
 #if defined(SBE_ISR_TASKLET)
 	return;
 #elif defined(SBE_ISR_IMMEDIATE)
@@ -1365,8 +1272,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	max_bh = max (bh, max_bh);
     }
     atomic_set (&ci->bh_pending, 0);/* if here, no longer pending */
-    while ((headx = ci->iqp_headx) != (tailx = ci->iqp_tailx))
-    {
+    while ((headx = ci->iqp_headx) != (tailx = ci->iqp_tailx)) {
 	intCnt = (tailx >= headx) ? (tailx - headx) : (tailx - headx + INT_QUEUE_SIZE);
 	currInt = le32_to_cpu (ci->iqd_p[headx]);
 
@@ -1385,8 +1291,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	if ((currInt == badInt) || (currInt == badInt2))
 	    ci->intlog.drvr_int_failure++;
 
-	while ((currInt == badInt) || (currInt == badInt2))
-	{
+	while ((currInt == badInt) || (currInt == badInt2)) {
 	    for (loopCount = 0; loopCount < 0x30; loopCount++)
 		OS_uwait_dummy ();  /* use call to avoid optimization removal
 				     * of dummy delay */
@@ -1396,9 +1301,8 @@ musycc_intr_bh_tasklet (ci_t * ci)
 		break;
 	}
 
-	if ((currInt == badInt) || (currInt == badInt2))        /* catch failure of Bug
+	if ((currInt == badInt) || (currInt == badInt2)) {      /* catch failure of Bug
 								 * Fix checking */
-	{
 	    if (cxt1e1_log_level >= LOG_WARN)
 		pr_info("%s: Illegal Interrupt Detected @ 0x%p, mod %d.)\n",
 			ci->devname, &ci->iqd_p[headx], headx);
@@ -1414,12 +1318,9 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	     */
 
 	    if (currInt == badInt)
-	    {
 		ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY2);
-	    } else
-	    {
+	    else
 		ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
-	    }
 	    ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1); /* insure wrapness */
 	    FLUSH_MEM_WRITE ();
 	    FLUSH_MEM_READ ();
@@ -1434,8 +1335,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	ci->iqd_p[headx] = __constant_cpu_to_le32 (INT_EMPTY_ENTRY);
 	FLUSH_MEM_WRITE ();
 
-	if (cxt1e1_log_level >= LOG_DEBUG)
-	{
+	if (cxt1e1_log_level >= LOG_DEBUG) {
 	    if (err != 0)
 		pr_info(" %08x -> err: %2d,", currInt, err);
 
@@ -1445,11 +1345,9 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	pi = &ci->port[group];      /* notice that here we assume 1-1 group -
 				     * port mapping */
 	ch = pi->chan[gchan];
-	switch (event)
-	{
+	switch (event) {
 	case EVE_SACK:              /* Service Request Acknowledge */
-	    if (cxt1e1_log_level >= LOG_DEBUG)
-	    {
+	    if (cxt1e1_log_level >= LOG_DEBUG) {
 		volatile u_int32_t r;
 
 		r = pci_read_32 ((u_int32_t *) &pi->reg->srd);
@@ -1463,12 +1361,9 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	case EVE_EOM:               /* End Of Message */
 	case EVE_EOB:               /* End Of Buffer (Transparent mode) */
 	    if (tx)
-	    {
 		musycc_bh_tx_eom (pi, gchan);
-	    } else
-	    {
+	    else
 		musycc_bh_rx_eom (pi, gchan);
-	    }
 #if 0
 	    break;
 #else
@@ -1480,9 +1375,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 #endif
 	case EVE_NONE:
 	    if (err == ERR_SHT)
-	    {
 		ch->s.rx_length_errors++;
-	    }
 	    break;
 	default:
 	    if (cxt1e1_log_level >= LOG_WARN)
@@ -1498,8 +1391,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	 * bit-level processing.
 	 */
 
-	switch (err)
-	{
+	switch (err) {
 	case ERR_ONR:
 	    /*
 	     * Per MUSYCC manual, Section  6.4.8.3 [Transmit Errors], this
@@ -1508,8 +1400,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	     * Per MUSYCC manual, Section  6.4.8.4 [Receive Errors], this error
 	     * requires Receive channel reactivation.
 	     */
-	    if (tx)
-	    {
+	    if (tx) {
 
 		/*
 		 * TX ONR Error only occurs when channel is configured for
@@ -1532,9 +1423,8 @@ musycc_intr_bh_tasklet (ci_t * ci)
 			pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
 				ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped (ch->user), ch->txd_free);
 #ifdef RLD_DEBUG
-			if (ch->p.chan_mode == 2)       /* problem = ONR on HDLC
+			if (ch->p.chan_mode == 2) {     /* problem = ONR on HDLC
 							 * mode */
-			{
 			    pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
 				    (u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
 				    sd_queue_stopped (ch->user),
@@ -1544,8 +1434,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 #endif
 		    }
 		}
-	    } else                  /* RX buffer overrun */
-	    {
+	    } else {                 /* RX buffer overrun */
 		/*
 		 * Per MUSYCC manual, Section 6.4.8.4 [Receive Errors],
 		 * channel recovery for this RX ONR error IS required.  It is
@@ -1556,8 +1445,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 		ch->s.rx_over_errors++;
 		ch->ch_start_rx = CH_START_RX_ONR;
 
-		if (cxt1e1_log_level >= LOG_WARN)
-		{
+		if (cxt1e1_log_level >= LOG_WARN) {
 		    pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
 			    ci->devname, ch->channum, ch->p.chan_mode);
 		    //musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
@@ -1566,8 +1454,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 	    musycc_chan_restart (ch);
 	    break;
 	case ERR_BUF:
-	    if (tx)
-	    {
+	    if (tx) {
 		ch->s.tx_fifo_errors++;
 		ch->ch_start_tx = CH_START_TX_BUF;
 		/*
@@ -1577,8 +1464,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 		if (cxt1e1_log_level >= LOG_MONITOR)
 		    pr_info("%s: TX buffer underrun [BUFF] on channel %d, mode %x\n",
 			    ci->devname, ch->channum, ch->p.chan_mode);
-	    } else                  /* RX buffer overrun */
-	    {
+	    } else {                 /* RX buffer overrun */
 		ch->s.rx_over_errors++;
 		/*
 		 * Per MUSYCC manual, Section 6.4.8.4 [Receive Errors], HDLC
@@ -1610,16 +1496,13 @@ musycc_intr_bh_tasklet (ci_t * ci)
 
 	/* Check for interrupt lost condition */
 	if ((currInt & INTRPT_ILOST_M) && (cxt1e1_log_level >= LOG_ERROR))
-	{
 	    pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
 		    ci->devname);
-	}
 	ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);     /* insure wrapness */
 	FLUSH_MEM_WRITE ();
 	FLUSH_MEM_READ ();
     }                               /* while */
-    if ((cxt1e1_log_level >= LOG_MONITOR2) && (ci->iqp_headx != ci->iqp_tailx))
-    {
+    if ((cxt1e1_log_level >= LOG_MONITOR2) && (ci->iqp_headx != ci->iqp_tailx)) {
 	int         bh;
 
 	bh = atomic_read (&CI->bh_pending);
@@ -1690,16 +1573,12 @@ musycc_chan_down (ci_t * dummy, int channum)
     pi->regram->rmp[gchan] = 0;
     FLUSH_MEM_WRITE ();
     for (i = 0; i < ch->txd_num; i++)
-    {
 	if (ch->mdt[i].mem_token != 0)
 	    OS_mem_token_free (ch->mdt[i].mem_token);
-    }
 
     for (i = 0; i < ch->rxd_num; i++)
-    {
 	if (ch->mdr[i].mem_token != 0)
 	    OS_mem_token_free (ch->mdr[i].mem_token);
-    }
 
     OS_kfree (ch->mdr);
     ch->mdr = 0;
@@ -1787,16 +1666,14 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     m2 = mem_token;
     txd_need_cnt = 0;
     for (len = OS_mem_token_tlen (m2); len > 0;
-	 m2 = (void *) OS_mem_token_next (m2))
-    {
+	 m2 = (void *) OS_mem_token_next (m2)) {
 	if (!OS_mem_token_len (m2))
 	    continue;
 	txd_need_cnt++;
 	len -= OS_mem_token_len (m2);
     }
 
-    if (txd_need_cnt == 0)
-    {
+    if (txd_need_cnt == 0) {
 	if (cxt1e1_log_level >= LOG_MONITOR2)
 	    pr_info("%s channel %d: no TX data in User buffer\n", ci->devname, channum);
 	OS_mem_token_free (mem_token);
@@ -1805,14 +1682,11 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     /*************************************************/
     /** Are there sufficient descriptors available? **/
     /*************************************************/
-    if (txd_need_cnt > ch->txd_num) /* never enough descriptors for this
-				     * large a buffer */
-    {
+    if (txd_need_cnt > ch->txd_num) { /* never enough descriptors for this
+				       * large a buffer */
 	if (cxt1e1_log_level >= LOG_DEBUG)
-	{
 	    pr_info("start_xmit: discarding buffer, insufficient descriptor cnt %d, need %d.\n",
 		    ch->txd_num, txd_need_cnt + 1);
-	}
 	ch->s.tx_dropped++;
 	OS_mem_token_free (mem_token);
 	return 0;
@@ -1823,13 +1697,10 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     /************************************************************/
     /** flow control the line if not enough descriptors remain **/
     /************************************************************/
-    if (txd_need_cnt > ch->txd_free)
-    {
+    if (txd_need_cnt > ch->txd_free) {
 	if (cxt1e1_log_level >= LOG_MONITOR2)
-	{
 	    pr_info("start_xmit[%d]: EBUSY - need more descriptors, have %d of %d need %d\n",
 		    channum, ch->txd_free, ch->txd_num, txd_need_cnt);
-	}
 	ch->tx_full = 1;
 	ch->txd_required = txd_need_cnt;
 	sd_disable_xmit (ch->user);
@@ -1844,8 +1715,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     m2 = mem_token;
     md = ch->txd_usr_add;           /* get current available descriptor */
 
-    for (len = OS_mem_token_tlen (m2); len > 0; m2 = OS_mem_token_next (m2))
-    {
+    for (len = OS_mem_token_tlen (m2); len > 0; m2 = OS_mem_token_next (m2)) {
 	int         u = OS_mem_token_len (m2);
 
 	if (!u)
@@ -1861,8 +1731,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 
 	if (len)                    /* not last chunk */
 	    u |= EOBIRQ_ENABLE;
-	else if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
-	{
+	else if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)	{
 	    /*
 	     * Per MUSYCC Ref 6.4.9 for Transparent Mode, the host must
 	     * always clear EOMIRQ_ENABLE in every Transmit Buffer Descriptor
@@ -1875,8 +1744,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
 
 	/* last chunk in hdlc mode */
 	u |= (ch->p.idlecode << IDLE_CODE);
-	if (ch->p.pad_fill_count)
-	{
+	if (ch->p.pad_fill_count) {
 #if 0
 	    /* NOOP NOTE: u_int8_t cannot be > 0xFF */
 	    /* sanitize pad_fill_count for maximums allowed by hardware */
@@ -1919,9 +1787,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
      * transmission.
      */
     if (ch->ch_start_tx)
-    {
 	musycc_chan_restart (ch);
-    }
 #ifdef SBE_WAN256T3_ENABLE
     wan256t3_led (ci, LED_TX, LEDV_G);
 #endif
-- 
1.7.10.4

