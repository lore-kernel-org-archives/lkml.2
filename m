Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932296Ab0JOUkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 16:40:15 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54125 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0JOUkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 16:40:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=FE5NAFiFws1TcnPVokQOEf5OUK8/HWmaI+fkyv/WDf6gycz6STUkHf0jHP/nJhOcOV
         Lrx51svw+dSjQ8g8ufnR1KIRAx94pzZzfV1vGmIre3d6i7Hl+cPd+gfFBclCPEOpPP8z
         T5ciDGPRA2te9D24IpsdLv5czWDEWAheBjr5s=
From: Marek Belisko <marek.belisko@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Marek Belisko <marek.belisko@gmail.com>
Subject: [PATCH] staging:ft1000: Remove dead code from ft1000_hw.c
Date: Fri, 15 Oct 2010 22:15:28 +0200
Message-Id: <1287173728-9798-1-git-send-email-marek.belisko@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Marek Belisko <marek.belisko@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_hw.c |  267 +------------------------
 1 files changed, 6 insertions(+), 261 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
index 915c95c..e98db30 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_hw.c
@@ -16,10 +16,6 @@
 #include <linux/usb.h>
 #include "ft1000_usb.h"
 #include <linux/types.h>
-//#include <asm/semaphore.h>		//aelias [-] reason : file moved
-//#include <linux/semaphore.h>		//aelias [+] reason : file moved
-//#include <asm/io.h>
-//#include <linux/kthread.h>
 
 #define HARLEY_READ_REGISTER     0x0
 #define HARLEY_WRITE_REGISTER    0x01
@@ -41,14 +37,6 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev);
 static int ft1000_open (struct net_device *dev);
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev);
 static int ft1000_chkcard (struct ft1000_device *dev);
-/*
-static const struct net_device_ops ft1000net_ops = {
-    .ndo_start_xmit = ft1000_start_xmit,
-    .ndo_get_stats = ft1000_netdev_stats,
-    .ndo_open = ft1000_open,
-    .ndo_stop = ft1000_close,
-};
-*/
 
 //Jim
 
@@ -75,7 +63,6 @@ static void ft1000_control_complete(struct urb *urb)
         DEBUG("NULL ft1000dev->dev, failure\n");
         return ;
     }
-    //spin_lock(&ft1000dev->device_lock);
 
     if(waitqueue_active(&ft1000dev->control_wait))
     {
@@ -83,7 +70,6 @@ static void ft1000_control_complete(struct urb *urb)
     }
 
     //DEBUG("FT1000_CONTROL_COMPLETE RETURNED\n");
-    //spin_unlock(&ft1000dev->device_lock);
 }
 
 //---------------------------------------------------------------------------
