Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2FRUQp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 16:16:45 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:5336 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab2FRUQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 16:16:43 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-16.tower-131.messagelabs.com!1340050600!22561211!2
X-Originating-IP: [216.166.12.180]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: fix return value for insn_bits functions
Date: Mon, 18 Jun 2012 13:16:35 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206181316.36104.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The comedi_subdevice 'insn_bits' functions return the number of data
elements used to perform the command. Most of the insn_bits functions
return an open coded '2' to indicate this. The same value is available
as 'insn->n'. Return that instead to better indicate what the return
means.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/drivers/acl7225b.c       |  4 ++--
 drivers/staging/comedi/drivers/adl_pci6208.c    |  2 +-
 drivers/staging/comedi/drivers/adl_pci7230.c    |  4 ++--
 drivers/staging/comedi/drivers/adl_pci7432.c    |  4 ++--
 drivers/staging/comedi/drivers/adl_pci9111.c    |  4 ++--
 drivers/staging/comedi/drivers/adl_pci9118.c    |  4 ++--
 drivers/staging/comedi/drivers/adq12b.c         |  4 ++--
 drivers/staging/comedi/drivers/adv_pci1710.c    |  4 ++--
 drivers/staging/comedi/drivers/adv_pci1723.c    |  2 +-
 drivers/staging/comedi/drivers/adv_pci_dio.c    | 12 ++++++------
 drivers/staging/comedi/drivers/aio_iiro_16.c    |  4 ++--
 drivers/staging/comedi/drivers/amplc_dio200.c   |  2 +-
 drivers/staging/comedi/drivers/amplc_pc236.c    |  2 +-
 drivers/staging/comedi/drivers/amplc_pc263.c    |  2 +-
 drivers/staging/comedi/drivers/cb_das16_cs.c    |  2 +-
 drivers/staging/comedi/drivers/cb_pcidas64.c    |  6 +++---
 drivers/staging/comedi/drivers/comedi_parport.c |  8 ++++----
 drivers/staging/comedi/drivers/contec_pci_dio.c |  4 ++--
 drivers/staging/comedi/drivers/das08.c          |  8 ++++----
 drivers/staging/comedi/drivers/das16.c          |  4 ++--
 drivers/staging/comedi/drivers/das16m1.c        |  4 ++--
 drivers/staging/comedi/drivers/das1800.c        |  4 ++--
 drivers/staging/comedi/drivers/das800.c         |  4 ++--
 drivers/staging/comedi/drivers/dmm32at.c        |  2 +-
 drivers/staging/comedi/drivers/dt2801.c         |  2 +-
 drivers/staging/comedi/drivers/dt2811.c         |  4 ++--
 drivers/staging/comedi/drivers/dt2817.c         |  2 +-
 drivers/staging/comedi/drivers/dt282x.c         |  2 +-
 drivers/staging/comedi/drivers/dt3000.c         |  2 +-
 drivers/staging/comedi/drivers/dyna_pci10xx.c   |  4 ++--
 drivers/staging/comedi/drivers/icp_multi.c      |  4 ++--
 drivers/staging/comedi/drivers/ii_pci20kc.c     |  2 +-
 drivers/staging/comedi/drivers/me4000.c         |  2 +-
 drivers/staging/comedi/drivers/me_daq.c         |  2 +-
 drivers/staging/comedi/drivers/mpc8260cpm.c     |  2 +-
 drivers/staging/comedi/drivers/multiq3.c        |  4 ++--
 drivers/staging/comedi/drivers/ni_6527.c        |  6 +++---
 drivers/staging/comedi/drivers/ni_65xx.c        |  2 +-
 drivers/staging/comedi/drivers/ni_660x.c        |  2 +-
 drivers/staging/comedi/drivers/ni_670x.c        |  2 +-
 drivers/staging/comedi/drivers/ni_at_ao.c       |  2 +-
 drivers/staging/comedi/drivers/ni_atmio16d.c    |  2 +-
 drivers/staging/comedi/drivers/ni_daq_700.c     |  2 +-
 drivers/staging/comedi/drivers/ni_mio_common.c  |  8 ++++----
 drivers/staging/comedi/drivers/ni_pcidio.c      |  2 +-
 drivers/staging/comedi/drivers/pcl711.c         |  4 ++--
 drivers/staging/comedi/drivers/pcl725.c         |  4 ++--
 drivers/staging/comedi/drivers/pcl726.c         |  4 ++--
 drivers/staging/comedi/drivers/pcl730.c         |  4 ++--
 drivers/staging/comedi/drivers/pcl812.c         |  4 ++--
 drivers/staging/comedi/drivers/pcl818.c         |  4 ++--
 drivers/staging/comedi/drivers/pcm3730.c        |  4 ++--
 drivers/staging/comedi/drivers/pcmmio.c         |  2 +-
 drivers/staging/comedi/drivers/pcmuio.c         |  2 +-
 drivers/staging/comedi/drivers/poc.c            |  4 ++--
 drivers/staging/comedi/drivers/rtd520.c         |  2 +-
 drivers/staging/comedi/drivers/rti800.c         |  4 ++--
 drivers/staging/comedi/drivers/s526.c           |  2 +-
 drivers/staging/comedi/drivers/s626.c           |  2 +-
 drivers/staging/comedi/drivers/skel.c           |  2 +-
 drivers/staging/comedi/drivers/ssv_dnp.c        |  2 +-
 drivers/staging/comedi/drivers/usbdux.c         |  2 +-
 drivers/staging/comedi/drivers/usbduxsigma.c    |  2 +-
 63 files changed, 107 insertions(+), 107 deletions(-)

