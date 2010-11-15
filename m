Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933805Ab0KOVMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 16:12:54 -0500
Received: from mail.perches.com ([173.55.12.10]:1399 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758540Ab0KOVMu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 16:12:50 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 09/10] drivers/staging: Remove unnecessary casts of netdev_priv
Date: Mon, 15 Nov 2010 13:12:32 -0800
Message-Id: <223eff1b1e8c4d1791af56113d088b379a93780b.1289855436.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289855436.git.joe@perches.com>
References: <cover.1289855436.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c   |   54 ++++++++++----------
 drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c |    8 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |    8 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   16 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    2 +-
 drivers/staging/rtl8712/usb_intf.c                 |    2 +-
 7 files changed, 48 insertions(+), 48 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
index eed7e94..588afd5 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_hw.c
@@ -132,7 +132,7 @@ inline void ft1000_asic_write(struct net_device *dev, u16 offset, u16 value)
 //---------------------------------------------------------------------------
 static inline u16 ft1000_read_fifo_len(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 
 	if (info->AsicID == ELECTRABUZZ_ID) {
 		return (ft1000_read_reg(dev, FT1000_REG_UFIFO_STAT) - 16);
@@ -155,7 +155,7 @@ static inline u16 ft1000_read_fifo_len(struct net_device *dev)
 //---------------------------------------------------------------------------
 u16 ft1000_read_dpram(struct net_device * dev, int offset)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 	u16 data;
 
@@ -184,7 +184,7 @@ u16 ft1000_read_dpram(struct net_device * dev, int offset)
 static inline void ft1000_write_dpram(struct net_device *dev,
 					  int offset, u16 value)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 
 	// Provide mutual exclusive access while reading ASIC registers.
@@ -208,7 +208,7 @@ static inline void ft1000_write_dpram(struct net_device *dev,
 //---------------------------------------------------------------------------
 u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 	u16 data;
 
@@ -242,7 +242,7 @@ u16 ft1000_read_dpram_mag_16(struct net_device *dev, int offset, int Index)
 static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 						 int offset, u16 value, int Index)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 
 	// Provide mutual exclusive access while reading ASIC registers.
@@ -270,7 +270,7 @@ static inline void ft1000_write_dpram_mag_16(struct net_device *dev,
 //---------------------------------------------------------------------------
 u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 	u32 data;
 
@@ -298,7 +298,7 @@ u32 ft1000_read_dpram_mag_32(struct net_device *dev, int offset)
 //---------------------------------------------------------------------------
 void ft1000_write_dpram_mag_32(struct net_device *dev, int offset, u32 value)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	unsigned long flags;
 
 	// Provide mutual exclusive access while reading ASIC registers.
@@ -320,7 +320,7 @@ void ft1000_write_dpram_mag_32(struct net_device *dev, int offset, u32 value)
 //---------------------------------------------------------------------------
 static void ft1000_enable_interrupts(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw:ft1000_enable_interrupts()\n");
@@ -345,7 +345,7 @@ static void ft1000_enable_interrupts(struct net_device *dev)
 //---------------------------------------------------------------------------
 static void ft1000_disable_interrupts(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw: ft1000_disable_interrupts()\n");
@@ -370,7 +370,7 @@ static void ft1000_disable_interrupts(struct net_device *dev)
 //---------------------------------------------------------------------------
 static void ft1000_reset_asic(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 tempword;
 
 	DEBUG(1, "ft1000_hw:ft1000_reset_asic called\n");
@@ -414,7 +414,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 //---------------------------------------------------------------------------
 static int ft1000_reset_card(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 tempword;
 	int i;
 	unsigned long flags;
@@ -618,7 +618,7 @@ static void ft1000_hbchk(u_long data)
 	FT1000_INFO *info;
 	USHORT tempword;
 
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	if (info->CardReady == 1) {
 		// Perform dsp heartbeat check
@@ -831,7 +831,7 @@ static void ft1000_hbchk(u_long data)
 //---------------------------------------------------------------------------
 void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qtype)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	int i;
 	u16 tempword;
 	unsigned long flags;
@@ -916,7 +916,7 @@ void ft1000_send_cmd (struct net_device *dev, u16 *ptempbuffer, int size, u16 qt
 //---------------------------------------------------------------------------
 BOOLEAN ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16 *pnxtph)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 size;
 	u16 *ppseudohdr;
 	int i;
@@ -1009,7 +1009,7 @@ BOOLEAN ft1000_receive_cmd(struct net_device *dev, u16 * pbuffer, int maxsz, u16
 //---------------------------------------------------------------------------
 void ft1000_proc_drvmsg(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 msgtype;
 	u16 tempword;
 	PMEDIAMSG pmediamsg;
@@ -1292,7 +1292,7 @@ void ft1000_proc_drvmsg(struct net_device *dev)
 //---------------------------------------------------------------------------
 int ft1000_parse_dpram_msg(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 doorbell;
 	u16 portid;
 	u16 nxtph;
@@ -1449,7 +1449,7 @@ int ft1000_parse_dpram_msg(struct net_device *dev)
 //---------------------------------------------------------------------------
 static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 i;
 	u32 templong;
 	u16 tempword;
@@ -1596,7 +1596,7 @@ static void ft1000_flush_fifo(struct net_device *dev, u16 DrvErrNum)
 int ft1000_copy_up_pkt(struct net_device *dev)
 {
 	u16 tempword;
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 len;
 	struct sk_buff *skb;
 	u16 i;
@@ -1783,7 +1783,7 @@ int ft1000_copy_up_pkt(struct net_device *dev)
 //---------------------------------------------------------------------------
 int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	union {
 		PSEUDO_HDR blk;
 		u16 buff[sizeof(PSEUDO_HDR) >> 1];
@@ -1943,7 +1943,7 @@ int ft1000_copy_down_pkt(struct net_device *dev, u16 * packet, u16 len)
 
 static struct net_device_stats *ft1000_stats(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	return (&info->stats);
 }
 
@@ -1967,7 +1967,7 @@ static int ft1000_open(struct net_device *dev)
 
 static int ft1000_close(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 
 	DEBUG(0, "ft1000_hw: ft1000_close()\n");
 
@@ -1989,7 +1989,7 @@ static int ft1000_close(struct net_device *dev)
 
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u8 *pdata;
 
 	DEBUG(1, "ft1000_hw: ft1000_start_xmit()\n");
@@ -2026,7 +2026,7 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 {
 	struct net_device *dev = (struct net_device *)dev_id;
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	u16 tempword;
 	u16 inttype;
 	int cnt;
@@ -2091,7 +2091,7 @@ static irqreturn_t ft1000_interrupt(int irq, void *dev_id)
 
 void stop_ft1000_card(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv(dev);
+	FT1000_INFO *info = netdev_priv(dev);
 	PPROV_RECORD ptr;
 //	int cnt;
 
@@ -2127,7 +2127,7 @@ static void ft1000_get_drvinfo(struct net_device *dev,
 				   struct ethtool_drvinfo *info)
 {
 	FT1000_INFO *ft_info;
-	ft_info = (FT1000_INFO *) netdev_priv(dev);
+	ft_info = netdev_priv(dev);
 
 	snprintf(info->driver, 32, "ft1000");
 	snprintf(info->bus_info, ETHTOOL_BUSINFO_LEN, "PCMCIA 0x%lx",
@@ -2139,7 +2139,7 @@ static void ft1000_get_drvinfo(struct net_device *dev,
 static u32 ft1000_get_link(struct net_device *dev)
 {
 	FT1000_INFO *info;
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 	return info->mediastate;
 }
 
@@ -2185,7 +2185,7 @@ struct net_device *init_ft1000_card(unsigned short irq, int port,
 	}
 
 	SET_NETDEV_DEV(dev, fdev);
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	memset(info, 0, sizeof(FT1000_INFO));
 
diff --git a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
index b45de9b..935608e 100644
--- a/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-pcmcia/ft1000_proc.c
@@ -65,7 +65,7 @@ int ft1000ReadProc(char *page, char **start, off_t off,
 	time_t delta;
 
 	dev = (struct net_device *)data;
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	if (off > 0) {
 		*eof = 1;
@@ -174,7 +174,7 @@ static int ft1000NotifyProc(struct notifier_block *this, unsigned long event,
 	struct net_device *dev = ptr;
 	FT1000_INFO *info;
 
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	switch (event) {
 	case NETDEV_CHANGENAME:
@@ -195,7 +195,7 @@ void ft1000InitProc(struct net_device *dev)
 {
 	FT1000_INFO *info;
 
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	info->proc_ft1000 = proc_mkdir(FT1000_PROC, init_net.proc_net);
 	create_proc_read_entry(dev->name, 0644, info->proc_ft1000,
@@ -208,7 +208,7 @@ void ft1000CleanupProc(struct net_device *dev)
 {
 	FT1000_INFO *info;
 
-	info = (FT1000_INFO *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 	remove_proc_entry(dev->name, info->proc_ft1000);
 	remove_proc_entry(FT1000_PROC, init_net.proc_net);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index 197b3fb..2135455 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -423,7 +423,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 
     if ( pdevobj[num] != NULL )
         //info = (struct ft1000_info *)(pdevobj[num]->net->priv);
-		info = (struct ft1000_info *)netdev_priv(pdevobj[num]->net);
+		info = netdev_priv(pdevobj[num]->net);
     else
     {
         DEBUG("ft1000_ChOpen: can not find device object %d\n", num);
@@ -488,7 +488,7 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
         return (-EBADF);
     }
 
-	info = (struct ft1000_info *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
@@ -560,7 +560,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
     //DEBUG("FT1000:ft1000_ChIoctl:Command = 0x%x Argument = 0x%8x\n", Command, (u32)Argument);
 
     dev = File->private_data;
-	info = (struct ft1000_info *) netdev_priv(dev);
+	info = netdev_priv(dev);
     ft1000dev = info->pFt1000Dev;
     cmd = _IOC_NR(Command);
     //DEBUG("FT1000:ft1000_ChIoctl:cmd = 0x%x\n", cmd);
@@ -900,7 +900,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
     DEBUG("ft1000_ChRelease called\n");
 
     dev = File->private_data;
-	info = (struct ft1000_info *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
     if (ft1000_flarion_cnt == 0) {
         info->appcnt--;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index b41884e..1ca01e2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -786,7 +786,7 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	return -ENOMEM;
     }
 
-	pInfo = (struct ft1000_info *) netdev_priv(netdev);
+	pInfo = netdev_priv(netdev);
 
     //DEBUG("init_ft1000_netdev: gFt1000Info=%x, netdev=%x, ft1000dev=%x\n", gFt1000Info, netdev, ft1000dev);
 
@@ -1345,7 +1345,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 //---------------------------------------------------------------------------
 static int ft1000_open (struct net_device *dev)
 {
-	struct ft1000_info *pInfo = (struct ft1000_info *)netdev_priv(dev);
+	struct ft1000_info *pInfo = netdev_priv(dev);
     struct timeval tv; //mbelian
 	int ret;
 
@@ -1386,7 +1386,7 @@ static int ft1000_open (struct net_device *dev)
 //---------------------------------------------------------------------------
 int ft1000_close(struct net_device *net)
 {
-	struct ft1000_info *pInfo = (struct ft1000_info *) netdev_priv(net);
+	struct ft1000_info *pInfo = netdev_priv(net);
     struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
 
     //DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
@@ -1409,7 +1409,7 @@ int ft1000_close(struct net_device *net)
 
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
 {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
+	struct ft1000_info *info = netdev_priv(dev);
 
 	return &(info->stats); //mbelian
 }
@@ -1435,7 +1435,7 @@ Jim
 static int ft1000_chkcard (struct ft1000_device *dev) {
     u16 tempword;
     u16 status;
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
+	struct ft1000_info *info = netdev_priv(dev->net);
 
     if (info->fCondResetPend)
     {
@@ -1535,7 +1535,7 @@ static bool ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int max
 static int ft1000_dsp_prov(void *arg)
 {
     struct ft1000_device *dev = (struct ft1000_device *)arg;
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
+	struct ft1000_info *info = netdev_priv(dev->net);
     u16 tempword;
     u16 len;
     u16 i=0;
@@ -1618,7 +1618,7 @@ static int ft1000_dsp_prov(void *arg)
 
 
 static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
+	struct ft1000_info *info = netdev_priv(dev->net);
     u16 msgtype;
     u16 tempword;
 	struct media_msg *pmediamsg;
@@ -1901,7 +1901,7 @@ out:
 int ft1000_poll(void* dev_id) {
 
     struct ft1000_device *dev = (struct ft1000_device *)dev_id;
-	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
+	struct ft1000_info *info = netdev_priv(dev->net);
 
     u16 tempword;
     u16 status;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index f665640..105846d 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -65,7 +65,7 @@ ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
   time_t delta;
 
   dev = (struct net_device *) data;
-	info = (struct ft1000_info *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
   if (off > 0)
     {
@@ -172,7 +172,7 @@ ft1000NotifyProc (struct notifier_block *this, unsigned long event, void *ptr)
 	struct ft1000_info *info;
   struct proc_dir_entry *ft1000_proc_file;
 
-info = (struct ft1000_info *) netdev_priv(dev);
+info = netdev_priv(dev);
 
 
   switch (event)
@@ -198,7 +198,7 @@ ft1000InitProc (struct net_device *dev)
 {
 	struct ft1000_info *info;
   struct proc_dir_entry *ft1000_proc_file;
-	info = (struct ft1000_info *) netdev_priv(dev);
+	info = netdev_priv(dev);
 
 
   info->ft1000_proc_dir = proc_mkdir (FT1000_PROC_DIR, FTNET_PROC);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 99e3339..f87f928e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -163,7 +163,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_load;
 
-	pft1000info = (struct ft1000_info *) netdev_priv(ft1000dev->net);
+	pft1000info = netdev_priv(ft1000dev->net);
 
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
diff --git a/drivers/staging/rtl8712/usb_intf.c b/drivers/staging/rtl8712/usb_intf.c
index f1f0c63..a692ee8 100644
--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -527,7 +527,7 @@ error:
 static void r871xu_dev_remove(struct usb_interface *pusb_intf)
 {
 	struct net_device *pnetdev = usb_get_intfdata(pusb_intf);
-	struct _adapter *padapter = (struct _adapter *)netdev_priv(pnetdev);
+	struct _adapter *padapter = netdev_priv(pnetdev);
 	struct usb_device *udev = interface_to_usbdev(pusb_intf);
 
 	if (padapter) {
-- 
1.7.3.1.g432b3.dirty

