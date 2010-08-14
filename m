Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0HNWeD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:34:03 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46186 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757089Ab0HNWeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=CRkqs0GfUHcVzphjBYfCn2JggpnWHy5irfkiNFMssT1Lv2O7S/30ECWjBRLMxAj1g2
         CbqIVzfYRep4OnP0iThGi2JvWIa2BZvujnIzjXjKQEdoPE3yHhsyQbU1wwSZzgXr7uFB
         +nZlvrxR4HSE1oFFlLAtUMNh9zZ/QNzs9cP30=
From: Neil Munro <neilmunro@gmail.com>
To: gregkh@suse.de, wfp5p@virginia.edu
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Niadh <neilmunro@gmail.com>
Subject: [PATCH 8618/8618] Staging: RT2860: Fixed all warnings and errors in the iface directory
Date: Sat, 14 Aug 2010 23:39:51 +0100
Message-Id: <1281825591-19603-1-git-send-email-neilmunro@gmail.com>
X-Mailer: git-send-email 1.7.2.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Niadh <neilmunro@gmail.com>

I have cleaned both files inside the iface directory (fileo rtmp_pci.h and rtmp_usb.h). I am not sure about some of the changes I have made however my adjustments have solved all errors.
There were also a few issues on my machine with ap.h on my machine, however I have since cleaned that too.

If there are any issues please dont hesitate to let me know, I shall try to fix them as soon as I can.

Signed-off-by: Neil Munro <neilmunro@gmail.com>
---
 drivers/staging/rt2860/ap.h             |   20 +++---
 drivers/staging/rt2860/iface/rtmp_pci.h |   42 ++++++------
 drivers/staging/rt2860/iface/rtmp_usb.h |  110 +++++++++++++++++-------------
 3 files changed, 94 insertions(+), 78 deletions(-)

diff --git a/drivers/staging/rt2860/ap.h b/drivers/staging/rt2860/ap.h
index faac85d..2737c0c 100644
--- a/drivers/staging/rt2860/ap.h
+++ b/drivers/staging/rt2860/ap.h
@@ -24,18 +24,18 @@
  *                                                                       *
  *************************************************************************
 
-    Module Name:
-    ap.h
+Module Name:
+ap.h
 
-    Abstract:
-    Miniport generic portion header file
+Abstract:
+Miniport generic portion header file
 
-    Revision History:
-    Who         When          What
-    --------    ----------    ----------------------------------------------
-    Paul Lin    08-01-2002    created
-    James Tan   09-06-2002    modified (Revise NTCRegTable)
-    John Chang  12-22-2004    modified for RT2561/2661. merge with STA driver
+Revision History:
+Who         When          What
+--------    ----------    ----------------------------------------------
+Paul Lin    08-01-2002    created
+James Tan   09-06-2002    modified (Revise NTCRegTable)
+John Chang  12-22-2004    modified for RT2561/2661. merge with STA driver
 */
 #ifndef __AP_H__
 #define __AP_H__
diff --git a/drivers/staging/rt2860/iface/rtmp_pci.h b/drivers/staging/rt2860/iface/rtmp_pci.h
index 7759d56..3d66e38 100644
--- a/drivers/staging/rt2860/iface/rtmp_pci.h
+++ b/drivers/staging/rt2860/iface/rtmp_pci.h
@@ -32,7 +32,7 @@
 	((struct os_cookie *)handle)->pci_dev = dev_p;
 
 #ifdef LINUX
-// set driver data
+/* set driver data */
 #define RT28XX_DRVDATA_SET(_a)			pci_set_drvdata(_a, net_dev);
 
 #define RT28XX_PUT_DEVICE(dev_p)
@@ -42,7 +42,8 @@
 #ifdef PCI_MSI_SUPPORT
 #define RTMP_MSI_ENABLE(_pAd) \
 	{     struct os_cookie *_pObj = (struct os_cookie *)(_pAd->OS_Cookie); \
-		(_pAd)->HaveMsi = pci_enable_msi(_pObj->pci_dev) == 0 ? TRUE : FALSE; \
+		(_pAd)->HaveMsi = pci_enable_msi(_pObj->pci_dev) \
+							== 0 ? TRUE : FALSE; \
 	}
 
 #define RTMP_MSI_DISABLE(_pAd) \
@@ -52,27 +53,28 @@
 		_pAd->HaveMsi = FALSE;  \
 	}
 #else
