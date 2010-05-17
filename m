Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755780Ab0EQT0U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:26:20 -0400
Received: from mga11.intel.com ([192.55.52.93]:18727 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755014Ab0EQT0S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:26:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="567961819"
Subject: async_tx.git updated
From: Dan Williams <dan.j.williams@intel.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Cc: linus.walleij@stericsson.com, jassi.brar@samsung.com
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 May 2010 12:23:54 -0700
Message-ID: <1274124234.24802.18.camel@dwillia2-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below is my current patch queue.  The primary standouts are Linus'
primecell api patches (pending an evaluation of their suitability for
Versatile-muxing and the conversion of dma_set_amba_config() to use an
extended version of the ->device_control() method) and Jassi's pl330 dma
driver (pending the merge of Russell's queue which has the base
infrastructure).

Linus note the two fixes you sent for the dma40 driver rely on the
primecell reworks so are not included below.

Also, the new patch "async_tx: trim dma_async_tx_descriptor in 'no
channel switch' case" may be of interest to dma platforms that want to
eliminate some of the overhead of struct dma_async_tx_descriptor by
selecting ASYNC_TX_DISABLE_CHANNEL_SWITCH, see below.

--
Dan


The following changes since commit e40152ee1e1c7a63f4777791863215e3faa37a86:
  Linus Torvalds (1):
        Linus 2.6.34

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/djbw/async_tx.git next

Dan Williams (6):
      dmaengine: provide helper for setting txstate
      ioat: convert to circ_buf
      ioat2,3: convert to producer/consumer locking
      ioat3: disable cacheline-unaligned transfers for raid operations
      async_tx: trim dma_async_tx_descriptor in 'no channel switch' case
      Merge branch 'ioat' into dmaengine

Jassi Brar (1):
      DMA ENGINE: Do not reset 'private' of channel

Linus Walleij (5):
      DMAENGINE: COH 901 318 rename confusing vars
      DMAENGINE: COH 901 318 fix bytesleft
      DMAENGINE: generic slave control v2
      DMAENGINE: generic channel status v2
      DMAENGINE: Support for ST-Ericssons DMA40 block v3

Minskey Guo (1):
      ioat: Remove duplicated devm_kzalloc() calls for ioatdma_device

Richard Röjfors (2):
      dma: Add timb-dma
      dma: timb-dma: Update comment and fix compiler warning

Stephen Rothwell (1):
      async_tx: use of kzalloc/kfree requires the include of slab.h

Tobias Klauser (1):
      dmaengine: mpc512x: Use resource_size

 arch/arm/mach-u300/include/mach/coh901318.h    |   21 -
 arch/arm/plat-nomadik/include/plat/ste_dma40.h |  239 +++
 crypto/async_tx/async_tx.c                     |   46 +-
 drivers/dma/Kconfig                            |   14 +
 drivers/dma/Makefile                           |    2 +
 drivers/dma/at_hdmac.c                         |   34 +-
 drivers/dma/coh901318.c                        |  262 ++-
 drivers/dma/dmaengine.c                        |   22 +-
 drivers/dma/dw_dmac.c                          |   23 +-
 drivers/dma/fsldma.c                           |   28 +-
 drivers/dma/ioat/dma.c                         |   12 +-
 drivers/dma/ioat/dma.h                         |   19 +-
 drivers/dma/ioat/dma_v2.c                      |  186 +-
 drivers/dma/ioat/dma_v2.h                      |   33 +-
 drivers/dma/ioat/dma_v3.c                      |  143 +-
 drivers/dma/ioat/pci.c                         |    7 +-
 drivers/dma/iop-adma.c                         |   39 +-
 drivers/dma/ipu/ipu_idmac.c                    |   32 +-
 drivers/dma/mpc512x_dma.c                      |   15 +-
 drivers/dma/mv_xor.c                           |   25 +-
 drivers/dma/ppc4xx/adma.c                      |   19 +-
 drivers/dma/shdma.c                            |   26 +-
 drivers/dma/ste_dma40.c                        | 2596 ++++++++++++++++++++++++
 drivers/dma/ste_dma40_ll.c                     |  454 +++++
 drivers/dma/ste_dma40_ll.h                     |  354 ++++
 drivers/dma/timb_dma.c                         |  859 ++++++++
 drivers/dma/txx9dmac.c                         |   22 +-
 drivers/mmc/host/atmel-mci.c                   |    2 +-
 drivers/serial/sh-sci.c                        |    2 +-
 drivers/video/mx3fb.c                          |    3 +-
 include/linux/dmaengine.h                      |  127 ++-
 include/linux/timb_dma.h                       |   55 +
 sound/soc/txx9/txx9aclc.c                      |    6 +-
 33 files changed, 5216 insertions(+), 511 deletions(-)
 create mode 100644 arch/arm/plat-nomadik/include/plat/ste_dma40.h
 create mode 100644 drivers/dma/ste_dma40.c
 create mode 100644 drivers/dma/ste_dma40_ll.c
 create mode 100644 drivers/dma/ste_dma40_ll.h
 create mode 100644 drivers/dma/timb_dma.c
 create mode 100644 include/linux/timb_dma.h

--
async_tx: trim dma_async_tx_descriptor in 'no channel switch' case

From: Dan Williams <dan.j.williams@intel.com>

Saves 24 bytes per descriptor (64-bit) when the channel-switching
capabilities of async_tx are not required.

Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---

 crypto/async_tx/async_tx.c |   46 ++++++++++++++-------------------
 drivers/dma/dmaengine.c    |   16 ++++++------
 include/linux/dmaengine.h  |   61 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 89 insertions(+), 34 deletions(-)


diff --git a/crypto/async_tx/async_tx.c b/crypto/async_tx/async_tx.c
index f9cdf04..7f2c00a 100644
--- a/crypto/async_tx/async_tx.c
+++ b/crypto/async_tx/async_tx.c
@@ -81,18 +81,13 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	struct dma_device *device = chan->device;
 	struct dma_async_tx_descriptor *intr_tx = (void *) ~0;
 
-	#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
-	BUG();
-	#endif
-
 	/* first check to see if we can still append to depend_tx */
-	spin_lock_bh(&depend_tx->lock);
-	if (depend_tx->parent && depend_tx->chan == tx->chan) {
-		tx->parent = depend_tx;
-		depend_tx->next = tx;
+	txd_lock(depend_tx);
+	if (txd_parent(depend_tx) && depend_tx->chan == tx->chan) {
+		txd_chain(depend_tx, tx);
 		intr_tx = NULL;
 	}
-	spin_unlock_bh(&depend_tx->lock);
+	txd_unlock(depend_tx);
 
 	/* attached dependency, flush the parent channel */
 	if (!intr_tx) {
@@ -111,24 +106,22 @@ async_tx_channel_switch(struct dma_async_tx_descriptor *depend_tx,
 	if (intr_tx) {
 		intr_tx->callback = NULL;
 		intr_tx->callback_param = NULL;
-		tx->parent = intr_tx;
-		/* safe to set ->next outside the lock since we know we are
+		/* safe to chain outside the lock since we know we are
 		 * not submitted yet
 		 */
-		intr_tx->next = tx;
+		txd_chain(intr_tx, tx);
 
 		/* check if we need to append */
-		spin_lock_bh(&depend_tx->lock);
-		if (depend_tx->parent) {
-			intr_tx->parent = depend_tx;
-			depend_tx->next = intr_tx;
+		txd_lock(depend_tx);
+		if (txd_parent(depend_tx)) {
+			txd_chain(depend_tx, intr_tx);
 			async_tx_ack(intr_tx);
 			intr_tx = NULL;
 		}
-		spin_unlock_bh(&depend_tx->lock);
+		txd_unlock(depend_tx);
 
 		if (intr_tx) {
-			intr_tx->parent = NULL;
+			txd_clear_parent(intr_tx);
 			intr_tx->tx_submit(intr_tx);
 			async_tx_ack(intr_tx);
 		}
@@ -176,21 +169,20 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 		 * 2/ dependencies are 1:1 i.e. two transactions can
 		 * not depend on the same parent
 		 */
-		BUG_ON(async_tx_test_ack(depend_tx) || depend_tx->next ||
-		       tx->parent);
+		BUG_ON(async_tx_test_ack(depend_tx) || txd_next(depend_tx) ||
+		       txd_parent(tx));
 
 		/* the lock prevents async_tx_run_dependencies from missing
 		 * the setting of ->next when ->parent != NULL
 		 */
-		spin_lock_bh(&depend_tx->lock);
-		if (depend_tx->parent) {
+		txd_lock(depend_tx);
+		if (txd_parent(depend_tx)) {
 			/* we have a parent so we can not submit directly
 			 * if we are staying on the same channel: append
 			 * else: channel switch
 			 */
 			if (depend_tx->chan == chan) {
-				tx->parent = depend_tx;
-				depend_tx->next = tx;
+				txd_chain(depend_tx, tx);
 				s = ASYNC_TX_SUBMITTED;
 			} else
 				s = ASYNC_TX_CHANNEL_SWITCH;
@@ -203,7 +195,7 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 			else
 				s = ASYNC_TX_CHANNEL_SWITCH;
 		}
-		spin_unlock_bh(&depend_tx->lock);
+		txd_unlock(depend_tx);
 
 		switch (s) {
 		case ASYNC_TX_SUBMITTED:
@@ -212,12 +204,12 @@ async_tx_submit(struct dma_chan *chan, struct dma_async_tx_descriptor *tx,
 			async_tx_channel_switch(depend_tx, tx);
 			break;
 		case ASYNC_TX_DIRECT_SUBMIT:
-			tx->parent = NULL;
+			txd_clear_parent(tx);
 			tx->tx_submit(tx);
 			break;
 		}
 	} else {
-		tx->parent = NULL;
+		txd_clear_parent(tx);
 		tx->tx_submit(tx);
 	}
 
diff --git a/drivers/dma/dmaengine.c b/drivers/dma/dmaengine.c
index d18b5d0..fcfe1a6 100644
--- a/drivers/dma/dmaengine.c
+++ b/drivers/dma/dmaengine.c
@@ -978,7 +978,9 @@ void dma_async_tx_descriptor_init(struct dma_async_tx_descriptor *tx,
 	struct dma_chan *chan)
 {
 	tx->chan = chan;
+	#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	spin_lock_init(&tx->lock);
+	#endif
 }
 EXPORT_SYMBOL(dma_async_tx_descriptor_init);
 
@@ -1011,7 +1013,7 @@ EXPORT_SYMBOL_GPL(dma_wait_for_async_tx);
  */
 void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 {
-	struct dma_async_tx_descriptor *dep = tx->next;
+	struct dma_async_tx_descriptor *dep = txd_next(tx);
 	struct dma_async_tx_descriptor *dep_next;
 	struct dma_chan *chan;
 
@@ -1019,7 +1021,7 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 		return;
 
 	/* we'll submit tx->next now, so clear the link */
-	tx->next = NULL;
+	txd_clear_next(tx);
 	chan = dep->chan;
 
 	/* keep submitting up until a channel switch is detected
@@ -1027,14 +1029,14 @@ void dma_run_dependencies(struct dma_async_tx_descriptor *tx)
 	 * processing the interrupt from async_tx_channel_switch
 	 */
 	for (; dep; dep = dep_next) {
-		spin_lock_bh(&dep->lock);
-		dep->parent = NULL;
-		dep_next = dep->next;
+		txd_lock(dep);
+		txd_clear_parent(dep);
+		dep_next = txd_next(dep);
 		if (dep_next && dep_next->chan == chan)
-			dep->next = NULL; /* ->next will be submitted */
+			txd_clear_next(dep); /* ->next will be submitted */
 		else
 			dep_next = NULL; /* submit current dep and terminate */
-		spin_unlock_bh(&dep->lock);
+		txd_unlock(dep);
 
 		dep->tx_submit(dep);
 	}
diff --git a/include/linux/dmaengine.h b/include/linux/dmaengine.h
index 20ea12c..fa35164 100644
--- a/include/linux/dmaengine.h
+++ b/include/linux/dmaengine.h
@@ -230,11 +230,72 @@ struct dma_async_tx_descriptor {
 	dma_cookie_t (*tx_submit)(struct dma_async_tx_descriptor *tx);
 	dma_async_tx_callback callback;
 	void *callback_param;
+#ifndef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
 	struct dma_async_tx_descriptor *next;
 	struct dma_async_tx_descriptor *parent;
 	spinlock_t lock;
+#endif
 };
 
+#ifdef CONFIG_ASYNC_TX_DISABLE_CHANNEL_SWITCH
+static inline void txd_lock(struct dma_async_tx_descriptor *txd)
+{
+	BUG();
+}
+static inline void txd_unlock(struct dma_async_tx_descriptor *txd)
+{
+}
+static inline void txd_chain(struct dma_async_tx_descriptor *txd, struct dma_async_tx_descriptor *next)
+{
+	BUG();
+}
+static inline void txd_clear_parent(struct dma_async_tx_descriptor *txd)
+{
+}
+static inline void txd_clear_next(struct dma_async_tx_descriptor *txd)
+{
+}
+static inline struct dma_async_tx_descriptor *txd_next(struct dma_async_tx_descriptor *txd)
+{
+	return NULL;
+}
+static inline struct dma_async_tx_descriptor *txd_parent(struct dma_async_tx_descriptor *txd)
+{
+	return NULL;
+}
+
+#else
+static inline void txd_lock(struct dma_async_tx_descriptor *txd)
+{
+	spin_lock_bh(&txd->lock);
+}
+static inline void txd_unlock(struct dma_async_tx_descriptor *txd)
+{
+	spin_unlock_bh(&txd->lock);
+}
+static inline void txd_chain(struct dma_async_tx_descriptor *txd, struct dma_async_tx_descriptor *next)
+{
+	txd->next = next;
+	next->parent = txd;
+}
+static inline void txd_clear_parent(struct dma_async_tx_descriptor *txd)
+{
+	txd->parent = NULL;
+}
+static inline void txd_clear_next(struct dma_async_tx_descriptor *txd)
+{
+	txd->next = NULL;
+}
+static inline struct dma_async_tx_descriptor *txd_parent(struct dma_async_tx_descriptor *txd)
+{
+	return txd->parent;
+}
+static inline struct dma_async_tx_descriptor *txd_next(struct dma_async_tx_descriptor *txd)
+{
+	return txd->next;
+}
+#endif
+
 /**
  * struct dma_device - info on the entity supplying DMA services
  * @chancnt: how many DMA channels are supported


