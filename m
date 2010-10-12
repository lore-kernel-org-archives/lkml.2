Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751634Ab0JLV5q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 17:57:46 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:64774 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab0JLV5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 17:57:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=Beje9QnycgTe2oU5u7MthWxDYPsvkUu1bDIEoPdRQItHQbjFdcmDK49y++PQMxGQIf
         5DdJi9+9HBQErRMmxFkgZuXN/RTx4HVoBEn+QIt/6FAZ5sq8E30fgwxd5MeBzC6H0IMz
         gkOtgyu+v5G3/cCt3Wl59rQ00wLZLnoiiZnZE=
Subject: [PATCH] staging/cxt1e1: fix mtu_max name pollution
From: Bob Beers <bob.beers@gmail.com>
Reply-To: bob.beers@gmail.com
To: gregkh@suse.de
Cc: napohybelskurwysynom2010@gmail.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Tue, 12 Oct 2010 17:57:41 -0400
Message-Id: <1286920661.8951.4.camel@tjeff3.edgeaccess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename 'max_mtu' to 'cxt1e1_max_mtu' to avoid multiple definition of `max_mtu'.

Signed-off-by: Bob Beers <bbeers@gmail.com>
---


diff -pubr -X /home/bbeers/dontdiff linux-2.6-a/drivers/staging/cxt1e1/linux.c linux-2.6/drivers/staging/cxt1e1/linux.c
--- linux-2.6-a/drivers/staging/cxt1e1/linux.c  2010-03-02 17:41:47.000000000 -0500
+++ linux-2.6/drivers/staging/cxt1e1/linux.c    2010-10-11 11:07:18.000000000 -0400
@@ -114,9 +114,9 @@ int         max_mru = MUSYCC_MRU;
 int         max_mru_default = MUSYCC_MRU;
 module_param(max_mru, int, 0444);

-int         max_mtu = MUSYCC_MTU;
+int         cxt1e1_max_mtu = MUSYCC_MTU;
 int         max_mtu_default = MUSYCC_MTU;
-module_param(max_mtu, int, 0444);
+module_param(cxt1e1_max_mtu, int, 0444);

 int         max_txdesc_used = MUSYCC_TXDESC_MIN;
 int         max_txdesc_default = MUSYCC_TXDESC_MIN;
@@ -1274,9 +1274,9 @@ c4_mod_init (void)
     if (max_mru != max_mru_default)
         printk (KERN_INFO "%s NOTE: driver parameter <max_mru> changed from default %d to %d.\n",
                 THIS_MODULE->name, max_mru_default, max_mru);
-    if (max_mtu != max_mtu_default)
-        printk (KERN_INFO "%s NOTE: driver parameter <max_mtu> changed from default %d to %d.\n",
-                THIS_MODULE->name, max_mtu_default, max_mtu);
+       if (cxt1e1_max_mtu != max_mtu_default)
+               printk(KERN_INFO "%s NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
+                          THIS_MODULE->name, max_mtu_default, cxt1e1_max_mtu);
     if (max_rxdesc_used != max_rxdesc_default)
     {
         if (max_rxdesc_used > 2000)
diff -pubr -X /home/bbeers/dontdiff linux-2.6-a/drivers/staging/cxt1e1/musycc.c linux-2.6/drivers/staging/cxt1e1/musycc.c
--- linux-2.6-a/drivers/staging/cxt1e1/musycc.c 2010-03-02 17:41:47.000000000 -0500
+++ linux-2.6/drivers/staging/cxt1e1/musycc.c   2010-10-11 11:11:55.000000000 -0400
@@ -99,7 +99,7 @@ extern int  drvr_state;
 extern int  log_level;

 extern int  max_mru;
-extern int  max_mtu;
+extern int  cxt1e1_max_mtu;
 extern int  max_rxdesc_used;
 extern int  max_txdesc_used;
 extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
@@ -963,11 +963,11 @@ musycc_init (ci_t * ci)
                 THIS_MODULE->name, max_mru, 0xffe);
         max_mru = 0xffe;
     }
-    if (max_mtu > 0xffe)
+       if (cxt1e1_max_mtu > 0xffe)
     {
         printk (KERN_WARNING "%s: Maximum allowed MTU exceeded, resetting %d to %d.\n",
-                THIS_MODULE->name, max_mtu, 0xffe);
-        max_mtu = 0xffe;
+                               THIS_MODULE->name, cxt1e1_max_mtu, 0xffe);
+               cxt1e1_max_mtu = 0xffe;
     }
 #ifdef SBE_WAN256T3_ENABLE
     for (i = 0; i < MUSYCC_NPORTS; i++)
diff -pubr -X /home/bbeers/dontdiff linux-2.6-a/drivers/staging/cxt1e1/pmcc4_drv.c linux-2.6/drivers/staging/cxt1e1/pmcc4_drv.c
--- linux-2.6-a/drivers/staging/cxt1e1/pmcc4_drv.c      2010-03-02 17:41:47.000000000 -0500
+++ linux-2.6/drivers/staging/cxt1e1/pmcc4_drv.c        2010-10-11 10:25:44.000000000 -0400
@@ -138,7 +138,7 @@ void        musycc_update_timeslots (mpi
 extern void musycc_update_tx_thp (mch_t *);
 extern int  log_level;
 extern int  max_mru;
-extern int  max_mtu;
+extern int  cxt1e1_max_mtu;
 extern int  max_rxdesc_used, max_rxdesc_default;
 extern int  max_txdesc_used, max_txdesc_default;

diff -pubr -X /home/bbeers/dontdiff linux-2.6-a/drivers/staging/cxt1e1/sbeproc.c linux-2.6/drivers/staging/cxt1e1/sbeproc.c
--- linux-2.6-a/drivers/staging/cxt1e1/sbeproc.c        2010-03-02 17:41:47.000000000 -0500
+++ linux-2.6/drivers/staging/cxt1e1/sbeproc.c  2010-10-11 10:27:16.000000000 -0400
@@ -171,17 +171,9 @@ sbecom_proc_get_sbe_info (char *buffer,
 #ifdef SBE_PMCC4_ENABLE
     {
         extern int max_mru;
-#if 0
-        extern int max_chans_used;
-        extern int max_mtu;
-#endif
         extern int max_rxdesc_used, max_txdesc_used;

         len += sprintf (buffer + len, "\nmax_mru:         %d\n", max_mru);
-#if 0
-        len += sprintf (buffer + len, "\nmax_chans_used:  %d\n", max_chans_used);
-        len += sprintf (buffer + len, "max_mtu:         %d\n", max_mtu);
-#endif
         len += sprintf (buffer + len, "max_rxdesc_used: %d\n", max_rxdesc_used);
         len += sprintf (buffer + len, "max_txdesc_used: %d\n", max_txdesc_used);
     }