-#define RTMP_MSI_ENABLE(_pAd)		do{}while(0)
-#define RTMP_MSI_DISABLE(_pAd)		do{}while(0)
-#endif // PCI_MSI_SUPPORT //
+#define RTMP_MSI_ENABLE(_pAd)		do {} while (0)
+#define RTMP_MSI_DISABLE(_pAd)		do {} while (0)
+#endif /* PCI_MSI_SUPPORT */
 
-#define RTMP_PCI_DEV_UNMAP()										\
-{	if (net_dev->base_addr)	{								\
-		iounmap((void *)(net_dev->base_addr));				\
+#define RTMP_PCI_DEV_UNMAP()						\
+{	if (net_dev->base_addr)	{					\
+		iounmap((void *)(net_dev->base_addr));			\
 		release_mem_region(pci_resource_start(dev_p, 0),	\
-							pci_resource_len(dev_p, 0)); }	\
-	if (net_dev->irq) pci_release_regions(dev_p); }
+					pci_resource_len(dev_p, 0)); } \
+	if (net_dev->irq) \
+		pci_release_regions(dev_p); }
 
-#define PCI_REG_READ_WORD(pci_dev, offset, Configuration)   \
-    if (pci_read_config_word(pci_dev, offset, &reg16) == 0)     \
-        Configuration = le2cpu16(reg16);                        \
-    else                                                        \
-        Configuration = 0;
+#define PCI_REG_READ_WORD(pci_dev, offset, Configuration)   {\
+	if (pci_read_config_word(pci_dev, offset, &reg16) == 0)     \
+		Configuration = le2cpu16(reg16);                        \
+	else                                                        \
+		Configuration = 0; }
 
-#define PCI_REG_WIRTE_WORD(pci_dev, offset, Configuration)  \
-    reg16 = cpu2le16(Configuration);                        \
-    pci_write_config_word(pci_dev, offset, reg16);
+#define PCI_REG_WIRTE_WORD(pci_dev, offset, Configuration)  {\
+	reg16 = cpu2le16(Configuration);                        \
+	pci_write_config_word(pci_dev, offset, reg16); }
 
-#endif // LINUX //
+#endif /* LINUX */
 
-#endif // __RTMP_PCI_H__ //
+#endif /* __RTMP_PCI_H__ */
diff --git a/drivers/staging/rt2860/iface/rtmp_usb.h b/drivers/staging/rt2860/iface/rtmp_usb.h
index 33479cc..5712896 100644
--- a/drivers/staging/rt2860/iface/rtmp_usb.h
+++ b/drivers/staging/rt2860/iface/rtmp_usb.h
@@ -32,41 +32,40 @@
 
 #ifdef LINUX
 #include <linux/usb.h>
-#endif // LINUX //
+#endif /* LINUX */
 
 extern u8 EpToQueue[6];
 
 #define RXBULKAGGRE_ZISE			12
-#define MAX_TXBULK_LIMIT			(LOCAL_TXBUF_SIZE*(BULKAGGRE_ZISE-1))
-#define MAX_TXBULK_SIZE			(LOCAL_TXBUF_SIZE*BULKAGGRE_ZISE)
-#define MAX_RXBULK_SIZE			(LOCAL_TXBUF_SIZE*RXBULKAGGRE_ZISE)
+#define MAX_TXBULK_LIMIT		(LOCAL_TXBUF_SIZE*(BULKAGGRE_ZISE-1))
+#define MAX_TXBULK_SIZE		(LOCAL_TXBUF_SIZE*BULKAGGRE_ZISE)
+#define MAX_RXBULK_SIZE		(LOCAL_TXBUF_SIZE*RXBULKAGGRE_ZISE)
 #define MAX_MLME_HANDLER_MEMORY 20
 
-// Flags for Bulkflags control for bulk out data
-//
+/* Flags for Bulkflags control for bulk out data */
 #define	fRTUSB_BULK_OUT_DATA_NULL				0x00000001
-#define	fRTUSB_BULK_OUT_RTS						0x00000002
-#define	fRTUSB_BULK_OUT_MLME						0x00000004
+#define	fRTUSB_BULK_OUT_RTS					0x00000002
+#define	fRTUSB_BULK_OUT_MLME					0x00000004
 
