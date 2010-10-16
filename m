Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756398Ab0JPWGu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 18:06:50 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58167 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0JPWGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 18:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:content-type:date:message-id
         :mime-version:x-mailer:content-transfer-encoding;
        b=uY5O7yXI77HmG0kLOwFZGlL268uqxOaXhHLRx2pJ1/IWIbQXrM4KEMjGQUXTK7evEO
         Xm4Ok3/wuBs1j6NiAyx/lrJyuDb3R6q3xBD+9RHFCIFO3HLLvqfatYvhlobWpoont7MK
         AHGH1kWO7B5Rk9Ns+hhQXv/I5pJvDn6+3NdW0=
Subject: [PATCH] Staging/cxt1e1: multiple definition of max_mtu fix
From: Bob Beers <bob.beers@gmail.com>
Reply-To: bob.beers@gmail.com
To: gregkh@suse.de
Cc: napohybelskurwysynom2010@gmail.com, akpm@linux-foundation.org,
        mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain
Date: Sat, 16 Oct 2010 18:06:36 -0400
Message-Id: <1287266797.16929.4.camel@tjeff3.edgeaccess.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-8.el5_2.3) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

eliminate multiple definition of max_mtu by renaming
 with cxt1e1_ prefix, similarly rename max_mru

Signed-off-by: Bob Beers <bbeers@gmail.com>
---

 drivers/staging/cxt1e1/linux.c     |   20 ++++++++++----------
 drivers/staging/cxt1e1/musycc.c    |   22 +++++++++++-----------
 drivers/staging/cxt1e1/pmcc4_drv.c |   14 +++++++-------
 drivers/staging/cxt1e1/sbeproc.c   |    8 ++++----
 4 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
index eb0f4bd..589b765 100644
--- a/drivers/staging/cxt1e1/linux.c
+++ b/drivers/staging/cxt1e1/linux.c
@@ -112,13 +112,13 @@ int         log_level = LOG_ERROR;
 int         log_level_default = LOG_ERROR;
 module_param(log_level, int, 0444);

-int         max_mru = MUSYCC_MRU;
+int         cxt1e1_max_mru = MUSYCC_MRU;
 int         max_mru_default = MUSYCC_MRU;
-module_param(max_mru, int, 0444);
+module_param(cxt1e1_max_mru, int, 0444);

-int         max_mtu = MUSYCC_MTU;
+int         cxt1e1_max_mtu = MUSYCC_MTU;
 int         max_mtu_default = MUSYCC_MTU;
-module_param(max_mtu, int, 0444);
+module_param(cxt1e1_max_mtu, int, 0444);

 int         max_txdesc_used = MUSYCC_TXDESC_MIN;
 int         max_txdesc_default = MUSYCC_TXDESC_MIN;
@@ -1118,12 +1118,12 @@ c4_mod_init (void)
     if (log_level != log_level_default)
         pr_info("NOTE: driver parameter <log_level> changed from default %d to %d.\n",
                 log_level_default, log_level);
-    if (max_mru != max_mru_default)
-        pr_info("NOTE: driver parameter <max_mru> changed from default %d to %d.\n",
-                max_mru_default, max_mru);
-    if (max_mtu != max_mtu_default)
-        pr_info("NOTE: driver parameter <max_mtu> changed from default %d to %d.\n",
-                max_mtu_default, max_mtu);
+       if (cxt1e1_max_mru != max_mru_default)
+               pr_info("NOTE: driver parameter <cxt1e1_max_mru> changed from default %d to %d.\n",
+                               max_mru_default, cxt1e1_max_mru);
+       if (cxt1e1_max_mtu != max_mtu_default)
+               pr_info("NOTE: driver parameter <cxt1e1_max_mtu> changed from default %d to %d.\n",
+                               max_mtu_default, cxt1e1_max_mtu);
     if (max_rxdesc_used != max_rxdesc_default)
     {
         if (max_rxdesc_used > 2000)
diff --git a/drivers/staging/cxt1e1/musycc.c b/drivers/staging/cxt1e1/musycc.c
index 12c76a5..fdde35a 100644
--- a/drivers/staging/cxt1e1/musycc.c
+++ b/drivers/staging/cxt1e1/musycc.c
@@ -99,8 +99,8 @@ extern ci_t *c4_list;
 extern int  drvr_state;
 extern int  log_level;

-extern int  max_mru;
-extern int  max_mtu;
+extern int  cxt1e1_max_mru;
+extern int  cxt1e1_max_mtu;
 extern int  max_rxdesc_used;
 extern int  max_txdesc_used;
 extern ci_t *CI;                /* dummy pointr to board ZEROE's data - DEBUG
@@ -819,7 +819,7 @@ musycc_init_port (mpi_t * pi)
                                 MUSYCC_PCD_TX_DRIVEN);

     /* Message length descriptor */
-    pi->regram->mld = __constant_cpu_to_le32 (max_mru | (max_mru << 16));
+       pi->regram->mld = __constant_cpu_to_le32 (cxt1e1_max_mru | (cxt1e1_max_mru << 16));
     FLUSH_MEM_WRITE ();

     musycc_serv_req (pi, SR_GROUP_INIT | SR_RX_DIRECTION);
@@ -913,17 +913,17 @@ musycc_init (ci_t * ci)

     /* sanity check settable parameters */

-    if (max_mru > 0xffe)
+       if (cxt1e1_max_mru > 0xffe)
     {
         pr_warning("Maximum allowed MRU exceeded, resetting %d to %d.\n",
-                   max_mru, 0xffe);
-        max_mru = 0xffe;
+                                  cxt1e1_max_mru, 0xffe);
+               cxt1e1_max_mru = 0xffe;
     }
