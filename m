Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0KHXVU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 18:21:20 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:19264 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755992Ab0KHXVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 18:21:18 -0500
Date: Tue, 9 Nov 2010 00:09:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: linux-kernel@vger.kernel.org
cc: Greg Kroah-Hartman <gregkh@suse.de>, Dan Carpenter <error27@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org
Subject: [PATCH 10/17][trivial] staging, bcm: Remove unnecessary casts of
 void ptr returning alloc function return values
Message-ID: <alpine.LNX.2.00.1011082342560.23697@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The [vk][cmz]alloc(_node) family of functions return void pointers which
it's completely unnecessary/pointless to cast to other pointer types since
that happens implicitly.

This patch removes such casts from drivers/staging/bcm/


Signed-off-by: Jesper Juhl <jj@chaosbits.net>
---
 CmHost.c       |    2 +-
 InterfaceDld.c |   27 +++++++++++++--------------
 Misc.c         |   12 +++++-------
 3 files changed, 19 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/bcm/CmHost.c b/drivers/staging/bcm/CmHost.c
index 6f388a3..0d9a34a 100644
--- a/drivers/staging/bcm/CmHost.c
+++ b/drivers/staging/bcm/CmHost.c
@@ -1778,7 +1778,7 @@ ULONG StoreCmControlResponseMessage(PMINI_ADAPTER Adapter,PVOID pvBuffer,UINT *p
 	}
 	// For DSA_REQ, only upto "psfAuthorizedSet" parameter should be accessed by driver!
 
-	pstAddIndication=(stLocalSFAddIndication *)kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
+	pstAddIndication=kmalloc(sizeof(*pstAddIndication), GFP_KERNEL);
 	if(NULL==pstAddIndication)
 		return 0;
 