-#define	fRTUSB_BULK_OUT_PSPOLL					0x00000010
+#define	fRTUSB_BULK_OUT_PSPOLL				0x00000010
 #define	fRTUSB_BULK_OUT_DATA_FRAG				0x00000020
-#define	fRTUSB_BULK_OUT_DATA_FRAG_2				0x00000040
-#define	fRTUSB_BULK_OUT_DATA_FRAG_3				0x00000080
-#define	fRTUSB_BULK_OUT_DATA_FRAG_4				0x00000100
+#define	fRTUSB_BULK_OUT_DATA_FRAG_2			0x00000040
+#define	fRTUSB_BULK_OUT_DATA_FRAG_3			0x00000080
+#define	fRTUSB_BULK_OUT_DATA_FRAG_4			0x00000100
 
-#define	fRTUSB_BULK_OUT_DATA_NORMAL				0x00010000
+#define	fRTUSB_BULK_OUT_DATA_NORMAL			0x00010000
 #define	fRTUSB_BULK_OUT_DATA_NORMAL_2			0x00020000
 #define	fRTUSB_BULK_OUT_DATA_NORMAL_3			0x00040000
 #define	fRTUSB_BULK_OUT_DATA_NORMAL_4			0x00080000
 
-// TODO:move to ./ate/include/iface/ate_usb.h
+/* TODO:move to ./ate/include/iface/ate_usb.h */
 
 #define FREE_HTTX_RING(_pCookie, _pipeId, _txContext)			\
-{										\
-	if ((_txContext)->ENextBulkOutPosition == (_txContext)->CurWritePosition)	\
-	{																	\
+{									\
+	if ((_txContext)->ENextBulkOutPosition == \
+	(_txContext)->CurWritePosition) {\
 		(_txContext)->bRingEmpty = TRUE;			\
-	}																	\
+	}								\
 	/*NdisInterlockedDecrement(&(_p)->TxCount); */\
 }
 
@@ -77,16 +76,32 @@ extern u8 EpToQueue[6];
 ******************************************************************************/
 
 #ifdef LINUX
-#define BULKAGGRE_ZISE          100
-#define RT28XX_PUT_DEVICE							usb_put_dev
-#define RTUSB_ALLOC_URB(iso)							usb_alloc_urb(iso, GFP_ATOMIC)
-#define RTUSB_SUBMIT_URB(pUrb)							usb_submit_urb(pUrb, GFP_ATOMIC)
-#define RTUSB_URB_ALLOC_BUFFER(pUsb_Dev, BufSize, pDma_addr)			usb_alloc_coherent(pUsb_Dev, BufSize, GFP_ATOMIC, pDma_addr)
-#define RTUSB_URB_FREE_BUFFER(pUsb_Dev, BufSize, pTransferBuf, Dma_addr)	usb_free_coherent(pUsb_Dev, BufSize, pTransferBuf, Dma_addr)
+#define BULKAGGRE_ZISE			100
+#define RT28XX_PUT_DEVICE			usb_put_dev
+#define RTUSB_ALLOC_URB(iso)		usb_alloc_urb(iso, GFP_ATOMIC)
+#define RTUSB_SUBMIT_URB(pUrb)		usb_submit_urb(pUrb, \
+								GFP_ATOMIC)
+#define RTUSB_URB_ALLOC_BUFFER(pUsb_Dev, \
+							BufSize, \
+							pDma_addr)	\
+							usb_alloc_coherent(\
+							pUsb_Dev, \
+							BufSize, \
+							GFP_ATOMIC, \
+							pDma_addr)
+#define RTUSB_URB_FREE_BUFFER(pUsb_Dev, \
+							BufSize, \
+							pTransferBuf, \
+							Dma_addr)	\
+							usb_free_coherent( \
+							pUsb_Dev, \
+							BufSize, \
+							pTransferBuf, \
+							Dma_addr)
 
 #define RTUSB_FREE_URB(pUrb)	usb_free_urb(pUrb)
 
-// unlink urb
+/* unlink urb */
 #define RTUSB_UNLINK_URB(pUrb)		usb_kill_urb(pUrb)
 
 extern void dump_urb(struct urb *purb);
@@ -97,9 +112,9 @@ extern void dump_urb(struct urb *purb);
 #define NdisInterlockedDecrement	atomic_dec
 #define InterlockedExchange		atomic_set
 
-#endif // LINUX //
+#endif /* LINUX */
 
