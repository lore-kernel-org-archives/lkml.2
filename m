Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933325Ab3AIUik (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 15:38:40 -0500
Received: from mail.kernel.org ([198.145.19.201]:42235 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933152Ab3AIUid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:33 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 031/123] usb: gadget: midi: free hs descriptors
Date: Wed,  9 Jan 2013 12:34:30 -0800
Message-Id: <20130109201502.532261085@linuxfoundation.org>
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
@@ -415,6 +415,7 @@ static void f_midi_unbind(struct usb_con
 	midi->id = NULL;
 
 	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
 	kfree(midi);
 }
 


