Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0ECRMi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 13:12:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:53359 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751822Ab0ECRMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 13:12:36 -0400
Date: Mon, 3 May 2010 10:09:02 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
       devel@driverdev.osuosl.org
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       support@sbei.com, support@onestopsystems.com
Subject: [PATCH -next] staging: fix cxt1e1 module names
Message-Id: <20100503100902.517c146f.randy.dunlap@oracle.com>
In-Reply-To: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
References: <20100503151619.f75e3a80.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4BDF0398.003A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Lots of cxt1e1 source code uses THIS_MODULE->name, which won't build
when CONFIG_MODULES is not enabled, so use KBUILD_MODNAME instead.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: support@sbei.com
Cc: support@onestopsystems.com
---
 drivers/staging/cxt1e1/hwprobe.c   |    9 +++++----
 drivers/staging/cxt1e1/linux.c     |   16 ++++++++--------
 drivers/staging/cxt1e1/musycc.c    |    4 ++--
 drivers/staging/cxt1e1/pmcc4_drv.c |   13 ++++++++-----
 drivers/staging/cxt1e1/sbeproc.c   |    4 ++--
 5 files changed, 25 insertions(+), 21 deletions(-)

--- linux-next-20100503.orig/drivers/staging/cxt1e1/musycc.c
+++ linux-next-20100503/drivers/staging/cxt1e1/musycc.c
@@ -960,13 +960,13 @@ musycc_init (ci_t * ci)
     if (max_mru > 0xffe)
     {
         printk (KERN_WARNING "%s: Maximum allowed MRU exceeded, resetting %d to %d.\n",
-                THIS_MODULE->name, max_mru, 0xffe);
+                KBUILD_MODNAME, max_mru, 0xffe);
         max_mru = 0xffe;
     }
     if (max_mtu > 0xffe)
     {
         printk (KERN_WARNING "%s: Maximum allowed MTU exceeded, resetting %d to %d.\n",
-                THIS_MODULE->name, max_mtu, 0xffe);
+                KBUILD_MODNAME, max_mtu, 0xffe);
         max_mtu = 0xffe;
     }
 #ifdef SBE_WAN256T3_ENABLE
--- linux-next-20100503.orig/drivers/staging/cxt1e1/pmcc4_drv.c
+++ linux-next-20100503/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -171,10 +171,11 @@ sbecom_set_loglevel (int d)
     {
         if (log_level != d)
         {
-            printk ("%s: log level changed from %d to %d\n", THIS_MODULE->name, log_level, d);
+            printk ("%s: log level changed from %d to %d\n",
+		KBUILD_MODNAME, log_level, d);
             log_level = d;          /* set new */
         } else
-            printk ("%s: log level is %d\n", THIS_MODULE->name, log_level);
+            printk ("%s: log level is %d\n", KBUILD_MODNAME, log_level);
     }
 }
 
@@ -221,7 +222,7 @@ c4_new (void *hi)
         ci->brdno = ci->next ? ci->next->brdno + 1 : 0;
     } else
         printk (KERN_WARNING "%s: failed CI malloc, size %u.\n",
-                THIS_MODULE->name, (unsigned int) sizeof (ci_t));
+                KBUILD_MODNAME, (unsigned int) sizeof (ci_t));
 
     if (CI == 0)
         CI = ci;                    /* DEBUG, only board 0 usage */
@@ -545,7 +546,8 @@ c4_watchdog (ci_t * ci)
     if (drvr_state != SBE_DRVR_AVAILABLE)
     {
         if (log_level >= LOG_MONITOR)
-            printk ("%s: drvr not available (%x)\n", THIS_MODULE->name, drvr_state);
+            printk ("%s: drvr not available (%x)\n",
+		KBUILD_MODNAME, drvr_state);
         return;
     }
 #if 0
@@ -848,7 +850,8 @@ c4_init (ci_t * ci, u_char *func0, u_cha
             } else
             {
                 printk (KERN_WARNING "%s: failed mch_t malloc, port %d channel %d size %u.\n",
-                        THIS_MODULE->name, portnum, j, (unsigned int) sizeof (mch_t));
+                        KBUILD_MODNAME, portnum, j,
+			(unsigned int) sizeof (mch_t));
                 break;
             }
         }
--- linux-next-20100503.orig/drivers/staging/cxt1e1/linux.c
+++ linux-next-20100503/drivers/staging/cxt1e1/linux.c
@@ -338,7 +338,7 @@ chan_open (struct net_device * ndev)
 
     if ((ret = hdlc_open (ndev)))
     {
-        printk ("%s: hdlc_open failure, err %d.\n", THIS_MODULE->name, ret);
+        printk ("%s: hdlc_open failure, err %d.\n", KBUILD_MODNAME, ret);
         return ret;
     }
     if ((ret = c4_chan_up (priv->ci, priv->channum)))