diff --git a/drivers/staging/comedi/drivers/acl7225b.c b/drivers/staging/comedi/drivers/acl7225b.c
index ab765d3..ddba5db 100644
--- a/drivers/staging/comedi/drivers/acl7225b.c
+++ b/drivers/staging/comedi/drivers/acl7225b.c
@@ -43,7 +43,7 @@ static int acl7225b_do_insn(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int acl7225b_di_insn(struct comedi_device *dev,
@@ -53,7 +53,7 @@ static int acl7225b_di_insn(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + (unsigned long)s->private) |
 	    (inb(dev->iobase + (unsigned long)s->private + 1) << 8);
 
-	return 2;
+	return insn->n;
 }
 
 static int acl7225b_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/adl_pci6208.c b/drivers/staging/comedi/drivers/adl_pci6208.c
index f0a5958..79f6765 100644
--- a/drivers/staging/comedi/drivers/adl_pci6208.c
+++ b/drivers/staging/comedi/drivers/adl_pci6208.c
@@ -157,7 +157,7 @@ static int pci6208_ao_rinsn(struct comedi_device *dev,
 	 * it was a purely digital output subdevice */
 	/* data[1]=s->state; */
 
-/* return 2; */
+/* return insn->n; */
 /* } */
 
 /* static int pci6208_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/adl_pci7230.c b/drivers/staging/comedi/drivers/adl_pci7230.c
index d75734a..cfb8bb0 100644
--- a/drivers/staging/comedi/drivers/adl_pci7230.c
+++ b/drivers/staging/comedi/drivers/adl_pci7230.c
@@ -61,7 +61,7 @@ static int adl_pci7230_do_insn_bits(struct comedi_device *dev,
 		outl((s->state  << 16) & 0xffffffff, dev->iobase + PCI7230_DO);
 	}
 
-	return 2;
+	return insn->n;
 }
 
 static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
@@ -71,7 +71,7 @@ static int adl_pci7230_di_insn_bits(struct comedi_device *dev,
 {
 	data[1] = inl(dev->iobase + PCI7230_DI) & 0xffffffff;
 
-	return 2;
+	return insn->n;
 }
 
 static struct pci_dev *adl_pci7230_find_pci(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/adl_pci7432.c b/drivers/staging/comedi/drivers/adl_pci7432.c
index b071a08..10683c2 100644
--- a/drivers/staging/comedi/drivers/adl_pci7432.c
+++ b/drivers/staging/comedi/drivers/adl_pci7432.c
@@ -65,7 +65,7 @@ static int adl_pci7432_do_insn_bits(struct comedi_device *dev,
 		       dev->iobase + PCI7432_DO);
 		outl(s->state & 0xffffffff, dev->iobase + PCI7432_DO);
 	}
-	return 2;
+	return insn->n;
 }
 
 static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
@@ -79,7 +79,7 @@ static int adl_pci7432_di_insn_bits(struct comedi_device *dev,
 	data[1] = inl(dev->iobase + PCI7432_DI) & 0xffffffff;
 	printk(KERN_DEBUG "comedi: data1 %8x\n", data[1]);
 
-	return 2;
+	return insn->n;
 }
 
 static struct pci_dev *adl_pci7432_find_pci(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/adl_pci9111.c b/drivers/staging/comedi/drivers/adl_pci9111.c
index 4f2cea8..c41cfc5 100644
--- a/drivers/staging/comedi/drivers/adl_pci9111.c
+++ b/drivers/staging/comedi/drivers/adl_pci9111.c
@@ -1153,7 +1153,7 @@ static int pci9111_di_insn_bits(struct comedi_device *dev,
 	bits = pci9111_di_get_bits();
 	data[1] = bits;
 
-	return 2;
+	return insn->n;
 }
 
 /*  Digital outputs */
@@ -1179,7 +1179,7 @@ static int pci9111_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = bits;
 
-	return 2;
+	return insn->n;
 }
 
 /*  ------------------------------------------------------------------ */
diff --git a/drivers/staging/comedi/drivers/adl_pci9118.c b/drivers/staging/comedi/drivers/adl_pci9118.c
index 9a7b6a5..4482aab 100644
--- a/drivers/staging/comedi/drivers/adl_pci9118.c
+++ b/drivers/staging/comedi/drivers/adl_pci9118.c
@@ -492,7 +492,7 @@ static int pci9118_insn_bits_di(struct comedi_device *dev,
 {
 	data[1] = inl(dev->iobase + PCI9118_DI) & 0xf;
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -509,7 +509,7 @@ static int pci9118_insn_bits_do(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/adq12b.c b/drivers/staging/comedi/drivers/adq12b.c
index f7bb145..6df51c8 100644
--- a/drivers/staging/comedi/drivers/adq12b.c
+++ b/drivers/staging/comedi/drivers/adq12b.c
@@ -193,7 +193,7 @@ static int adq12b_di_insn_bits(struct comedi_device *dev,
 	/* only bits 0-4 have information about digital inputs */
 	data[1] = (inb(dev->iobase + ADQ12B_STINR) & (0x1f));
 
-	return 2;
+	return insn->n;
 }
 
 static int adq12b_do_insn_bits(struct comedi_device *dev,
@@ -215,7 +215,7 @@ static int adq12b_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = devpriv->digital_state;
 
-	return 2;
+	return insn->n;
 }
 
 static int adq12b_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/adv_pci1710.c b/drivers/staging/comedi/drivers/adv_pci1710.c
index 60a50ad..c28df0f 100644
--- a/drivers/staging/comedi/drivers/adv_pci1710.c
+++ b/drivers/staging/comedi/drivers/adv_pci1710.c
@@ -435,7 +435,7 @@ static int pci171x_insn_bits_di(struct comedi_device *dev,
 {
 	data[1] = inw(dev->iobase + PCI171x_DI);
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -452,7 +452,7 @@ static int pci171x_insn_bits_do(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/adv_pci1723.c b/drivers/staging/comedi/drivers/adv_pci1723.c
index d37c14d..5c99c74 100644
--- a/drivers/staging/comedi/drivers/adv_pci1723.c
+++ b/drivers/staging/comedi/drivers/adv_pci1723.c
@@ -284,7 +284,7 @@ static int pci1723_dio_insn_bits(struct comedi_device *dev,
 		outw(s->state, dev->iobase + PCI1723_WRITE_DIGITAL_OUTPUT_CMD);
 	}
 	data[1] = inw(dev->iobase + PCI1723_READ_DIGITAL_INPUT_DATA);
-	return 2;
+	return insn->n;
 }
 
 static int pci1723_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
index 942dc77..e09c9cc 100644
--- a/drivers/staging/comedi/drivers/adv_pci_dio.c
+++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
@@ -424,7 +424,7 @@ static int pci_dio_insn_bits_di_b(struct comedi_device *dev,
 		data[1] |= inb(dev->iobase + d->addr + i) << (8 * i);
 
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -441,7 +441,7 @@ static int pci_dio_insn_bits_di_w(struct comedi_device *dev,
 	for (i = 0; i < d->regs; i++)
 		data[1] |= inw(dev->iobase + d->addr + 2 * i) << (16 * i);
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -463,7 +463,7 @@ static int pci_dio_insn_bits_do_b(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -485,7 +485,7 @@ static int pci_dio_insn_bits_do_w(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -634,7 +634,7 @@ static int pci1760_insn_bits_di(struct comedi_device *dev,
 {
 	data[1] = inb(dev->iobase + IMB3);
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -663,7 +663,7 @@ static int pci1760_insn_bits_do(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/aio_iiro_16.c b/drivers/staging/comedi/drivers/aio_iiro_16.c
index 3434107..16f28f6 100644
--- a/drivers/staging/comedi/drivers/aio_iiro_16.c
+++ b/drivers/staging/comedi/drivers/aio_iiro_16.c
@@ -80,7 +80,7 @@ static int aio_iiro_16_dio_insn_bits_write(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
@@ -92,7 +92,7 @@ static int aio_iiro_16_dio_insn_bits_read(struct comedi_device *dev,
 	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_0_7);
 	data[1] |= inb(dev->iobase + AIO_IIRO_16_INPUT_8_15) << 8;
 
-	return 2;
+	return insn->n;
 }
 
 static int aio_iiro_16_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/amplc_dio200.c b/drivers/staging/comedi/drivers/amplc_dio200.c
index c67b09f..55f3050 100644
--- a/drivers/staging/comedi/drivers/amplc_dio200.c
+++ b/drivers/staging/comedi/drivers/amplc_dio200.c
@@ -551,7 +551,7 @@ dio200_subdev_intr_insn_bits(struct comedi_device *dev,
 		data[0] = 0;
 	}
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/amplc_pc236.c b/drivers/staging/comedi/drivers/amplc_pc236.c
index e55321e..77dae8e 100644
--- a/drivers/staging/comedi/drivers/amplc_pc236.c
+++ b/drivers/staging/comedi/drivers/amplc_pc236.c
@@ -293,7 +293,7 @@ static int pc236_intr_insn(struct comedi_device *dev,
 			   unsigned int *data)
 {
 	data[1] = 0;
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/amplc_pc263.c b/drivers/staging/comedi/drivers/amplc_pc263.c
index a018d81..e90178d 100644
--- a/drivers/staging/comedi/drivers/amplc_pc263.c
+++ b/drivers/staging/comedi/drivers/amplc_pc263.c
@@ -194,7 +194,7 @@ static int pc263_do_insn_bits(struct comedi_device *dev,
 		outb(s->state & 0xFF, dev->iobase);
 		outb(s->state >> 8, dev->iobase + 1);
 	}
-	return 2;
+	return insn->n;
 }
 
 static void pc263_report_attach(struct comedi_device *dev)
diff --git a/drivers/staging/comedi/drivers/cb_das16_cs.c b/drivers/staging/comedi/drivers/cb_das16_cs.c
index c3a7133..e958199 100644
--- a/drivers/staging/comedi/drivers/cb_das16_cs.c
+++ b/drivers/staging/comedi/drivers/cb_das16_cs.c
@@ -560,7 +560,7 @@ static int das16cs_dio_insn_bits(struct comedi_device *dev,
 	 * input and output lines. */
 	data[1] = inw(dev->iobase + 16);
 
-	return 2;
+	return insn->n;
 }
 
 static int das16cs_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/cb_pcidas64.c b/drivers/staging/comedi/drivers/cb_pcidas64.c
index 3aab75b..5186804 100644
--- a/drivers/staging/comedi/drivers/cb_pcidas64.c
+++ b/drivers/staging/comedi/drivers/cb_pcidas64.c
@@ -3615,7 +3615,7 @@ static int di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	data[1] = bits;
 	data[0] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 static int do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -3631,7 +3631,7 @@ static int do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int dio_60xx_config_insn(struct comedi_device *dev,
@@ -3674,7 +3674,7 @@ static int dio_60xx_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = readb(priv(dev)->dio_counter_iobase + DIO_DATA_60XX_REG);
 
-	return 2;
+	return insn->n;
 }
 
 static void caldac_write(struct comedi_device *dev, unsigned int channel,
diff --git a/drivers/staging/comedi/drivers/comedi_parport.c b/drivers/staging/comedi/drivers/comedi_parport.c
index 10c3c35..9a63cac 100644
--- a/drivers/staging/comedi/drivers/comedi_parport.c
+++ b/drivers/staging/comedi/drivers/comedi_parport.c
@@ -110,7 +110,7 @@ static int parport_insn_a(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = inb(dev->iobase + PARPORT_A);
 
-	return 2;
+	return insn->n;
 }
 
 static int parport_insn_config_a(struct comedi_device *dev,
@@ -139,7 +139,7 @@ static int parport_insn_b(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = (inb(dev->iobase + PARPORT_B) >> 3);
 
-	return 2;
+	return insn->n;
 }
 
 static int parport_insn_c(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -155,7 +155,7 @@ static int parport_insn_c(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = devpriv->c_data & 0xf;
 
-	return 2;
+	return insn->n;
 }
 
 static int parport_intr_insn(struct comedi_device *dev,
@@ -163,7 +163,7 @@ static int parport_intr_insn(struct comedi_device *dev,
 			     struct comedi_insn *insn, unsigned int *data)
 {
 	data[1] = 0;
-	return 2;
+	return insn->n;
 }
 
 static int parport_intr_cmdtest(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/contec_pci_dio.c b/drivers/staging/comedi/drivers/contec_pci_dio.c
index 8d27154..9ccd29e 100644
--- a/drivers/staging/comedi/drivers/contec_pci_dio.c
+++ b/drivers/staging/comedi/drivers/contec_pci_dio.c
@@ -81,7 +81,7 @@ static int contec_do_insn_bits(struct comedi_device *dev,
 			dev->iobase + thisboard->out_offs);
 		outw(s->state, dev->iobase + thisboard->out_offs);
 	}
-	return 2;
+	return insn->n;
 }
 
 static int contec_di_insn_bits(struct comedi_device *dev,
@@ -94,7 +94,7 @@ static int contec_di_insn_bits(struct comedi_device *dev,
 
 	data[1] = inw(dev->iobase + thisboard->in_offs);
 
-	return 2;
+	return insn->n;
 }
 
 static int contec_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/das08.c b/drivers/staging/comedi/drivers/das08.c
index c4627a6..d0128e0 100644
--- a/drivers/staging/comedi/drivers/das08.c
+++ b/drivers/staging/comedi/drivers/das08.c
@@ -313,7 +313,7 @@ static int das08_di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	data[0] = 0;
 	data[1] = DAS08_IP(inb(dev->iobase + DAS08_STATUS));
 
-	return 2;
+	return insn->n;
 }
 
 static int das08_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -338,7 +338,7 @@ static int das08_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = wbits;
 
-	return 2;
+	return insn->n;
 }
 
 static int __maybe_unused
@@ -348,7 +348,7 @@ das08jr_di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	data[0] = 0;
 	data[1] = inb(dev->iobase + DAS08JR_DIO);
 
-	return 2;
+	return insn->n;
 }
 
 static int __maybe_unused
@@ -365,7 +365,7 @@ das08jr_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = devpriv->do_bits;
 
-	return 2;
+	return insn->n;
 }
 
 static int __maybe_unused
diff --git a/drivers/staging/comedi/drivers/das16.c b/drivers/staging/comedi/drivers/das16.c
index 0c6ad10..895cc77 100644
--- a/drivers/staging/comedi/drivers/das16.c
+++ b/drivers/staging/comedi/drivers/das16.c
@@ -812,7 +812,7 @@ static int das16_di_rbits(struct comedi_device *dev, struct comedi_subdevice *s,
 	data[1] = bits;
 	data[0] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 static int das16_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -832,7 +832,7 @@ static int das16_do_wbits(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	outb(s->state, dev->iobase + DAS16_DIO);
 
-	return 2;
+	return insn->n;
 }
 
 static int das16_ao_winsn(struct comedi_device *dev, struct comedi_subdevice *s,
diff --git a/drivers/staging/comedi/drivers/das16m1.c b/drivers/staging/comedi/drivers/das16m1.c
index f3fba13..2009263 100644
--- a/drivers/staging/comedi/drivers/das16m1.c
+++ b/drivers/staging/comedi/drivers/das16m1.c
@@ -428,7 +428,7 @@ static int das16m1_di_rbits(struct comedi_device *dev,
 	data[1] = bits;
 	data[0] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 static int das16m1_do_wbits(struct comedi_device *dev,
@@ -449,7 +449,7 @@ static int das16m1_do_wbits(struct comedi_device *dev,
 
 	outb(devpriv->do_bits, dev->iobase + DAS16M1_DIO);
 
-	return 2;
+	return insn->n;
 }
 
 static void das16m1_handler(struct comedi_device *dev, unsigned int status)
diff --git a/drivers/staging/comedi/drivers/das1800.c b/drivers/staging/comedi/drivers/das1800.c
index af60e5d5..e464c25 100644
--- a/drivers/staging/comedi/drivers/das1800.c
+++ b/drivers/staging/comedi/drivers/das1800.c
@@ -1353,7 +1353,7 @@ static int das1800_di_rbits(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + DAS1800_DIGITAL) & 0xf;
 	data[0] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 /* writes to digital output channels */
@@ -1374,7 +1374,7 @@ static int das1800_do_wbits(struct comedi_device *dev,
 
 	data[1] = devpriv->do_bits;
 
-	return 2;
+	return insn->n;
 }
 
 static int das1800_init_dma(struct comedi_device *dev, unsigned int dma0,
diff --git a/drivers/staging/comedi/drivers/das800.c b/drivers/staging/comedi/drivers/das800.c
index 81698b1..6505f76 100644
--- a/drivers/staging/comedi/drivers/das800.c
+++ b/drivers/staging/comedi/drivers/das800.c
@@ -874,7 +874,7 @@ static int das800_di_rbits(struct comedi_device *dev,
 	data[1] = bits;
 	data[0] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 static int das800_do_wbits(struct comedi_device *dev,
@@ -898,7 +898,7 @@ static int das800_do_wbits(struct comedi_device *dev,
 
 	data[1] = wbits;
 
-	return 2;
+	return insn->n;
 }
 
 /* loads counters with divisor1, divisor2 from private structure */
diff --git a/drivers/staging/comedi/drivers/dmm32at.c b/drivers/staging/comedi/drivers/dmm32at.c
index 7cc9d20..af353167 100644
--- a/drivers/staging/comedi/drivers/dmm32at.c
+++ b/drivers/staging/comedi/drivers/dmm32at.c
@@ -956,7 +956,7 @@ static int dmm32at_dio_insn_bits(struct comedi_device *dev,
 	 * it was a purely digital output subdevice */
 	/* data[1]=s->state; */
 
-	return 2;
+	return insn->n;
 }
 
 static int dmm32at_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/dt2801.c b/drivers/staging/comedi/drivers/dt2801.c
index d0bbbbb..d332269 100644
--- a/drivers/staging/comedi/drivers/dt2801.c
+++ b/drivers/staging/comedi/drivers/dt2801.c
@@ -546,7 +546,7 @@ static int dt2801_dio_insn_bits(struct comedi_device *dev,
 	dt2801_writedata(dev, which);
 	dt2801_readdata(dev, data + 1);
 
-	return 2;
+	return insn->n;
 }
 
 static int dt2801_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/dt2811.c b/drivers/staging/comedi/drivers/dt2811.c
index b239f38..290b933 100644
--- a/drivers/staging/comedi/drivers/dt2811.c
+++ b/drivers/staging/comedi/drivers/dt2811.c
@@ -354,7 +354,7 @@ static int dt2811_di_insn_bits(struct comedi_device *dev,
 {
 	data[1] = inb(dev->iobase + DT2811_DIO);
 
-	return 2;
+	return insn->n;
 }
 
 static int dt2811_do_insn_bits(struct comedi_device *dev,
@@ -367,7 +367,7 @@ static int dt2811_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/dt2817.c b/drivers/staging/comedi/drivers/dt2817.c
index 9282ca5..beba044 100644
--- a/drivers/staging/comedi/drivers/dt2817.c
+++ b/drivers/staging/comedi/drivers/dt2817.c
@@ -119,7 +119,7 @@ static int dt2817_dio_insn_bits(struct comedi_device *dev,
 	data[1] |= (inb(dev->iobase + DT2817_DATA + 2) << 16);
 	data[1] |= (inb(dev->iobase + DT2817_DATA + 3) << 24);
 
-	return 2;
+	return insn->n;
 }
 
 static int dt2817_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/dt282x.c b/drivers/staging/comedi/drivers/dt282x.c
index 9c0a0df..4af3343 100644
--- a/drivers/staging/comedi/drivers/dt282x.c
+++ b/drivers/staging/comedi/drivers/dt282x.c
@@ -1038,7 +1038,7 @@ static int dt282x_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = inw(dev->iobase + DT2821_DIODAT);
 
-	return 2;
+	return insn->n;
 }
 
 static int dt282x_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/dt3000.c b/drivers/staging/comedi/drivers/dt3000.c
index 0b130bf..cc685cd 100644
--- a/drivers/staging/comedi/drivers/dt3000.c
+++ b/drivers/staging/comedi/drivers/dt3000.c
@@ -752,7 +752,7 @@ static int dt3k_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = dt3k_readsingle(dev, SUBS_DIN, 0, 0);
 
-	return 2;
+	return insn->n;
 }
 
 static int dt3k_mem_insn_read(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/dyna_pci10xx.c b/drivers/staging/comedi/drivers/dyna_pci10xx.c
index 78f3c8b..d0e3679 100644
--- a/drivers/staging/comedi/drivers/dyna_pci10xx.c
+++ b/drivers/staging/comedi/drivers/dyna_pci10xx.c
@@ -198,7 +198,7 @@ static int dyna_pci10xx_di_insn_bits(struct comedi_device *dev,
 	data[1] = d;
 	data[0] = s->state;
 	mutex_unlock(&devpriv->mutex);
-	return 2;
+	return insn->n;
 }
 
 /* digital output bit interface */
@@ -226,7 +226,7 @@ static int dyna_pci10xx_do_insn_bits(struct comedi_device *dev,
 	 */
 	data[1] = s->state;
 	mutex_unlock(&devpriv->mutex);
-	return 2;
+	return insn->n;
 }
 
 /******************************************************************************/
diff --git a/drivers/staging/comedi/drivers/icp_multi.c b/drivers/staging/comedi/drivers/icp_multi.c
index 544bed8..b10ebdb 100644
--- a/drivers/staging/comedi/drivers/icp_multi.c
+++ b/drivers/staging/comedi/drivers/icp_multi.c
@@ -542,7 +542,7 @@ static int icp_multi_insn_bits_di(struct comedi_device *dev,
 {
 	data[1] = readw(devpriv->io_addr + ICP_MULTI_DI);
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -585,7 +585,7 @@ static int icp_multi_insn_bits_do(struct comedi_device *dev,
 #ifdef ICP_MULTI_EXTDEBUG
 	printk(KERN_DEBUG "icp multi EDBG: END: icp_multi_insn_bits_do(...)\n");
 #endif
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/ii_pci20kc.c b/drivers/staging/comedi/drivers/ii_pci20kc.c
index bea3d03..0f9cfe6 100644
--- a/drivers/staging/comedi/drivers/ii_pci20kc.c
+++ b/drivers/staging/comedi/drivers/ii_pci20kc.c
@@ -565,7 +565,7 @@ static int pci20xxx_dio_insn_bits(struct comedi_device *dev,
 	data[1] |= readb(devpriv->ioaddr + PCI20000_DIO_2) << 16;
 	data[1] |= readb(devpriv->ioaddr + PCI20000_DIO_3) << 24;
 
-	return 2;
+	return insn->n;
 }
 
 static void pci20xxx_dio_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/me4000.c b/drivers/staging/comedi/drivers/me4000.c
index 631b422..9a8258e 100644
--- a/drivers/staging/comedi/drivers/me4000.c
+++ b/drivers/staging/comedi/drivers/me4000.c
@@ -1675,7 +1675,7 @@ static int me4000_dio_insn_bits(struct comedi_device *dev,
 		  ((inl(info->dio_context.port_2_reg) & 0xFF) << 16) |
 		  ((inl(info->dio_context.port_3_reg) & 0xFF) << 24);
 
-	return 2;
+	return insn->n;
 }
 
 static int me4000_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/me_daq.c b/drivers/staging/comedi/drivers/me_daq.c
index ae3b046..1803d66 100644
--- a/drivers/staging/comedi/drivers/me_daq.c
+++ b/drivers/staging/comedi/drivers/me_daq.c
@@ -331,7 +331,7 @@ static int me_dio_insn_bits(struct comedi_device *dev,
 		data[1] |= readw(dev_private->me_regbase + ME_DIO_PORT_B) << 16;
 	}
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/mpc8260cpm.c b/drivers/staging/comedi/drivers/mpc8260cpm.c
index a6311b1..a7fda8f 100644
--- a/drivers/staging/comedi/drivers/mpc8260cpm.c
+++ b/drivers/staging/comedi/drivers/mpc8260cpm.c
@@ -113,7 +113,7 @@ static int mpc8260cpm_dio_bits(struct comedi_device *dev,
 
 	p = cpm_pdat((int)s->private);
 
-	return 2;
+	return insn->n;
 }
 
 static int mpc8260cpm_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/multiq3.c b/drivers/staging/comedi/drivers/multiq3.c
index d1a8e91..eccbe1f 100644
--- a/drivers/staging/comedi/drivers/multiq3.c
+++ b/drivers/staging/comedi/drivers/multiq3.c
@@ -163,7 +163,7 @@ static int multiq3_di_insn_bits(struct comedi_device *dev,
 {
 	data[1] = inw(dev->iobase + MULTIQ3_DIGIN_PORT);
 
-	return 2;
+	return insn->n;
 }
 
 static int multiq3_do_insn_bits(struct comedi_device *dev,
@@ -176,7 +176,7 @@ static int multiq3_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int multiq3_encoder_insn_read(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_6527.c b/drivers/staging/comedi/drivers/ni_6527.c
index eec44a0..a80c52f 100644
--- a/drivers/staging/comedi/drivers/ni_6527.c
+++ b/drivers/staging/comedi/drivers/ni_6527.c
@@ -178,7 +178,7 @@ static int ni6527_di_insn_bits(struct comedi_device *dev,
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(1)) << 8;
 	data[1] |= readb(devpriv->mite->daq_io_addr + Port_Register(2)) << 16;
 
-	return 2;
+	return insn->n;
 }
 
 static int ni6527_do_insn_bits(struct comedi_device *dev,
@@ -206,7 +206,7 @@ static int ni6527_do_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static irqreturn_t ni6527_interrupt(int irq, void *d)
@@ -335,7 +335,7 @@ static int ni6527_intr_insn_bits(struct comedi_device *dev,
 				 struct comedi_insn *insn, unsigned int *data)
 {
 	data[1] = 0;
-	return 2;
+	return insn->n;
 }
 
 static int ni6527_intr_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_65xx.c b/drivers/staging/comedi/drivers/ni_65xx.c
index f92f8ab..bce39f1 100644
--- a/drivers/staging/comedi/drivers/ni_65xx.c
+++ b/drivers/staging/comedi/drivers/ni_65xx.c
@@ -602,7 +602,7 @@ static int ni_65xx_intr_insn_bits(struct comedi_device *dev,
 				  struct comedi_insn *insn, unsigned int *data)
 {
 	data[1] = 0;
-	return 2;
+	return insn->n;
 }
 
 static int ni_65xx_intr_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_660x.c b/drivers/staging/comedi/drivers/ni_660x.c
index 5391a39..5e863ff 100644
--- a/drivers/staging/comedi/drivers/ni_660x.c
+++ b/drivers/staging/comedi/drivers/ni_660x.c
@@ -1285,7 +1285,7 @@ static int ni_660x_dio_insn_bits(struct comedi_device *dev,
 	data[1] =
 	    (ni_660x_read_register(dev, 0,
 				   DIO32Input) >> base_bitfield_channel);
-	return 2;
+	return insn->n;
 }
 
 static void ni_660x_select_pfi_output(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_670x.c b/drivers/staging/comedi/drivers/ni_670x.c
index b62b427..9032bac 100644
--- a/drivers/staging/comedi/drivers/ni_670x.c
+++ b/drivers/staging/comedi/drivers/ni_670x.c
@@ -319,7 +319,7 @@ static int ni_670x_dio_insn_bits(struct comedi_device *dev,
 	 * input lines. */
 	data[1] = readl(devpriv->mite->daq_io_addr + DIO_PORT0_DATA_OFFSET);
 
-	return 2;
+	return insn->n;
 }
 
 static int ni_670x_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_at_ao.c b/drivers/staging/comedi/drivers/ni_at_ao.c
index 28848bc..62c8c44 100644
--- a/drivers/staging/comedi/drivers/ni_at_ao.c
+++ b/drivers/staging/comedi/drivers/ni_at_ao.c
@@ -247,7 +247,7 @@ static int atao_dio_insn_bits(struct comedi_device *dev,
 
 	data[1] = inw(dev->iobase + ATAO_DIN);
 
-	return 2;
+	return insn->n;
 }
 
 static int atao_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_atmio16d.c b/drivers/staging/comedi/drivers/ni_atmio16d.c
index 54c0394..2c78d3d 100644
--- a/drivers/staging/comedi/drivers/ni_atmio16d.c
+++ b/drivers/staging/comedi/drivers/ni_atmio16d.c
@@ -606,7 +606,7 @@ static int atmio16d_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = inw(dev->iobase + MIO_16_DIG_IN_REG);
 
-	return 2;
+	return insn->n;
 }
 
 static int atmio16d_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_daq_700.c b/drivers/staging/comedi/drivers/ni_daq_700.c
index 53b0173..4b42809 100644
--- a/drivers/staging/comedi/drivers/ni_daq_700.c
+++ b/drivers/staging/comedi/drivers/ni_daq_700.c
@@ -174,7 +174,7 @@ static int subdev_700_insn(struct comedi_device *dev,
 	data[1] = s->state & 0xff;
 	data[1] |= CALLBACK_FUNC(0, _700_DATA, 0, CALLBACK_ARG) << 8;
 
-	return 2;
+	return insn->n;
 }
 
 static int subdev_700_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ni_mio_common.c b/drivers/staging/comedi/drivers/ni_mio_common.c
index 42df64e..cf0e0d14 100644
--- a/drivers/staging/comedi/drivers/ni_mio_common.c
+++ b/drivers/staging/comedi/drivers/ni_mio_common.c
@@ -3584,7 +3584,7 @@ static int ni_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = devpriv->stc_readw(dev, DIO_Parallel_Input_Register);
 
-	return 2;
+	return insn->n;
 }
 
 static int ni_m_series_dio_insn_config(struct comedi_device *dev,
@@ -3636,7 +3636,7 @@ static int ni_m_series_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = ni_readl(M_Offset_Static_Digital_Input);
 
-	return 2;
+	return insn->n;
 }
 
 static int ni_cdio_cmdtest(struct comedi_device *dev,
@@ -5394,7 +5394,7 @@ static int ni_pfi_insn_bits(struct comedi_device *dev,
 		ni_writew(s->state, M_Offset_PFI_DO);
 	}
 	data[1] = ni_readw(M_Offset_PFI_DI);
-	return 2;
+	return insn->n;
 }
 
 static int ni_pfi_insn_config(struct comedi_device *dev,
@@ -5485,7 +5485,7 @@ static int ni_rtsi_insn_bits(struct comedi_device *dev,
 {
 	data[1] = 0;
 
-	return 2;
+	return insn->n;
 }
 
 /* Find best multiplier/divider to try and get the PLL running at 80 MHz
diff --git a/drivers/staging/comedi/drivers/ni_pcidio.c b/drivers/staging/comedi/drivers/ni_pcidio.c
index 133ab2f..0a55de9 100644
--- a/drivers/staging/comedi/drivers/ni_pcidio.c
+++ b/drivers/staging/comedi/drivers/ni_pcidio.c
@@ -752,7 +752,7 @@ static int ni_pcidio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = readl(devpriv->mite->daq_io_addr + Port_IO(0));
 
-	return 2;
+	return insn->n;
 }
 
 static int ni_pcidio_cmdtest(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/pcl711.c b/drivers/staging/comedi/drivers/pcl711.c
index 0df086a..bb72d0b 100644
--- a/drivers/staging/comedi/drivers/pcl711.c
+++ b/drivers/staging/comedi/drivers/pcl711.c
@@ -452,7 +452,7 @@ static int pcl711_di_insn_bits(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + PCL711_DI_LO) |
 	    (inb(dev->iobase + PCL711_DI_HI) << 8);
 
-	return 2;
+	return insn->n;
 }
 
 /* Digital port write - Untested on 8112 */
@@ -471,7 +471,7 @@ static int pcl711_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl711_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/pcl725.c b/drivers/staging/comedi/drivers/pcl725.c
index 433ea05..d5b60cf 100644
--- a/drivers/staging/comedi/drivers/pcl725.c
+++ b/drivers/staging/comedi/drivers/pcl725.c
@@ -31,7 +31,7 @@ static int pcl725_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl725_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -39,7 +39,7 @@ static int pcl725_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 {
 	data[1] = inb(dev->iobase + PCL725_DI);
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl725_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/pcl726.c b/drivers/staging/comedi/drivers/pcl726.c
index dfff9af..2b10f1d 100644
--- a/drivers/staging/comedi/drivers/pcl726.c
+++ b/drivers/staging/comedi/drivers/pcl726.c
@@ -200,7 +200,7 @@ static int pcl726_di_insn_bits(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + board->di_lo) |
 	    (inb(dev->iobase + board->di_hi) << 8);
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl726_do_insn_bits(struct comedi_device *dev,
@@ -220,7 +220,7 @@ static int pcl726_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl726_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/pcl730.c b/drivers/staging/comedi/drivers/pcl730.c
index d40caca..4675ec5 100644
--- a/drivers/staging/comedi/drivers/pcl730.c
+++ b/drivers/staging/comedi/drivers/pcl730.c
@@ -48,7 +48,7 @@ static int pcl730_do_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl730_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
@@ -57,7 +57,7 @@ static int pcl730_di_insn(struct comedi_device *dev, struct comedi_subdevice *s,
 	data[1] = inb(dev->iobase + ((unsigned long)s->private)) |
 	    (inb(dev->iobase + ((unsigned long)s->private) + 1) << 8);
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl730_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/pcl812.c b/drivers/staging/comedi/drivers/pcl812.c
index 1c146c8..578fd89 100644
--- a/drivers/staging/comedi/drivers/pcl812.c
+++ b/drivers/staging/comedi/drivers/pcl812.c
@@ -504,7 +504,7 @@ static int pcl812_di_insn_bits(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + PCL812_DI_LO);
 	data[1] |= inb(dev->iobase + PCL812_DI_HI) << 8;
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -522,7 +522,7 @@ static int pcl812_do_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/pcl818.c b/drivers/staging/comedi/drivers/pcl818.c
index 8e426a1..46ebcf7 100644
--- a/drivers/staging/comedi/drivers/pcl818.c
+++ b/drivers/staging/comedi/drivers/pcl818.c
@@ -445,7 +445,7 @@ static int pcl818_di_insn_bits(struct comedi_device *dev,
 	data[1] = inb(dev->iobase + PCL818_DI_LO) |
 	    (inb(dev->iobase + PCL818_DI_HI) << 8);
 
-	return 2;
+	return insn->n;
 }
 
 /*
@@ -466,7 +466,7 @@ static int pcl818_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/pcm3730.c b/drivers/staging/comedi/drivers/pcm3730.c
index 311fe2d..d65e0bd 100644
--- a/drivers/staging/comedi/drivers/pcm3730.c
+++ b/drivers/staging/comedi/drivers/pcm3730.c
@@ -39,7 +39,7 @@ static int pcm3730_do_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int pcm3730_di_insn_bits(struct comedi_device *dev,
@@ -47,7 +47,7 @@ static int pcm3730_di_insn_bits(struct comedi_device *dev,
 				struct comedi_insn *insn, unsigned int *data)
 {
 	data[1] = inb(dev->iobase + (unsigned long)(s->private));
-	return 2;
+	return insn->n;
 }
 
 static int pcm3730_attach(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/pcmmio.c b/drivers/staging/comedi/drivers/pcmmio.c
index a918cc0..82a60d6 100644
--- a/drivers/staging/comedi/drivers/pcmmio.c
+++ b/drivers/staging/comedi/drivers/pcmmio.c
@@ -344,7 +344,7 @@ static int pcmmio_dio_insn_bits(struct comedi_device *dev,
 	printk(KERN_DEBUG "s->state %08x data_out %08x\n", s->state, data[1]);
 #endif
 
-	return 2;
+	return insn->n;
 }
 
 /* The input or output configuration of each digital line is
diff --git a/drivers/staging/comedi/drivers/pcmuio.c b/drivers/staging/comedi/drivers/pcmuio.c
index cfbf916..42944a8 100644
--- a/drivers/staging/comedi/drivers/pcmuio.c
+++ b/drivers/staging/comedi/drivers/pcmuio.c
@@ -277,7 +277,7 @@ static int pcmuio_dio_insn_bits(struct comedi_device *dev,
 		data[1]);
 #endif
 
-	return 2;
+	return insn->n;
 }
 
 /* The input or output configuration of each digital line is
diff --git a/drivers/staging/comedi/drivers/poc.c b/drivers/staging/comedi/drivers/poc.c
index a655b90..c253bb9 100644
--- a/drivers/staging/comedi/drivers/poc.c
+++ b/drivers/staging/comedi/drivers/poc.c
@@ -104,7 +104,7 @@ static int pcl733_insn_bits(struct comedi_device *dev,
 	data[1] |= (inb(dev->iobase + 2) << 16);
 	data[1] |= (inb(dev->iobase + 3) << 24);
 
-	return 2;
+	return insn->n;
 }
 
 static int pcl734_insn_bits(struct comedi_device *dev,
@@ -125,7 +125,7 @@ static int pcl734_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 static int poc_attach(struct comedi_device *dev, struct comedi_devconfig *it)
diff --git a/drivers/staging/comedi/drivers/rtd520.c b/drivers/staging/comedi/drivers/rtd520.c
index 6ff1fa0..cc1371d 100644
--- a/drivers/staging/comedi/drivers/rtd520.c
+++ b/drivers/staging/comedi/drivers/rtd520.c
@@ -1826,7 +1826,7 @@ static int rtd_dio_insn_bits(struct comedi_device *dev,
 
 	/*DPRINTK("rtd520:port_0 wrote: 0x%x read: 0x%x\n", s->state, data[1]); */
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/rti800.c b/drivers/staging/comedi/drivers/rti800.c
index b6f2199..f7fa940 100644
--- a/drivers/staging/comedi/drivers/rti800.c
+++ b/drivers/staging/comedi/drivers/rti800.c
@@ -264,7 +264,7 @@ static int rti800_di_insn_bits(struct comedi_device *dev,
 			       struct comedi_insn *insn, unsigned int *data)
 {
 	data[1] = inb(dev->iobase + RTI800_DI);
-	return 2;
+	return insn->n;
 }
 
 static int rti800_do_insn_bits(struct comedi_device *dev,
@@ -280,7 +280,7 @@ static int rti800_do_insn_bits(struct comedi_device *dev,
 
 	data[1] = s->state;
 
-	return 2;
+	return insn->n;
 }
 
 /*
diff --git a/drivers/staging/comedi/drivers/s526.c b/drivers/staging/comedi/drivers/s526.c
index b1dd224..358380f 100644
--- a/drivers/staging/comedi/drivers/s526.c
+++ b/drivers/staging/comedi/drivers/s526.c
@@ -694,7 +694,7 @@ static int s526_dio_insn_bits(struct comedi_device *dev,
 	 * it was a purely digital output subdevice */
 	/* data[1]=s->state & 0xFF; */
 
-	return 2;
+	return insn->n;
 }
 
 static int s526_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/s626.c b/drivers/staging/comedi/drivers/s626.c
index 182074c..d5edd9c 100644
--- a/drivers/staging/comedi/drivers/s626.c
+++ b/drivers/staging/comedi/drivers/s626.c
@@ -2160,7 +2160,7 @@ static int s626_dio_insn_bits(struct comedi_device *dev,
 	}
 	data[1] = DEBIread(dev, diopriv->RDDIn);
 
-	return 2;
+	return insn->n;
 }
 
 static int s626_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/skel.c b/drivers/staging/comedi/drivers/skel.c
index 67207de..6baac52 100644
--- a/drivers/staging/comedi/drivers/skel.c
+++ b/drivers/staging/comedi/drivers/skel.c
@@ -577,7 +577,7 @@ static int skel_dio_insn_bits(struct comedi_device *dev,
 	 * it was a purely digital output subdevice */
 	/* data[1]=s->state; */
 
-	return 2;
+	return insn->n;
 }
 
 static int skel_dio_insn_config(struct comedi_device *dev,
diff --git a/drivers/staging/comedi/drivers/ssv_dnp.c b/drivers/staging/comedi/drivers/ssv_dnp.c
index f7bf3a2..72dbccc 100644
--- a/drivers/staging/comedi/drivers/ssv_dnp.c
+++ b/drivers/staging/comedi/drivers/ssv_dnp.c
@@ -110,7 +110,7 @@ static int dnp_dio_insn_bits(struct comedi_device *dev,
 	outb(PCDR, CSCIR);
 	data[0] += ((inb(CSCDR) & 0xF0) << 12);
 
-	return 2;
+	return insn->n;
 
 }
 
diff --git a/drivers/staging/comedi/drivers/usbdux.c b/drivers/staging/comedi/drivers/usbdux.c
index 3185e1c..83ee669 100644
--- a/drivers/staging/comedi/drivers/usbdux.c
+++ b/drivers/staging/comedi/drivers/usbdux.c
@@ -1809,7 +1809,7 @@ static int usbdux_dio_insn_bits(struct comedi_device *dev,
 
 	data[1] = le16_to_cpu(this_usbduxsub->insnBuffer[1]);
 	up(&this_usbduxsub->sem);
-	return 2;
+	return insn->n;
 }
 
 /* reads the 4 counters, only two are used just now */
diff --git a/drivers/staging/comedi/drivers/usbduxsigma.c b/drivers/staging/comedi/drivers/usbduxsigma.c
index f944c6a..f51867e 100644
--- a/drivers/staging/comedi/drivers/usbduxsigma.c
+++ b/drivers/staging/comedi/drivers/usbduxsigma.c
@@ -1884,7 +1884,7 @@ static int usbdux_dio_insn_bits(struct comedi_device *dev,
 	s->state = data[1];
 
 	up(&this_usbduxsub->sem);
-	return 2;
+	return insn->n;
 }
 
 /***********************************/
-- 
1.7.11