-    if (max_mtu > 0xffe)
+       if (cxt1e1_max_mtu > 0xffe)
     {
         pr_warning("Maximum allowed MTU exceeded, resetting %d to %d.\n",
-                   max_mtu, 0xffe);
-        max_mtu = 0xffe;
+                                  cxt1e1_max_mtu, 0xffe);
+               cxt1e1_max_mtu = 0xffe;
     }
 #ifdef SBE_WAN256T3_ENABLE
     for (i = 0; i < MUSYCC_NPORTS; i++)
@@ -1172,7 +1172,7 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
 #endif                              /*** CONFIG_SBE_WAN256T3_NCOMM ***/

             {
-                if ((m2 = OS_mem_token_alloc (max_mru)))
+                               if ((m2 = OS_mem_token_alloc (cxt1e1_max_mru)))
                 {
                     /* substitute the mbuf+cluster */
                     md->mem_token = m2;
@@ -1204,7 +1204,7 @@ musycc_bh_rx_eom (mpi_t * pi, int gchan)
             ch->s.rx_length_errors++;
         }
         FLUSH_MEM_WRITE ();
-        status = max_mru;
+               status = cxt1e1_max_mru;
         if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
             status |= EOBIRQ_ENABLE;
         md->status = cpu_to_le32 (status);
diff --git a/drivers/staging/cxt1e1/pmcc4_drv.c b/drivers/staging/cxt1e1/pmcc4_drv.c
index 9f730e6..be8618f 100644
--- a/drivers/staging/cxt1e1/pmcc4_drv.c
+++ b/drivers/staging/cxt1e1/pmcc4_drv.c
@@ -136,8 +136,8 @@ void        musycc_update_timeslots (mpi_t *);

 extern void musycc_update_tx_thp (mch_t *);
 extern int  log_level;
-extern int  max_mru;
-extern int  max_mtu;
+extern int  cxt1e1_max_mru;
+extern int  cxt1e1_max_mtu;
 extern int  max_rxdesc_used, max_rxdesc_default;
 extern int  max_txdesc_used, max_txdesc_default;

@@ -1047,7 +1047,7 @@ c4_set_port (ci_t * ci, int portnum)
                                 MUSYCC_PCD_RXDATA_RISING);

     /* Message length descriptor */
-    pi->regram->mld = __constant_cpu_to_le32 (max_mru | (max_mru << 16));
+       pi->regram->mld = __constant_cpu_to_le32 (cxt1e1_max_mru | (cxt1e1_max_mru << 16));

     /* tsm algorithm */
     for (i = 0; i < 32; i++)
@@ -1434,9 +1434,9 @@ c4_chan_up (ci_t * ci, int channum)
     ch->mdr = OS_kmalloc (sizeof (struct mdesc) * rxnum);
     ch->mdt = OS_kmalloc (sizeof (struct mdesc) * txnum);
     if (ch->p.chan_mode == CFG_CH_PROTO_TRANS)
-        tmp = __constant_cpu_to_le32 (max_mru | EOBIRQ_ENABLE);
+               tmp = __constant_cpu_to_le32 (cxt1e1_max_mru | EOBIRQ_ENABLE);
     else
-        tmp = __constant_cpu_to_le32 (max_mru);
+               tmp = __constant_cpu_to_le32 (cxt1e1_max_mru);

     for (i = 0, md = ch->mdr; i < rxnum; i++, md++)
     {
@@ -1449,11 +1449,11 @@ c4_chan_up (ci_t * ci, int channum)
         }
         md->next = cpu_to_le32 (OS_vtophys (md->snext));

-        if (!(m = OS_mem_token_alloc (max_mru)))
+               if (!(m = OS_mem_token_alloc (cxt1e1_max_mru)))
         {
             if (log_level >= LOG_MONITOR)
                 pr_info("%s: c4_chan_up[%d] - token alloc failure, size = %d.\n",
-                        ci->devname, channum, max_mru);
+                                               ci->devname, channum, cxt1e1_max_mru);
             goto errfree;
         }
         md->mem_token = m;
diff --git a/drivers/staging/cxt1e1/sbeproc.c b/drivers/staging/cxt1e1/sbeproc.c
index 4f4dcd3..9405b7a 100644
--- a/drivers/staging/cxt1e1/sbeproc.c
+++ b/drivers/staging/cxt1e1/sbeproc.c
@@ -172,17 +172,17 @@ sbecom_proc_get_sbe_info (char *buffer, char **start, off_t offset,

 #ifdef SBE_PMCC4_ENABLE
     {
-        extern int max_mru;
+               extern int cxt1e1_max_mru;
 #if 0
         extern int max_chans_used;
-        extern int max_mtu;
+        extern int cxt1e1_max_mtu;
 #endif
         extern int max_rxdesc_used, max_txdesc_used;

-        len += sprintf (buffer + len, "\nmax_mru:         %d\n", max_mru);
+        len += sprintf (buffer + len, "\ncxt1e1_max_mru:         %d\n", cxt1e1_max_mru);
 #if 0
         len += sprintf (buffer + len, "\nmax_chans_used:  %d\n", max_chans_used);
-        len += sprintf (buffer + len, "max_mtu:         %d\n", max_mtu);
+        len += sprintf (buffer + len, "cxt1e1_max_mtu:         %d\n", cxt1e1_max_mtu);
 #endif
         len += sprintf (buffer + len, "max_rxdesc_used: %d\n", max_rxdesc_used);
         len += sprintf (buffer + len, "max_txdesc_used: %d\n", max_txdesc_used);
--
1.5.5.6



