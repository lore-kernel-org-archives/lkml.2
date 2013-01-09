Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933505Ab3AIUjM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:39:12 -0500
Received: from mail.kernel.org ([198.145.19.201]:42450 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933439Ab3AIUi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:58 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 30/80] usb: gadget: midi: free hs descriptors
Date: Wed,  9 Jan 2013 12:35:22 -0800
Message-Id: <20130109201504.250690740@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201500.410171651@linuxfoundation.org>
References: <20130109201500.410171651@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d185039f7982eb82cf8d03b6fb6689587ca5af24 upstream.

The HS descriptors are only created if HS is supported by the UDC but we
never free them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/gadget/f_midi.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/gadget/f_midi.c
+++ b/drivers/usb/gadget/f_midi.c
@@ -416,6 +416,7 @@ static void f_midi_unbind(struct usb_con
 	midi->id = NULL;
 
 	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
 	kfree(midi);
 }
 


