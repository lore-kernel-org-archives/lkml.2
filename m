Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950Ab2LRNND (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 08:13:03 -0500
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:43842 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754836Ab2LRNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 08:12:50 -0500
From: Loic Pallardy <loic.pallardy-ext@stericsson.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Janusz Krzysztofik <jkrzyszt@tis.icnet.pl>,
        Omar Ramirez Luna <omar.ramirez@copitl.com>,
        Loic PALLARDY <loic.pallardy@st.com>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Dom Cobley <popcornmix@gmail.com>, Wim Van Sebroeck <wim@iguana.be>,
        Linus Walleij <linus.walleij@linaro.org>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        Tejun Heo <tj@kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        STEricsson_nomadik_linux <STEricsson_nomadik_linux@list.st.com>,
        Loic Pallardy <loic.pallardy-ext@stericsson.com>
Subject: [PATCH 3/9] mailbox: rename omap_mbox in mailbox
Date: Tue, 18 Dec 2012 14:10:06 +0100
Message-ID: <1355836212-17956-4-git-send-email-loic.pallardy-ext@stericsson.com>
X-Mailer: git-send-email 1.7.11.1
In-Reply-To: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
References: <1355836212-17956-1-git-send-email-loic.pallardy-ext@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In order to create a generic mailbox framework, functions
and structures should be renamed in mailbox.

Signed-off-by: Loic Pallardy <loic.pallardy@st.com>
---
 drivers/mailbox/Kconfig         |   3 +-
 drivers/mailbox/mailbox-omap1.c |  28 ++++-----
 drivers/mailbox/mailbox-omap2.c |  60 +++++++++---------
 drivers/mailbox/mailbox.c       | 133 ++++++++++++++++++++--------------------
 drivers/mailbox/mailbox.h       |  56 ++++++++---------
 include/linux/mailbox.h         |  22 +++----
 6 files changed, 151 insertions(+), 151 deletions(-)

diff --git a/drivers/mailbox/Kconfig b/drivers/mailbox/Kconfig
index e98ca6c..d1e7d74 100644
--- a/drivers/mailbox/Kconfig
+++ b/drivers/mailbox/Kconfig
@@ -25,9 +25,8 @@ config OMAP2PLUS_MBOX
          to use OMAP2+ Mailbox framework support.
 
 
-config OMAP_MBOX_KFIFO_SIZE
+config MBOX_KFIFO_SIZE
        int "Mailbox kfifo default buffer size (bytes)"
-       depends on OMAP1_MBOX || OMAP2PLUS_MBOX
        default 256
        help
          Specify the default size of mailbox's kfifo buffers (bytes).
diff --git a/drivers/mailbox/mailbox-omap1.c b/drivers/mailbox/mailbox-omap1.c
index d681d4e..31cb70a 100644
--- a/drivers/mailbox/mailbox-omap1.c
+++ b/drivers/mailbox/mailbox-omap1.c
@@ -50,7 +50,7 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
 }
 
 /* msg */
-static mbox_msg_t omap1_mbox_fifo_read(struct omap_mbox *mbox)
+static mbox_msg_t omap1_mbox_fifo_read(struct mailbox *mbox)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
@@ -63,7 +63,7 @@ static mbox_msg_t omap1_mbox_fifo_read(struct omap_mbox *mbox)
 }
 
 static void
-omap1_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+omap1_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->tx_fifo;
@@ -72,12 +72,12 @@ omap1_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
 	mbox_write_reg(msg >> 16, fifo->cmd);
 }
 
-static int omap1_mbox_fifo_empty(struct omap_mbox *mbox)
+static int omap1_mbox_fifo_empty(struct mailbox *mbox)
 {
 	return 0;
 }
 
