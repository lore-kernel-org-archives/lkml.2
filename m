Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1EDQfn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 12:35:43 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58370 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752090Ab1EDQfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 12:35:42 -0400
Date: Wed, 4 May 2011 12:35:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Tony Vroon <tony@linx.net>
cc: linux-usb@vger.kernel.org, <usb-storage@lists.one-eyed-alien.net>,
        <linux-kernel@vger.kernel.org>
Subject: Re: ums-realtek: Unneeded SubClass & Protocol entries (Fujitsu S760
 laptop)
In-Reply-To: <4DC14DD9.9060407@linx.net>
Message-ID: <Pine.LNX.4.44L0.1105041232160.2039-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 May 2011, Tony Vroon wrote:

> Good afternoon,
> 
> The following message was emitted by my kernel:
> usb 1-1.6: new high speed USB device number 5 using ehci_hcd
> ums-realtek 1-1.6:1.0: This device (0bda,0138,3882 S 06 P 50) has
> unneeded SubClass and Protocol entries in unusual_devs.h (kernel
> 2.6.39-rc5-00274-g609cfda)
>    Please send a copy of this message to <linux-usb@vger.kernel.org> and
> <usb-storage@lists.one-eyed-alien.net>
> scsi6 : usb-storage 1-1.6:1.0

Thanks for reporting this.  Does the patch below cause the message to 
go away?

Alan Stern



Index: usb-2.6/drivers/usb/storage/unusual_realtek.h
===================================================================
--- usb-2.6.orig/drivers/usb/storage/unusual_realtek.h
+++ usb-2.6/drivers/usb/storage/unusual_realtek.h
@@ -23,19 +23,19 @@
 #if defined(CONFIG_USB_STORAGE_REALTEK) || \
 		defined(CONFIG_USB_STORAGE_REALTEK_MODULE)
 
-UNUSUAL_DEV(0x0bda, 0x0159, 0x0000, 0x9999,
+UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
 UNUSUAL_DEV(0x0bda, 0x0158, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
-UNUSUAL_DEV(0x0bda, 0x0138, 0x0000, 0x9999,
+UNUSUAL_DEV(0x0bda, 0x0159, 0x0000, 0x9999,
 		"Realtek",
 		"USB Card Reader",
-		USB_SC_SCSI, USB_PR_BULK, init_realtek_cr, 0),
+		USB_SC_DEVICE, USB_PR_DEVICE, init_realtek_cr, 0),
 
 #endif  /* defined(CONFIG_USB_STORAGE_REALTEK) || ... */

