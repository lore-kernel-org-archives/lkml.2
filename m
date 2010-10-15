Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0JOMSX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 08:18:23 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58183 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754292Ab0JOMSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 08:18:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=gCHrori+DLXC4ApJ5VyRqT6jOldev4ObaUWizRRfBx/mPdJHbpEb+Wivl48ATgzruw
         MJWCe3A4t0aggepmzJy9pswrnANW7mSPWlQ2s3xtWgJo7oR0H1rxMJBJIkyb1HfmHYlP
         iA3t3ukfYf/yc1dammrOOVRo8atv4rl7xSZTk=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH 7/7] staging:ft1000: Remove FT1000_INFO typedef usage.
Date: Fri, 15 Oct 2010 14:13:04 +0200
Message-Id: <1287144784-3359-7-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
References: <1287144784-3359-1-git-send-email-marek.belisko@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c   |   28 +++++++-------
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   16 ++++----
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   42 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |   14 +++---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    8 ++--
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |    6 +-
 6 files changed, 57 insertions(+), 57 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
index e2a9278..b76baf3 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_chdev.c
@@ -95,7 +95,7 @@ static struct file_operations ft1000fops =
 //---------------------------------------------------------------------------
 static int exec_mknod (void *pdata)
 {
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     char mjnum[4];
     char minornum[4];
     char temp[32];
@@ -137,13 +137,13 @@ static int exec_mknod (void *pdata)
 static int rm_mknod (void *pdata)
 {
 
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     //char *argv[4]={"rm", "-f", "/dev/FT1000", NULL};
     int retcode;
     char temp[32];
     char *argv[]={"rm", "-f", temp, NULL};
 
-    info = (PFT1000_INFO)pdata;
+	info = (struct ft1000_info *)pdata;
     DEBUG("ft1000_chdev:rm_mknod is called for device %s\n", info->DeviceName);
     sprintf(temp, "%s%s", "/dev/", info->DeviceName) ;
 
@@ -235,7 +235,7 @@ void ft1000_free_buffer (struct dpram_blk *pdpram_blk, struct list_head *plist)
 //---------------------------------------------------------------------------
 int ft1000_CreateDevice(struct ft1000_device *dev)
 {
-    PFT1000_INFO info = netdev_priv(dev->net);
+	struct ft1000_info *info = netdev_priv(dev->net);
     int result;
     int i;
     pid_t pid;
@@ -349,7 +349,7 @@ int ft1000_CreateDevice(struct ft1000_device *dev)
 //---------------------------------------------------------------------------
 void ft1000_DestroyDevice(struct net_device *dev)
 {
-    PFT1000_INFO info = netdev_priv(dev);
+	struct ft1000_info *info = netdev_priv(dev);
     int result = 0;
     pid_t pid;
 		int i;
@@ -412,7 +412,7 @@ void ft1000_DestroyDevice(struct net_device *dev)
 //---------------------------------------------------------------------------
 static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 {
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     int i,num;
 
     DEBUG("ft1000_ChOpen called\n");
@@ -423,8 +423,8 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
         DEBUG("pdevobj[%d]=%p\n", i, pdevobj[i]); //aelias [+] reason: down
 
     if ( pdevobj[num] != NULL )
-        //info = (PFT1000_INFO)(pdevobj[num]->net->priv);
-    	info = (FT1000_INFO *) netdev_priv (pdevobj[num]->net);
+        //info = (struct ft1000_info *)(pdevobj[num]->net->priv);
+		info = (struct ft1000_info *)netdev_priv(pdevobj[num]->net);
     else
     {
         DEBUG("ft1000_ChOpen: can not find device object %d\n", num);
@@ -480,7 +480,7 @@ static int ft1000_ChOpen (struct inode *Inode, struct file *File)
 static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
 {
     struct net_device *dev = file->private_data;
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     int i;
 
     //DEBUG("ft1000_ChPoll called\n");
@@ -489,7 +489,7 @@ static unsigned int ft1000_ChPoll(struct file *file, poll_table *wait)
         return (-EBADF);
     }
 
-	info = (FT1000_INFO *) netdev_priv (dev);
+	info = (struct ft1000_info *) netdev_priv(dev);
 
     // Search for matching file object
     for (i=0; i<MAX_NUM_APP; i++) {
@@ -531,7 +531,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 {
     void __user *argp = (void __user *)Argument;
     struct net_device *dev;
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     struct ft1000_device *ft1000dev;
     int result=0;
     int cmd;
@@ -561,7 +561,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
     //DEBUG("FT1000:ft1000_ChIoctl:Command = 0x%x Argument = 0x%8x\n", Command, (u32)Argument);
 
     dev = File->private_data;
-	info = (FT1000_INFO *) netdev_priv (dev);
+	info = (struct ft1000_info *) netdev_priv(dev);
     ft1000dev = info->pFt1000Dev;
     cmd = _IOC_NR(Command);
     //DEBUG("FT1000:ft1000_ChIoctl:cmd = 0x%x\n", cmd);
@@ -893,7 +893,7 @@ static long ft1000_ChIoctl (struct file *File, unsigned int Command,
 //---------------------------------------------------------------------------
 static int ft1000_ChRelease (struct inode *Inode, struct file *File)
 {
-    PFT1000_INFO info;
+	struct ft1000_info *info;
     struct net_device *dev;
     int i;
     struct dpram_blk *pdpram_blk;
@@ -901,7 +901,7 @@ static int ft1000_ChRelease (struct inode *Inode, struct file *File)
     DEBUG("ft1000_ChRelease called\n");
 
     dev = File->private_data;
-	info = (FT1000_INFO *) netdev_priv (dev);
+	info = (struct ft1000_info *) netdev_priv(dev);
 
     if (ft1000_flarion_cnt == 0) {
         info->appcnt--;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index ee32f40..4dd456f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -205,7 +205,7 @@ static USHORT get_handshake(struct ft1000_device *ft1000dev, USHORT expected_val
    USHORT            handshake;
    int               loopcnt;
    ULONG             status=0;
-   PFT1000_INFO       pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    loopcnt = 0;
    while (loopcnt < 100)
@@ -294,7 +294,7 @@ static USHORT get_handshake_usb(struct ft1000_device *ft1000dev, USHORT expected
    USHORT            temp;
    ULONG             status=0;
 
-   PFT1000_INFO      pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    loopcnt = 0;
    handshake = 0;
    while (loopcnt < 100)
@@ -352,7 +352,7 @@ static USHORT get_request_type(struct ft1000_device *ft1000dev)
    ULONG    status;
    USHORT   tempword;
    ULONG    tempx;
-   PFT1000_INFO pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    if ( pft1000info->bootmode == 1)
    {
@@ -380,7 +380,7 @@ static USHORT get_request_type_usb(struct ft1000_device *ft1000dev)
    ULONG    status;
    USHORT   tempword;
    ULONG    tempx;
-   PFT1000_INFO pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
    if ( pft1000info->bootmode == 1)
    {
        status = fix_ft1000_read_dpram32 (ft1000dev, DWNLD_MAG1_TYPE_LOC, (PUCHAR)&tempx);
@@ -423,7 +423,7 @@ static long get_request_value(struct ft1000_device *ft1000dev)
    ULONG     value;
    USHORT   tempword;
    ULONG    status;
-   PFT1000_INFO pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
 
        if ( pft1000info->bootmode == 1)
@@ -452,7 +452,7 @@ static long get_request_value_usb(struct ft1000_device *ft1000dev)
    ULONG     value;
    USHORT   tempword;
    ULONG    status;
-   PFT1000_INFO pft1000info = netdev_priv(ft1000dev->net);
+   struct ft1000_info * pft1000info = netdev_priv(ft1000dev->net);
 
        if (pft1000info->usbboot == 2) {
           value = pft1000info->tempbuf[4];
@@ -556,7 +556,7 @@ static ULONG write_blk (struct ft1000_device *ft1000dev, USHORT **pUsFile, UCHAR
    USHORT tempword;
    USHORT tempbuffer[64];
    USHORT resultbuffer[64];
-   PFT1000_INFO pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    //DEBUG("FT1000:download:start word_length = %d\n",(int)word_length);
    dpram = (USHORT)DWNLD_MAG1_PS_HDR_LOC;
@@ -801,7 +801,7 @@ u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart, ULONG  FileLe
    USHORT                  dpram = 0;
    PUCHAR                  pbuffer;
 	struct prov_record *pprov_record;
-   FT1000_INFO *pft1000info = netdev_priv(ft1000dev->net);
+	struct ft1000_info *pft1000info = netdev_priv(ft1000dev->net);
 
    DEBUG("Entered   scram_dnldr...\n");
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index f8ca086..4c77d2c 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -32,7 +32,7 @@
 //#define JDEBUG
 
 static int ft1000_reset(struct net_device *ft1000dev);
-static int ft1000_submit_rx_urb(PFT1000_INFO info);
+static int ft1000_submit_rx_urb(struct ft1000_info *info);
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ft1000_open (struct net_device *dev);
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
@@ -625,7 +625,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
     USHORT tempword;
     ULONG templong;
 
-    PFT1000_INFO pft1000info;
+	struct ft1000_info *pft1000info;
 
     pft1000info = netdev_priv(ft1000dev->net);
 
@@ -679,7 +679,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static void ft1000_reset_asic (struct net_device *dev)
 {
-    FT1000_INFO *info = netdev_priv(dev);
+    struct ft1000_info *info = netdev_priv(dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
     u16 tempword;
 
@@ -719,7 +719,7 @@ static void ft1000_reset_asic (struct net_device *dev)
 //---------------------------------------------------------------------------
 static int ft1000_reset_card (struct net_device *dev)
 {
-    FT1000_INFO *info = netdev_priv(dev);
+	struct ft1000_info *info = netdev_priv(dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
     u16 tempword;
 	struct prov_record *ptr;
@@ -797,7 +797,7 @@ static const struct net_device_ops ftnet_ops =
 u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 {
     struct net_device *netdev;
-    FT1000_INFO *pInfo = NULL;
+	struct ft1000_info *pInfo = NULL;
     struct dpram_blk *pdpram_blk;
 	int i, ret_val;
 	struct list_head *cur, *tmp;
@@ -808,18 +808,18 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     DEBUG("Enter init_ft1000_netdev...\n");
 
 
-    netdev = alloc_etherdev( sizeof(FT1000_INFO));
+	netdev = alloc_etherdev(sizeof(struct ft1000_info));
     if (!netdev )
     {
         DEBUG("init_ft1000_netdev: can not allocate network device\n");
 	return -ENOMEM;
     }
 
-	pInfo = (FT1000_INFO *) netdev_priv (netdev);
+	pInfo = (struct ft1000_info *) netdev_priv(netdev);
 
     //DEBUG("init_ft1000_netdev: gFt1000Info=%x, netdev=%x, ft1000dev=%x\n", gFt1000Info, netdev, ft1000dev);
 
-    memset (pInfo, 0, sizeof(FT1000_INFO));
+	memset(pInfo, 0, sizeof(struct ft1000_info));
 
     dev_alloc_name(netdev, netdev->name);
 
@@ -961,7 +961,7 @@ err_net:
 int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *intf)
 {
     struct net_device *netdev;
-    FT1000_INFO *pInfo;
+	struct ft1000_info *pInfo;
 	int rc;
 
     netdev = ft1000dev->net;
@@ -1171,7 +1171,7 @@ static inline u16 ft1000_read_fifo_len (struct net_device *dev)
     u16 temp;
     u16 ret;
 
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
 //    DEBUG("ft1000_read_fifo_len: enter ft1000dev %x\n", ft1000dev);			//aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct ft1000_device *???
     DEBUG("ft1000_read_fifo_len: enter ft1000dev %p\n", ft1000dev);	//aelias [+] reason: up
@@ -1217,7 +1217,7 @@ static inline u16 ft1000_read_fifo_len (struct net_device *dev)
 //---------------------------------------------------------------------------
 static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
 {
-    FT1000_INFO *pInfo = netdev_priv(netdev);
+	struct ft1000_info *pInfo = netdev_priv(netdev);
     struct ft1000_device *pFt1000Dev = pInfo->pFt1000Dev;
 
 
@@ -1322,7 +1322,7 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
 //---------------------------------------------------------------------------
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
-    FT1000_INFO *pInfo = netdev_priv(dev);
+	struct ft1000_info *pInfo = netdev_priv(dev);
     struct ft1000_device *pFt1000Dev= pInfo->pFt1000Dev;
     u8 *pdata;
     int maxlen, pipe;
@@ -1398,7 +1398,7 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 //---------------------------------------------------------------------------
 static int ft1000_copy_up_pkt (struct urb *urb)
 {
-    PFT1000_INFO info = urb->context;
+	struct ft1000_info *info = urb->context;
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
     struct net_device *net = ft1000dev->net;
 
@@ -1512,7 +1512,7 @@ static int ft1000_copy_up_pkt (struct urb *urb)
 //              SUCCESS
 //
 //---------------------------------------------------------------------------
-static int ft1000_submit_rx_urb(PFT1000_INFO info)
+static int ft1000_submit_rx_urb(struct ft1000_info *info)
 {
     int result;
     struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
@@ -1562,7 +1562,7 @@ static int ft1000_submit_rx_urb(PFT1000_INFO info)
 //---------------------------------------------------------------------------
 static int ft1000_open (struct net_device *dev)
 {
-	FT1000_INFO *pInfo = (FT1000_INFO *)netdev_priv(dev);
+	struct ft1000_info *pInfo = (struct ft1000_info *)netdev_priv(dev);
     struct timeval tv; //mbelian
 
     DEBUG("ft1000_open is called for card %d\n", pInfo->CardNumber);
@@ -1601,7 +1601,7 @@ static int ft1000_open (struct net_device *dev)
 //---------------------------------------------------------------------------
 int ft1000_close(struct net_device *net)
 {
-	FT1000_INFO *pInfo = (FT1000_INFO *) netdev_priv (net);
+	struct ft1000_info *pInfo = (struct ft1000_info *) netdev_priv(net);
     struct ft1000_device *ft1000dev = pInfo->pFt1000Dev;
 
     //DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
@@ -1624,7 +1624,7 @@ int ft1000_close(struct net_device *net)
 
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
 {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev);
 
 	return &(info->stats); //mbelian
 }
@@ -1650,7 +1650,7 @@ Jim
 static int ft1000_chkcard (struct ft1000_device *dev) {
     u16 tempword;
     u16 status;
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
 
     if (info->fCondResetPend)
     {
@@ -1750,7 +1750,7 @@ static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int
 static int ft1000_dsp_prov(void *arg)
 {
     struct ft1000_device *dev = (struct ft1000_device *)arg;
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
     u16 tempword;
     u16 len;
     u16 i=0;
@@ -1833,7 +1833,7 @@ static int ft1000_dsp_prov(void *arg)
 
 
 static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
     u16 msgtype;
     u16 tempword;
 	struct media_msg *pmediamsg;
@@ -2116,7 +2116,7 @@ out:
 int ft1000_poll(void* dev_id) {
 
     struct ft1000_device *dev = (struct ft1000_device *)dev_id;
-	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
+	struct ft1000_info *info = (struct ft1000_info *) netdev_priv(dev->net);
 
     u16 tempword;
     u16 status;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index d1ef396..36cdd58 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -52,7 +52,7 @@ ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
   unsigned short ledStat;
   unsigned short conStat;
 
-  FT1000_INFO *info;
+	struct ft1000_info *info;
 
   char *status[] = { "Idle (Disconnect)", "Searching", "Active (Connected)",
     "Waiting for L2", "Sleep", "No Coverage", "", ""
@@ -65,7 +65,7 @@ ft1000ReadProc (char *page, char **start, off_t off, int count, int *eof,
   time_t delta;
 
   dev = (struct net_device *) data;
-  info = (FT1000_INFO *) netdev_priv (dev);
+	info = (struct ft1000_info *) netdev_priv(dev);
 
   if (off > 0)
     {
@@ -169,10 +169,10 @@ static int
 ft1000NotifyProc (struct notifier_block *this, unsigned long event, void *ptr)
 {
   struct net_device *dev = ptr;
-  FT1000_INFO *info;
+	struct ft1000_info *info;
   struct proc_dir_entry *ft1000_proc_file;
 
-  info = (FT1000_INFO *) netdev_priv (dev);
+info = (struct ft1000_info *) netdev_priv(dev);
 
 
   switch (event)
@@ -196,9 +196,9 @@ static struct notifier_block ft1000_netdev_notifier = {
 void
 ft1000InitProc (struct net_device *dev)
 {
-  FT1000_INFO *info;
+	struct ft1000_info *info;
   struct proc_dir_entry *ft1000_proc_file;
-  info = (FT1000_INFO *) netdev_priv (dev);
+	info = (struct ft1000_info *) netdev_priv(dev);
 
 
   info->ft1000_proc_dir = proc_mkdir (FT1000_PROC_DIR, FTNET_PROC);
@@ -222,7 +222,7 @@ ft1000InitProc (struct net_device *dev)
 }
 
 void
-ft1000CleanupProc (FT1000_INFO * info)
+ft1000CleanupProc(struct ft1000_info *info)
 {
   remove_proc_entry (info->netdevname, info->ft1000_proc_dir);
   remove_proc_entry (FT1000_PROC_DIR, FTNET_PROC);
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index 5fae954..28f55b2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -64,7 +64,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	int i, ret = 0, size;
 
 	struct ft1000_device *ft1000dev;
-	FT1000_INFO *pft1000info;
+	struct ft1000_info *pft1000info;
 	const struct firmware *dsp_fw;
 
 	ft1000dev = kmalloc(sizeof(struct ft1000_device), GFP_KERNEL);
@@ -164,7 +164,7 @@ static int ft1000_probe(struct usb_interface *interface,
 	if (ret)
 		goto err_load;
 
-	pft1000info = (FT1000_INFO *) netdev_priv(ft1000dev->net);
+	pft1000info = (struct ft1000_info *) netdev_priv(ft1000dev->net);
 
 	DEBUG("In probe: pft1000info=%p\n", pft1000info);
 	ret = dsp_reload(ft1000dev);
@@ -210,11 +210,11 @@ err_fw:
 
 static void ft1000_disconnect(struct usb_interface *interface)
 {
-	FT1000_INFO *pft1000info;
+	struct ft1000_info *pft1000info;
 
 	DEBUG("ft1000_disconnect is called\n");
 
-	pft1000info = (PFT1000_INFO) usb_get_intfdata(interface);
+	pft1000info = (struct ft1000_info *) usb_get_intfdata(interface);
 	DEBUG("In disconnect pft1000info=%p\n", pft1000info);
 
 	if (pft1000info) {
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index e3ecbea..37d9e46 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -486,7 +486,7 @@ struct ft1000_device
 //	struct net_device_stats stats; //mbelian
 } __attribute__ ((packed));
 
-typedef struct _FT1000_INFO {
+struct ft1000_info {
     struct ft1000_device *pFt1000Dev;
     struct net_device_stats stats;
 
@@ -558,7 +558,7 @@ typedef struct _FT1000_INFO {
 	unsigned short tempbuf[32];
 	char netdevname[IFNAMSIZ];
 	struct proc_dir_entry *ft1000_proc_dir; //mbelian
-} FT1000_INFO, *PFT1000_INFO;
+};
 
 
 struct dpram_blk {
@@ -601,7 +601,7 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
 int ft1000_poll(void* dev_id);
 
 void ft1000InitProc(struct net_device *dev);
-void ft1000CleanupProc(FT1000_INFO *info);
+void ft1000CleanupProc(struct ft1000_info *info);
 
 
 
-- 
1.7.1