-static int omap1_mbox_fifo_full(struct omap_mbox *mbox)
+static int omap1_mbox_fifo_full(struct mailbox *mbox)
 {
 	struct omap_mbox1_fifo *fifo =
 		&((struct omap_mbox1_priv *)mbox->priv)->rx_fifo;
@@ -87,29 +87,29 @@ static int omap1_mbox_fifo_full(struct omap_mbox *mbox)
 
 /* irq */
 static void
-omap1_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+omap1_mbox_enable_irq(struct mailbox *mbox, mailbox_type_t irq)
 {
 	if (irq == IRQ_RX)
 		enable_irq(mbox->irq);
 }
 
 static void
-omap1_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+omap1_mbox_disable_irq(struct mailbox *mbox, mailbox_type_t irq)
 {
 	if (irq == IRQ_RX)
 		disable_irq(mbox->irq);
 }
 
 static int
-omap1_mbox_is_irq(struct omap_mbox *mbox, omap_mbox_type_t irq)
+omap1_mbox_is_irq(struct mailbox *mbox, mailbox_type_t irq)
 {
 	if (irq == IRQ_TX)
 		return 0;
 	return 1;
 }
 
-static struct omap_mbox_ops omap1_mbox_ops = {
-	.type           = OMAP_MBOX_TYPE1,
+static struct mailbox_ops omap1_mbox_ops = {
+	.type           = MBOX_HW_FIFO1_TYPE,
 	.fifo_read      = omap1_mbox_fifo_read,
 	.fifo_write     = omap1_mbox_fifo_write,
 	.fifo_empty     = omap1_mbox_fifo_empty,
@@ -135,19 +135,19 @@ static struct omap_mbox1_priv omap1_mbox_dsp_priv = {
 	},
 };
 
-static struct omap_mbox mbox_dsp_info = {
+static struct mailbox mbox_dsp_info = {
 	.name   = "dsp",
 	.ops    = &omap1_mbox_ops,
 	.priv   = &omap1_mbox_dsp_priv,
 };
 
-static struct omap_mbox *omap1_mboxes[] = { &mbox_dsp_info, NULL };
+static struct mailbox *omap1_mboxes[] = { &mbox_dsp_info, NULL };
 
 static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
-	struct omap_mbox **list;
+	struct mailbox **list;
 
 	list = omap1_mboxes;
 	list[0]->irq = platform_get_irq_byname(pdev, "dsp");
@@ -157,7 +157,7 @@ static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 	if (!mbox_base)
 		return -ENOMEM;
 
-	ret = omap_mbox_register(&pdev->dev, list);
+	ret = mailbox_register(&pdev->dev, list);
 	if (ret) {
 		iounmap(mbox_base);
 		return ret;
@@ -168,7 +168,7 @@ static int __devinit omap1_mbox_probe(struct platform_device *pdev)
 
 static int __devexit omap1_mbox_remove(struct platform_device *pdev)
 {
-	omap_mbox_unregister();
+	mailbox_unregister();
 	iounmap(mbox_base);
 	return 0;
 }
diff --git a/drivers/mailbox/mailbox-omap2.c b/drivers/mailbox/mailbox-omap2.c
index 7dcffa8..230d9d3 100644
--- a/drivers/mailbox/mailbox-omap2.c
+++ b/drivers/mailbox/mailbox-omap2.c
@@ -61,8 +61,8 @@ struct omap_mbox2_priv {
 	unsigned long irqdisable;
 };
 
-static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
-		omap_mbox_type_t irq);
+static void omap2_mbox_enable_irq(struct mailbox *mbox,
+		mailbox_type_t irq);
 
 static inline unsigned int mbox_read_reg(size_t ofs)
 {
@@ -75,7 +75,7 @@ static inline void mbox_write_reg(u32 val, size_t ofs)
 }
 
 /* Mailbox H/W preparations */
-static int omap2_mbox_startup(struct omap_mbox *mbox)
+static int omap2_mbox_startup(struct mailbox *mbox)
 {
 	u32 l;
 
@@ -88,35 +88,35 @@ static int omap2_mbox_startup(struct omap_mbox *mbox)
 	return 0;
 }
 
-static void omap2_mbox_shutdown(struct omap_mbox *mbox)
+static void omap2_mbox_shutdown(struct mailbox *mbox)
 {
 	pm_runtime_put_sync(mbox->dev->parent);
 	pm_runtime_disable(mbox->dev->parent);
 }
 
 /* Mailbox FIFO handle functions */
-static mbox_msg_t omap2_mbox_fifo_read(struct omap_mbox *mbox)
+static mbox_msg_t omap2_mbox_fifo_read(struct mailbox *mbox)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
 	return (mbox_msg_t) mbox_read_reg(fifo->msg);
 }
 
-static void omap2_mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+static void omap2_mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
 	mbox_write_reg(msg, fifo->msg);
 }
 
-static int omap2_mbox_fifo_empty(struct omap_mbox *mbox)
+static int omap2_mbox_fifo_empty(struct mailbox *mbox)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->rx_fifo;
 	return (mbox_read_reg(fifo->msg_stat) == 0);
 }
 
-static int omap2_mbox_fifo_full(struct omap_mbox *mbox)
+static int omap2_mbox_fifo_full(struct mailbox *mbox)
 {
 	struct omap_mbox2_fifo *fifo =
 		&((struct omap_mbox2_priv *)mbox->priv)->tx_fifo;
@@ -124,8 +124,8 @@ static int omap2_mbox_fifo_full(struct omap_mbox *mbox)
 }
 
 /* Mailbox IRQ handle functions */
