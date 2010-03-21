Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753083Ab0CURaE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 13:30:04 -0400
Received: from smtp1.rdslink.ro ([81.196.12.70]:58003 "EHLO smtp.rdslink.ro"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752347Ab0CURaA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 13:30:00 -0400
X-Mail-Scanner: Scanned by qSheff-II-2.1-r3 (http://www.enderunix.org/qsheff/)
Subject: 0002-Staging-cx25821-fix-coding-style-issues-in-cx25821-c.patch
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
To: gregkh@suse.de, mchehab@redhat.com, peterhuewe@gmx.de,
       palash.bandyopadhyay@conexant.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       linux-media@vger.kernel.org
Content-Type: text/plain; charset="ANSI_X3.4-1968"
Date: Sun, 21 Mar 2010 19:29:46 +0200
Message-ID: <1269192586.6971.2.camel@tuxtm-linux>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From d0cc598f638e6b1dc8c06c2327e67667d52095ed Mon Sep 17 00:00:00 2001
From: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>
Date: Sun, 21 Mar 2010 19:18:19 +0200
Subject: [PATCH 2/2] Staging: cx25821: fix coding style issues in cx25821-core.c
 This is a patch to cx25821-core.c file that fixes up warnings and errors found by the checkpatch.pl tool
 Signed-off-by: Olimpiu Pascariu <olimpiu.pascariu@gmail.com>

---
 drivers/staging/cx25821/cx25821-core.c |  156 ++++++++++++++++----------------
 1 files changed, 77 insertions(+), 79 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-core.c b/drivers/staging/cx25821/cx25821-core.c
index 67f689d..c527473 100644
--- a/drivers/staging/cx25821/cx25821-core.c
+++ b/drivers/staging/cx25821/cx25821-core.c
@@ -31,6 +31,7 @@ MODULE_AUTHOR("Shu Lin - Hiep Huynh");
 MODULE_LICENSE("GPL");
 
 struct list_head cx25821_devlist;
+EXPORT_SYMBOL(cx25821_devlist);
 
 static unsigned int debug;
 module_param(debug, int, 0644);
@@ -312,6 +313,7 @@ struct sram_channel cx25821_sram_channels[] = {
 		       .irq_bit = 11,
 		       },
 };
+EXPORT_SYMBOL(cx25821_sram_channels);
 
 struct sram_channel *channel0 = &cx25821_sram_channels[SRAM_CH00];
 struct sram_channel *channel1 = &cx25821_sram_channels[SRAM_CH01];
@@ -387,70 +389,74 @@ static void cx25821_registers_init(struct cx25821_dev *dev)
 {
 	u32 tmp;
 
-	// enable RUN_RISC in Pecos
+	/* enable RUN_RISC in Pecos */
 	cx_write(DEV_CNTRL2, 0x20);
 
-	// Set the master PCI interrupt masks to enable video, audio, MBIF, and GPIO interrupts
-	// I2C interrupt masking is handled by the I2C objects themselves.
+	/* Set the master PCI interrupt masks to enable video, audio, MBIF,
+	 * and GPIO interrupts
+	 * I2C interrupt masking is handled by the I2C objects themselves. */
 	cx_write(PCI_INT_MSK, 0x2001FFFF);
 
 	tmp = cx_read(RDR_TLCTL0);
-	tmp &= ~FLD_CFG_RCB_CK_EN;	// Clear the RCB_CK_EN bit
+	tmp &= ~FLD_CFG_RCB_CK_EN;	/* Clear the RCB_CK_EN bit */
 	cx_write(RDR_TLCTL0, tmp);
 
-	// PLL-A setting for the Audio Master Clock
+	/* PLL-A setting for the Audio Master Clock */
 	cx_write(PLL_A_INT_FRAC, 0x9807A58B);
 
-	// PLL_A_POST = 0x1C, PLL_A_OUT_TO_PIN = 0x1
+	/* PLL_A_POST = 0x1C, PLL_A_OUT_TO_PIN = 0x1 */
 	cx_write(PLL_A_POST_STAT_BIST, 0x8000019C);
 
-	// clear reset bit [31]
+	/* clear reset bit [31] */
 	tmp = cx_read(PLL_A_INT_FRAC);
 	cx_write(PLL_A_INT_FRAC, tmp & 0x7FFFFFFF);
 
-	// PLL-B setting for Mobilygen Host Bus Interface
+	/* PLL-B setting for Mobilygen Host Bus Interface */
 	cx_write(PLL_B_INT_FRAC, 0x9883A86F);
 
-	// PLL_B_POST = 0xD, PLL_B_OUT_TO_PIN = 0x0
+	/* PLL_B_POST = 0xD, PLL_B_OUT_TO_PIN = 0x0 */
 	cx_write(PLL_B_POST_STAT_BIST, 0x8000018D);
 
-	// clear reset bit [31]
+	/* clear reset bit [31] */
 	tmp = cx_read(PLL_B_INT_FRAC);
 	cx_write(PLL_B_INT_FRAC, tmp & 0x7FFFFFFF);
 
-	// PLL-C setting for video upstream channel
+	/* PLL-C setting for video upstream channel */
 	cx_write(PLL_C_INT_FRAC, 0x96A0EA3F);
 
-	// PLL_C_POST = 0x3, PLL_C_OUT_TO_PIN = 0x0
+	/* PLL_C_POST = 0x3, PLL_C_OUT_TO_PIN = 0x0 */
 	cx_write(PLL_C_POST_STAT_BIST, 0x80000103);
 
-	// clear reset bit [31]
+	/* clear reset bit [31] */
 	tmp = cx_read(PLL_C_INT_FRAC);
 	cx_write(PLL_C_INT_FRAC, tmp & 0x7FFFFFFF);
 
-	// PLL-D setting for audio upstream channel
+	/* PLL-D setting for audio upstream channel */
 	cx_write(PLL_D_INT_FRAC, 0x98757F5B);
 
-	// PLL_D_POST = 0x13, PLL_D_OUT_TO_PIN = 0x0
+	/* PLL_D_POST = 0x13, PLL_D_OUT_TO_PIN = 0x0 */
 	cx_write(PLL_D_POST_STAT_BIST, 0x80000113);
 
-	// clear reset bit [31]
+	/* clear reset bit [31] */
 	tmp = cx_read(PLL_D_INT_FRAC);
 	cx_write(PLL_D_INT_FRAC, tmp & 0x7FFFFFFF);
 
-	// This selects the PLL C clock source for the video upstream channel I and J
+	/* This selects the PLL C clock source for the video upstream channel
+	 * I and J */
 	tmp = cx_read(VID_CH_CLK_SEL);
 	cx_write(VID_CH_CLK_SEL, (tmp & 0x00FFFFFF) | 0x24000000);
 
-	// 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for channel A-C
-	//select 656/VIP DST for downstream Channel A - C
+	/* 656/VIP SRC Upstream Channel I & J and 7 - Host Bus Interface for
+	 * channel A-C
+	 * select 656/VIP DST for downstream Channel A - C */
 	tmp = cx_read(VID_CH_MODE_SEL);
-	//cx_write( VID_CH_MODE_SEL, tmp | 0x1B0001FF);
+	/* cx_write( VID_CH_MODE_SEL, tmp | 0x1B0001FF); */
 	cx_write(VID_CH_MODE_SEL, tmp & 0xFFFFFE00);
 
-	// enables 656 port I and J as output
+	/* enables 656 port I and J as output */
 	tmp = cx_read(CLK_RST);
-	tmp |= FLD_USE_ALT_PLL_REF;	// use external ALT_PLL_REF pin as its reference clock instead
+	/* use external ALT_PLL_REF pin as its reference clock instead */
+	tmp |= FLD_USE_ALT_PLL_REF;
 	cx_write(CLK_RST, tmp & ~(FLD_VID_I_CLK_NOE | FLD_VID_J_CLK_NOE));
 
 	mdelay(100);
@@ -475,9 +481,8 @@ int cx25821_sram_channel_setup(struct cx25821_dev *dev,
 	cdt = ch->cdt;
 	lines = ch->fifo_size / bpl;
 
-	if (lines > 4) {
+	if (lines > 4)
 		lines = 4;
-	}
 
 	BUG_ON(lines < 2);
 
@@ -493,16 +498,15 @@ int cx25821_sram_channel_setup(struct cx25821_dev *dev,
 		cx_write(cdt + 16 * i + 12, 0);
 	}
 
-	//init the first cdt buffer
+	/* init the first cdt buffer */
 	for (i = 0; i < 128; i++)
 		cx_write(ch->fifo_start + 4 * i, i);
 
 	/* write CMDS */
-	if (ch->jumponly) {
+	if (ch->jumponly)
 		cx_write(ch->cmds_start + 0, 8);
-	} else {
+	else
 		cx_write(ch->cmds_start + 0, risc);
-	}
 
 	cx_write(ch->cmds_start + 4, 0);	/* 64 bits 63-32 */
 	cx_write(ch->cmds_start + 8, cdt);
@@ -525,6 +529,7 @@ int cx25821_sram_channel_setup(struct cx25821_dev *dev,
 
 	return 0;
 }
+EXPORT_SYMBOL(cx25821_sram_channel_setup);
 
 int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 				     struct sram_channel *ch,
@@ -545,9 +550,8 @@ int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 	cdt = ch->cdt;
 	lines = ch->fifo_size / bpl;
 
-	if (lines > 3) {
-		lines = 3;	//for AUDIO
-	}
+	if (lines > 3)
+		lines = 3;	/* for AUDIO */
 
 	BUG_ON(lines < 2);
 
@@ -564,25 +568,23 @@ int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 	}
 
 	/* write CMDS */
-	if (ch->jumponly) {
+	if (ch->jumponly)
 		cx_write(ch->cmds_start + 0, 8);
-	} else {
+	else
 		cx_write(ch->cmds_start + 0, risc);
-	}
 
 	cx_write(ch->cmds_start + 4, 0);	/* 64 bits 63-32 */
 	cx_write(ch->cmds_start + 8, cdt);
 	cx_write(ch->cmds_start + 12, (lines * 16) >> 3);
 	cx_write(ch->cmds_start + 16, ch->ctrl_start);
 
-	//IQ size
-	if (ch->jumponly) {
+	/* IQ size */
+	if (ch->jumponly)
 		cx_write(ch->cmds_start + 20, 0x80000000 | (64 >> 2));
-	} else {
+	else
 		cx_write(ch->cmds_start + 20, 64 >> 2);
-	}
 
-	//zero out
+	/* zero out */
 	for (i = 24; i < 80; i += 4)
 		cx_write(ch->cmds_start + i, 0);
 
@@ -594,6 +596,7 @@ int cx25821_sram_channel_setup_audio(struct cx25821_dev *dev,
 
 	return 0;
 }
+EXPORT_SYMBOL(cx25821_sram_channel_setup_audio);
 
 void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
 {
@@ -657,6 +660,7 @@ void cx25821_sram_channel_dump(struct cx25821_dev *dev, struct sram_channel *ch)
 	printk(KERN_WARNING "        :   cnt2_reg: 0x%08x\n",
 	       cx_read(ch->cnt2_reg));
 }
+EXPORT_SYMBOL(cx25821_sram_channel_dump);
 
 void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 				     struct sram_channel *ch)
@@ -730,7 +734,7 @@ void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 		printk(KERN_WARNING "instruction %d = 0x%x\n", i, risc);
 	}
 