@@ -550,14 +536,11 @@ static void card_reset_dsp (struct ft1000_device *ft1000dev, BOOLEAN value)
     {
         DEBUG("Activate DSP\n");
         status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-#if 1
-        tempword |= DSP_ENCRYPTED;
+        
+	tempword |= DSP_ENCRYPTED;
         tempword &= ~DSP_UNENCRYPTED;
-#else
-        tempword |= DSP_UNENCRYPTED;
-        tempword &= ~DSP_ENCRYPTED;
-#endif
-        status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
+        
+	status = ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
         status = ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
         tempword &= ~EFUSE_MEM_DISABLE;
         tempword &= ~DSP_RESET_BIT;
@@ -589,16 +572,9 @@ void CardSendCommand(struct ft1000_device *ft1000dev, void *ptempbuffer, int siz
     DEBUG("CardSendCommand: enter CardSendCommand... size=%d\n", size);
 
     commandbuf =(unsigned char*) kmalloc(size+2, GFP_KERNEL);
-    //memset((void*)commandbuf, 0, size+2);
     memcpy((void*)commandbuf+2, (void*)ptempbuffer, size);
 
     //DEBUG("CardSendCommand: Command Send\n");
-    /***
-    for (i=0; i<size+2; i++)
-    {
-        DEBUG("FT1000:ft1000_ChIoctl: data %d = 0x%x\n", i, *ptr++);
-    }
-    ***/
 
     ft1000_read_register(ft1000dev, &temp, FT1000_REG_DOORBELL);
 
@@ -728,51 +704,7 @@ static void ft1000_reset_asic (struct net_device *dev)
     DEBUG("ft1000_hw: interrupt status register = 0x%x\n",tempword);
 
 }
-/*
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_disable_interrupts
-// Descripton: This function will disable all interrupts.
-// Input:
-//     dev    - device structure
-// Output:
-//     None.
-//
-//---------------------------------------------------------------------------
-static void ft1000_disable_interrupts(struct net_device *dev) {
-    FT1000_INFO *info = netdev_priv(dev);
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-    u16 tempword;
-
-    DEBUG("ft1000_hw: ft1000_disable_interrupts()\n");
-    ft1000_write_register (ft1000dev, ISR_MASK_ALL, FT1000_REG_SUP_IMASK);
-    ft1000_read_register (ft1000dev, &tempword, FT1000_REG_SUP_IMASK);
-    DEBUG("ft1000_hw:ft1000_disable_interrupts:current interrupt enable mask = 0x%x\n", tempword);
-    info->InterruptsEnabled = FALSE;
-}
-
-//---------------------------------------------------------------------------
-//
-// Function:   ft1000_enable_interrupts
-// Descripton: This function will enable interrupts base on the current interrupt mask.
-// Input:
-//     dev    - device structure
-// Output:
-//     None.
-//
-//---------------------------------------------------------------------------
-static void ft1000_enable_interrupts(struct net_device *dev) {
-    FT1000_INFO *info = netdev_priv(dev);
-    struct ft1000_device *ft1000dev = info->pFt1000Dev;
-    u16 tempword;
 
-    DEBUG("ft1000_hw:ft1000_enable_interrupts()\n");
-    ft1000_write_register (ft1000dev, info->CurrentInterruptEnableMask, FT1000_REG_SUP_IMASK);
-    ft1000_read_register (ft1000dev, &tempword, FT1000_REG_SUP_IMASK);
-    DEBUG("ft1000_hw:ft1000_enable_interrupts:current interrupt enable mask = 0x%x\n", tempword);
-    info->InterruptsEnabled = TRUE;
-}
-*/
 
 //---------------------------------------------------------------------------
 //
@@ -797,7 +729,6 @@ static int ft1000_reset_card (struct net_device *dev)
     info->fCondResetPend = 1;
     info->CardReady = 0;
     info->fProvComplete = 0;
-    //ft1000_disable_interrupts(dev);
 
     // Make sure we free any memory reserve for provisioning
     while (list_empty(&info->prov_list) == 0) {
@@ -814,76 +745,6 @@ static int ft1000_reset_card (struct net_device *dev)
 
     info->DSPResetNum++;
 
-#if 0
-    DEBUG("ft1000_hw:ft1000_reset_card:resetting ASIC and DSP\n");
-    ft1000_write_register (ft1000dev, (DSP_RESET_BIT | ASIC_RESET_BIT), FT1000_REG_RESET );
-
-
-    // Copy DSP session record into info block if this is not a coldstart
-    //if (ft1000_card_present == 1) {
-        spin_lock_irqsave(&info->dpram_lock, flags);
-
-            ft1000_write_register(ft1000dev,  FT1000_DPRAM_MAG_RX_BASE, FT1000_REG_DPRAM_ADDR);
-            for (i=0;i<MAX_DSP_SESS_REC/2; i++) {
-                //info->DSPSess.MagRec[i] = inl(dev->base_addr+FT1000_REG_MAG_DPDATA);
-                ft1000_read_dpram32(ft1000dev, FT1000_REG_MAG_DPDATA, (PCHAR)&(info->DSPSess.MagRec[i]), 4);
-            }
-
-        spin_unlock_irqrestore(&info->dpram_lock, flags);
-    //}
-    info->squeseqnum = 0;
-
-    DEBUG("ft1000_hw:ft1000_reset_card:resetting ASIC\n");
-    mdelay(10);
-    //reset ASIC
-    ft1000_reset_asic(dev);
-
-    info->DSPResetNum++;
-
-    DEBUG("ft1000_hw:ft1000_reset_card:downloading dsp image\n");
-
-
-        // Put dsp in reset and take ASIC out of reset
-        DEBUG("ft1000_hw:ft1000_reset_card:Put DSP in reset and take ASIC out of reset\n");
-        ft1000_write_register (ft1000dev, DSP_RESET_BIT, FT1000_REG_RESET);
-
-        // Setting MAGNEMITE ASIC to big endian mode
-        ft1000_write_register (ft1000dev, HOST_INTF_BE, FT1000_REG_SUP_CTRL);
-
-        // Take DSP out of reset
-
-           ft1000_read_register(ft1000dev, &tempword, FT1000_REG_RESET);
-           tempword |= DSP_ENCRYPTED;
-           tempword &= ~DSP_UNENCRYPTED;
-           ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-           tempword &= ~EFUSE_MEM_DISABLE;
-           ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-           tempword &= ~DSP_RESET_BIT;
-           ft1000_write_register(ft1000dev, tempword, FT1000_REG_RESET);
-
-
-        // FLARION_DSP_ACTIVE;
-        mdelay(10);
-        DEBUG("ft1000_hw:ft1000_reset_card:Take DSP out of reset\n");
-
-        // Wait for 0xfefe indicating dsp ready before starting download
-        for (i=0; i<50; i++) {
-            //tempword = ft1000_read_dpram_mag_16(dev, FT1000_MAG_DPRAM_FEFE, FT1000_MAG_DPRAM_FEFE_INDX);
-            ft1000_read_dpram32 (ft1000dev, FT1000_MAG_DPRAM_FEFE_INDX, (PUCHAR)&templong, 4);
-            if (tempword == 0xfefe) {
-                break;
-            }
-            mdelay(20);
-        }
-
-        if (i==50) {
-            DEBUG("ft1000_hw:ft1000_reset_card:No FEFE detected from DSP\n");
-            return FALSE;
-        }
-
-
-#endif
-
     DEBUG("ft1000_hw:ft1000_reset_card: call dsp_reload\n");
     dsp_reload(ft1000dev);
 
@@ -900,7 +761,6 @@ static int ft1000_reset_card (struct net_device *dev)
 
 
     info->CardReady = 1;
-    //ft1000_enable_interrupts(dev);
 
     info->fCondResetPend = 0;
     return TRUE;
@@ -955,7 +815,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
 	return -ENOMEM;
     }
 
-    //pInfo = (PFT1000_INFO)netdev->priv;
 	pInfo = (FT1000_INFO *) netdev_priv (netdev);
 
     //DEBUG("init_ft1000_netdev: gFt1000Info=%x, netdev=%x, ft1000dev=%x\n", gFt1000Info, netdev, ft1000dev);
@@ -990,7 +849,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     else
     {
         //not the first inserted card, increase card number by 1
-        /*gCardIndex ++;*/
         pInfo->CardNumber = gCardIndex;
         /*DEBUG("card number = %d\n", pInfo->CardNumber);*/ //mbelian
     }
@@ -1035,9 +893,6 @@ u16 init_ft1000_netdev(struct ft1000_device *ft1000dev)
     netdev->stop = &ft1000_close;
 #endif
 
-    //netif_stop_queue(netdev); //mbelian
-
-
     ft1000dev->net = netdev;
 
 
@@ -1131,19 +986,6 @@ int reg_ft1000_netdev(struct ft1000_device *ft1000dev, struct usb_interface *int
     //Create character device, implemented by Jim
     ft1000_CreateDevice(ft1000dev);
 
-    //INIT_LIST_HEAD(&pInfo->prov_list);
-
-
-    //hard code MAC address for now
-/**
-    netdev->dev_addr[0] = 0;
-    netdev->dev_addr[1] = 7;
-    netdev->dev_addr[2] = 0x35;
-    netdev->dev_addr[3] = 0x84;
-    netdev->dev_addr[4] = 0;
-    netdev->dev_addr[5] = 0x20 + pInfo->CardNumber;
-**/
-
     DEBUG ("reg_ft1000_netdev returned\n");
 
     pInfo->CardReady = 1;
@@ -1177,14 +1019,12 @@ static void ft1000_usb_transmit_complete(struct urb *urb)
     struct ft1000_device *ft1000dev = urb->context;
 
     //DEBUG("ft1000_usb_transmit_complete entered\n");
-// Jim   spin_lock(&ft1000dev->device_lock);
 
     if (urb->status)
         printk("%s: TX status %d\n", ft1000dev->net->name, urb->status);
 
     netif_wake_queue(ft1000dev->net);
 
-//Jim    spin_unlock(&ft1000dev->device_lock);
     //DEBUG("Return from ft1000_usb_transmit_complete\n");
 }
 
@@ -1221,11 +1061,6 @@ static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pip
 
     spin_lock(&ft1000dev->device_lock);
 
-    /*DECLARE_WAITQUEUE(wait, current);
-    struct urb *urb;
-    struct usb_ctrlrequest *dr;
-    int status;*/
-
     if(in_interrupt())
     {
         spin_unlock(&ft1000dev->device_lock);
@@ -1256,7 +1091,6 @@ static int ft1000_read_fifo_reg(struct ft1000_device *ft1000dev,unsigned int pip
 
     init_waitqueue_head(&ft1000dev->control_wait);
 
-    //current->state = TASK_INTERRUPTIBLE; //mbelian
 	set_current_state(TASK_INTERRUPTIBLE);
 
     add_wait_queue(&ft1000dev->control_wait, &wait);
@@ -1337,12 +1171,10 @@ static inline u16 ft1000_read_fifo_len (struct net_device *dev)
     u16 temp;
     u16 ret;
 
-    //FT1000_INFO *info = (PFT1000_INFO)dev->priv;
 	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev);
     struct ft1000_device *ft1000dev = info->pFt1000Dev;
 //    DEBUG("ft1000_read_fifo_len: enter ft1000dev %x\n", ft1000dev);			//aelias [-] reason: warning: format ???%x??? expects type ???unsigned int???, but argument 2 has type ???struct ft1000_device *???
     DEBUG("ft1000_read_fifo_len: enter ft1000dev %p\n", ft1000dev);	//aelias [+] reason: up
-    //ft1000_read_register(ft1000dev, &temp, FT1000_REG_MAG_UFSR);
 
     ret = STATUS_SUCCESS;
 
@@ -1405,45 +1237,6 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
 
     //DEBUG("ft1000_copy_down_pkt() entered, len = %d\n", len);
 
-#if 0
-    // Check if there is room on the FIFO
-    if ( len > ft1000_read_fifo_len (netdev) )
-    {
-         udelay(10);
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-             udelay(20);
-         }
-
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-             udelay(20);
-         }
-
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-             udelay(20);
-         }
-
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-             udelay(20);
-         }
-
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-             udelay(20);
-         }
-
-         if ( len > ft1000_read_fifo_len (netdev) )
-         {
-            DEBUG("ft1000_hw:ft1000_copy_down_pkt:Transmit FIFO is fulli - pkt drop\n");
-            pInfo->stats.tx_errors++;
-            return STATUS_SUCCESS;
-         }
-    }
-#endif
-
     count = sizeof (PSEUDO_HDR) + len;
     if(count > MAX_BUF_SIZE)
     {
@@ -1472,8 +1265,6 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     *pTemp++ = checksum;
     memcpy (&(pFt1000Dev->tx_buf[sizeof(PSEUDO_HDR)]), packet, len);
 
-    //usb_init_urb(pFt1000Dev->tx_urb); //mbelian
-
     netif_stop_queue(netdev);
 
     //DEBUG ("ft1000_copy_down_pkt: count = %d\n", count);
@@ -1499,9 +1290,6 @@ static int ft1000_copy_down_pkt (struct net_device *netdev, u8 *packet, u16 len)
     {
 		DEBUG("ft1000 failed tx_urb %d\n", ret);
 
-   /*     pInfo->stats.tx_errors++;
-
-        netif_start_queue(netdev);  */  //mbelian
 		return STATUS_FAILURE;
 
     }
@@ -1552,7 +1340,6 @@ static int ft1000_start_xmit(struct sk_buff *skb, struct net_device *dev)
     {
         DEBUG("network driver is closed, return\n");
         dev_kfree_skb(skb);
-        //usb_kill_urb(pFt1000Dev->tx_urb); //mbelian
         return STATUS_SUCCESS;
     }
 
@@ -1730,7 +1517,6 @@ static int ft1000_submit_rx_urb(PFT1000_INFO info)
     int result;
     struct ft1000_device *pFt1000Dev = info->pFt1000Dev;
 
-    //netif_carrier_on(pFt1000Dev->net);
 
     //DEBUG ("ft1000_submit_rx_urb entered: sizeof rx_urb is %d\n", sizeof(*pFt1000Dev->rx_urb));
     if ( pFt1000Dev->status & FT1000_STATUS_CLOSING)
@@ -1739,10 +1525,6 @@ static int ft1000_submit_rx_urb(PFT1000_INFO info)
         //usb_kill_urb(pFt1000Dev->rx_urb); //mbelian
         return STATUS_SUCCESS;
     }