-static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
-		omap_mbox_type_t irq)
+static void omap2_mbox_enable_irq(struct mailbox *mbox,
+		mailbox_type_t irq)
 {
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 l, bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
@@ -135,8 +135,8 @@ static void omap2_mbox_enable_irq(struct omap_mbox *mbox,
 	mbox_write_reg(l, p->irqenable);
 }
 
-static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
-		omap_mbox_type_t irq)
+static void omap2_mbox_disable_irq(struct mailbox *mbox,
+		mailbox_type_t irq)
 {
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
@@ -147,8 +147,8 @@ static void omap2_mbox_disable_irq(struct omap_mbox *mbox,
 	mbox_write_reg(bit, p->irqdisable);
 }
 
-static void omap2_mbox_ack_irq(struct omap_mbox *mbox,
-		omap_mbox_type_t irq)
+static void omap2_mbox_ack_irq(struct mailbox *mbox,
+		mailbox_type_t irq)
 {
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
@@ -159,8 +159,8 @@ static void omap2_mbox_ack_irq(struct omap_mbox *mbox,
 	mbox_read_reg(p->irqstatus);
 }
 
-static int omap2_mbox_is_irq(struct omap_mbox *mbox,
-		omap_mbox_type_t irq)
+static int omap2_mbox_is_irq(struct mailbox *mbox,
+		mailbox_type_t irq)
 {
 	struct omap_mbox2_priv *p = mbox->priv;
 	u32 bit = (irq == IRQ_TX) ? p->notfull_bit : p->newmsg_bit;
@@ -170,7 +170,7 @@ static int omap2_mbox_is_irq(struct omap_mbox *mbox,
 	return (int)(enable & status & bit);
 }
 
-static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
+static void omap2_mbox_save_ctx(struct mailbox *mbox)
 {
 	int i;
 	struct omap_mbox2_priv *p = mbox->priv;
@@ -187,7 +187,7 @@ static void omap2_mbox_save_ctx(struct omap_mbox *mbox)
 	}
 }
 
-static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
+static void omap2_mbox_restore_ctx(struct mailbox *mbox)
 {
 	int i;
 	struct omap_mbox2_priv *p = mbox->priv;
@@ -204,8 +204,8 @@ static void omap2_mbox_restore_ctx(struct omap_mbox *mbox)
 	}
 }
 
-static struct omap_mbox_ops omap2_mbox_ops = {
-	.type           = OMAP_MBOX_TYPE2,
+static struct mailbox_ops omap2_mbox_ops = {
+	.type           = MBOX_HW_FIFO2_TYPE,
 	.startup        = omap2_mbox_startup,
 	.shutdown       = omap2_mbox_shutdown,
 	.fifo_read      = omap2_mbox_fifo_read,
@@ -247,7 +247,7 @@ static struct omap_mbox2_priv omap2_mbox_dsp_priv = {
 	.irqdisable     = MAILBOX_IRQENABLE(0),
 };
 
-struct omap_mbox mbox_dsp_info = {
+struct mailbox mbox_dsp_info = {
 	.name   = "dsp",
 	.ops    = &omap2_mbox_ops,
 	.priv   = &omap2_mbox_dsp_priv,
@@ -255,7 +255,7 @@ struct omap_mbox mbox_dsp_info = {
 #endif
 
 #if defined(CONFIG_ARCH_OMAP3)
-struct omap_mbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
+struct mailbox *omap3_mboxes[] = { &mbox_dsp_info, NULL };
 #endif
 
 #if defined(CONFIG_SOC_OMAP2420)
@@ -276,7 +276,7 @@ static struct omap_mbox2_priv omap2_mbox_iva_priv = {
 	.irqdisable     = MAILBOX_IRQENABLE(3),
 };
 
-static struct omap_mbox mbox_iva_info = {
+static struct mailbox mbox_iva_info = {
 	.name   = "iva",
 	.ops    = &omap2_mbox_ops,
 	.priv   = &omap2_mbox_iva_priv,
@@ -284,7 +284,7 @@ static struct omap_mbox mbox_iva_info = {
 #endif
 
 #ifdef CONFIG_ARCH_OMAP2
-struct omap_mbox *omap2_mboxes[] = {
+struct mailbox *omap2_mboxes[] = {
 	&mbox_dsp_info,
 #ifdef CONFIG_SOC_OMAP2420
 	&mbox_iva_info,
@@ -311,7 +311,7 @@ static struct omap_mbox2_priv omap2_mbox_1_priv = {
 	.irqdisable     = OMAP4_MAILBOX_IRQENABLE_CLR(0),
 };
 
-struct omap_mbox mbox_1_info = {
+struct mailbox mbox_1_info = {
 	.name   = "mailbox-1",
 	.ops    = &omap2_mbox_ops,
 	.priv   = &omap2_mbox_1_priv,
@@ -333,20 +333,20 @@ static struct omap_mbox2_priv omap2_mbox_2_priv = {
 	.irqdisable     = OMAP4_MAILBOX_IRQENABLE_CLR(0),
 };
 
-struct omap_mbox mbox_2_info = {
+struct mailbox mbox_2_info = {
 	.name   = "mailbox-2",
 	.ops    = &omap2_mbox_ops,
 	.priv   = &omap2_mbox_2_priv,
 };
 
-struct omap_mbox *omap4_mboxes[] = { &mbox_1_info, &mbox_2_info, NULL };
+struct mailbox *omap4_mboxes[] = { &mbox_1_info, &mbox_2_info, NULL };
 #endif
 
 static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 {
 	struct resource *mem;
 	int ret;
-	struct omap_mbox **list;
+	struct mailbox **list;
 
 	if (false)
 		;
@@ -386,7 +386,7 @@ static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 	if (!mbox_base)
 		return -ENOMEM;
 
-	ret = omap_mbox_register(&pdev->dev, list);
+	ret = mailbox_register(&pdev->dev, list);
 	if (ret) {
 		iounmap(mbox_base);
 		return ret;
@@ -397,7 +397,7 @@ static int __devinit omap2_mbox_probe(struct platform_device *pdev)
 
 static int __devexit omap2_mbox_remove(struct platform_device *pdev)
 {
-	omap_mbox_unregister();
+	mailbox_unregister();
 	iounmap(mbox_base);
 	return 0;
 }
diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
index 8cb3b15..b9389c6 100644
--- a/drivers/mailbox/mailbox.c
+++ b/drivers/mailbox/mailbox.c
@@ -1,9 +1,10 @@
 /*
- * OMAP mailbox driver
+ * Mailbox framework
  *
  * Copyright (C) 2006-2009 Nokia Corporation. All rights reserved.
  *
  * Contact: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
+ * Author: Loic Pallardy <loic.pallardy@st.com> for ST-Ericsson
  *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
@@ -33,40 +34,40 @@
 
 #include "mailbox.h"
 
-static struct omap_mbox **mboxes;
+static struct mailbox **mboxes;
 
 static int mbox_configured;
 static DEFINE_MUTEX(mbox_configured_lock);
 
-static unsigned int mbox_kfifo_size = CONFIG_OMAP_MBOX_KFIFO_SIZE;
+static unsigned int mbox_kfifo_size = CONFIG_MBOX_KFIFO_SIZE;
 module_param(mbox_kfifo_size, uint, S_IRUGO);
-MODULE_PARM_DESC(mbox_kfifo_size, "Size of omap's mailbox kfifo (bytes)");
+MODULE_PARM_DESC(mbox_kfifo_size, "Size of mailbox kfifo (bytes)");
 
 /* Mailbox FIFO handle functions */
-static inline mbox_msg_t mbox_fifo_read(struct omap_mbox *mbox)
+static inline mbox_msg_t mbox_fifo_read(struct mailbox *mbox)
 {
 	return mbox->ops->fifo_read(mbox);
 }
-static inline void mbox_fifo_write(struct omap_mbox *mbox, mbox_msg_t msg)
+static inline void mbox_fifo_write(struct mailbox *mbox, mbox_msg_t msg)
 {
 	mbox->ops->fifo_write(mbox, msg);
 }
-static inline int mbox_fifo_empty(struct omap_mbox *mbox)
+static inline int mbox_fifo_empty(struct mailbox *mbox)
 {
 	return mbox->ops->fifo_empty(mbox);
 }
-static inline int mbox_fifo_full(struct omap_mbox *mbox)
+static inline int mbox_fifo_full(struct mailbox *mbox)
 {
 	return mbox->ops->fifo_full(mbox);
 }
 
 /* Mailbox IRQ handle functions */
-static inline void ack_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static inline void ack_mbox_irq(struct mailbox *mbox, mailbox_irq_t irq)
 {
 	if (mbox->ops->ack_irq)
 		mbox->ops->ack_irq(mbox, irq);
 }
-static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+static inline int is_mbox_irq(struct mailbox *mbox, mailbox_irq_t irq)
 {
 	return mbox->ops->is_irq(mbox, irq);
 }
@@ -74,12 +75,12 @@ static inline int is_mbox_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
 /*
  * message sender
  */
-static int __mbox_poll_for_space(struct omap_mbox *mbox)
+static int __mbox_poll_for_space(struct mailbox *mbox)
 {
 	int ret = 0, i = 1000;
 
 	while (mbox_fifo_full(mbox)) {
-		if (mbox->ops->type == OMAP_MBOX_TYPE2)
+		if (mbox->ops->type == MBOX_HW_FIFO2_TYPE)
 			return -1;
 		if (--i == 0)
 			return -1;
@@ -88,9 +89,9 @@ static int __mbox_poll_for_space(struct omap_mbox *mbox)
 	return ret;
 }
 
-int omap_mbox_msg_send(struct omap_mbox *mbox, mbox_msg_t msg)
+int mailbox_msg_send(struct mailbox *mbox, mbox_msg_t msg)
 {
-	struct omap_mbox_queue *mq = mbox->txq;
+	struct mailbox_queue *mq = mbox->txq;
 	int ret = 0, len;
 
 	spin_lock_bh(&mq->lock);
@@ -114,9 +115,9 @@ out:
 	spin_unlock_bh(&mq->lock);
 	return ret;
 }
-EXPORT_SYMBOL(omap_mbox_msg_send);
+EXPORT_SYMBOL(mailbox_msg_send);
 
-void omap_mbox_save_ctx(struct omap_mbox *mbox)
+void mailbox_save_ctx(struct mailbox *mbox)
 {
 	if (!mbox->ops->save_ctx) {
 		dev_err(mbox->dev, "%s:\tno save\n", __func__);
@@ -125,9 +126,9 @@ void omap_mbox_save_ctx(struct omap_mbox *mbox)
 
 	mbox->ops->save_ctx(mbox);
 }
-EXPORT_SYMBOL(omap_mbox_save_ctx);
+EXPORT_SYMBOL(mailbox_save_ctx);
 
-void omap_mbox_restore_ctx(struct omap_mbox *mbox)
+void mailbox_restore_ctx(struct mailbox *mbox)
 {
 	if (!mbox->ops->restore_ctx) {
 		dev_err(mbox->dev, "%s:\tno restore\n", __func__);
@@ -136,30 +137,30 @@ void omap_mbox_restore_ctx(struct omap_mbox *mbox)
 
 	mbox->ops->restore_ctx(mbox);
 }
-EXPORT_SYMBOL(omap_mbox_restore_ctx);
+EXPORT_SYMBOL(mailbox_restore_ctx);
 
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+void mailbox_enable_irq(struct mailbox *mbox, mailbox_irq_t irq)
 {
 	mbox->ops->enable_irq(mbox, irq);
 }
-EXPORT_SYMBOL(omap_mbox_enable_irq);
+EXPORT_SYMBOL(mailbox_enable_irq);
 
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq)
+void mailbox_disable_irq(struct mailbox *mbox, mailbox_irq_t irq)
 {
 	mbox->ops->disable_irq(mbox, irq);
 }
-EXPORT_SYMBOL(omap_mbox_disable_irq);
+EXPORT_SYMBOL(mailbox_disable_irq);
 
 static void mbox_tx_tasklet(unsigned long tx_data)
 {
-	struct omap_mbox *mbox = (struct omap_mbox *)tx_data;
-	struct omap_mbox_queue *mq = mbox->txq;
+	struct mailbox *mbox = (struct mailbox *)tx_data;
+	struct mailbox_queue *mq = mbox->txq;
 	mbox_msg_t msg;
 	int ret;
 
 	while (kfifo_len(&mq->fifo)) {
 		if (__mbox_poll_for_space(mbox)) {
-			omap_mbox_enable_irq(mbox, IRQ_TX);
+			mailbox_enable_irq(mbox, IRQ_TX);
 			break;
 		}
 
@@ -176,8 +177,8 @@ static void mbox_tx_tasklet(unsigned long tx_data)
  */
 static void mbox_rx_work(struct work_struct *work)
 {
-	struct omap_mbox_queue *mq =
-		container_of(work, struct omap_mbox_queue, work);
+	struct mailbox_queue *mq =
+		container_of(work, struct mailbox_queue, work);
 	mbox_msg_t msg;
 	int len;
 
@@ -190,7 +191,7 @@ static void mbox_rx_work(struct work_struct *work)
 		spin_lock_irq(&mq->lock);
 		if (mq->full) {
 			mq->full = false;
-			omap_mbox_enable_irq(mq->mbox, IRQ_RX);
+			mailbox_enable_irq(mq->mbox, IRQ_RX);
 		}
 		spin_unlock_irq(&mq->lock);
 	}
@@ -199,22 +200,22 @@ static void mbox_rx_work(struct work_struct *work)
 /*
  * Mailbox interrupt handler
  */
-static void __mbox_tx_interrupt(struct omap_mbox *mbox)
+static void __mbox_tx_interrupt(struct mailbox *mbox)
 {
-	omap_mbox_disable_irq(mbox, IRQ_TX);
+	mailbox_disable_irq(mbox, IRQ_TX);
 	ack_mbox_irq(mbox, IRQ_TX);
 	tasklet_schedule(&mbox->txq->tasklet);
 }
 
-static void __mbox_rx_interrupt(struct omap_mbox *mbox)
+static void __mbox_rx_interrupt(struct mailbox *mbox)
 {
-	struct omap_mbox_queue *mq = mbox->rxq;
+	struct mailbox_queue *mq = mbox->rxq;
 	mbox_msg_t msg;
 	int len;
 
 	while (!mbox_fifo_empty(mbox)) {
 		if (unlikely(kfifo_avail(&mq->fifo) < sizeof(msg))) {
-			omap_mbox_disable_irq(mbox, IRQ_RX);
+			mailbox_disable_irq(mbox, IRQ_RX);
 			mq->full = true;
 			goto nomem;
 		}
@@ -224,7 +225,7 @@ static void __mbox_rx_interrupt(struct omap_mbox *mbox)
 		len = kfifo_in(&mq->fifo, (unsigned char *)&msg, sizeof(msg));
 		WARN_ON(len != sizeof(msg));
 
-		if (mbox->ops->type == OMAP_MBOX_TYPE1)
+		if (mbox->ops->type == MBOX_HW_FIFO1_TYPE)
 			break;
 	}
 
@@ -236,7 +237,7 @@ nomem:
 
 static irqreturn_t mbox_interrupt(int irq, void *p)
 {
-	struct omap_mbox *mbox = p;
+	struct mailbox *mbox = p;
 
 	if (is_mbox_irq(mbox, IRQ_TX))
 		__mbox_tx_interrupt(mbox);
@@ -247,13 +248,13 @@ static irqreturn_t mbox_interrupt(int irq, void *p)
 	return IRQ_HANDLED;
 }
 
-static struct omap_mbox_queue *mbox_queue_alloc(struct omap_mbox *mbox,
+static struct mailbox_queue *mbox_queue_alloc(struct mailbox *mbox,
 		void (*work) (struct work_struct *),
 		void (*tasklet)(unsigned long))
 {
-	struct omap_mbox_queue *mq;
+	struct mailbox_queue *mq;
 
-	mq = kzalloc(sizeof(struct omap_mbox_queue), GFP_KERNEL);
+	mq = kzalloc(sizeof(struct mailbox_queue), GFP_KERNEL);
 	if (!mq)
 		return NULL;
 
@@ -273,16 +274,16 @@ error:
 	return NULL;
 }
 
-static void mbox_queue_free(struct omap_mbox_queue *q)
+static void mbox_queue_free(struct mailbox_queue *q)
 {
 	kfifo_free(&q->fifo);
 	kfree(q);
 }
 
-static int omap_mbox_startup(struct omap_mbox *mbox)
+static int mailbox_startup(struct mailbox *mbox)
 {
 	int ret = 0;
-	struct omap_mbox_queue *mq;
+	struct mailbox_queue *mq;
 
 	mutex_lock(&mbox_configured_lock);
 	if (!mbox_configured++) {
@@ -317,7 +318,7 @@ static int omap_mbox_startup(struct omap_mbox *mbox)
 		mbox->rxq = mq;
 		mq->mbox = mbox;
 
-		omap_mbox_enable_irq(mbox, IRQ_RX);
+		mailbox_enable_irq(mbox, IRQ_RX);
 	}
 	mutex_unlock(&mbox_configured_lock);
 	return 0;
@@ -336,12 +337,12 @@ fail_startup:
 	return ret;
 }
 
-static void omap_mbox_fini(struct omap_mbox *mbox)
+static void mailbox_fini(struct mailbox *mbox)
 {
 	mutex_lock(&mbox_configured_lock);
 
 	if (!--mbox->use_count) {
-		omap_mbox_disable_irq(mbox, IRQ_RX);
+		mailbox_disable_irq(mbox, IRQ_RX);
 		free_irq(mbox->irq, mbox);
 		tasklet_kill(&mbox->txq->tasklet);
 		flush_work(&mbox->rxq->work);
@@ -357,9 +358,9 @@ static void omap_mbox_fini(struct omap_mbox *mbox)
 	mutex_unlock(&mbox_configured_lock);
 }
 
-struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
+struct mailbox *mailbox_get(const char *name, struct notifier_block *nb)
 {
-	struct omap_mbox *_mbox, *mbox = NULL;
+	struct mailbox *_mbox, *mbox = NULL;
 	int i, ret;
 
 	if (!mboxes)
@@ -378,7 +379,7 @@ struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
 	if (nb)
 		blocking_notifier_chain_register(&mbox->notifier, nb);
 
-	ret = omap_mbox_startup(mbox);
+	ret = mailbox_startup(mbox);
 	if (ret) {
 		blocking_notifier_chain_unregister(&mbox->notifier, nb);
 		return ERR_PTR(-ENODEV);
@@ -386,18 +387,18 @@ struct omap_mbox *omap_mbox_get(const char *name, struct notifier_block *nb)
 
 	return mbox;
 }
-EXPORT_SYMBOL(omap_mbox_get);
+EXPORT_SYMBOL(mailbox_get);
 
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb)
+void mailbox_put(struct mailbox *mbox, struct notifier_block *nb)
 {
 	blocking_notifier_chain_unregister(&mbox->notifier, nb);
-	omap_mbox_fini(mbox);
+	mailbox_fini(mbox);
 }
-EXPORT_SYMBOL(omap_mbox_put);
+EXPORT_SYMBOL(mailbox_put);
 
-static struct class omap_mbox_class = { .name = "mbox", };
+static struct class mailbox_class = { .name = "mbox", };
 
-int omap_mbox_register(struct device *parent, struct omap_mbox **list)
+int mailbox_register(struct device *parent, struct mailbox **list)
 {
 	int ret;
 	int i;
@@ -407,8 +408,8 @@ int omap_mbox_register(struct device *parent, struct omap_mbox **list)
 		return -EINVAL;
 
 	for (i = 0; mboxes[i]; i++) {
-		struct omap_mbox *mbox = mboxes[i];
-		mbox->dev = device_create(&omap_mbox_class,
+		struct mailbox *mbox = mboxes[i];
+		mbox->dev = device_create(&mailbox_class,
 				parent, 0, mbox, "%s", mbox->name);
 		if (IS_ERR(mbox->dev)) {
 			ret = PTR_ERR(mbox->dev);
@@ -424,9 +425,9 @@ err_out:
 		device_unregister(mboxes[i]->dev);
 	return ret;
 }
-EXPORT_SYMBOL(omap_mbox_register);
+EXPORT_SYMBOL(mailbox_register);
 
-int omap_mbox_unregister(void)
+int mailbox_unregister(void)
 {
 	int i;
 
@@ -438,13 +439,13 @@ int omap_mbox_unregister(void)
 	mboxes = NULL;
 	return 0;
 }
-EXPORT_SYMBOL(omap_mbox_unregister);
+EXPORT_SYMBOL(mailbox_unregister);
 
-static int __init omap_mbox_init(void)
+static int __init mailbox_init(void)
 {
 	int err;
 
-	err = class_register(&omap_mbox_class);
+	err = class_register(&mailbox_class);
 	if (err)
 		return err;
 
@@ -455,15 +456,15 @@ static int __init omap_mbox_init(void)
 
 	return 0;
 }
-subsys_initcall(omap_mbox_init);
+subsys_initcall(mailbox_init);
 
-static void __exit omap_mbox_exit(void)
+static void __exit mailbox_exit(void)
 {
-	class_unregister(&omap_mbox_class);
+	class_unregister(&mailbox_class);
 }
-module_exit(omap_mbox_exit);
+module_exit(mailbox_exit);
 
 MODULE_LICENSE("GPL v2");
-MODULE_DESCRIPTION("omap mailbox: interrupt driven messaging");
+MODULE_DESCRIPTION("mailbox framework: interrupt driven messaging");
 MODULE_AUTHOR("Toshihiro Kobayashi");
 MODULE_AUTHOR("Hiroshi DOYU");
diff --git a/drivers/mailbox/mailbox.h b/drivers/mailbox/mailbox.h
index bf3c1b4..530f191 100644
--- a/drivers/mailbox/mailbox.h
+++ b/drivers/mailbox/mailbox.h
@@ -10,54 +10,54 @@
 #include <linux/kfifo.h>
 #include <linux/mailbox.h>
 
-typedef int __bitwise omap_mbox_type_t;
-#define OMAP_MBOX_TYPE1 ((__force omap_mbox_type_t) 1)
-#define OMAP_MBOX_TYPE2 ((__force omap_mbox_type_t) 2)
-
-struct omap_mbox_ops {
-	omap_mbox_type_t        type;
-	int             (*startup)(struct omap_mbox *mbox);
-	void            (*shutdown)(struct omap_mbox *mbox);
+typedef int __bitwise mailbox_type_t;
+#define MBOX_HW_FIFO1_TYPE ((__force mailbox_type_t) 1)
+#define MBOX_HW_FIFO2_TYPE ((__force mailbox_type_t) 2)
+
+struct mailbox_ops {
+	mailbox_type_t        type;
+	int             (*startup)(struct mailbox *mbox);
+	void            (*shutdown)(struct mailbox *mbox);
 	/* fifo */
-	mbox_msg_t      (*fifo_read)(struct omap_mbox *mbox);
-	void            (*fifo_write)(struct omap_mbox *mbox, mbox_msg_t msg);
-	int             (*fifo_empty)(struct omap_mbox *mbox);
-	int             (*fifo_full)(struct omap_mbox *mbox);
+	mbox_msg_t      (*fifo_read)(struct mailbox *mbox);
+	void            (*fifo_write)(struct mailbox *mbox, mbox_msg_t msg);
+	int             (*fifo_empty)(struct mailbox *mbox);
+	int             (*fifo_full)(struct mailbox *mbox);
 	/* irq */
-	void            (*enable_irq)(struct omap_mbox *mbox,
-			omap_mbox_irq_t irq);
-	void            (*disable_irq)(struct omap_mbox *mbox,
-			omap_mbox_irq_t irq);
-	void            (*ack_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-	int             (*is_irq)(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+	void            (*enable_irq)(struct mailbox *mbox,
+			mailbox_irq_t irq);
+	void            (*disable_irq)(struct mailbox *mbox,
+			mailbox_irq_t irq);
+	void            (*ack_irq)(struct mailbox *mbox, mailbox_irq_t irq);
+	int             (*is_irq)(struct mailbox *mbox, mailbox_irq_t irq);
 	/* ctx */
-	void            (*save_ctx)(struct omap_mbox *mbox);
-	void            (*restore_ctx)(struct omap_mbox *mbox);
+	void            (*save_ctx)(struct mailbox *mbox);
+	void            (*restore_ctx)(struct mailbox *mbox);
 };
 
-struct omap_mbox_queue {
+struct mailbox_queue {
 	spinlock_t              lock;
 	struct kfifo            fifo;
 	struct work_struct      work;
 	struct tasklet_struct   tasklet;
-	struct omap_mbox        *mbox;
+	struct mailbox        *mbox;
 	bool full;
 };
 
-struct omap_mbox {
+struct mailbox {
 	char                    *name;
 	unsigned int            irq;
-	struct omap_mbox_queue  *txq, *rxq;
-	struct omap_mbox_ops    *ops;
+	struct mailbox_queue  *txq, *rxq;
+	struct mailbox_ops    *ops;
 	struct device           *dev;
 	void                    *priv;
 	int                     use_count;
 	struct blocking_notifier_head   notifier;
 };
 
-void omap_mbox_init_seq(struct omap_mbox *);
+void mailbox_init_seq(struct mailbox *);
 
-int omap_mbox_register(struct device *parent, struct omap_mbox **);
-int omap_mbox_unregister(void);
+int mailbox_register(struct device *parent, struct mailbox **);
+int mailbox_unregister(void);
 
 #endif /* MAILBOX_H */
diff --git a/include/linux/mailbox.h b/include/linux/mailbox.h
index 78ef848..18c9502 100644
--- a/include/linux/mailbox.h
+++ b/include/linux/mailbox.h
@@ -1,18 +1,18 @@
 /* mailbox.h */
 
 typedef u32 mbox_msg_t;
-struct omap_mbox;
+struct mailbox;
 
-typedef int __bitwise omap_mbox_irq_t;
-#define IRQ_TX ((__force omap_mbox_irq_t) 1)
-#define IRQ_RX ((__force omap_mbox_irq_t) 2)
+typedef int __bitwise mailbox_irq_t;
+#define IRQ_TX ((__force mailbox_irq_t) 1)
+#define IRQ_RX ((__force mailbox_irq_t) 2)
 
-int omap_mbox_msg_send(struct omap_mbox *, mbox_msg_t msg);
+int mailbox_msg_send(struct mailbox *, mbox_msg_t msg);
 
-struct omap_mbox *omap_mbox_get(const char *, struct notifier_block *nb);
-void omap_mbox_put(struct omap_mbox *mbox, struct notifier_block *nb);
+struct mailbox *mailbox_get(const char *, struct notifier_block *nb);
+void mailbox_put(struct mailbox *mbox, struct notifier_block *nb);
 
-void omap_mbox_save_ctx(struct omap_mbox *mbox);
-void omap_mbox_restore_ctx(struct omap_mbox *mbox);
-void omap_mbox_enable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
-void omap_mbox_disable_irq(struct omap_mbox *mbox, omap_mbox_irq_t irq);
+void mailbox_save_ctx(struct mailbox *mbox);
+void mailbox_restore_ctx(struct mailbox *mbox);
+void mailbox_enable_irq(struct mailbox *mbox, mailbox_irq_t irq);
+void mailbox_disable_irq(struct mailbox *mbox, mailbox_irq_t irq);
-- 
1.7.11.1