-	//read data from the first cdt buffer
+	/* read data from the first cdt buffer */
 	risc = cx_read(AUD_A_CDT);
 	printk(KERN_WARNING "\nread cdt loc=0x%x\n", risc);
 	for (i = 0; i < 8; i++) {
@@ -740,31 +744,32 @@ void cx25821_sram_channel_dump_audio(struct cx25821_dev *dev,
 	printk(KERN_WARNING "\n\n");
 
 	value = cx_read(CLK_RST);
-	CX25821_INFO(" CLK_RST = 0x%x \n\n", value);
+	CX25821_INFO(" CLK_RST = 0x%x\n\n", value);
 
 	value = cx_read(PLL_A_POST_STAT_BIST);
-	CX25821_INFO(" PLL_A_POST_STAT_BIST = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_A_POST_STAT_BIST = 0x%x\n\n", value);
 	value = cx_read(PLL_A_INT_FRAC);
-	CX25821_INFO(" PLL_A_INT_FRAC = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_A_INT_FRAC = 0x%x\n\n", value);
 
 	value = cx_read(PLL_B_POST_STAT_BIST);
-	CX25821_INFO(" PLL_B_POST_STAT_BIST = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_B_POST_STAT_BIST = 0x%x\n\n", value);
 	value = cx_read(PLL_B_INT_FRAC);
-	CX25821_INFO(" PLL_B_INT_FRAC = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_B_INT_FRAC = 0x%x\n\n", value);
 
 	value = cx_read(PLL_C_POST_STAT_BIST);
-	CX25821_INFO(" PLL_C_POST_STAT_BIST = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_C_POST_STAT_BIST = 0x%x\n\n", value);
 	value = cx_read(PLL_C_INT_FRAC);
-	CX25821_INFO(" PLL_C_INT_FRAC = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_C_INT_FRAC = 0x%x\n\n", value);
 
 	value = cx_read(PLL_D_POST_STAT_BIST);
-	CX25821_INFO(" PLL_D_POST_STAT_BIST = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_D_POST_STAT_BIST = 0x%x\n\n", value);
 	value = cx_read(PLL_D_INT_FRAC);
-	CX25821_INFO(" PLL_D_INT_FRAC = 0x%x \n\n", value);
+	CX25821_INFO(" PLL_D_INT_FRAC = 0x%x\n\n", value);
 
 	value = cx25821_i2c_read(&dev->i2c_bus[0], AFE_AB_DIAG_CTRL, &tmp);
-	CX25821_INFO(" AFE_AB_DIAG_CTRL (0x10900090) = 0x%x \n\n", value);
+	CX25821_INFO(" AFE_AB_DIAG_CTRL (0x10900090) = 0x%x\n\n", value);
 }
+EXPORT_SYMBOL(cx25821_sram_channel_dump_audio);
 
 static void cx25821_shutdown(struct cx25821_dev *dev)
 {
@@ -834,8 +839,8 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 	cx_write(AUD_E_INT_STAT, 0xffffffff);
 
 	cx_write(CLK_DELAY, cx_read(CLK_DELAY) & 0x80000000);
-	cx_write(PAD_CTRL, 0x12);	//for I2C
-	cx25821_registers_init(dev);	//init Pecos registers
+	cx_write(PAD_CTRL, 0x12);	/* for I2C */
+	cx25821_registers_init(dev);	/* init Pecos registers */
 	mdelay(100);
 
 	for (i = 0; i < VID_CHANNEL_NUM; i++) {
@@ -846,7 +851,7 @@ static void cx25821_initialize(struct cx25821_dev *dev)
 		dev->use_cif_resolution[i] = FALSE;
 	}
 
-	//Probably only affect Downstream
+	/* Probably only affect Downstream */
 	for (i = VID_UPSTREAM_SRAM_CHANNEL_I; i <= VID_UPSTREAM_SRAM_CHANNEL_J;
 	     i++) {
 		cx25821_set_vip_mode(dev, &dev->sram_channels[i]);
@@ -943,12 +948,11 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	dev->clk_freq = 28000000;
 	dev->sram_channels = cx25821_sram_channels;
 
-	if (dev->nr > 1) {
+	if (dev->nr > 1)
 		CX25821_INFO("dev->nr > 1!");
-	}
 
 	/* board config */
-	dev->board = 1;		//card[dev->nr];
+	dev->board = 1;		/* card[dev->nr]; */
 	dev->_max_num_decoders = MAX_DECODERS;
 
 	dev->pci_bus = dev->pci->bus->number;
@@ -1006,8 +1010,8 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 	cx25821_initialize(dev);
 
 	cx25821_i2c_register(&dev->i2c_bus[0]);
-//  cx25821_i2c_register(&dev->i2c_bus[1]);
-//  cx25821_i2c_register(&dev->i2c_bus[2]);
+/*  cx25821_i2c_register(&dev->i2c_bus[1]);
+ *  cx25821_i2c_register(&dev->i2c_bus[2]); */
 
 	CX25821_INFO("i2c register! bus->i2c_rc = %d\n",
 		     dev->i2c_bus[0].i2c_rc);
@@ -1025,7 +1029,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 
 	for (i = VID_UPSTREAM_SRAM_CHANNEL_I;
 	     i <= AUDIO_UPSTREAM_SRAM_CHANNEL_B; i++) {
-		//Since we don't have template8 for Audio Downstream
+		/* Since we don't have template8 for Audio Downstream */
 		if (cx25821_video_register(dev, i, video_template[i - 1]) < 0) {
 			printk(KERN_ERR
 			       "%s() Failed to register analog video adapters for Upstream channel %d.\n",
@@ -1033,7 +1037,7 @@ static int cx25821_dev_setup(struct cx25821_dev *dev)
 		}
 	}
 
-	// register IOCTL device
+	/* register IOCTL device */
 	dev->ioctl_dev =
 	    cx25821_vdev_init(dev, dev->pci, video_template[VIDEO_IOCTL_CH],
 			      "video");
@@ -1111,6 +1115,7 @@ void cx25821_dev_unregister(struct cx25821_dev *dev)
 	cx25821_i2c_unregister(&dev->i2c_bus[0]);
 	cx25821_iounmap(dev);
 }
+EXPORT_SYMBOL(cx25821_dev_unregister);
 
 static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 				  unsigned int offset, u32 sync_line,
@@ -1121,9 +1126,8 @@ static __le32 *cx25821_risc_field(__le32 * rp, struct scatterlist *sglist,
 	unsigned int line, todo;
 
 	/* sync instruction */
-	if (sync_line != NO_SYNC_LINE) {
+	if (sync_line != NO_SYNC_LINE)
 		*(rp++) = cpu_to_le32(RISC_RESYNC | sync_line);
-	}
 
 	/* scan lines */
 	sg = sglist;
@@ -1298,7 +1302,8 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 	instructions = 1 + (bpl * lines) / PAGE_SIZE + lines;
 	instructions += 1;
 
-	if ((rc = btcx_riscmem_alloc(pci, risc, instructions * 12)) < 0)
+	rc = btcx_riscmem_alloc(pci, risc, instructions * 12);
+	if (rc < 0)
 		return rc;
 
 	/* write risc instructions */
@@ -1311,6 +1316,7 @@ int cx25821_risc_databuffer_audio(struct pci_dev *pci,
 	BUG_ON((risc->jmp - risc->cpu + 2) * sizeof(*risc->cpu) > risc->size);
 	return 0;
 }
+EXPORT_SYMBOL(cx25821_risc_databuffer_audio);
 
 int cx25821_risc_stopper(struct pci_dev *pci, struct btcx_riscmem *risc,
 			 u32 reg, u32 mask, u32 value)
@@ -1374,7 +1380,7 @@ static irqreturn_t cx25821_irq(int irq, void *dev_id)
 		}
 	}
 
-      out:
+out:
 	return IRQ_RETVAL(handled);
 }
 
@@ -1398,12 +1404,14 @@ void cx25821_print_irqbits(char *name, char *tag, char **strings,
 	}
 	printk("\n");
 }