-    //memset(pFt1000Dev->rx_urb, 0, sizeof(*pFt1000Dev->rx_urb));
-    //usb_init_urb(pFt1000Dev->rx_urb);//mbelian
-
-    //spin_lock_init(&pFt1000Dev->rx_urb->lock);
 
     usb_fill_bulk_urb(pFt1000Dev->rx_urb,
             pFt1000Dev->dev,
@@ -1797,8 +1579,6 @@ static int ft1000_open (struct net_device *dev)
 
     netif_start_queue(dev);
 
-    //netif_device_attach(dev);
-
     netif_carrier_on(dev); //mbelian
 
     ft1000_submit_rx_urb(pInfo);
@@ -1827,11 +1607,8 @@ int ft1000_close(struct net_device *net)
     //DEBUG ("ft1000_close: netdev->refcnt=%d\n", net->refcnt);
 
     ft1000dev->status |= FT1000_STATUS_CLOSING;
-
+    
     //DEBUG("ft1000_close: calling usb_kill_urb \n");
-    //usb_kill_urb(ft1000dev->rx_urb);
-    //usb_kill_urb(ft1000dev->tx_urb);
-
 
     DEBUG("ft1000_close: pInfo=%p, ft1000dev=%p\n", pInfo, ft1000dev);
     netif_carrier_off(net);//mbelian
@@ -1848,9 +1625,7 @@ int ft1000_close(struct net_device *net)
 static struct net_device_stats *ft1000_netdev_stats(struct net_device *dev)
 {
 	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev);
-    //struct ft1000_device *ft1000dev = info->pFt1000Dev;
 
-    //return &(ft1000dev->stats);//mbelian
 	return &(info->stats); //mbelian
 }
 