-#define NT_SUCCESS(status)			(((status) >=0) ? (TRUE):(FALSE))
+#define NT_SUCCESS(status)		(((status) >= 0) ? (TRUE) : (FALSE))
 
 #define USBD_TRANSFER_DIRECTION_OUT		0
 #define USBD_TRANSFER_DIRECTION_IN		0
@@ -112,8 +127,8 @@ extern void dump_urb(struct urb *purb);
 #define USB_ST_NOERROR     0
 #endif
 
-// vendor-specific control operations
-#define CONTROL_TIMEOUT_JIFFIES ( (100 * OS_HZ) / 1000)
+/* vendor-specific control operations */
+#define CONTROL_TIMEOUT_JIFFIES ((100 * OS_HZ) / 1000)
 #define UNLINK_TIMEOUT_MS		3
 
 void RTUSBBulkOutDataPacketComplete(struct urb *purb, struct pt_regs *pt_regs);
@@ -125,50 +140,49 @@ void RTUSBBulkRxComplete(struct urb *pUrb, struct pt_regs *pt_regs);
 
 #ifdef KTHREAD_SUPPORT
 #define RTUSBMlmeUp(pAd) \
-	do{								    \
+	do {								    \
 		struct rt_rtmp_os_task *_pTask = &((pAd)->mlmeTask);\
-		if (_pTask->kthread_task) \
-        { \
+		if (_pTask->kthread_task) {\
 			_pTask->kthread_running = TRUE; \
-	        wake_up(&_pTask->kthread_q); \
+		wake_up(&_pTask->kthread_q); \
 		} \
-	}while(0)
+	} while (0)
 #else
 #define RTUSBMlmeUp(pAd)	        \
-	do{								    \
+	do {								    \
 		struct rt_rtmp_os_task *_pTask = &((pAd)->mlmeTask);\
 		CHECK_PID_LEGALITY(_pTask->taskPID)		    \
 		{ \
 			RTMP_SEM_EVENT_UP(&(_pTask->taskSema)); \
-		}\
-	}while(0)
+		} \
+	} while (0)
 #endif
 
 #ifdef KTHREAD_SUPPORT
 #define RTUSBCMDUp(pAd) \
-	do{	\
+	do {	\
 		struct rt_rtmp_os_task *_pTask = &((pAd)->cmdQTask);	\
 		{ \
 			_pTask->kthread_running = TRUE; \
-	        wake_up(&_pTask->kthread_q); \
+		wake_up(&_pTask->kthread_q); \
 		} \
-	}while(0)
+	} while (0)
 
 #else
 #define RTUSBCMDUp(pAd)	                \
-	do{									    \
+	do {							    \
 		struct rt_rtmp_os_task *_pTask = &((pAd)->cmdQTask);	\
 		CHECK_PID_LEGALITY(_pTask->taskPID)	    \
 		{\
 			RTMP_SEM_EVENT_UP(&(_pTask->taskSema)); \
-		}\
-	}while(0)
+		} \
+	} while (0)
 #endif
 
 #define DEVICE_VENDOR_REQUEST_OUT       0x40
 #define DEVICE_VENDOR_REQUEST_IN        0xc0
-//#define INTERFACE_VENDOR_REQUEST_OUT    0x41
-//#define INTERFACE_VENDOR_REQUEST_IN     0xc1
+/*#define INTERFACE_VENDOR_REQUEST_OUT    0x41*/
+/*#define INTERFACE_VENDOR_REQUEST_IN     0xc1*/
 
 #define BULKOUT_MGMT_RESET_FLAG		0x80
 
@@ -176,7 +190,7 @@ void RTUSBBulkRxComplete(struct urb *pUrb, struct pt_regs *pt_regs);
 #define RTUSB_CLEAR_BULK_FLAG(_M, _F)	((_M)->BulkFlags &= ~(_F))
 #define RTUSB_TEST_BULK_FLAG(_M, _F)	(((_M)->BulkFlags & (_F)) != 0)
 
-#define RTMP_IRQ_REQUEST(net_dev)		do{}while(0)
-#define RTMP_IRQ_RELEASE(net_dev)		do{}while(0)
+#define RTMP_IRQ_REQUEST(net_dev)		do {} while (0)
+#define RTMP_IRQ_RELEASE(net_dev)		do {} while (0)
 
-#endif // __RTMP_USB_H__ //
+#endif /* __RTMP_USB_H__ */
-- 
1.7.2.1

