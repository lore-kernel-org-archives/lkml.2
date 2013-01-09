Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab3AIVef (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:34:35 -0500
Received: from mail.kernel.org ([198.145.19.201]:42304 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab3AIUil (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:41 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 033/123] usb: gadget: tcm_usb_gadget: NULL terminate the FS descriptor list
Date: Wed,  9 Jan 2013 12:34:32 -0800
Message-Id: <20130109201502.802194819@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit fad8deb274edcef1c8ca38946338f5f4f8126fe2 upstream.

The descriptor list for FS speed was not NULL terminated. This patch
fixes this.

While here one of the twe two bAlternateSetting assignments for the BOT
interface. Both assign 0, one is enough.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/tcm_usb_gadget.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/tcm_usb_gadget.c
+++ b/drivers/usb/gadget/tcm_usb_gadget.c
@@ -2139,6 +2139,7 @@ static struct usb_descriptor_header *uas
 	(struct usb_descriptor_header *) &uasp_status_pipe_desc,
 	(struct usb_descriptor_header *) &uasp_fs_cmd_desc,
 	(struct usb_descriptor_header *) &uasp_cmd_pipe_desc,
+	NULL,
 };
 
 static struct usb_descriptor_header *uasp_hs_function_desc[] = {