@@ -1896,7 +1671,6 @@ static int ft1000_chkcard (struct ft1000_device *dev) {
     // if the device is not present.
     status = ft1000_read_register(dev, &tempword, FT1000_REG_ASIC_ID);
     //DEBUG("ft1000_hw:ft1000_chkcard: read FT1000_REG_ASIC_ID = %x\n", tempword);
-    //pxu if (tempword == 0xffff) {
     if (tempword != 0x1b01 ){
 	dev->status |= FT1000_STATUS_CLOSING; //mbelian
         DEBUG("ft1000_hw:ft1000_chkcard: Version = 0xffff Card not detected\n");
@@ -1934,7 +1708,6 @@ static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int
     }
     else {
         ppseudohdr = (u16 *)pbuffer;
-        //spin_lock_irqsave (&info->dpram_lock, flags);
         ft1000_write_register(dev, FT1000_DPRAM_MAG_RX_BASE, FT1000_REG_DPRAM_ADDR);
         ret = ft1000_read_register(dev, pbuffer, FT1000_REG_MAG_DPDATAH);
         //DEBUG("ft1000_hw:received data = 0x%x\n", *pbuffer);
@@ -1958,7 +1731,6 @@ static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int
             ret = ft1000_read_register(dev, &tempword, FT1000_REG_DPRAM_DATA);
             *pbuffer = ntohs(tempword);
         }
-        //spin_unlock_irqrestore(&info->dpram_lock, flags);
 
         // Check if pseudo header checksum is good
         // Calculate pseudo header checksum
@@ -1970,24 +1742,6 @@ static BOOLEAN ft1000_receive_cmd (struct ft1000_device *dev, u16 *pbuffer, int
             return FALSE;
         }
 
-
-#if 0
-        DEBUG("ft1000_receive_cmd:pbuffer\n");
-        for(i = 0; i < size; i+=5)
-        {
-            if( (i + 5) < size )
-                DEBUG("0x%x, 0x%x, 0x%x, 0x%x, 0x%x\n", tempbuffer[i], tempbuffer[i+1], tempbuffer[i+2], tempbuffer[i+3], tempbuffer[i+4]);
-            else
-            {
-                for (j = i; j < size; j++)
-                DEBUG("0x%x ", tempbuffer[j]);
-                DEBUG("\n");
-                break;
-            }
-        }
-
-#endif
-
         return TRUE;
     }
 }