+EXPORT_SYMBOL(cx25821_print_irqbits);
 
 struct cx25821_dev *cx25821_dev_get(struct pci_dev *pci)
 {
 	struct cx25821_dev *dev = pci_get_drvdata(pci);
 	return dev;
 }
+EXPORT_SYMBOL(cx25821_dev_get);
 
 static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 				     const struct pci_device_id *pci_id)
@@ -1429,7 +1437,7 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 		goto fail_unregister_device;
 	}
 
-	printk(KERN_INFO "cx25821 Athena pci enable ! \n");
+	printk(KERN_INFO "cx25821 Athena pci enable !\n");
 
 	if (cx25821_dev_setup(dev) < 0) {
 		err = -EINVAL;
@@ -1463,14 +1471,14 @@ static int __devinit cx25821_initdev(struct pci_dev *pci_dev,
 
 	return 0;
 
-      fail_irq:
-	printk(KERN_INFO "cx25821 cx25821_initdev() can't get IRQ ! \n");
+fail_irq:
+	printk(KERN_INFO "cx25821 cx25821_initdev() can't get IRQ !\n");
 	cx25821_dev_unregister(dev);
 
-      fail_unregister_device:
+fail_unregister_device:
 	v4l2_device_unregister(&dev->v4l2_dev);
 
-      fail_free:
+fail_free:
 	kfree(dev);
 	return err;
 }
@@ -1535,16 +1543,6 @@ static void __exit cx25821_fini(void)
 	pci_unregister_driver(&cx25821_pci_driver);
 }
 
-EXPORT_SYMBOL(cx25821_devlist);
-EXPORT_SYMBOL(cx25821_sram_channels);
-EXPORT_SYMBOL(cx25821_print_irqbits);
-EXPORT_SYMBOL(cx25821_dev_get);
-EXPORT_SYMBOL(cx25821_dev_unregister);
-EXPORT_SYMBOL(cx25821_sram_channel_setup);
-EXPORT_SYMBOL(cx25821_sram_channel_dump);
-EXPORT_SYMBOL(cx25821_sram_channel_setup_audio);
-EXPORT_SYMBOL(cx25821_sram_channel_dump_audio);
-EXPORT_SYMBOL(cx25821_risc_databuffer_audio);
 EXPORT_SYMBOL(cx25821_set_gpiopin_direction);
 
 module_init(cx25821_init);
-- 
1.7.0



