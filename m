Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932274Ab2L1T1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Dec 2012 14:27:47 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:55618 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932416Ab2L1TTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Dec 2012 14:19:39 -0500
Message-Id: <20121228190338.486163782@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Fri, 28 Dec 2012 20:04:11 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@ti.com>
Subject: [ 041/173] usb: gadget: midi: free hs descriptors
In-Reply-To: <20121228190330.025298996@decadent.org.uk>
X-SA-Exim-Connect-IP: 151.217.219.220
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit d185039f7982eb82cf8d03b6fb6689587ca5af24 upstream.

The HS descriptors are only created if HS is supported by the UDC but we
never free them.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/gadget/f_midi.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/usb/gadget/f_midi.c b/drivers/usb/gadget/f_midi.c
index b2522ba..b978c5d 100644
--- a/drivers/usb/gadget/f_midi.c
+++ b/drivers/usb/gadget/f_midi.c
@@ -415,6 +415,7 @@ static void f_midi_unbind(struct usb_configuration *c, struct usb_function *f)
 	midi->id = NULL;
 
 	usb_free_descriptors(f->descriptors);
+	usb_free_descriptors(f->hs_descriptors);
 	kfree(midi);
 }
 


