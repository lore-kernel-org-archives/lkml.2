Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754165Ab1HHSbv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 14:31:51 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:50804 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753044Ab1HHSbu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 14:31:50 -0400
Date: Mon, 8 Aug 2011 11:31:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: lkml <linux-kernel@vger.kernel.org>, gregkh <greg@kroah.com>,
        akpm <akpm@linux-foundation.org>
Cc: driverdevel <devel@driverdev.osuosl.org>,
        Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging: fix ft1000 sparse warnings
Message-Id: <20110808113148.578148c2.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix sparse warnings in staging/ft1000/:

drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:69:7: warning: obsolete struct initializer, use C99 syntax

and make many functions & data static.  Examples:
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:65:23: warning: symbol 'fw_entry' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:836:6: warning: symbol 'ft1000_send_cmd' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:1014:6: warning: symbol 'ft1000_proc_drvmsg' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:1788:5: warning: symbol 'ft1000_copy_down_pkt' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2096:6: warning: symbol 'stop_ft1000_card' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c:2155:19: warning: symbol 'init_ft1000_card' was not declared. Should it be static?

rivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c:172:5: warning: symbol 'ft1000_confcheck' was not declared. Should it be static?

drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:50:5: warning: symbol 'ft1000ReadProc' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:194:6: warning: symbol 'ft1000InitProc' was not declared. Should it be static?
drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c:207:6: warning: symbol 'ft1000CleanupProc' was not declared. Should it be static?

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000.h      |   10 ++++
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c   |    8 +--
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c |    3 -
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   24 ++++-------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    4 -
 5 files changed, 27 insertions(+), 22 deletions(-)

--- lnx-31-rc1.orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ lnx-31-rc1/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -56,16 +56,11 @@
 #include <linux/delay.h>
 #include "ft1000.h"
 
-int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength);
-
-void ft1000InitProc(struct net_device *dev);
-void ft1000CleanupProc(struct net_device *dev);
-
-const struct firmware *fw_entry;
+static const struct firmware *fw_entry;
 
 static void ft1000_hbchk(u_long data);
 static struct timer_list poll_timer = {
-      function:ft1000_hbchk
+      .function = ft1000_hbchk
 };
 
 static u16 cmdbuffer[1024];
@@ -788,7 +783,7 @@ static void ft1000_hbchk(u_long data)
 // Output:
 //
 //---------------------------------------------------------------------------
-void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qtype)
+static void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qtype)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	int i;
@@ -873,7 +868,8 @@ void ft1000_send_cmd (struct net_device 
 //          = 1 (successful)
 //
 //---------------------------------------------------------------------------
-bool ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16 *pnxtph)
+static bool ft1000_receive_cmd(struct net_device *dev, u16 *pbuffer,
+				int maxsz, u16 *pnxtph)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 size;
@@ -966,7 +962,7 @@ bool ft1000_receive_cmd(struct net_devic
 //     none
 //
 //---------------------------------------------------------------------------
-void ft1000_proc_drvmsg(struct net_device *dev)
+static void ft1000_proc_drvmsg(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 msgtype;
@@ -1245,7 +1241,7 @@ void ft1000_proc_drvmsg(struct net_devic
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-int ft1000_parse_dpram_msg(struct net_device *dev)
+static int ft1000_parse_dpram_msg(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	u16 doorbell;
@@ -1546,7 +1542,7 @@ static void ft1000_flush_fifo(struct net
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-int ft1000_copy_up_pkt(struct net_device *dev)
+static int ft1000_copy_up_pkt(struct net_device *dev)
 {
 	u16 tempword;
 	struct ft1000_info *info = netdev_priv(dev);
@@ -1734,7 +1730,7 @@ int ft1000_copy_up_pkt(struct net_device
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
+static int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 {
 	struct ft1000_info *info = netdev_priv(dev);
 	union {
@@ -2102,7 +2098,7 @@ static const struct ethtool_ops ops = {
 };
 
 struct net_device *init_ft1000_card(struct pcmcia_device *link,
-					void *ft1000_reset)
+						void *ft1000_reset)
 {
 	struct ft1000_info *info;
 	struct net_device *dev;
--- lnx-31-rc1.orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
+++ lnx-31-rc1/drivers/staging/ft1000/ft1000-pcmcia/ft1000.h
@@ -68,6 +68,16 @@ struct ft1000_info {
 	char netdevname[IFNAMSIZ];
 };
 
+struct pcmcia_device;
+struct net_device;
+extern struct net_device *init_ft1000_card(struct pcmcia_device *link,
+						void *ft1000_reset);
+extern void stop_ft1000_card(struct net_device *dev);
+extern int card_download(struct net_device *dev, const u8 *pFileStart,
+			size_t FileLength);
+extern void ft1000InitProc(struct net_device *dev);
+extern void ft1000CleanupProc(struct net_device *dev);
+
 extern u16 ft1000_read_dpram(struct net_device *dev, int offset);
 extern void card_bootload(struct net_device *dev);
 extern u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index);
--- lnx-31-rc1.orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
+++ lnx-31-rc1/drivers/staging/ft1000/ft1000-pcmcia/ft1000_cs.c
@@ -41,14 +41,12 @@ MODULE_LICENSE("GPL");
 
 /*====================================================================*/
 
-struct net_device *init_ft1000_card(struct pcmcia_device *link,
-					void *ft1000_reset);
-void stop_ft1000_card(struct net_device *);
-
 static int ft1000_config(struct pcmcia_device *link);
 static void ft1000_detach(struct pcmcia_device *link);
 static int ft1000_attach(struct pcmcia_device *link);
 
+#include "ft1000.h"
+
 /*====================================================================*/
 
 static void ft1000_reset(struct pcmcia_device *link)
@@ -75,7 +73,7 @@ static void ft1000_detach(struct pcmcia_
 	free_netdev(dev);
 }
 
-int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
+static int ft1000_confcheck(struct pcmcia_device *link, void *priv_data)
 {
 	return pcmcia_request_io(link);
 }
--- lnx-31-rc1.orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ lnx-31-rc1/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -47,8 +47,8 @@
 	} \
 	len += snprintf(page+len, PAGE_SIZE - len, "%d\n", var[i])
 
-int ft1000ReadProc(char *page, char **start, off_t off,
-		   int count, int *eof, void *data)
+static int ft1000ReadProc(char *page, char **start, off_t off,
+			  int count, int *eof, void *data)
 {
 	struct net_device *dev;
 	int len;
--- lnx-31-rc1.orig/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
+++ lnx-31-rc1/drivers/staging/ft1000/ft1000-pcmcia/ft1000_dnld.c
@@ -287,7 +287,8 @@ u16 hdr_checksum(struct pseudo_hdr *pHdr
 	return chksum;
 }
 
-int card_download(struct net_device *dev, const u8 *pFileStart, u32 FileLength)
+int card_download(struct net_device *dev, const u8 *pFileStart,
+		  size_t FileLength)
 {
 	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 	int Status = SUCCESS;