@@ -1263,33 +1263,33 @@ c4_mod_init (void)
 {
     int         rtn;
 
-    printk (KERN_WARNING "%s: %s\n", THIS_MODULE->name, pmcc4_OSSI_release);
+    printk (KERN_WARNING "%s: %s\n", KBUILD_MODNAME, pmcc4_OSSI_release);
     if ((rtn = c4hw_attach_all ()))
         return -rtn;                /* installation failure - see system log */
 
     /* housekeeping notifications */
     if (log_level != log_level_default)
         printk (KERN_INFO "%s NOTE: driver parameter <log_level> changed from default %d to %d.\n",
-                THIS_MODULE->name, log_level_default, log_level);
+                KBUILD_MODNAME, log_level_default, log_level);
     if (max_mru != max_mru_default)
         printk (KERN_INFO "%s NOTE: driver parameter <max_mru> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_mru_default, max_mru);
+                KBUILD_MODNAME, max_mru_default, max_mru);
     if (max_mtu != max_mtu_default)
         printk (KERN_INFO "%s NOTE: driver parameter <max_mtu> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_mtu_default, max_mtu);
+                KBUILD_MODNAME, max_mtu_default, max_mtu);
     if (max_rxdesc_used != max_rxdesc_default)
     {
         if (max_rxdesc_used > 2000)
             max_rxdesc_used = 2000; /* out-of-bounds reset */
         printk (KERN_INFO "%s NOTE: driver parameter <max_rxdesc_used> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_rxdesc_default, max_rxdesc_used);
+                KBUILD_MODNAME, max_rxdesc_default, max_rxdesc_used);
     }
     if (max_txdesc_used != max_txdesc_default)
     {
         if (max_txdesc_used > 1000)
             max_txdesc_used = 1000; /* out-of-bounds reset */
         printk (KERN_INFO "%s NOTE: driver parameter <max_txdesc_used> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_txdesc_default, max_txdesc_used);
+                KBUILD_MODNAME, max_txdesc_default, max_txdesc_used);
     }
     return 0;                       /* installation success */
 }
@@ -1331,7 +1331,7 @@ c4_mod_remove (void)
     cleanup_devs ();
     c4_cleanup ();
     cleanup_ioremap ();
-    printk (KERN_INFO "SBE %s - driver removed.\n", THIS_MODULE->name);
+    printk (KERN_INFO "SBE %s - driver removed.\n", KBUILD_MODNAME);
 }
 
 module_init (c4_mod_init);
--- linux-next-20100503.orig/drivers/staging/cxt1e1/sbeproc.c
+++ linux-next-20100503/drivers/staging/cxt1e1/sbeproc.c
@@ -319,7 +319,7 @@ sbecom_proc_brd_init (ci_t * ci)
     if (!ci->dir_dev)
     {
         printk (KERN_ERR "%s: Unable to create directory /proc/driver/%s\n",
-                THIS_MODULE->name, ci->devname);
+                KBUILD_MODNAME, ci->devname);
         goto fail;
     }
     e = create_proc_read_entry ("info", S_IFREG | S_IRUGO,
@@ -327,7 +327,7 @@ sbecom_proc_brd_init (ci_t * ci)
     if (!e)
     {
         printk (KERN_ERR "%s: Unable to create entry /proc/driver/%s/info\n",
-                THIS_MODULE->name, ci->devname);
+                KBUILD_MODNAME, ci->devname);
         goto fail;
     }
     return 0;
--- linux-next-20100503.orig/drivers/staging/cxt1e1/hwprobe.c
+++ linux-next-20100503/drivers/staging/cxt1e1/hwprobe.c
@@ -230,7 +230,8 @@ c4_hdw_init (struct pci_dev * pdev, int 
     /* our MUSYCC chip supports two functions, 0 & 1 */
     if ((fun = PCI_FUNC (pdev->devfn)) > 1)
     {
-        printk (KERN_WARNING "%s: unexpected devfun: 0x%x\n", THIS_MODULE->name, pdev->devfn);
+        printk (KERN_WARNING "%s: unexpected devfun: 0x%x\n",
+		KBUILD_MODNAME, pdev->devfn);
         return 0;
     }
     if (pdev->bus)                  /* obtain bus number */
@@ -260,7 +261,7 @@ c4_hdw_init (struct pci_dev * pdev, int 
                                      * exceeded */
     {
         printk (KERN_WARNING "%s: exceeded number of allowed devices (>%d)?\n",
-                THIS_MODULE->name, MAX_BOARDS);
+                KBUILD_MODNAME, MAX_BOARDS);
         return 0;
     }
     if (pdev->bus)
@@ -282,7 +283,7 @@ c4_hdw_init (struct pci_dev * pdev, int 
          */
         char       *cp = hi->devname;
 
-        strcpy (cp, THIS_MODULE->name);
+        strcpy (cp, KBUILD_MODNAME);
         cp += strlen (cp);          /* reposition */
         *cp++ = '-';
         *cp++ = '0' + (found / 2);  /* there are two found interfaces per
@@ -319,7 +320,7 @@ c4hw_attach_all (void)
     }
     if (!found)
     {
-        printk (KERN_WARNING "%s: No boards found.\n", THIS_MODULE->name);
+        printk (KERN_WARNING "%s: No boards found.\n", KBUILD_MODNAME);
         return ENODEV;
     }
     /* sanity check for consistant hardware found */
