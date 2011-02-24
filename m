Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab1BXFeq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 00:34:46 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:35154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751202Ab1BXFeo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 00:34:44 -0500
Date: Thu, 24 Feb 2011 16:34:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Shah <amit.shah@redhat.com>
Subject: linux-next: manual merge of the tty tree with Linus' tree
Message-Id: <20110224163439.05352f9b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

Today's linux-next merge of the tty tree got a conflict in
drivers/char/Makefile between commit
51df0acc3d76cf41d5496ef044cc5717ab5c7f71 ("virtio: console: Move file
back to drivers/char/") from Linus' tree and commit
a6afd9f3e819de4795fcd356e5bfad446e4323f2 ("tty: move a number of tty
drivers from drivers/char/ to drivers/tty/") (and later ones) from the tty
tree.

I fixed it up (see below) and can carry the fix as necessary.
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/char/Makefile
index 8238f89,3ca1f62..0000000
--- a/drivers/char/Makefile
+++ b/drivers/char/Makefile
@@@ -5,32 -5,7 +5,8 @@@
  obj-y				+= mem.o random.o
  obj-$(CONFIG_TTY_PRINTK)	+= ttyprintk.o
  obj-y				+= misc.o
- obj-$(CONFIG_BFIN_JTAG_COMM)	+= bfin_jtag_comm.o
- obj-$(CONFIG_MVME147_SCC)	+= generic_serial.o vme_scc.o
- obj-$(CONFIG_MVME162_SCC)	+= generic_serial.o vme_scc.o
- obj-$(CONFIG_BVME6000_SCC)	+= generic_serial.o vme_scc.o
- obj-$(CONFIG_ROCKETPORT)	+= rocket.o
- obj-$(CONFIG_SERIAL167)		+= serial167.o
- obj-$(CONFIG_CYCLADES)		+= cyclades.o
- obj-$(CONFIG_STALLION)		+= stallion.o
- obj-$(CONFIG_ISTALLION)		+= istallion.o
- obj-$(CONFIG_NOZOMI)		+= nozomi.o
- obj-$(CONFIG_DIGIEPCA)		+= epca.o
- obj-$(CONFIG_SPECIALIX)		+= specialix.o
- obj-$(CONFIG_MOXA_INTELLIO)	+= moxa.o
- obj-$(CONFIG_A2232)		+= ser_a2232.o generic_serial.o
  obj-$(CONFIG_ATARI_DSP56K)	+= dsp56k.o
- obj-$(CONFIG_MOXA_SMARTIO)	+= mxser.o
- obj-$(CONFIG_COMPUTONE)		+= ip2/
- obj-$(CONFIG_RISCOM8)		+= riscom8.o
- obj-$(CONFIG_ISI)		+= isicom.o
- obj-$(CONFIG_SYNCLINK)		+= synclink.o
- obj-$(CONFIG_SYNCLINKMP)	+= synclinkmp.o
- obj-$(CONFIG_SYNCLINK_GT)	+= synclink_gt.o
- obj-$(CONFIG_AMIGA_BUILTIN_SERIAL) += amiserial.o
- obj-$(CONFIG_SX)		+= sx.o generic_serial.o
- obj-$(CONFIG_RIO)		+= rio/ generic_serial.o
 +obj-$(CONFIG_VIRTIO_CONSOLE)	+= virtio_console.o
  obj-$(CONFIG_RAW_DRIVER)	+= raw.o
  obj-$(CONFIG_SGI_SNSC)		+= snsc.o snsc_event.o
  obj-$(CONFIG_MSPEC)		+= mspec.o
