Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2FNCMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 22:12:25 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:20247 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755156Ab2FNCMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 22:12:23 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-127.messagelabs.com!1339639942!5738438!1
X-Originating-IP: [216.166.12.99]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/5] staging: comedi: me4000: remove CALL_PDEBUG macro
Date: Wed, 13 Jun 2012 19:12:18 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206131912.18751.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The CALL_PDEBUG macro is used to do function tracing in the driver.
There are better ways to do this. Remove it.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/me4000.c |   61 -------------------------------
 drivers/staging/comedi/drivers/me4000.h |    8 ----
 2 files changed, 0 insertions(+), 69 deletions(-)

diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index aae01f1..f5a0bcf 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -163,8 +163,6 @@ static int me4000_probe(struct comedi_device *dev, struct comedi_devconfig *it)
 	int result, i;
 	struct me4000_board *board;
 
-	CALL_PDEBUG("In me4000_probe()\n");
-
 	/* Allocate private memory */
 	if (alloc_private(dev, sizeof(struct me4000_info)) < 0)
 		return -ENOMEM;
@@ -308,9 +306,6 @@ found:
 
 static int get_registers(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 {
-
-	CALL_PDEBUG("In get_registers()\n");
-
     /*--------------------------- plx regbase -------------------------------*/
 
 	info->plx_regbase = pci_resource_start(pci_dev_p, 1);
@@ -362,8 +357,6 @@ static int init_board_info(struct comedi_device *dev, struct pci_dev *pci_dev_p)
 {
 	int result;
 
-	CALL_PDEBUG("In init_board_info()\n");
-
 	/* Init spin locks */
 	/* spin_lock_init(&info->preload_lock); */
 	/* spin_lock_init(&info->ai_ctrl_lock); */
@@ -394,8 +387,6 @@ static int init_ao_context(struct comedi_device *dev)
 {
 	int i;
 
-	CALL_PDEBUG("In init_ao_context()\n");
-
 	for (i = 0; i < thisboard->ao.count; i++) {
 		/* spin_lock_init(&info->ao_context[i].use_lock); */
 		info->ao_context[i].irq = info->irq;
@@ -475,9 +466,6 @@ static int init_ao_context(struct comedi_device *dev)
 
 static int init_ai_context(struct comedi_device *dev)
 {
-
-	CALL_PDEBUG("In init_ai_context()\n");
-
 	info->ai_context.irq = info->irq;
 
 	info->ai_context.ctrl_reg = info->me4000_regbase + ME4000_AI_CTRL_REG;
@@ -509,9 +497,6 @@ static int init_ai_context(struct comedi_device *dev)
 
 static int init_dio_context(struct comedi_device *dev)
 {
-
-	CALL_PDEBUG("In init_dio_context()\n");
-
 	info->dio_context.dir_reg = info->me4000_regbase + ME4000_DIO_DIR_REG;
 	info->dio_context.ctrl_reg = info->me4000_regbase + ME4000_DIO_CTRL_REG;
 	info->dio_context.port_0_reg =
@@ -528,9 +513,6 @@ static int init_dio_context(struct comedi_device *dev)
 
 static int init_cnt_context(struct comedi_device *dev)
 {
-
-	CALL_PDEBUG("In init_cnt_context()\n");
-
 	info->cnt_context.ctrl_reg = info->timer_regbase + ME4000_CNT_CTRL_REG;
 	info->cnt_context.counter_0_reg =
 	    info->timer_regbase + ME4000_CNT_COUNTER_0_REG;
@@ -554,8 +536,6 @@ static int xilinx_download(struct comedi_device *dev)
 	int idx = 0;
 	int size = 0;
 
-	CALL_PDEBUG("In xilinx_download()\n");
-
 	init_waitqueue_head(&queue);
 
 	/*
@@ -634,8 +614,6 @@ static int reset_board(struct comedi_device *dev)
 {
 	unsigned long icr;
 
-	CALL_PDEBUG("In reset_board()\n");
-
 	/* Make a hardware reset */
 	icr = me4000_inl(dev, info->plx_regbase + PLX_ICR);
 	icr |= 0x40000000;
@@ -708,8 +686,6 @@ static int me4000_ai_insn_read(struct comedi_device *dev,
 	unsigned long tmp;
 	long lval;
 
-	CALL_PDEBUG("In me4000_ai_insn_read()\n");
-
 	if (insn->n == 0) {
 		return 0;
 	} else if (insn->n > 1) {
@@ -827,8 +803,6 @@ static int me4000_ai_cancel(struct comedi_device *dev,
 {
 	unsigned long tmp;
 
-	CALL_PDEBUG("In me4000_ai_cancel()\n");
-
 	/* Stop any running conversion */
 	tmp = me4000_inl(dev, info->ai_context.ctrl_reg);
 	tmp &= ~(ME4000_AI_CTRL_BIT_STOP | ME4000_AI_CTRL_BIT_IMMEDIATE_STOP);
@@ -846,8 +820,6 @@ static int ai_check_chanlist(struct comedi_device *dev,
 	int aref;
 	int i;
 
-	CALL_PDEBUG("In ai_check_chanlist()\n");
-
 	/* Check whether a channel list is available */
 	if (!cmd->chanlist_len) {
 		printk(KERN_ERR
@@ -933,8 +905,6 @@ static int ai_round_cmd_args(struct comedi_device *dev,
 
 	int rest;
 
-	CALL_PDEBUG("In ai_round_cmd_args()\n");
-
 	*init_ticks = 0;
 	*scan_ticks = 0;
 	*chan_ticks = 0;
@@ -994,9 +964,6 @@ static void ai_write_timer(struct comedi_device *dev,
 			   unsigned int init_ticks,
 			   unsigned int scan_ticks, unsigned int chan_ticks)
 {
-
-	CALL_PDEBUG("In ai_write_timer()\n");
-
 	me4000_outl(dev, init_ticks - 1,
 		    info->ai_context.scan_pre_timer_low_reg);
 	me4000_outl(dev, 0x0, info->ai_context.scan_pre_timer_high_reg);
@@ -1020,8 +987,6 @@ static int ai_prepare(struct comedi_device *dev,
 
 	unsigned long tmp = 0;
 
-	CALL_PDEBUG("In ai_prepare()\n");
-
 	/* Write timer arguments */
 	ai_write_timer(dev, init_ticks, scan_ticks, chan_ticks);
 
@@ -1089,8 +1054,6 @@ static int ai_write_chanlist(struct comedi_device *dev,
 	unsigned int aref;
 	int i;
 
-	CALL_PDEBUG("In ai_write_chanlist()\n");
-
 	for (i = 0; i < cmd->chanlist_len; i++) {
 		chan = CR_CHAN(cmd->chanlist[i]);
 		rang = CR_RANGE(cmd->chanlist[i]);
@@ -1127,8 +1090,6 @@ static int me4000_ai_do_cmd(struct comedi_device *dev,
 	unsigned int chan_ticks = 0;
 	struct comedi_cmd *cmd = &s->async->cmd;
 
-	CALL_PDEBUG("In me4000_ai_do_cmd()\n");
-
 	/* Reset the analog input */
 	err = me4000_ai_cancel(dev, s);
 	if (err)
@@ -1173,8 +1134,6 @@ static int me4000_ai_do_cmd_test(struct comedi_device *dev,
 	unsigned int scan_ticks;
 	int err = 0;
 
-	CALL_PDEBUG("In me4000_ai_do_cmd_test()\n");
-
 	PDEBUG("me4000_ai_do_cmd_test(): subdev         = %d\n", cmd->subdev);
 	PDEBUG("me4000_ai_do_cmd_test(): flags          = %08X\n", cmd->flags);
 	PDEBUG("me4000_ai_do_cmd_test(): start_src      = %08X\n",
@@ -1717,8 +1676,6 @@ static int me4000_ao_insn_write(struct comedi_device *dev,
 	int aref = CR_AREF(insn->chanspec);
 	unsigned long tmp;
 
-	CALL_PDEBUG("In me4000_ao_insn_write()\n");
-
 	if (insn->n == 0) {
 		return 0;
 	} else if (insn->n > 1) {
@@ -1794,9 +1751,6 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 				struct comedi_subdevice *s,
 				struct comedi_insn *insn, unsigned int *data)
 {
-
-	CALL_PDEBUG("In me4000_dio_insn_bits()\n");
-
 	/* Length of data must be 2 (mask and new data, see below) */
 	if (insn->n == 0)
 		return 0;
@@ -1851,8 +1805,6 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 	unsigned long tmp;
 	int chan = CR_CHAN(insn->chanspec);
 
-	CALL_PDEBUG("In me4000_dio_insn_config()\n");
-
 	switch (data[0]) {
 	default:
 		return -EINVAL;
@@ -1948,9 +1900,6 @@ static int me4000_dio_insn_config(struct comedi_device *dev,
 
 static int cnt_reset(struct comedi_device *dev, unsigned int channel)
 {
-
-	CALL_PDEBUG("In cnt_reset()\n");
-
 	switch (channel) {
 	case 0:
 		me4000_outb(dev, 0x30, info->cnt_context.ctrl_reg);
@@ -1982,8 +1931,6 @@ static int cnt_config(struct comedi_device *dev, unsigned int channel,
 {
 	int tmp = 0;
 
-	CALL_PDEBUG("In cnt_config()\n");
-
 	switch (channel) {
 	case 0:
 		tmp |= ME4000_CNT_COUNTER_0;
@@ -2041,8 +1988,6 @@ static int me4000_cnt_insn_config(struct comedi_device *dev,
 
 	int err;
 
-	CALL_PDEBUG("In me4000_cnt_insn_config()\n");
-
 	switch (data[0]) {
 	case GPCT_RESET:
 		if (insn->n != 1) {
@@ -2087,8 +2032,6 @@ static int me4000_cnt_insn_read(struct comedi_device *dev,
 
 	unsigned short tmp;
 
-	CALL_PDEBUG("In me4000_cnt_insn_read()\n");
-
 	if (insn->n == 0)
 		return 0;
 
@@ -2137,8 +2080,6 @@ static int me4000_cnt_insn_write(struct comedi_device *dev,
 
 	unsigned short tmp;
 
-	CALL_PDEBUG("In me4000_cnt_insn_write()\n");
-
 	if (insn->n == 0) {
 		return 0;
 	} else if (insn->n > 1) {
@@ -2184,8 +2125,6 @@ static int me4000_attach(struct comedi_device *dev, struct comedi_devconfig *it)
 	struct comedi_subdevice *s;
 	int result;
 
-	CALL_PDEBUG("In me4000_attach()\n");
-
 	result = me4000_probe(dev, it);
 	if (result)
 		return result;
diff --git a/drivers/staging/comedi/drivers/me4000.h b/drivers/staging/comedi/drivers/me4000.h
index 733b192..7087da2 100644
--- a/drivers/staging/comedi/drivers/me4000.h
+++ b/drivers/staging/comedi/drivers/me4000.h
@@ -28,18 +28,10 @@
   Debug section
   ===========================================================================*/
 
-#undef ME4000_CALL_DEBUG	/*  Debug function entry and exit */
 #undef ME4000_PORT_DEBUG	/*  Debug port access */
 #undef ME4000_ISR_DEBUG		/*  Debug the interrupt service routine */
 #undef ME4000_DEBUG		/*  General purpose debug masseges */
 
-#ifdef ME4000_CALL_DEBUG
-#undef CALL_PDEBUG
-#define CALL_PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor, ##args)
-#else
-# define CALL_PDEBUG(fmt, args...)	/*  no debugging, do nothing */
-#endif
-
 #ifdef ME4000_PORT_DEBUG
 #undef PORT_PDEBUG
 #define PORT_PDEBUG(fmt, args...) printk(KERN_DEBUG"comedi%d: me4000: " fmt, dev->minor,  ##args)
-- 
1.7.7