@@ -2008,8 +1762,7 @@ static int ft1000_dsp_prov(void *arg)
 
     DEBUG("*** DspProv Entered\n");
 
-    while (         list_empty(&info->prov_list) == 0
-                   /*&&  !kthread_should_stop()  */)
+    while (list_empty(&info->prov_list) == 0)
     {
 	DEBUG("DSP Provisioning List Entry\n");
 
@@ -2040,7 +1793,6 @@ static int ft1000_dsp_prov(void *arg)
             len = *(u16 *)ptr->pprov_data;
             len = htons(len);
             len += PSEUDOSZ;
-            //len = htons(len);
 
             pmsg = (PUSHORT)ptr->pprov_data;
             ppseudo_hdr = (PPSEUDO_HDR)pmsg;
@@ -2091,7 +1843,6 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
     PPSEUDO_HDR ppseudo_hdr;
     PUSHORT pmsg;
     u16 status;
-    //struct timeval tv; //mbelian
     union {
         u8  byte[2];
         u16 wrd;
@@ -2105,8 +1856,6 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
     status = ft1000_read_dpram32(dev, 0x200, cmdbuffer, size);
 
 
-    //if (ft1000_receive_cmd(dev, &cmdbuffer[0], MAX_CMD_SQSIZE, &tempword))
-    {
 
 #ifdef JDEBUG
         DEBUG("ft1000_proc_drvmsg:cmdbuffer\n");
@@ -2354,7 +2103,6 @@ static int ft1000_proc_drvmsg (struct ft1000_device *dev, u16 size) {
           break;
         }
 
-    }
 
     status = STATUS_SUCCESS;
 out:
@@ -2367,8 +2115,6 @@ out:
 
 int ft1000_poll(void* dev_id) {
 
-    //FT1000_INFO *info = (PFT1000_INFO)((struct net_device *)dev_id)->priv;
-    //struct ft1000_device *dev = (struct ft1000_device *)info->pFt1000Dev;
     struct ft1000_device *dev = (struct ft1000_device *)dev_id;
 	FT1000_INFO *info = (FT1000_INFO *) netdev_priv (dev->net);
 
@@ -2393,7 +2139,6 @@ int ft1000_poll(void* dev_id) {
     status = ft1000_read_register (dev, &tempword, FT1000_REG_DOORBELL);
    // DEBUG("ft1000_poll: read FT1000_REG_DOORBELL message 0x%x\n", tempword);
 
-    //while ( (tempword) && (!status) ) {
     if ( !status )
     {
 
-- 
1.7.1