diff --git a/drivers/staging/bcm/InterfaceDld.c b/drivers/staging/bcm/InterfaceDld.c
index 60c0f29..1a61c7b 100644
--- a/drivers/staging/bcm/InterfaceDld.c
+++ b/drivers/staging/bcm/InterfaceDld.c
@@ -6,7 +6,7 @@ int InterfaceFileDownload( PVOID arg,
                         struct file *flp,
                         unsigned int on_chip_loc)
 {
-    char            *buff=NULL;
+    char            *buff;
    // unsigned int    reg=0;
     mm_segment_t    oldfs={0};
     int             errno=0, len=0 /*,is_config_file = 0*/;
@@ -14,7 +14,7 @@ int InterfaceFileDownload( PVOID arg,
 	PS_INTERFACE_ADAPTER psIntfAdapter = (PS_INTERFACE_ADAPTER)arg;
 	//PMINI_ADAPTER Adapter = psIntfAdapter->psAdapter;
 
-    buff=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
+    buff=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
     if(!buff)
     {
         return -ENOMEM;
@@ -57,7 +57,7 @@ int InterfaceFileReadbackFromChip( PVOID arg,
                         struct file *flp,
                         unsigned int on_chip_loc)
 {
-    char            *buff=NULL, *buff_readback=NULL;
+    char            *buff, *buff_readback;
     unsigned int    reg=0;
     mm_segment_t    oldfs={0};
     int             errno=0, len=0, is_config_file = 0;
@@ -66,8 +66,8 @@ int InterfaceFileReadbackFromChip( PVOID arg,
 	INT				Status = STATUS_SUCCESS;
 	PS_INTERFACE_ADAPTER psIntfAdapter = (PS_INTERFACE_ADAPTER)arg;
 
-    buff=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
-    buff_readback=(PCHAR)kmalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
+    buff=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_DMA);
+    buff_readback=kmalloc(MAX_TRANSFER_CTRL_BYTE_USB , GFP_DMA);
     if(!buff || !buff_readback)
     {
         bcm_kfree(buff);
@@ -236,7 +236,7 @@ static int bcm_download_buffer(PMINI_ADAPTER Adapter,
 	unsigned char *mappedbuffer, unsigned int u32FirmwareLength,
 	unsigned long u32StartingAddress)
 {
-    char            *buff=NULL;
+    char            *buff;
     unsigned int    len = 0;
 	int 			retval = STATUS_SUCCESS;
 	buff = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
@@ -302,16 +302,15 @@ static int bcm_buffer_readback(PMINI_ADAPTER Adapter,
 	unsigned char *mappedbuffer, unsigned int u32FirmwareLength,
 	unsigned long u32StartingAddress)
 {
-	unsigned char *buff = NULL;
-	unsigned char *readbackbuff = NULL;
+	unsigned char *buff;
+	unsigned char *readbackbuff;
 	unsigned int  len = u32FirmwareLength;
 	int retval = STATUS_SUCCESS;
 
-    buff=(unsigned char *)kzalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
+    buff=kzalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
 	if(NULL == buff)
 		return -ENOMEM;
-	readbackbuff =  (unsigned char *)kzalloc(MAX_TRANSFER_CTRL_BYTE_USB,
-					GFP_KERNEL);
+	readbackbuff = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB, GFP_KERNEL);
 	if(NULL == readbackbuff)
 	{
 		bcm_kfree(buff);
@@ -375,7 +374,7 @@ int bcm_ioctl_fw_download(PMINI_ADAPTER Adapter, FIRMWARE_INFO *psFwInfo)
 	else
 	{
 
-		buff = (PUCHAR)kzalloc(psFwInfo->u32FirmwareLength,GFP_KERNEL);
+		buff = kzalloc(psFwInfo->u32FirmwareLength,GFP_KERNEL);
 		if(buff==NULL)
 		{
 			BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL,"Failed in allocation memory");
@@ -450,11 +449,11 @@ static INT buffRdbkVerify(PMINI_ADAPTER Adapter,
 			PUCHAR mappedbuffer, UINT u32FirmwareLength,
 			ULONG u32StartingAddress)
 {
-	PUCHAR readbackbuff = NULL;
+	PUCHAR readbackbuff;
 	UINT len = u32FirmwareLength;
 	INT retval = STATUS_SUCCESS;
 
-	readbackbuff = (PUCHAR)kzalloc(MAX_TRANSFER_CTRL_BYTE_USB,GFP_KERNEL);
+	readbackbuff = kzalloc(MAX_TRANSFER_CTRL_BYTE_USB,GFP_KERNEL);
 	if(NULL == readbackbuff)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "MEMORY ALLOCATION FAILED");
diff --git a/drivers/staging/bcm/Misc.c b/drivers/staging/bcm/Misc.c
index 22550f7..6ffd5e5 100644
--- a/drivers/staging/bcm/Misc.c
+++ b/drivers/staging/bcm/Misc.c
@@ -60,8 +60,7 @@ InitAdapter(PMINI_ADAPTER psAdapter)
     //init_waitqueue_head(&psAdapter->device_wake_queue);
     psAdapter->fw_download_done=FALSE;
 
-    psAdapter->pvOsDepData = (PLINUX_DEP_DATA) kmalloc(sizeof(LINUX_DEP_DATA),
-                 GFP_KERNEL);
+    psAdapter->pvOsDepData = kmalloc(sizeof(LINUX_DEP_DATA), GFP_KERNEL);
 
     if(psAdapter->pvOsDepData == NULL)
 	{
@@ -73,8 +72,7 @@ InitAdapter(PMINI_ADAPTER psAdapter)
 	default_wimax_protocol_initialize(psAdapter);
 	for (i=0;i<MAX_CNTRL_PKTS;i++)
 	{
-		psAdapter->txctlpacket[i] = (char *)kmalloc(MAX_CNTL_PKT_SIZE,
-												GFP_KERNEL);
+		psAdapter->txctlpacket[i] = kmalloc(MAX_CNTL_PKT_SIZE, GFP_KERNEL);
 		if(!psAdapter->txctlpacket[i])
 		{
 			BCM_DEBUG_PRINT(psAdapter,DBG_TYPE_INITEXIT, MP_INIT, DBG_LVL_ALL, "No More Cntl pkts got, max got is %d", i);
@@ -1360,7 +1358,7 @@ int bcm_parse_target_params(PMINI_ADAPTER Adapter)
 	int len = 0;
 	loff_t	pos = 0;
 
-	buff=(PCHAR)kmalloc(BUFFER_1K, GFP_KERNEL);
+	buff=kmalloc(BUFFER_1K, GFP_KERNEL);
 	if(!buff)
 	{
 		return -ENOMEM;
@@ -1540,12 +1538,12 @@ VOID doPowerAutoCorrection(PMINI_ADAPTER psAdapter)
 #if 0
 static unsigned char *ReadMacAddrEEPROM(PMINI_ADAPTER Adapter, ulong dwAddress)
 {
-	unsigned char *pucmacaddr = NULL;
+	unsigned char *pucmacaddr;
 	int status = 0, i=0;
 	unsigned int temp =0;
 
 
-	pucmacaddr = (unsigned char *)kmalloc(MAC_ADDRESS_SIZE, GFP_KERNEL);
+	pucmacaddr = kmalloc(MAC_ADDRESS_SIZE, GFP_KERNEL);
 	if(!pucmacaddr)
 	{
 		BCM_DEBUG_PRINT(Adapter,DBG_TYPE_PRINTK, 0, 0, "No Buffers to Read the EEPROM Address\n");



-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

