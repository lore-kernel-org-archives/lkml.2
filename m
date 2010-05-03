Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756229Ab0ECTdW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 15:33:22 -0400
Received: from mail.perches.com ([173.55.12.10]:1848 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753827Ab0ECTdT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 15:33:19 -0400
Subject: Re: [PATCH -next] staging/cxt1e1: Convert bare printks to
 pr_<level>
From: Joe Perches <joe@perches.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>, support@sbei.com,
       support@onestopsystems.com
In-Reply-To: <20100503110657.00b4e140.randy.dunlap@oracle.com>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
	 <20100503100902.517c146f.randy.dunlap@oracle.com>
	 <1272909764.30040.92.camel@Joe-Laptop.home>
	 <20100503110657.00b4e140.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 03 May 2010 12:33:16 -0700
Message-ID: <1272915196.30040.163.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
A few line splits for long arguments
A couple of embedded function names converted to "%s", __func__
Removed some uses of THIS_MODULE->name
 
Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/cxt1e1/comet.c               |    8 +-
 drivers/staging/cxt1e1/functions.c           |    4 +-
 drivers/staging/cxt1e1/hwprobe.c             |   22 ++--
 drivers/staging/cxt1e1/linux.c               |   28 ++--
 drivers/staging/cxt1e1/musycc.c              |  128 +++++++++---------
 drivers/staging/cxt1e1/pmc93x6_eeprom.c      |   12 +-
 drivers/staging/cxt1e1/pmcc4_drv.c           |  183 +++++++++++++-------------
 drivers/staging/cxt1e1/sbecom_inline_linux.h |    4 +-
 drivers/staging/cxt1e1/sbeproc.c             |    6 +-
 9 files changed, 204 insertions(+), 191 deletions(-)

diff --git a/drivers/staging/cxt1e1/comet.c b/drivers/staging/cxt1e1/comet.c
index b709099..dcbe6b6 100644
--- a/drivers/staging/cxt1e1/comet.c
+++ b/drivers/staging/cxt1e1/comet.c
@@ -11,6 +11,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <asm/io.h>
 #include <linux/hdlc.h>
 #include "pmcc4_sysdep.h"
@@ -291,12 +293,12 @@ init_comet (void *ci, comet_t * comet, u_int32_t port_mode, int clockmaster,
         if ((moreParams & CFG_CLK_PORT_MASK) == CFG_CLK_PORT_INTERNAL)
         {
             if (log_level >= LOG_SBEBUG12)
-                printk (">> init_comet: clockmaster internal clock\n");
+                pr_info(">> %s: clockmaster internal clock\n", __func__);
             pci_write_32 ((u_int32_t *) &comet->tx_time, 0x0d); /* internal oscillator */
         } else                      /* external clock source */
         {
             if (log_level >= LOG_SBEBUG12)
-                printk (">> init_comet: clockmaster external clock\n");
+                pr_info(">> %s: clockmaster external clock\n", __func__);
             pci_write_32 ((u_int32_t *) &comet->tx_time, 0x09); /* loop timing
                                                                  * (external) */
         }
@@ -311,7 +313,7 @@ init_comet (void *ci, comet_t * comet, u_int32_t port_mode, int clockmaster,
         pci_write_32 ((u_int32_t *) &comet->brif_fpcfg, 0x20);  /* Slave Mode i.e.
                                                                  * FPMODE=1 (@0x20) */
         if (log_level >= LOG_SBEBUG12)
-            printk (">> init_comet: clockslave internal clock\n");
+            pr_info(">> %s: clockslave internal clock\n", __func__);
         pci_write_32 ((u_int32_t *) &comet->tx_time, 0x0d);     /* oscillator timing */
     }
 
diff --git a/drivers/staging/cxt1e1/functions.c b/drivers/staging/cxt1e1/functions.c
index 738129d..86b4980 100644
--- a/drivers/staging/cxt1e1/functions.c
+++ b/drivers/staging/cxt1e1/functions.c
@@ -68,7 +68,7 @@ pci_read_32 (u_int32_t *p)
     FLUSH_PCI_READ ();
     v = le32_to_cpu (*p);
     if (log_level >= LOG_DEBUG)
-        printk ("pci_read : %x = %x\n", (u_int32_t) p, v);
+        pr_info("pci_read : %x = %x\n", (u_int32_t) p, v);
     return v;
 #else
     FLUSH_PCI_READ ();              /* */
@@ -81,7 +81,7 @@ pci_write_32 (u_int32_t *p, u_int32_t v)
 {
 #ifdef FLOW_DEBUG
     if (log_level >= LOG_DEBUG)
-        printk ("pci_write: %x = %x\n", (u_int32_t) p, v);
+        pr_info("pci_write: %x = %x\n", (u_int32_t) p, v);
 #endif
     *p = cpu_to_le32 (v);
     FLUSH_PCI_WRITE ();             /* This routine is called from routines
diff --git a/drivers/staging/cxt1e1/hwprobe.c b/drivers/staging/cxt1e1/hwprobe.c
index 571fa1f..8d4e8d2 100644
--- a/drivers/staging/cxt1e1/hwprobe.c
+++ b/drivers/staging/cxt1e1/hwprobe.c
@@ -83,17 +83,17 @@ show_two (hdw_info_t * hi, int brdno)
               (sn[5] & 0x0000ff),
              (u_int8_t) hi->revid[0]);
 
-    printk ("%s\n", banner);
+    pr_info("%s\n", banner);
 
     pdev = hi->pdev[0];
-    printk ("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
+    pr_info("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
             hi->devname, "MUSYCC",
             (unsigned long) hi->addr_mapped[0], hi->addr[0],
             hi->pci_busno, (u_int8_t) PCI_SLOT (pdev->devfn),
             (u_int8_t) PCI_FUNC (pdev->devfn), pdev->irq);
 
     pdev = hi->pdev[1];
-    printk ("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
+    pr_info("%s: %s at v/p=%lx/%lx (%02x:%02x.%x) irq %d\n",
             hi->devname, "EBUS  ",
             (unsigned long) hi->addr_mapped[1], hi->addr[1],
             hi->pci_busno, (u_int8_t) PCI_SLOT (pdev->devfn),
@@ -116,22 +116,22 @@ hdw_sn_get (hdw_info_t * hi, int brdno)
     {
         unsigned char *ucp = (unsigned char *) &hi->mfg_info.data;
 
-        printk ("eeprom[00]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[00]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 0), *(ucp + 1), *(ucp + 2), *(ucp + 3), *(ucp + 4), *(ucp + 5), *(ucp + 6), *(ucp + 7));
-        printk ("eeprom[08]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[08]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 8), *(ucp + 9), *(ucp + 10), *(ucp + 11), *(ucp + 12), *(ucp + 13), *(ucp + 14), *(ucp + 15));
-        printk ("eeprom[16]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[16]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 16), *(ucp + 17), *(ucp + 18), *(ucp + 19), *(ucp + 20), *(ucp + 21), *(ucp + 22), *(ucp + 23));
-        printk ("eeprom[24]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[24]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 24), *(ucp + 25), *(ucp + 26), *(ucp + 27), *(ucp + 28), *(ucp + 29), *(ucp + 30), *(ucp + 31));
-        printk ("eeprom[32]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[32]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 32), *(ucp + 33), *(ucp + 34), *(ucp + 35), *(ucp + 36), *(ucp + 37), *(ucp + 38), *(ucp + 39));
-        printk ("eeprom[40]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
+        pr_info("eeprom[40]:  %02x %02x %02x %02x  %02x %02x %02x %02x\n",
                 *(ucp + 40), *(ucp + 41), *(ucp + 42), *(ucp + 43), *(ucp + 44), *(ucp + 45), *(ucp + 46), *(ucp + 47));
     }
 #endif
 #if 0
-    printk ("sn: %x %x %x %x %x %x\n",
+    pr_info("sn: %x %x %x %x %x %x\n",
             hi->mfg_info.Serial[0],
             hi->mfg_info.Serial[1],
             hi->mfg_info.Serial[2],
@@ -144,7 +144,7 @@ hdw_sn_get (hdw_info_t * hi, int brdno)
     {
         /* bad crc, data is suspect */
         if (log_level >= LOG_WARN)
-            printk ("%s: EEPROM cksum error\n", hi->devname);
+            pr_info("%s: EEPROM cksum error\n", hi->devname);
         hi->mfg_info_sts = EEPROM_CRCERR;
     } else
         hi->mfg_info_sts = EEPROM_OK;
diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index ce2942c..134e756 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -195,7 +195,8 @@ c4_wk_chan_restart (mch_t * ch)
     mpi_t      *pi = ch->up;
 
 #ifdef RLD_RESTART_DEBUG
-    printk (">> c4_wk_chan_restart: queueing Port %d Chan %d, mch_t @ %p\n", pi->portnum, ch->channum, ch);
+    pr_info(">> %s: queueing Port %d Chan %d, mch_t @ %p\n",
+            __func__, pi->portnum, ch->channum, ch);
 #endif
 
     /* create new entry w/in workqueue for this channel and let'er rip */
@@ -236,7 +237,8 @@ c4_wq_port_init (mpi_t * pi)
     sprintf (np, "%s%d", pi->up->devname, pi->portnum); /* IE pmcc4-01) */
 
 #ifdef RLD_RESTART_DEBUG
-    printk (">> c4_wq_port_init: creating workqueue <%s> for Port %d.\n", name, pi->portnum); /* RLD DEBUG */
+    pr_info(">> %s: creating workqueue <%s> for Port %d.\n",
+            __func__, name, pi->portnum); /* RLD DEBUG */
 #endif
     if (!(pi->wq_port = create_singlethread_workqueue (name)))
         return ENOMEM;
@@ -284,7 +286,7 @@ c4_ebus_interrupt (int irq, void *dev_instance)
 static int
 void_open (struct net_device * ndev)
 {
-    printk ("%s: trying to open master device !\n", ndev->name);
+    pr_info("%s: trying to open master device !\n", ndev->name);
     return -1;
 }
 
@@ -317,7 +319,7 @@ chan_open (struct net_device * ndev)
     hdlc->proto = IF_PROTO_HDLC;
     if ((ret = hdlc_open (hdlc)))
     {
-        printk ("%s: hdlc_open failure, err %d.\n", THIS_MODULE->name, ret);
+        pr_info("hdlc_open failure, err %d.\n", ret);
         return ret;
     }
     if ((ret = c4_chan_up (DEV_TO_PRIV (hdlc)->ci, DEV_TO_PRIV (hdlc)->channum)))
@@ -340,7 +342,7 @@ chan_open (struct net_device * ndev)
 
     if ((ret = hdlc_open (ndev)))
     {
-        printk ("%s: hdlc_open failure, err %d.\n", THIS_MODULE->name, ret);
+        pr_info("hdlc_open failure, err %d.\n", ret);
         return ret;
     }
     if ((ret = c4_chan_up (priv->ci, priv->channum)))
@@ -629,7 +631,7 @@ create_chan (struct net_device * ndev, ci_t * ci,
     if (ret)
     {
         if (log_level >= LOG_WARN)
-            printk ("%s: create_chan[%d] registration error = %d.\n",
+            pr_info("%s: create_chan[%d] registration error = %d.\n",
                     ci->devname, cp->channum, ret);
         free_netdev (dev);          /* cleanup */
         return 0;                   /* failed to register */
@@ -1018,7 +1020,7 @@ c4_ioctl (struct net_device * ndev, struct ifreq * ifr, int cmd)
 #endif
 
 #if 0
-    printk ("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
+    pr_info("c4_ioctl: iocmd %x, dir %x type %x nr %x iolen %d.\n", iocmd,
             _IOC_DIR (iocmd), _IOC_TYPE (iocmd), _IOC_NR (iocmd),
             _IOC_SIZE (iocmd));
 #endif
@@ -1031,23 +1033,23 @@ c4_ioctl (struct net_device * ndev, struct ifreq * ifr, int cmd)
     switch (iocmd)
     {
     case SBE_IOC_PORT_GET:
-        //printk (">> SBE_IOC_PORT_GET Ioctl...\n");
+        //pr_info(">> SBE_IOC_PORT_GET Ioctl...\n");
         ret = do_get_port (ndev, data);
         break;
     case SBE_IOC_PORT_SET:
-        //printk (">> SBE_IOC_PORT_SET Ioctl...\n");
+        //pr_info(">> SBE_IOC_PORT_SET Ioctl...\n");
         ret = do_set_port (ndev, data);
         break;
     case SBE_IOC_CHAN_GET:
-        //printk (">> SBE_IOC_CHAN_GET Ioctl...\n");
+        //pr_info(">> SBE_IOC_CHAN_GET Ioctl...\n");
         ret = do_get_chan (ndev, data);
         break;
     case SBE_IOC_CHAN_SET:
-        //printk (">> SBE_IOC_CHAN_SET Ioctl...\n");
+        //pr_info(">> SBE_IOC_CHAN_SET Ioctl...\n");
         ret = do_set_chan (ndev, data);
         break;
     case C4_DEL_CHAN:
-        //printk (">> C4_DEL_CHAN Ioctl...\n");
+        //pr_info(">> C4_DEL_CHAN Ioctl...\n");
         ret = do_del_chan (ndev, data);
         break;
     case SBE_IOC_CHAN_NEW:
@@ -1084,7 +1086,7 @@ c4_ioctl (struct net_device * ndev, struct ifreq * ifr, int cmd)
                 return -EFAULT;
         break;
     default:
-        //printk (">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
+        //pr_info(">> c4_ioctl: EINVAL - unknown iocmd <%x>\n", iocmd);
         ret = -EINVAL;
         break;
     }
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 7a6d92a..d3f5a5b 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -137,7 +137,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
     }
     if (ch->rxd_num == 0)
     {
-        printk ("  ZERO receive buffers allocated for this channel.");
+        pr_info("  ZERO receive buffers allocated for this channel.");
     } else
     {
         FLUSH_MEM_READ ();
@@ -146,7 +146,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
         {
             status = le32_to_cpu (m->status);
             {
-                printk ("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
+                pr_info("%c  %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
                         (m == &ch->mdr[ch->rxix_irq_srv]) ? 'F' : ' ',
                         (unsigned long) m, n,
                         status,
@@ -170,13 +170,13 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
                     {
                         dp = (u_int32_t *) OS_phystov ((void *) (le32_to_cpu (m->data)));
                         if (len >= 0x10)
-                            printk ("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
+                            pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
                                     *dp, *(dp + 1), *(dp + 2), *(dp + 3));
                         else if (len >= 0x08)
-                            printk ("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+                            pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
                                     *dp, *(dp + 1));
                         else
-                            printk ("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
+                            pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
                     }
                 }
 #endif
@@ -184,7 +184,7 @@ musycc_dump_rxbuffer_ring (mch_t * ch, int lockit)
             m = m->snext;
         }
     }                               /* -for- */
-    printk ("\n");
+    pr_info("\n");
 
     if (lockit)
     {
@@ -209,7 +209,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
     }
     if (ch->txd_num == 0)
     {
-        printk ("  ZERO transmit buffers allocated for this channel.");
+        pr_info("  ZERO transmit buffers allocated for this channel.");
     } else
     {
         FLUSH_MEM_READ ();
@@ -218,7 +218,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
         {
             status = le32_to_cpu (m->status);
             {
-                printk ("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
+                pr_info("%c%c %08lx[%2d]: sts %08x (%c%c%c%c:%d.) Data [%08x] Next [%08x]\n",
                         (m == ch->txd_usr_add) ? 'F' : ' ',
                         (m == ch->txd_irq_srv) ? 'L' : ' ',
                         (unsigned long) m, n,
@@ -238,13 +238,13 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
                     {
                         dp = (u_int32_t *) OS_phystov ((void *) (le32_to_cpu (m->data)));
                         if (len >= 0x10)
-                            printk ("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
+                            pr_info("    %x[%x]: %08X %08X %08X %08x\n", (u_int32_t) dp, len,
                                     *dp, *(dp + 1), *(dp + 2), *(dp + 3));
                         else if (len >= 0x08)
-                            printk ("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
+                            pr_info("    %x[%x]: %08X %08X\n", (u_int32_t) dp, len,
                                     *dp, *(dp + 1));
                         else
-                            printk ("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
+                            pr_info("    %x[%x]: %08X\n", (u_int32_t) dp, len, *dp);
                     }
                 }
 #endif
@@ -252,7 +252,7 @@ musycc_dump_txbuffer_ring (mch_t * ch, int lockit)
             m = m->snext;
         }
     }                               /* -for- */
-    printk ("\n");
+    pr_info("\n");
 
     if (lockit)
     {
@@ -281,7 +281,7 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
         int         bh;
 
         bh = atomic_read (&ci->bh_pending);
-        printk (">> bh_pend %d [%d] ihead %d itail %d [%d] th_cnt %d bh_cnt %d wdcnt %d note %d\n",
+        pr_info(">> bh_pend %d [%d] ihead %d itail %d [%d] th_cnt %d bh_cnt %d wdcnt %d note %d\n",
                 bh, max_bh, ci->iqp_headx, ci->iqp_tailx, max_intcnt,
                 ci->intlog.drvr_intr_thcount,
                 ci->intlog.drvr_intr_bhcount,
@@ -292,20 +292,20 @@ musycc_dump_ring (ci_t * ci, unsigned int chan)
 
     if (!(ch = sd_find_chan (dummy, chan)))
     {
-        printk (">> musycc_dump_ring: channel %d not up.\n", chan);
+        pr_info(">> musycc_dump_ring: channel %d not up.\n", chan);
         return ENOENT;
     }
-    printk (">> CI %p CHANNEL %3d @ %p: state %x status/p %x/%x\n", ci, chan, ch, ch->state,
+    pr_info(">> CI %p CHANNEL %3d @ %p: state %x status/p %x/%x\n", ci, chan, ch, ch->state,
             ch->status, ch->p.status);
-    printk ("--------------------------------\nTX Buffer Ring - Channel %d, txd_num %d. (bd/ch pend %d %d), TXD required %d, txpkt %lu\n",
+    pr_info("--------------------------------\nTX Buffer Ring - Channel %d, txd_num %d. (bd/ch pend %d %d), TXD required %d, txpkt %lu\n",
             chan, ch->txd_num,
             (u_int32_t) atomic_read (&ci->tx_pending), (u_int32_t) atomic_read (&ch->tx_pending), ch->txd_required, ch->s.tx_packets);
-    printk ("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
+    pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
             ch->user, ch->txd_irq_srv, ch->txd_usr_add,
             sd_queue_stopped (ch->user),
             ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
     musycc_dump_txbuffer_ring (ch, 1);
-    printk ("RX Buffer Ring - Channel %d, rxd_num %d. IRQ_SRV[%d] 0x%p, start_rx %x rxpkt %lu\n",
+    pr_info("RX Buffer Ring - Channel %d, rxd_num %d. IRQ_SRV[%d] 0x%p, start_rx %x rxpkt %lu\n",
             chan, ch->rxd_num, ch->rxix_irq_srv,
             &ch->mdr[ch->rxix_irq_srv], ch->ch_start_rx, ch->s.rx_packets);
     musycc_dump_rxbuffer_ring (ch, 1);
@@ -400,7 +400,7 @@ musycc_update_tx_thp (mch_t * ch)
     spin_unlock_irqrestore (&ch->ch_txlock, flags);
 
 #ifdef RLD_TRANS_DEBUG
-    printk ("++ musycc_update_tx_thp[%d]: setting thp = %p, sts %x\n", ch->channum, md, md->status);
+    pr_info("++ musycc_update_tx_thp[%d]: setting thp = %p, sts %x\n", ch->channum, md, md->status);
 #endif
 }
 
@@ -429,7 +429,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
     pi = ch->up;
 
 #ifdef RLD_TRANS_DEBUG
-    printk ("wq_chan_restart[%d]: start_RT[%d/%d] status %x\n",
+    pr_info("wq_chan_restart[%d]: start_RT[%d/%d] status %x\n",
             ch->channum, ch->ch_start_rx, ch->ch_start_tx, ch->status);
 
 #endif
@@ -451,12 +451,12 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
                 hereb4--;
 #ifdef RLD_TRANS_DEBUG
                 md = &ch->mdr[ch->rxix_irq_srv];
-                printk ("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
+                pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
                 ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status),
                         ch->s.rx_packets);
 #elif defined(RLD_RXACT_DEBUG)
                 md = &ch->mdr[ch->rxix_irq_srv];
-                printk ("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
+                pr_info("++ musycc_wq_chan_restart[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
                 ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status),
                         ch->s.rx_packets);
                 musycc_dump_rxbuffer_ring (ch, 1);      /* RLD DEBUG */
@@ -482,7 +482,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
         if (!md)
         {
 #ifdef RLD_TRANS_DEBUG
-            printk ("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
+            pr_info("-- musycc_wq_chan_restart[%d]: WARNING, starting NULL md\n", ch->channum);
 #endif
 #if 0
             spin_unlock_irqrestore (&ch->ch_txlock, flags);
@@ -494,7 +494,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
             spin_unlock_irqrestore (&ch->ch_txlock, flags);   /* allow interrupts for service request */
 #endif
 #ifdef RLD_TRANS_DEBUG
-            printk ("++ musycc_wq_chan_restart() CHAN TX ACTIVATE: chan %d txd_irq_srv %p = sts %x, txpkt %lu\n",
+            pr_info("++ musycc_wq_chan_restart() CHAN TX ACTIVATE: chan %d txd_irq_srv %p = sts %x, txpkt %lu\n",
                     ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status, ch->s.tx_packets);
 #endif
             musycc_serv_req (pi, SR_CHANNEL_ACTIVATE | SR_TX_DIRECTION | ch->gchan);
@@ -503,7 +503,7 @@ musycc_wq_chan_restart (void *arg)      /* channel private structure */
         else
         {
             /* retain request to start until retried and we have data to xmit */
-            printk ("-- musycc_wq_chan_restart[%d]: DELAYED due to md %p sts %x data %x, start_tx %x\n",
+            pr_info("-- musycc_wq_chan_restart[%d]: DELAYED due to md %p sts %x data %x, start_tx %x\n",
                     ch->channum, md,
                     le32_to_cpu (md->status),
                     le32_to_cpu (md->data), ch->ch_start_tx);
@@ -527,14 +527,14 @@ void
 musycc_chan_restart (mch_t * ch)
 {
 #ifdef RLD_RESTART_DEBUG
-    printk ("++ musycc_chan_restart[%d]: txd_irq_srv @ %p = sts %x\n",
+    pr_info("++ musycc_chan_restart[%d]: txd_irq_srv @ %p = sts %x\n",
             ch->channum, ch->txd_irq_srv, ch->txd_irq_srv->status);
 #endif
 
 #if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,41)
     /* 2.6 - find next unprocessed message, then set TX thp to it */
 #ifdef RLD_RESTART_DEBUG
-    printk (">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n", ch->channum, &ch->ch_work);
+    pr_info(">> musycc_chan_restart: scheduling Chan %x workQ @ %p\n", ch->channum, &ch->ch_work);
 #endif
     c4_wk_chan_restart (ch);        /* work queue mechanism fires off: Ref:
                                      * musycc_wq_chan_restart () */
@@ -544,7 +544,7 @@ musycc_chan_restart (mch_t * ch)
 
     /* 2.4 - find next unprocessed message, then set TX thp to it */
 #ifdef RLD_RESTART_DEBUG
-    printk (">> musycc_chan_restart: scheduling Chan %x start_tx %x\n", ch->channum, ch->ch_start_tx);
+    pr_info(">> musycc_chan_restart: scheduling Chan %x start_tx %x\n", ch->channum, ch->ch_start_tx);
 #endif
     /* restart transmission from background loop */
     ch->up->up->wd_notify = WD_NOTIFY_1TX;
@@ -620,7 +620,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
     if (pi->sr_last == req)
     {
 #ifdef RLD_TRANS_DEBUG
-        printk (">> same SR, Port %d Req %x\n", pi->portnum, req);
+        pr_info(">> same SR, Port %d Req %x\n", pi->portnum, req);
 #endif
 
         /*
@@ -636,7 +636,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
             (r == (SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION)))
         {
 #ifdef RLD_TRANS_DEBUG
-            printk (">> same CHAN ACT SR, Port %d Req %x => issue SR_NOOP CMD\n", pi->portnum, req);
+            pr_info(">> same CHAN ACT SR, Port %d Req %x => issue SR_NOOP CMD\n", pi->portnum, req);
 #endif
             SD_SEM_GIVE (&pi->sr_sem_busy);     /* allow this next request */
             musycc_serv_req (pi, SR_NOOP);
@@ -646,7 +646,7 @@ musycc_serv_req (mpi_t * pi, u_int32_t req)
         {
             /* no need to issue back-to-back SR_NOOP commands at this time */
 #ifdef RLD_TRANS_DEBUG
-            printk (">> same Port SR_NOOP skipped, Port %d\n", pi->portnum);
+            pr_info(">> same Port SR_NOOP skipped, Port %d\n", pi->portnum);
 #endif
             SD_SEM_GIVE (&pi->sr_sem_busy);     /* allow this next request */
             return;
@@ -673,7 +673,7 @@ rewrite:
     if ((r != req) && (req != SR_CHIP_RESET) && (++rcnt <= MUSYCC_SR_RETRY_CNT))
     {
         if (log_level >= LOG_MONITOR)
-            printk ("%s: %d - reissue srv req/last %x/%x (hdw reads %x), Chan %d.\n",
+            pr_info("%s: %d - reissue srv req/last %x/%x (hdw reads %x), Chan %d.\n",
                     pi->up->devname, rcnt, req, pi->sr_last, r,
                     (pi->portnum * MUSYCC_NCHANS) + (req & 0x1f));
         OS_uwait_dummy ();          /* this delay helps reduce reissue counts
@@ -997,7 +997,8 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
     if (ch == 0 || ch->state != UP)
     {
         if (log_level >= LOG_ERROR)
-            printk ("%s: intr: xmit EOM on uninitialized channel %d\n", pi->up->devname, gchan);
+            pr_info("%s: intr: xmit EOM on uninitialized channel %d\n",
+                    pi->up->devname, gchan);
     }
     if (ch == 0 || ch->mdt == 0)
         return;                     /* note: mdt==0 implies a malloc()
@@ -1048,9 +1049,10 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
             {
                 if (log_level >= LOG_MONITOR)
                 {
-                    printk ("%s: Port %d Chan %2d - unexpected TX msg ownership intr (md %p sts %x)\n",
-                     pi->up->devname, pi->portnum, ch->channum, md, status);
-                    printk ("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
+                    pr_info("%s: Port %d Chan %2d - unexpected TX msg ownership intr (md %p sts %x)\n",
+                            pi->up->devname, pi->portnum, ch->channum,
+                            md, status);
+                    pr_info("++ User 0x%p IRQ_SRV 0x%p USR_ADD 0x%p QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
                             ch->user, ch->txd_irq_srv, ch->txd_usr_add,
                             sd_queue_stopped (ch->user),
                             ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
@@ -1060,7 +1062,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
             } else
             {
                 if (log_level >= LOG_MONITOR)
-                    printk ("%s: Port %d Chan %2d - recovered TX msg ownership [%d] (md %p sts %x)\n",
+                    pr_info("%s: Port %d Chan %2d - recovered TX msg ownership [%d] (md %p sts %x)\n",
                             pi->up->devname, pi->portnum, ch->channum, readCount, md, status);
             }
         }
@@ -1098,7 +1100,8 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
         md->status = 0;
 #ifdef RLD_TXFULL_DEBUG
         if (log_level >= LOG_MONITOR2)
-            printk ("~~ tx_eom: tx_full %x  txd_free %d -> %d\n", ch->tx_full, ch->txd_free, ch->txd_free + 1);
+            pr_info("~~ tx_eom: tx_full %x  txd_free %d -> %d\n",
+                    ch->tx_full, ch->txd_free, ch->txd_free + 1);
 #endif
         ++ch->txd_free;
         FLUSH_MEM_WRITE ();
@@ -1106,7 +1109,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
         if ((ch->p.chan_mode != CFG_CH_PROTO_TRANS) && (status & EOBIRQ_ENABLE))
         {
             if (log_level >= LOG_MONITOR)
-                printk ("%s: Mode (%x) incorrect EOB status (%x)\n",
+                pr_info("%s: Mode (%x) incorrect EOB status (%x)\n",
                         pi->up->devname, ch->p.chan_mode, status);
             if ((status & EOMIRQ_ENABLE) == 0)
                 break;
@@ -1137,7 +1140,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
 
 #ifdef RLD_TXFULL_DEBUG
             if (log_level >= LOG_MONITOR2)
-                printk ("tx_eom[%d]: enable xmit tx_full no more, txd_free %d txd_num/2 %d\n",
+                pr_info("tx_eom[%d]: enable xmit tx_full no more, txd_free %d txd_num/2 %d\n",
                         ch->channum,
                         ch->txd_free, ch->txd_num / 2);
 #endif
@@ -1151,7 +1154,7 @@ musycc_bh_tx_eom (mpi_t * pi, int gchan)
     else if (ch->tx_full)
     {
         if (log_level >= LOG_MONITOR2)
-            printk ("tx_eom[%d]: bypass TX enable though room available? (txd_free %d txd_num/2 %d)\n",
+            pr_info("tx_eom[%d]: bypass TX enable though room available? (txd_free %d txd_num/2 %d)\n",
                     ch->channum,
                     ch->txd_free, ch->txd_num / 2);
     }
@@ -1181,7 +1184,8 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
     if (ch == 0 || ch->state != UP)
     {
         if (log_level > LOG_ERROR)
-            printk ("%s: intr: receive EOM on uninitialized channel %d\n", pi->up->devname, gchan);
+            pr_info("%s: intr: receive EOM on uninitialized channel %d\n",
+                    pi->up->devname, gchan);
         return;
     }
     if (ch->mdr == 0)
@@ -1312,7 +1316,7 @@ musycc_intr_th_handler (void *devp)
     {
         if (log_level >= LOG_MONITOR)
         {
-            printk ("%s: note - updated ISD from %08x to %08x\n",
+            pr_info("%s: note - updated ISD from %08x to %08x\n",
                     ci->devname, status,
               (status & (~INTRPTS_NEXTINT_M)) | ci->intlog.this_status_new);
         }
@@ -1366,7 +1370,7 @@ musycc_intr_th_handler (void *devp)
          */
 #if 0
         /* chained interrupt = not ours */
-        printk (">> %s: intCnt NULL, sts %x, possibly a chained interrupt!\n",
+        pr_info(">> %s: intCnt NULL, sts %x, possibly a chained interrupt!\n",
                 ci->devname, status);
 #endif
         return IRQ_NONE;
@@ -1380,10 +1384,10 @@ musycc_intr_th_handler (void *devp)
 
     if ((log_level >= LOG_WARN) && (status & INTRPTS_INTFULL_M))
     {
-        printk ("%s: Interrupt queue full condition occurred\n", ci->devname);
+        pr_info("%s: Interrupt queue full condition occurred\n", ci->devname);
     }
     if (log_level >= LOG_DEBUG)
-        printk ("%s: interrupts pending, isd @ 0x%p: %x curr %d cnt %d NEXT %d\n",
+        pr_info("%s: interrupts pending, isd @ 0x%p: %x curr %d cnt %d NEXT %d\n",
                 ci->devname, &ci->reg->isd,
         status, nextInt, intCnt, (intCnt + nextInt) & (INT_QUEUE_SIZE - 1));
 
@@ -1490,7 +1494,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
                                                                  * Fix checking */
         {
             if (log_level >= LOG_WARN)
-                printk ("%s: Illegal Interrupt Detected @ 0x%p, mod %d.)\n",
+                pr_info("%s: Illegal Interrupt Detected @ 0x%p, mod %d.)\n",
                         ci->devname, &ci->iqd_p[headx], headx);
 
             /*
@@ -1527,9 +1531,9 @@ musycc_intr_bh_tasklet (ci_t * ci)
         if (log_level >= LOG_DEBUG)
         {
             if (err != 0)
-                printk (" %08x -> err: %2d,", currInt, err);
+                pr_info(" %08x -> err: %2d,", currInt, err);
 
-            printk ("+ interrupt event: %d, grp: %d, chan: %2d, side: %cX\n",
+            pr_info("+ interrupt event: %d, grp: %d, chan: %2d, side: %cX\n",
                     event, group, gchan, tx ? 'T' : 'R');
         }
         pi = &ci->port[group];      /* notice that here we assume 1-1 group -
@@ -1543,7 +1547,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
                 volatile u_int32_t r;
 
                 r = pci_read_32 ((u_int32_t *) &pi->reg->srd);
-                printk ("- SACK cmd: %08x (hdw= %08x)\n", pi->sr_last, r);
+                pr_info("- SACK cmd: %08x (hdw= %08x)\n", pi->sr_last, r);
             }
             SD_SEM_GIVE (&pi->sr_sem_wait);     /* wake up waiting process */
             break;
@@ -1576,7 +1580,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
             break;
         default:
             if (log_level >= LOG_WARN)
-                printk ("%s: unexpected interrupt event: %d, iqd[%d]: %08x, port: %d\n", ci->devname,
+                pr_info("%s: unexpected interrupt event: %d, iqd[%d]: %08x, port: %d\n", ci->devname,
                         event, headx, currInt, group);
             break;
         }                           /* switch on event */
@@ -1619,13 +1623,13 @@ musycc_intr_bh_tasklet (ci_t * ci)
                     if (log_level >= LOG_MONITOR)
 #endif
                     {
-                        printk ("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
+                        pr_info("%s: TX buffer underflow [ONR] on channel %d, mode %x QStopped %x free %d\n",
                                 ci->devname, ch->channum, ch->p.chan_mode, sd_queue_stopped (ch->user), ch->txd_free);
 #ifdef RLD_DEBUG
                         if (ch->p.chan_mode == 2)       /* problem = ONR on HDLC
                                                          * mode */
                         {
-                            printk ("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
+                            pr_info("++ Failed Last %x Next %x QStopped %x, start_tx %x tx_full %d txd_free %d mode %x\n",
                                     (u_int32_t) ch->txd_irq_srv, (u_int32_t) ch->txd_usr_add,
                                     sd_queue_stopped (ch->user),
                                     ch->ch_start_tx, ch->tx_full, ch->txd_free, ch->p.chan_mode);
@@ -1648,7 +1652,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
 
                 if (log_level >= LOG_WARN)
                 {
-                    printk ("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
+                    pr_info("%s: RX buffer overflow [ONR] on channel %d, mode %x\n",
                             ci->devname, ch->channum, ch->p.chan_mode);
                     //musycc_dump_rxbuffer_ring (ch, 0);        /* RLD DEBUG */
                 }
@@ -1665,7 +1669,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
                  * this BUFF error requires Transmit channel reactivation.
                  */
                 if (log_level >= LOG_MONITOR)
-                    printk ("%s: TX buffer underrun [BUFF] on channel %d, mode %x\n",
+                    pr_info("%s: TX buffer underrun [BUFF] on channel %d, mode %x\n",
                             ci->devname, ch->channum, ch->p.chan_mode);
             } else                  /* RX buffer overrun */
             {
@@ -1678,7 +1682,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
                  * not required, but data has been lost.
                  */
                 if (log_level >= LOG_WARN)
-                    printk ("%s: RX buffer overrun [BUFF] on channel %d, mode %x\n",
+                    pr_info("%s: RX buffer overrun [BUFF] on channel %d, mode %x\n",
                             ci->devname, ch->channum, ch->p.chan_mode);
                 /*
                  * Per MUSYCC manual, Section 6.4.9.4 [Receive Errors],
@@ -1701,7 +1705,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
         /* Check for interrupt lost condition */
         if ((currInt & INTRPT_ILOST_M) && (log_level >= LOG_ERROR))
         {
-            printk ("%s: Interrupt queue overflow - ILOST asserted\n",
+            pr_info("%s: Interrupt queue overflow - ILOST asserted\n",
                     ci->devname);
         }
         ci->iqp_headx = (headx + 1) & (INT_QUEUE_SIZE - 1);     /* insure wrapness */
@@ -1713,7 +1717,7 @@ musycc_intr_bh_tasklet (ci_t * ci)
         int         bh;
 
         bh = atomic_read (&CI->bh_pending);
-        printk ("_bh_: late arrivals, head %d != tail %d, pending %d\n",
+        pr_info("_bh_: late arrivals, head %d != tail %d, pending %d\n",
                 ci->iqp_headx, ci->iqp_tailx, bh);
     }
 #if defined(SBE_ISR_IMMEDIATE)
@@ -1867,7 +1871,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     if (log_level >= LOG_MONITOR2)
 #endif
     {
-        printk ("++ start_xmt[%d]: state %x start %x full %d free %d required %d stopped %x\n",
+        pr_info("++ start_xmt[%d]: state %x start %x full %d free %d required %d stopped %x\n",
                 channum, ch->state, ch->ch_start_tx, ch->tx_full,
                 ch->txd_free, ch->txd_required, sd_queue_stopped (ch->user));
     }
@@ -1888,7 +1892,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     if (txd_need_cnt == 0)
     {
         if (log_level >= LOG_MONITOR2)
-            printk ("%s channel %d: no TX data in User buffer\n", ci->devname, channum);
+            pr_info("%s channel %d: no TX data in User buffer\n", ci->devname, channum);
         OS_mem_token_free (mem_token);
         return 0;                   /* no data to send */
     }
@@ -1900,7 +1904,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     {
         if (log_level >= LOG_DEBUG)
         {
-            printk ("start_xmit: discarding buffer, insufficient descriptor cnt %d, need %d.\n",
+            pr_info("start_xmit: discarding buffer, insufficient descriptor cnt %d, need %d.\n",
                     ch->txd_num, txd_need_cnt + 1);
         }
         ch->s.tx_dropped++;
@@ -1917,7 +1921,7 @@ musycc_start_xmit (ci_t * ci, int channum, void *mem_token)
     {
         if (log_level >= LOG_MONITOR2)
         {
-            printk ("start_xmit[%d]: EBUSY - need more descriptors, have %d of %d need %d\n",
+            pr_info("start_xmit[%d]: EBUSY - need more descriptors, have %d of %d need %d\n",
                     channum, ch->txd_free, ch->txd_num, txd_need_cnt);
         }
         ch->tx_full = 1;
diff --git a/drivers/staging/cxt1e1/pmc93x6_eeprom.c b/drivers/staging/cxt1e1/pmc93x6_eeprom.c
index 02c829b..1c8dfb8 100644
--- a/drivers/staging/cxt1e1/pmc93x6_eeprom.c
+++ b/drivers/staging/cxt1e1/pmc93x6_eeprom.c
@@ -21,6 +21,8 @@
  *   GNU General Public License for more details.
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/types.h>
 #include "pmcc4_sysdep.h"
 #include "sbecom_inline_linux.h"
@@ -448,7 +450,7 @@ pmcCalcCrc_T01 (void *bufp)
             (u_int32_t *) &crc);
 
 #ifdef EEPROM_TYPE_DEBUG
-    printk ("sbeCrc: crc 1 calculated as %08x\n", crc); /* RLD DEBUG */
+    pr_info("sbeCrc: crc 1 calculated as %08x\n", crc); /* RLD DEBUG */
 #endif
     return ~crc;
 }
@@ -474,7 +476,7 @@ pmcCalcCrc_T02 (void *bufp)
             (u_int32_t *) &crc);
 
 #ifdef EEPROM_TYPE_DEBUG
-    printk ("sbeCrc: crc 2 calculated as %08x\n", crc); /* RLD DEBUG */
+    pr_info("sbeCrc: crc 2 calculated as %08x\n", crc); /* RLD DEBUG */
 #endif
     return crc;
 }
@@ -520,7 +522,7 @@ pmc_init_seeprom (u_int32_t addr, u_int32_t serialNum)
 
 #ifdef DEBUG
     for (i = 0; i < sizeof (FLD_TYPE2); ++i)
-        printk ("[%02X] = %02X\n", i, buffer.bytes[i] & 0xFF);
+        pr_info("[%02X] = %02X\n", i, buffer.bytes[i] & 0xFF);
 #endif
 
     /* Write structure to serial EEPROM */
@@ -538,7 +540,7 @@ pmc_verify_cksum (void *bufp)
     /* Retrieve contents of CRC field */
     crc1 = pmcGetBuffValue (&buf1->Crc32[0], sizeof (buf1->Crc32));
 #ifdef EEPROM_TYPE_DEBUG
-    printk ("EEPROM: chksum 1 reads   as %08x\n", crc1);        /* RLD DEBUG */
+    pr_info("EEPROM: chksum 1 reads   as %08x\n", crc1);        /* RLD DEBUG */
 #endif
     if ((buf1->type == PROM_FORMAT_TYPE1) &&
         (pmcCalcCrc_T01 ((void *) buf1) == crc1))
@@ -546,7 +548,7 @@ pmc_verify_cksum (void *bufp)
 
     crc2 = pmcGetBuffValue (&buf2->Crc32[0], sizeof (buf2->Crc32));
 #ifdef EEPROM_TYPE_DEBUG
-    printk ("EEPROM: chksum 2 reads   as %08x\n", crc2);        /* RLD DEBUG */
+    pr_info("EEPROM: chksum 2 reads   as %08x\n", crc2);        /* RLD DEBUG */
 #endif
     if ((buf2->type == PROM_FORMAT_TYPE2) &&
         (pmcCalcCrc_T02 ((void *) buf2) == crc2))
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 1617333..333cf26 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -172,10 +172,10 @@ sbecom_set_loglevel (int d)
     {
         if (log_level != d)
         {
-            printk ("%s: log level changed from %d to %d\n", THIS_MODULE->name, log_level, d);
+            pr_info("log level changed from %d to %d\n", log_level, d);
             log_level = d;          /* set new */
         } else
-            printk ("%s: log level is %d\n", THIS_MODULE->name, log_level);
+            pr_info("log level is %d\n", log_level);
     }
 }
 
@@ -292,19 +292,18 @@ checkPorts (ci_t * ci)
             if (!(((copyVal >> 3) & sbeLinkDown) ^ (value & sbeLinkDown)))
             {
                 if (value & sbeLinkDown)
-                    printk (KERN_WARN "%s: Port %d momentarily recovered.\n",
-                            ci->devname, portnum);
+                    pr_warning("%s: Port %d momentarily recovered.\n",
+                               ci->devname, portnum);
                 else
-                    printk (KERN_WARN
-                            "%s: Warning: Port %d link was briefly down.\n",
-                            ci->devname, portnum);
+                    pr_warning("%s: Warning: Port %d link was briefly down.\n",
+                               ci->devname, portnum);
             } else if (value & sbeLinkDown)
-                printk (KERN_WARN "%s: Warning: Port %d link is down.\n",
-                        ci->devname, portnum);
+                pr_warning("%s: Warning: Port %d link is down.\n",
+                           ci->devname, portnum);
             else
             {
-                printk (KERN_WARN "%s: Port %d link has recovered.\n",
-                        ci->devname, portnum);
+                pr_warning("%s: Port %d link has recovered.\n",
+                           ci->devname, portnum);
                 copyVal |= 0x20;    /* record link transition to up */
             }
             copyVal |= 0x10;        /* change (link) --> update LEDs  */
@@ -331,35 +330,30 @@ checkPorts (ci_t * ci)
                 if (value & 0x1f)
                 {                   /* if errors (crc or smf only) */
                     if (value & 0x10)
-                        printk (KERN_WARN
-                           "%s: E1 Port %d Codeword Sa4 change detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d Codeword Sa4 change detected.\n",
+                                   ci->devname, portnum);
                     if (value & 0x08)
-                        printk (KERN_WARN
-                           "%s: E1 Port %d Codeword Sa5 change detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d Codeword Sa5 change detected.\n",
+                                   ci->devname, portnum);
                     if (value & 0x04)
-                        printk (KERN_WARN
-                           "%s: E1 Port %d Codeword Sa6 change detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d Codeword Sa6 change detected.\n",
+                                   ci->devname, portnum);
                     if (value & 0x02)
-                        printk (KERN_WARN
-                           "%s: E1 Port %d Codeword Sa7 change detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d Codeword Sa7 change detected.\n",
+                                   ci->devname, portnum);
                     if (value & 0x01)
-                        printk (KERN_WARN
-                           "%s: E1 Port %d Codeword Sa8 change detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d Codeword Sa8 change detected.\n",
+                                   ci->devname, portnum);
                 }
                 value = pci_read_32 ((u_int32_t *) &comet->e1_frmr_mists);      /* crc & smf */
                 if (value & 0x3)
                 {                   /* if errors (crc or smf only) */
                     if (value & sbeE1CRC)
-                        printk (KERN_WARN "%s: E1 Port %d CRC-4 error(s) detected.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d CRC-4 error(s) detected.\n",
+                                   ci->devname, portnum);
                     if (value & sbeE1errSMF)    /* error in sub-multiframe */
-                        printk (KERN_WARN "%s: E1 Port %d received errored SMF.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d received errored SMF.\n",
+                                   ci->devname, portnum);
                 }
                 value = pci_read_32 ((u_int32_t *) &comet->e1_frmr_masts) & 0xcc; /* alarms */
                 /*
@@ -383,43 +377,43 @@ checkPorts (ci_t * ci)
                     if ((copyVal & sbeRedAlm) && !(value & sbeRedAlm))
                     {
                         copyVal &= ~sbeRedAlm;
-                        printk (KERN_WARN "%s: E1 Port %d LOF alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d LOF alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeRedAlm) && (value & sbeRedAlm))
                     {
                         copyVal |= sbeRedAlm;
-                        printk (KERN_WARN "%s: E1 Warning: Port %d LOF alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Warning: Port %d LOF alarm.\n",
+                                   ci->devname, portnum);
                     } else if ((copyVal & sbeYelAlm) && !(value & sbeYelAlm))
                     {
                         copyVal &= ~sbeYelAlm;
-                        printk (KERN_WARN "%s: E1 Port %d RAI alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d RAI alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeYelAlm) && (value & sbeYelAlm))
                     {
                         copyVal |= sbeYelAlm;
-                        printk (KERN_WARN "%s: E1 Warning: Port %d RAI alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Warning: Port %d RAI alarm.\n",
+                                   ci->devname, portnum);
                     } else if ((copyVal & sbeE1RMAI) && !(value & sbeE1RMAI))
                     {
                         copyVal &= ~sbeE1RMAI;
-                        printk (KERN_WARN "%s: E1 Port %d RMAI alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d RMAI alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeE1RMAI) && (value & sbeE1RMAI))
                     {
                         copyVal |= sbeE1RMAI;
-                        printk (KERN_WARN "%s: E1 Warning: Port %d RMAI alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Warning: Port %d RMAI alarm.\n",
+                                   ci->devname, portnum);
                     } else if ((copyVal & sbeAISAlm) && !(value & sbeAISAlm))
                     {
                         copyVal &= ~sbeAISAlm;
-                        printk (KERN_WARN "%s: E1 Port %d AIS alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Port %d AIS alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeAISAlm) && (value & sbeAISAlm))
                     {
                         copyVal |= sbeAISAlm;
-                        printk (KERN_WARN "%s: E1 Warning: Port %d AIS alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: E1 Warning: Port %d AIS alarm.\n",
+                                   ci->devname, portnum);
                     }
                 }
                 /* end of E1 alarm code */
@@ -433,33 +427,33 @@ checkPorts (ci_t * ci)
                     if ((copyVal & sbeRedAlm) && !(value & sbeRedAlm))
                     {
                         copyVal &= ~sbeRedAlm;
-                        printk (KERN_WARN "%s: Port %d red alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Port %d red alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeRedAlm) && (value & sbeRedAlm))
                     {
                         copyVal |= sbeRedAlm;
-                        printk (KERN_WARN "%s: Warning: Port %d red alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Warning: Port %d red alarm.\n",
+                                   ci->devname, portnum);
                     } else if ((copyVal & sbeYelAlm) && !(value & sbeYelAlm))
                     {
                         copyVal &= ~sbeYelAlm;
-                        printk (KERN_WARN "%s: Port %d yellow (RAI) alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Port %d yellow (RAI) alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeYelAlm) && (value & sbeYelAlm))
                     {
                         copyVal |= sbeYelAlm;
-                        printk (KERN_WARN "%s: Warning: Port %d yellow (RAI) alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Warning: Port %d yellow (RAI) alarm.\n",
+                                   ci->devname, portnum);
                     } else if ((copyVal & sbeAISAlm) && !(value & sbeAISAlm))
                     {
                         copyVal &= ~sbeAISAlm;
-                        printk (KERN_WARN "%s: Port %d blue (AIS) alarm ended.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Port %d blue (AIS) alarm ended.\n",
+                                   ci->devname, portnum);
                     } else if (!(copyVal & sbeAISAlm) && (value & sbeAISAlm))
                     {
                         copyVal |= sbeAISAlm;
-                        printk (KERN_WARN "%s: Warning: Port %d blue (AIS) alarm.\n",
-                                ci->devname, portnum);
+                        pr_warning("%s: Warning: Port %d blue (AIS) alarm.\n",
+                                   ci->devname, portnum);
                     }
                 }
             }                       /* end T1 mode alarm checks */
@@ -523,8 +517,8 @@ checkPorts (ci_t * ci)
                                                                  * loopbk mode */
             if (log_level >= LOG_DEBUG)
                 if (value != 0x3f)
-                    printk (KERN_WARN "%s: BOC value = %x on Port %d\n",
-                            ci->devname, value, portnum);
+                    pr_warning("%s: BOC value = %x on Port %d\n",
+                               ci->devname, value, portnum);
             /* end ESF loopback code */
         }
     }
@@ -546,7 +540,7 @@ c4_watchdog (ci_t * ci)
     if (drvr_state != SBE_DRVR_AVAILABLE)
     {
         if (log_level >= LOG_MONITOR)
-            printk ("%s: drvr not available (%x)\n", THIS_MODULE->name, drvr_state);
+            pr_info("drvr not available (%x)\n", drvr_state);
         return;
     }
 #if 0
@@ -579,7 +573,7 @@ c4_watchdog (ci_t * ci)
 #else
                     if (log_level >= LOG_MONITOR)
 #endif
-                        printk ("%s: watchdog reviving Port %d Channel %d [%d] sts %x/%x, start_TX %x free %x start_RX %x\n",
+                        pr_info("%s: watchdog reviving Port %d Channel %d [%d] sts %x/%x, start_TX %x free %x start_RX %x\n",
                          ci->devname, ch->channum, port, gchan, ch->channum,
                                 ch->p.status, ch->status,
                             ch->ch_start_tx, ch->txd_free, ch->ch_start_rx);
@@ -595,7 +589,8 @@ c4_watchdog (ci_t * ci)
                     {
                         ch->ch_start_rx = 0;    /* we are restarting RX... */
 #ifdef RLD_TRANS_DEBUG
-                        printk ("++ c4_watchdog() CHAN RX ACTIVATE: chan %d\n", ch->channum);
+                        pr_info("++ c4_watchdog() CHAN RX ACTIVATE: chan %d\n",
+                                ch->channum);
 #endif
 #ifdef RLD_RXACT_DEBUG
                         {
@@ -606,7 +601,7 @@ c4_watchdog (ci_t * ci)
                             {
                                 hereb4--;
                                 md = &ch->mdr[ch->rxix_irq_srv];
-                                printk ("++ c4_watchdog[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
+                                pr_info("++ c4_watchdog[%d] CHAN RX ACTIVATE: rxix_irq_srv %d, md %p sts %x, rxpkt %lu\n",
                                         ch->channum, ch->rxix_irq_srv, md, le32_to_cpu (md->status), ch->s.rx_packets);
                                 musycc_dump_rxbuffer_ring (ch, 1);      /* RLD DEBUG */
                             }
@@ -636,8 +631,9 @@ c4_watchdog (ci_t * ci)
                         md = ch->txd_irq_srv;
                         if (!md)
                         {
-                            printk ("-- c4_watchdog[%d]: WARNING, starting NULL md\n", ch->channum);
-                            printk ("--   chan %d txd_irq_srv %p sts %x usr_add %p sts %x, txpkt %lu\n",
+                            pr_info("-- c4_watchdog[%d]: WARNING, starting NULL md\n",
+                                    ch->channum);
+                            pr_info("--   chan %d txd_irq_srv %p sts %x usr_add %p sts %x, txpkt %lu\n",
                                     ch->channum, ch->txd_irq_srv, le32_to_cpu ((struct mdesc *) (ch->txd_irq_srv)->status),
                                     ch->txd_usr_add, le32_to_cpu ((struct mdesc *) (ch->txd_usr_add)->status),
                                     ch->s.tx_packets);
@@ -647,7 +643,8 @@ c4_watchdog (ci_t * ci)
                         } else if (md->data && ((le32_to_cpu (md->status)) & MUSYCC_TX_OWNED))
                         {
 #ifdef RLD_TRANS_DEBUG
-                            printk ("++ c4_watchdog[%d] CHAN TX ACTIVATE: start_tx %x\n", ch->channum, ch->ch_start_tx);
+                            pr_info("++ c4_watchdog[%d] CHAN TX ACTIVATE: start_tx %x\n",
+                                    ch->channum, ch->ch_start_tx);
 #endif
                             ch->ch_start_tx = 0;        /* we are restarting
                                                          * TX... */
@@ -661,7 +658,8 @@ c4_watchdog (ci_t * ci)
 #else
                             if (log_level >= LOG_MONITOR)
 #endif
-                                printk ("++ SACK[P%d/C%d] ack'd, continuing...\n", ch->up->portnum, ch->channum);
+                                pr_info("++ SACK[P%d/C%d] ack'd, continuing...\n",
+                                        ch->up->portnum, ch->channum);
                         }
                     }
                 }
@@ -784,7 +782,7 @@ c4_init (ci_t * ci, u_char *func0, u_char *func1)
             pi->p.portnum = portnum;
             pi->openchans = 0;
 #ifdef SBE_MAP_DEBUG
-            printk ("Comet-%d: addr = %p\n", portnum, pi->cometbase);
+            pr_info("Comet-%d: addr = %p\n", portnum, pi->cometbase);
 #endif
         }
         pmsk = c4_get_portcfg (ci);
@@ -811,7 +809,8 @@ c4_init (ci_t * ci, u_char *func0, u_char *func1)
             return SBE_DRVR_FAIL;
         }
 #ifdef SBE_MAP_DEBUG
-        printk (">> %s: c4_get_build - pmsk %x max_port %x\n", ci->devname, pmsk, ci->max_port);
+        pr_info(">> %s: c4_get_build - pmsk %x max_port %x\n",
+                ci->devname, pmsk, ci->max_port);
 #endif
     }
 
@@ -934,19 +933,20 @@ c4_loop_port (ci_t * ci, int portnum, u_int8_t cmd)
 
         pci_write_32 ((u_int32_t *) &comet->mdiag, cmd);
         if (log_level >= LOG_WARN)
-            printk ("%s: loopback mode changed to %2x from %2x on Port %d\n",
+            pr_info("%s: loopback mode changed to %2x from %2x on Port %d\n",
                     ci->devname, cmd, loopValue, portnum);
         loopValue = pci_read_32 ((u_int32_t *) &comet->mdiag) & COMET_MDIAG_LBMASK;
         if (loopValue != cmd)
         {
             if (log_level >= LOG_ERROR)
-                printk ("%s: write to loop register failed, unknown state for Port %d\n",
+                pr_info("%s: write to loop register failed, unknown state for Port %d\n",
                         ci->devname, portnum);
         }
     } else
     {
         if (log_level >= LOG_WARN)
-            printk ("%s: loopback already in that mode (%2x)\n", ci->devname, loopValue);
+            pr_info("%s: loopback already in that mode (%2x)\n",
+                    ci->devname, loopValue);
     }
     return 0;
 }
@@ -980,7 +980,7 @@ c4_frame_rw (ci_t * ci, struct sbecom_port_param * pp)
     {                               /* control says this is a register
                                      * _write_ */
         if (pp->portStatus == data)
-            printk ("%s: Port %d already that value!  Writing again anyhow.\n",
+            pr_info("%s: Port %d already that value!  Writing again anyhow.\n",
                     ci->devname, pp->portnum);
         pp->portP = (u_int8_t) data;
         pci_write_32 ((u_int32_t *) comet + pp->port_mode,
@@ -1080,11 +1080,11 @@ c4_musycc_rw (ci_t * ci, struct c4_musycc_param * mcp)
     if (ramread)
     {
         data = *dpr;
-        //printk ("c4_musycc_rw: RAM addr %p  read data %x (portno %x offset %x RAM ramread %x)\n", dpr, data, portnum, offset, ramread); /* RLD DEBUG */
+        //pr_info("c4_musycc_rw: RAM addr %p  read data %x (portno %x offset %x RAM ramread %x)\n", dpr, data, portnum, offset, ramread); /* RLD DEBUG */
     } else
     {
         data = pci_read_32 ((u_int32_t *) dph);
-        //printk ("c4_musycc_rw: REG addr %p  read data %x (portno %x offset %x RAM ramread %x)\n", dph, data, portnum, offset, ramread); /* RLD DEBUG */
+        //pr_info("c4_musycc_rw: REG addr %p  read data %x (portno %x offset %x RAM ramread %x)\n", dph, data, portnum, offset, ramread); /* RLD DEBUG */
     }
 
 
@@ -1092,7 +1092,7 @@ c4_musycc_rw (ci_t * ci, struct c4_musycc_param * mcp)
     {                               /* control says this is a register
                                      * _write_ */
         if (mcp->value == data)
-            printk ("%s: musycc grp%d already that value! writing again anyhow.\n",
+            pr_info("%s: musycc grp%d already that value! writing again anyhow.\n",
                     ci->devname, (mcp->RWportnum & 0x7));
         /* write register RAM */
         if (ramread)
@@ -1137,7 +1137,7 @@ c4_set_port (ci_t * ci, int portnum)
     e1mode = IS_FRAME_ANY_E1 (pp->port_mode);
     if (log_level >= LOG_MONITOR2)
     {
-        printk ("%s: c4_set_port[%d]:  entered, e1mode = %x, openchans %d.\n",
+        pr_info("%s: c4_set_port[%d]:  entered, e1mode = %x, openchans %d.\n",
                 ci->devname,
                 portnum, e1mode, pi->openchans);
     }
@@ -1421,13 +1421,12 @@ c4_fifo_alloc (mpi_t * pi, int chan, int *len)
     if (max != *len)
     {
         if (log_level >= LOG_WARN)
-            printk (
-                  "%s: wanted to allocate %d fifo space, but got only %d\n",
+            pr_info("%s: wanted to allocate %d fifo space, but got only %d\n",
                     pi->up->devname, *len, max);
         *len = max;
     }
     if (log_level >= LOG_DEBUG)
-        printk ("%s: allocated %d fifo at %d for channel %d/%d\n",
+        pr_info("%s: allocated %d fifo at %d for channel %d/%d\n",
                 pi->up->devname, max, start, chan, pi->p.portnum);
     for (i = maxstart; i < (maxstart + max); i++)
         pi->fifomap[i] = chan;
@@ -1440,7 +1439,7 @@ c4_fifo_free (mpi_t * pi, int chan)
     int         i;
 
     if (log_level >= LOG_DEBUG)
-        printk ("%s: deallocated fifo for channel %d/%d\n",
+        pr_info("%s: deallocated fifo for channel %d/%d\n",
                 pi->up->devname, chan, pi->p.portnum);
     for (i = 0; i < 32; i++)
         if (pi->fifomap[i] == chan)
@@ -1465,7 +1464,8 @@ c4_chan_up (ci_t * ci, int channum)
     if (ch->state == UP)
     {
         if (log_level >= LOG_MONITOR)
-            printk ("%s: channel already UP, graceful early exit\n", ci->devname);
+            pr_info("%s: channel already UP, graceful early exit\n",
+                    ci->devname);
         return 0;
     }
     pi = ch->up;
@@ -1478,9 +1478,10 @@ c4_chan_up (ci_t * ci, int channum)
         {
             if (1 || log_level >= LOG_WARN)
             {
-                printk ("%s: c4_chan_up[%d] EINVAL (attempt to cfg in-use or unavailable TimeSlot[%d])\n",
+                pr_info("%s: c4_chan_up[%d] EINVAL (attempt to cfg in-use or unavailable TimeSlot[%d])\n",
                         ci->devname, channum, i);
-                printk ("+ ask4 %x, currently %x\n", ch->p.bitmask[i], pi->tsm[i]);
+                pr_info("+ ask4 %x, currently %x\n",
+                        ch->p.bitmask[i], pi->tsm[i]);
             }
             return EINVAL;
         }
@@ -1493,7 +1494,8 @@ c4_chan_up (ci_t * ci, int channum)
     if (!nbuf)
     {
         /* if( log_level >= LOG_WARN)  */
-        printk ("%s: c4_chan_up[%d] ENOBUFS (no TimeSlots assigned)\n", ci->devname, channum);
+        pr_info("%s: c4_chan_up[%d] ENOBUFS (no TimeSlots assigned)\n",
+                ci->devname, channum);
         return ENOBUFS;             /* this should not happen */
     }
     addr = c4_fifo_alloc (pi, gchan, &nbuf);
@@ -1561,7 +1563,7 @@ c4_chan_up (ci_t * ci, int channum)
 #if 0
     /* DEBUG INFO */
     if (log_level >= LOG_MONITOR)
-        printk ("%s: mode %x rxnum %d (rxused %d def %d) txnum %d (txused %d def %d)\n",
+        pr_info("%s: mode %x rxnum %d (rxused %d def %d) txnum %d (txused %d def %d)\n",
                 ci->devname, ch->p.chan_mode,
                 rxnum, max_rxdesc_used, max_rxdesc_default,
                 txnum, max_txdesc_used, max_txdesc_default);
@@ -1592,7 +1594,8 @@ c4_chan_up (ci_t * ci, int channum)
         if (!(m = OS_mem_token_alloc (max_mru)))
         {
             if (log_level >= LOG_MONITOR)
-                printk ("%s: c4_chan_up[%d] - token alloc failure, size = %d.\n", ci->devname, channum, max_mru);
+                pr_info("%s: c4_chan_up[%d] - token alloc failure, size = %d.\n",
+                        ci->devname, channum, max_mru);
             goto errfree;
         }
         md->mem_token = m;
@@ -1638,7 +1641,7 @@ c4_chan_up (ci_t * ci, int channum)
     if (ch->p.status & RX_ENABLED)
     {
 #ifdef RLD_TRANS_DEBUG
-        printk ("++ c4_chan_up() CHAN RX ACTIVATE: chan %d\n", ch->channum);
+        pr_info("++ c4_chan_up() CHAN RX ACTIVATE: chan %d\n", ch->channum);
 #endif
         ch->ch_start_rx = 0;        /* we are restarting RX... */
         musycc_serv_req (pi, SR_CHANNEL_ACTIVATE | SR_RX_DIRECTION | gchan);
@@ -1646,7 +1649,7 @@ c4_chan_up (ci_t * ci, int channum)
     if (ch->p.status & TX_ENABLED)
     {
 #ifdef RLD_TRANS_DEBUG
-        printk ("++ c4_chan_up() CHAN TX ACTIVATE: chan %d <delayed>\n", ch->channum);
+        pr_info("++ c4_chan_up() CHAN TX ACTIVATE: chan %d <delayed>\n", ch->channum);
 #endif
         ch->ch_start_tx = CH_START_TX_1ST;      /* we are delaying start
                                                  * until receipt from user of
diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
index 44229a9..c65172d 100644
--- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
+++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h
@@ -94,7 +94,7 @@ pci_read_32 (u_int32_t *p)
     FLUSH_PCI_READ ();
     v = le32_to_cpu (*p);
     if (log_level >= LOG_DEBUG)
-        printk ("pci_read : %x = %x\n", (u_int32_t) p, v);
+        pr_info("pci_read : %x = %x\n", (u_int32_t) p, v);
     return v;
 #else
                 FLUSH_PCI_READ ();      /* */
@@ -107,7 +107,7 @@ pci_write_32 (u_int32_t *p, u_int32_t v)
 {
 #ifdef FLOW_DEBUG
     if (log_level >= LOG_DEBUG)
-        printk ("pci_write: %x = %x\n", (u_int32_t) p, v);
+        pr_info("pci_write: %x = %x\n", (u_int32_t) p, v);
 #endif
     *p = cpu_to_le32 (v);
     FLUSH_PCI_WRITE ();             /* This routine is called from routines
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 92f6f5c..4f4dcd3 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -66,7 +66,7 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
     }
 #if 0
     /** RLD DEBUG **/
-    printk (">> sbecom_proc_get_sbe_info: entered, offset %d. length %d.\n",
+    pr_info(">> sbecom_proc_get_sbe_info: entered, offset %d. length %d.\n",
             (int) offset, (int) length);
 #endif
 
@@ -90,7 +90,7 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
 
 #if 0
     /** RLD DEBUG **/
-    printk (">> sbecom_get_brdinfo: returned, first_if %p <%s> last_if %p <%s>\n",
+    pr_info(">> sbecom_get_brdinfo: returned, first_if %p <%s> last_if %p <%s>\n",
             (char *) &bip->first_iname, (char *) &bip->first_iname,
             (char *) &bip->last_iname, (char *) &bip->last_iname);
 #endif
@@ -293,7 +293,7 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,
 #endif
 
 #if 0
-    printk (">> proc_fs: returned len = %d., start %p\n", len, start);  /* RLD DEBUG */
+    pr_info(">> proc_fs: returned len = %d., start %p\n", len, start);  /* RLD DEBUG */
 #endif
 
 /***


