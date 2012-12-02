Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754023Ab2LBRw0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 12:52:26 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:55293 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753077Ab2LBRwZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 12:52:25 -0500
To: "Greg Kroah-Hartman" <greg@kroah.com>
Subject: [PATCH] staging: ft1000: rename struct ft1000_device to ft1000_usb
Cc: Marek Belisko <marek.belisko@gmail.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Content-Disposition: inline
From: Ondrej Zary <linux@rainbow-software.org>
Date: Sun, 2 Dec 2012 18:51:40 +0100
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201212021851.41698.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After unifying struct ft1000_info, struct ft1000_device is now wrong name.
Rename it to ft1000_usb to match its semantics.

Signed-off-by: Ondrej Zary <linux@rainbow-software.org>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c   |   12 ++--
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   40 +++++-----
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c      |   78 ++++++++++----------
 drivers/staging/ft1000/ft1000-usb/ft1000_proc.c    |    2 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c     |    6 +-
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.h     |   30 ++++----
 6 files changed, 84 insertions(+), 84 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
index fb197ab..297389e 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_debug.c
@@ -137,7 +137,7 @@ void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist)
 // Notes:       Only called by init_module().
 //
 //---------------------------------------------------------------------------
-int ft1000_create_dev(struct ft1000_device *dev)
+int ft1000_create_dev(struct ft1000_usb *dev)
 {
     int result;
     int i;
@@ -227,7 +227,7 @@ fail:
 void ft1000_destroy_dev(struct net_device *netdev)
 {
 	struct ft1000_info *info = netdev_priv(netdev);
-	struct ft1000_device *dev = info->priv;
+	struct ft1000_usb *dev = info->priv;
 		int i;
 	struct dpram_blk *pdpram_blk;
 	struct dpram_blk *ptr;
@@ -292,7 +292,7 @@ void ft1000_destroy_dev(struct net_device *netdev)
 static int ft1000_open (struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
-	struct ft1000_device *dev = (struct ft1000_device *)inode->i_private;
+	struct ft1000_usb *dev = (struct ft1000_usb *)inode->i_private;
     int i,num;
 
     DEBUG("%s called\n", __func__);
@@ -349,7 +349,7 @@ static unsigned int ft1000_poll_dev(struct file *file, poll_table *wait)
 {
     struct net_device *netdev = file->private_data;
 	struct ft1000_info *info = netdev_priv(netdev);
-	struct ft1000_device *dev = info->priv;
+	struct ft1000_usb *dev = info->priv;
     int i;
 
     //DEBUG("ft1000_poll_dev called\n");
@@ -398,7 +398,7 @@ static long ft1000_ioctl (struct file *file, unsigned int command,
 {
     void __user *argp = (void __user *)argument;
 	struct ft1000_info *info;
-    struct ft1000_device *ft1000dev;
+    struct ft1000_usb *ft1000dev;
     int result=0;
     int cmd;
     int i;
@@ -740,7 +740,7 @@ static int ft1000_release (struct inode *inode, struct file *file)
 {
 	struct ft1000_info *info;
     struct net_device *dev;
-    struct ft1000_device *ft1000dev;
+    struct ft1000_usb *ft1000dev;
     int i;
 	struct dpram_blk *pdpram_blk;
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index cc00e94..5190c8a 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -114,7 +114,7 @@ struct dsp_image_info {
 //---------------------------------------------------------------------------
 // Function:    check_usb_db
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //
 // Returns:     0 - success
 //
@@ -123,7 +123,7 @@ struct dsp_image_info {
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u32 check_usb_db (struct ft1000_device *ft1000dev)
+static u32 check_usb_db (struct ft1000_usb *ft1000dev)
 {
 	int loopcnt;
 	u16 temp;
@@ -172,7 +172,7 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 // Function:    get_handshake
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //              u16 expected_value - the handshake value expected
 //
 // Returns:     handshakevalue - success
@@ -183,7 +183,7 @@ static u32 check_usb_db (struct ft1000_device *ft1000dev)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
+static u16 get_handshake(struct ft1000_usb *ft1000dev, u16 expected_value)
 {
 	u16 handshake;
 	int loopcnt;
@@ -232,7 +232,7 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 //---------------------------------------------------------------------------
 // Function:    put_handshake
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //              u16 handshake_value - handshake to be written
 //
 // Returns:     none
@@ -243,7 +243,7 @@ static u16 get_handshake(struct ft1000_device *ft1000dev, u16 expected_value)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
+static void put_handshake(struct ft1000_usb *ft1000dev,u16 handshake_value)
 {
 	u32 tempx;
 	u16 tempword;
@@ -262,7 +262,7 @@ static void put_handshake(struct ft1000_device *ft1000dev,u16 handshake_value)
 					FT1000_REG_DOORBELL);
 }
 
-static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value)
+static u16 get_handshake_usb(struct ft1000_usb *ft1000dev, u16 expected_value)
 {
 	u16 handshake;
 	int loopcnt;
@@ -309,7 +309,7 @@ static u16 get_handshake_usb(struct ft1000_device *ft1000dev, u16 expected_value
 	return HANDSHAKE_TIMEOUT_VALUE;
 }
 
-static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_value)
+static void put_handshake_usb(struct ft1000_usb *ft1000dev,u16 handshake_value)
 {
 	int i;
 
@@ -319,7 +319,7 @@ static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_valu
 //---------------------------------------------------------------------------
 // Function:    get_request_type
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //
 // Returns:     request type - success
 //
@@ -328,7 +328,7 @@ static void put_handshake_usb(struct ft1000_device *ft1000dev,u16 handshake_valu
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u16 get_request_type(struct ft1000_device *ft1000dev)
+static u16 get_request_type(struct ft1000_usb *ft1000dev)
 {
 	u16 request_type;
 	u32 status;
@@ -351,7 +351,7 @@ static u16 get_request_type(struct ft1000_device *ft1000dev)
 	return request_type;
 }
 
-static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
+static u16 get_request_type_usb(struct ft1000_usb *ft1000dev)
 {
 	u16 request_type;
 	u32 status;
@@ -383,7 +383,7 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 // Function:    get_request_value
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //
 // Returns:     request value - success
 //
@@ -392,7 +392,7 @@ static u16 get_request_type_usb(struct ft1000_device *ft1000dev)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static long get_request_value(struct ft1000_device *ft1000dev)
+static long get_request_value(struct ft1000_usb *ft1000dev)
 {
 	u32 value;
 	u16 tempword;
@@ -419,7 +419,7 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 // Function:    put_request_value
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //              long lvalue - value to be put into DPRAM location DWNLD_MAG1_SIZE_LOC
 //
 // Returns:     none
@@ -429,7 +429,7 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
+static void put_request_value(struct ft1000_usb *ft1000dev, long lvalue)
 {
 	u32    tempx;
 	u32    status;
@@ -480,7 +480,7 @@ static int check_buffers(u16 *buff_w, u16 *buff_r, int len, int offset)
 //---------------------------------------------------------------------------
 // Function:    write_blk
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //              u16 **pUsFile - DSP image file pointer in u16
 //              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - length of the buffer to be written
@@ -494,7 +494,7 @@ static int check_buffers(u16 *buff_w, u16 *buff_r, int len, int offset)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u32 write_blk (struct ft1000_device *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
+static u32 write_blk (struct ft1000_usb *ft1000dev, u16 **pUsFile, u8 **pUcFile, long word_length)
 {
    u32 Status = STATUS_SUCCESS;
    u16 dpram;
@@ -619,7 +619,7 @@ static void usb_dnld_complete (struct urb *urb)
 //---------------------------------------------------------------------------
 // Function:    write_blk_fifo
 //
-// Parameters:  struct ft1000_device  - device structure
+// Parameters:  struct ft1000_usb  - device structure
 //              u16 **pUsFile - DSP image file pointer in u16
 //              u8  **pUcFile - DSP image file pointer in u8
 //              long   word_length - length of the buffer to be written
@@ -633,7 +633,7 @@ static void usb_dnld_complete (struct urb *urb)
 // Notes:
 //
 //---------------------------------------------------------------------------
-static u32 write_blk_fifo(struct ft1000_device *ft1000dev, u16 **pUsFile,
+static u32 write_blk_fifo(struct ft1000_usb *ft1000dev, u16 **pUsFile,
 			  u8 **pUcFile, long word_length)
 {
 	u32 Status = STATUS_SUCCESS;
@@ -676,7 +676,7 @@ static u32 write_blk_fifo(struct ft1000_device *ft1000dev, u16 **pUsFile,
 //  Returns:    status                  - return code
 //---------------------------------------------------------------------------
 
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
+u16 scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 		u32 FileLength)
 {
 	u16 status = STATUS_SUCCESS;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 6e2bbed..fe1e530 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -34,7 +34,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info);
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ft1000_open (struct net_device *dev);
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
-static int ft1000_chkcard (struct ft1000_device *dev);
+static int ft1000_chkcard (struct ft1000_usb *dev);
 
 static u8 tempbuffer[1600];
 
@@ -43,7 +43,7 @@ static u8 tempbuffer[1600];
 //---------------------------------------------------------------------------
 // Function:    ft1000_control
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              pipe - usb control message pipe
 //              request - control request
 //              requesttype - control message request type
@@ -61,7 +61,7 @@ static u8 tempbuffer[1600];
 // Notes:
 //
 //---------------------------------------------------------------------------
-static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
+static int ft1000_control(struct ft1000_usb *ft1000dev, unsigned int pipe,
 			  u8 request, u8 requesttype, u16 value, u16 index,
 			  void *data, u16 size, int timeout)
 {
@@ -84,7 +84,7 @@ static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
 //---------------------------------------------------------------------------
 // Function:    ft1000_read_register
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              Data - data buffer to hold the value read
 //              nRegIndex - register index
 //
@@ -97,7 +97,7 @@ static int ft1000_control(struct ft1000_device *ft1000dev, unsigned int pipe,
 //
 //---------------------------------------------------------------------------
 
-int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data,
+int ft1000_read_register(struct ft1000_usb *ft1000dev, u16* Data,
 			 u16 nRegIndx)
 {
 	int ret = STATUS_SUCCESS;
@@ -118,7 +118,7 @@ int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data,
 //---------------------------------------------------------------------------
 // Function:    ft1000_write_register
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              value - value to write into a register
 //              nRegIndex - register index
 //
@@ -130,7 +130,7 @@ int ft1000_read_register(struct ft1000_device *ft1000dev, u16* Data,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value,
+int ft1000_write_register(struct ft1000_usb *ft1000dev, u16 value,
 			  u16 nRegIndx)
 {
 	int ret = STATUS_SUCCESS;
@@ -151,7 +151,7 @@ int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value,
 //---------------------------------------------------------------------------
 // Function:    ft1000_read_dpram32
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to read
 //              buffer - data buffer to hold the data read
 //              cnt - number of byte read from DPRAM
@@ -165,7 +165,7 @@ int ft1000_write_register(struct ft1000_device *ft1000dev, u16 value,
 //
 //---------------------------------------------------------------------------
 
-int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+int ft1000_read_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer,
 			u16 cnt)
 {
 	int ret = STATUS_SUCCESS;
@@ -186,7 +186,7 @@ int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 //---------------------------------------------------------------------------
 // Function:    ft1000_write_dpram32
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to write the data
 //              buffer - data buffer to write into DPRAM
 //              cnt - number of bytes to write
@@ -199,7 +199,7 @@ int ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+int ft1000_write_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer,
 			 u16 cnt)
 {
 	int ret = STATUS_SUCCESS;
@@ -223,7 +223,7 @@ int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 //---------------------------------------------------------------------------
 // Function:    ft1000_read_dpram16
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to read
 //              buffer - data buffer to hold the data read
 //              hightlow - high or low 16 bit word
@@ -236,7 +236,7 @@ int ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
+int ft1000_read_dpram16(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer,
 			u8 highlow)
 {
 	int ret = STATUS_SUCCESS;
@@ -263,7 +263,7 @@ int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 //---------------------------------------------------------------------------
 // Function:    ft1000_write_dpram16
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to write the data
 //              value - 16bits value to write
 //              hightlow - high or low 16 bit word
@@ -276,7 +276,7 @@ int ft1000_read_dpram16(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u8 highlow)
+int ft1000_write_dpram16(struct ft1000_usb *ft1000dev, u16 indx, u16 value, u8 highlow)
 {
 	int ret = STATUS_SUCCESS;
 	u8 request;
@@ -302,7 +302,7 @@ int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u
 //---------------------------------------------------------------------------
 // Function:    fix_ft1000_read_dpram32
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to read
 //              buffer - data buffer to hold the data read
 //
@@ -315,7 +315,7 @@ int ft1000_write_dpram16(struct ft1000_device *ft1000dev, u16 indx, u16 value, u
 // Notes:
 //
 //---------------------------------------------------------------------------
-int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx,
+int fix_ft1000_read_dpram32(struct ft1000_usb *ft1000dev, u16 indx,
 			    u8 *buffer)
 {
 	u8 buf[16];
@@ -346,7 +346,7 @@ int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx,
 //---------------------------------------------------------------------------
 // Function:    fix_ft1000_write_dpram32
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              indx - starting address to write
 //              buffer - data buffer to write
 //
@@ -359,7 +359,7 @@ int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev, u16 indx,
 // Notes:
 //
 //---------------------------------------------------------------------------
-int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buffer)
+int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev, u16 indx, u8 *buffer)
 {
 	u16 pos1;
 	u16 pos2;
@@ -426,7 +426,7 @@ int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev, u16 indx, u8 *buff
 //
 //  Returns:    None
 //-----------------------------------------------------------------------
-static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
+static void card_reset_dsp(struct ft1000_usb *ft1000dev, bool value)
 {
 	u16 status = STATUS_SUCCESS;
 	u16 tempword;
@@ -465,7 +465,7 @@ static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 //---------------------------------------------------------------------------
 // Function:    card_send_command
 //
-// Parameters:  ft1000_device  - device structure
+// Parameters:  ft1000_usb  - device structure
 //              ptempbuffer - command buffer
 //              size - command buffer size
 //
@@ -477,7 +477,7 @@ static void card_reset_dsp(struct ft1000_device *ft1000dev, bool value)
 // Notes:
 //
 //---------------------------------------------------------------------------
-void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
+void card_send_command(struct ft1000_usb *ft1000dev, void *ptempbuffer,
 		       int size)
 {
 	unsigned short temp;
@@ -524,7 +524,7 @@ void card_send_command(struct ft1000_device *ft1000dev, void *ptempbuffer,
 //
 //  Returns:    None
 //-----------------------------------------------------------------------
-int dsp_reload(struct ft1000_device *ft1000dev)
+int dsp_reload(struct ft1000_usb *ft1000dev)
 {
 	u16 status;
 	u16 tempword;
@@ -588,7 +588,7 @@ int dsp_reload(struct ft1000_device *ft1000dev)
 static void ft1000_reset_asic(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-	struct ft1000_device *ft1000dev = info->priv;
+	struct ft1000_usb *ft1000dev = info->priv;
 	u16 tempword;
 
 	DEBUG("ft1000_hw:ft1000_reset_asic called\n");
@@ -627,7 +627,7 @@ static void ft1000_reset_asic(struct net_device *dev)
 static int ft1000_reset_card(struct net_device *dev)
 {
 	struct ft1000_info *info = netdev_priv(dev);
-	struct ft1000_device *ft1000dev = info->priv;
+	struct ft1000_usb *ft1000dev = info->priv;
 	u16 tempword;
 	struct prov_record *ptr;
 
@@ -694,7 +694,7 @@ static const struct net_device_ops ftnet_ops =
 // Notes:
 //
 //---------------------------------------------------------------------------
-int init_ft1000_netdev(struct ft1000_device *ft1000dev)
+int init_ft1000_netdev(struct ft1000_usb *ft1000dev)
 {
 	struct net_device *netdev;
 	struct ft1000_info *pInfo = NULL;
@@ -822,7 +822,7 @@ err_net:
 // Notes:
 //
 //---------------------------------------------------------------------------
-int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
+int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 		      struct usb_interface *intf)
 {
 	struct net_device *netdev;
@@ -876,7 +876,7 @@ int ft1000_reset(void *dev)
 static void ft1000_usb_transmit_complete(struct urb *urb)
 {
 
-	struct ft1000_device *ft1000dev = urb->context;
+	struct ft1000_usb *ft1000dev = urb->context;
 
 	if (urb->status)
 		pr_err("%s: TX status %d\n", ft1000dev->net->name, urb->status);
@@ -902,7 +902,7 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
 static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 {
 	struct ft1000_info *pInfo = netdev_priv(netdev);
-	struct ft1000_device *pFt1000Dev = pInfo->priv;
+	struct ft1000_usb *pFt1000Dev = pInfo->priv;
 
 	int count, ret;
 	u8 *t;
@@ -981,7 +981,7 @@ static int ft1000_copy_down_pkt(struct net_device *netdev, u8 * packet, u16 len)
 static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-	struct ft1000_device *pFt1000Dev = pInfo->priv;
+	struct ft1000_usb *pFt1000Dev = pInfo->priv;
 	u8 *pdata;
 	int maxlen, pipe;
 
@@ -1039,7 +1039,7 @@ err:
 static int ft1000_copy_up_pkt(struct urb *urb)
 {
 	struct ft1000_info *info = urb->context;
-	struct ft1000_device *ft1000dev = info->priv;
+	struct ft1000_usb *ft1000dev = info->priv;
 	struct net_device *net = ft1000dev->net;
 
 	u16 tempword;
@@ -1134,7 +1134,7 @@ static int ft1000_copy_up_pkt(struct urb *urb)
 static int ft1000_submit_rx_urb(struct ft1000_info *info)
 {
 	int result;
-	struct ft1000_device *pFt1000Dev = info->priv;
+	struct ft1000_usb *pFt1000Dev = info->priv;
 
 	if (pFt1000Dev->status & FT1000_STATUS_CLOSING) {
 		DEBUG("network driver is closed, return\n");
@@ -1177,7 +1177,7 @@ static int ft1000_submit_rx_urb(struct ft1000_info *info)
 static int ft1000_open(struct net_device *dev)
 {
 	struct ft1000_info *pInfo = netdev_priv(dev);
-	struct ft1000_device *pFt1000Dev = pInfo->priv;
+	struct ft1000_usb *pFt1000Dev = pInfo->priv;
 	struct timeval tv;
 
 	DEBUG("ft1000_open is called for card %d\n", pFt1000Dev->CardNumber);
@@ -1214,7 +1214,7 @@ static int ft1000_open(struct net_device *dev)
 int ft1000_close(struct net_device *net)
 {
 	struct ft1000_info *pInfo = netdev_priv(net);
-	struct ft1000_device *ft1000dev = pInfo->priv;
+	struct ft1000_usb *ft1000dev = pInfo->priv;
 
 	ft1000dev->status |= FT1000_STATUS_CLOSING;
 
@@ -1248,7 +1248,7 @@ static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
 //              TRUE  (device is present)
 //
 //---------------------------------------------------------------------------
-static int ft1000_chkcard(struct ft1000_device *dev)
+static int ft1000_chkcard(struct ft1000_usb *dev)
 {
 	u16 tempword;
 	u16 status;
@@ -1293,7 +1293,7 @@ static int ft1000_chkcard(struct ft1000_device *dev)
 //          = 1 (successful)
 //
 //---------------------------------------------------------------------------
-static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
+static bool ft1000_receive_cmd(struct ft1000_usb *dev, u16 *pbuffer,
 			       int maxsz, u16 *pnxtph)
 {
 	u16 size, ret;
@@ -1360,7 +1360,7 @@ static bool ft1000_receive_cmd(struct ft1000_device *dev, u16 *pbuffer,
 
 static int ft1000_dsp_prov(void *arg)
 {
-	struct ft1000_device *dev = (struct ft1000_device *)arg;
+	struct ft1000_usb *dev = (struct ft1000_usb *)arg;
 	struct ft1000_info *info = netdev_priv(dev->net);
 	u16 tempword;
 	u16 len;
@@ -1447,7 +1447,7 @@ static int ft1000_dsp_prov(void *arg)
 	return STATUS_SUCCESS;
 }
 
-static int ft1000_proc_drvmsg(struct ft1000_device *dev, u16 size)
+static int ft1000_proc_drvmsg(struct ft1000_usb *dev, u16 size)
 {
 	struct ft1000_info *info = netdev_priv(dev->net);
 	u16 msgtype;
@@ -1753,7 +1753,7 @@ out:
 
 int ft1000_poll(void* dev_id)
 {
-    struct ft1000_device *dev = (struct ft1000_device *)dev_id;
+    struct ft1000_usb *dev = (struct ft1000_usb *)dev_id;
 	struct ft1000_info *info = netdev_priv(dev->net);
 
     u16 tempword;
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
index c290b66..6590047 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_proc.c
@@ -51,7 +51,7 @@
 #define FTNET_PROC init_net.proc_net
 
 
-int ft1000_read_dpram16 (struct ft1000_device *ft1000dev, u16 indx,
+int ft1000_read_dpram16 (struct ft1000_usb *ft1000dev, u16 indx,
 			 u8 *buffer, u8 highlow);
 
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index e97fbc9..1bf3792 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -63,11 +63,11 @@ static int ft1000_probe(struct usb_interface *interface,
 	unsigned numaltsetting;
 	int i, ret = 0, size;
 
-	struct ft1000_device *ft1000dev;
+	struct ft1000_usb *ft1000dev;
 	struct ft1000_info *pft1000info = NULL;
 	const struct firmware *dsp_fw;
 
-	ft1000dev = kzalloc(sizeof(struct ft1000_device), GFP_KERNEL);
+	ft1000dev = kzalloc(sizeof(struct ft1000_usb), GFP_KERNEL);
 
 	if (!ft1000dev) {
 		pr_err("out of memory allocating device structure\n");
@@ -219,7 +219,7 @@ err_fw:
 static void ft1000_disconnect(struct usb_interface *interface)
 {
 	struct ft1000_info *pft1000info;
-	struct ft1000_device *ft1000dev;
+	struct ft1000_usb *ft1000dev;
 
 	DEBUG("ft1000_disconnect is called\n");
 
diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
index 152fe84..bd1da1f 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.h
@@ -62,7 +62,7 @@ struct ft1000_debug_dirs {
 	int int_number;
 };
 
-struct ft1000_device {
+struct ft1000_usb {
 	struct usb_device *dev;
 	struct net_device *net;
 
@@ -103,21 +103,21 @@ struct dpram_blk {
 	u16 *pbuffer;
 } __packed;
 
-int ft1000_read_register(struct ft1000_device *ft1000dev,
+int ft1000_read_register(struct ft1000_usb *ft1000dev,
 			u16 *Data, u16 nRegIndx);
-int ft1000_write_register(struct ft1000_device *ft1000dev,
+int ft1000_write_register(struct ft1000_usb *ft1000dev,
 			u16 value, u16 nRegIndx);
-int ft1000_read_dpram32(struct ft1000_device *ft1000dev,
+int ft1000_read_dpram32(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer, u16 cnt);
-int ft1000_write_dpram32(struct ft1000_device *ft1000dev,
+int ft1000_write_dpram32(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer, u16 cnt);
-int ft1000_read_dpram16(struct ft1000_device *ft1000dev,
+int ft1000_read_dpram16(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer, u8 highlow);
-int ft1000_write_dpram16(struct ft1000_device *ft1000dev,
+int ft1000_write_dpram16(struct ft1000_usb *ft1000dev,
 			u16 indx, u16 value, u8 highlow);
-int fix_ft1000_read_dpram32(struct ft1000_device *ft1000dev,
+int fix_ft1000_read_dpram32(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer);
-int fix_ft1000_write_dpram32(struct ft1000_device *ft1000dev,
+int fix_ft1000_write_dpram32(struct ft1000_usb *ft1000dev,
 			u16 indx, u8 *buffer);
 
 extern void *pFileStart;
@@ -125,25 +125,25 @@ extern size_t FileLength;
 extern int numofmsgbuf;
 
 int ft1000_close(struct net_device *dev);
-u16 scram_dnldr(struct ft1000_device *ft1000dev, void *pFileStart,
+u16 scram_dnldr(struct ft1000_usb *ft1000dev, void *pFileStart,
 		u32  FileLength);
 
 extern struct list_head freercvpool;
 
 extern spinlock_t free_buff_lock;   /* lock to arbitrate free buffer list for receive command data */
 
-int ft1000_create_dev(struct ft1000_device *dev);
+int ft1000_create_dev(struct ft1000_usb *dev);
 void ft1000_destroy_dev(struct net_device *dev);
-extern void card_send_command(struct ft1000_device *ft1000dev,
+extern void card_send_command(struct ft1000_usb *ft1000dev,
 				void *ptempbuffer, int size);
 
 struct dpram_blk *ft1000_get_buffer(struct list_head *bufflist);
 void ft1000_free_buffer(struct dpram_blk *pdpram_blk, struct list_head *plist);
 
-int dsp_reload(struct ft1000_device *ft1000dev);
-int init_ft1000_netdev(struct ft1000_device *ft1000dev);
+int dsp_reload(struct ft1000_usb *ft1000dev);
+int init_ft1000_netdev(struct ft1000_usb *ft1000dev);
 struct usb_interface;
-int reg_ft1000_netdev(struct ft1000_device *ft1000dev,
+int reg_ft1000_netdev(struct ft1000_usb *ft1000dev,
 			struct usb_interface *intf);
 int ft1000_poll(void *dev_id);
 
-- 
Ondrej Zary
