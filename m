Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab0IGOd0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 10:33:26 -0400
Received: from www.tglx.de ([62.245.132.106]:43744 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110Ab0IGOdH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 10:33:07 -0400
Message-Id: <20100907125055.947634394@linutronix.de>
User-Agent: quilt/0.47-1
Date: Tue, 07 Sep 2010 14:32:43 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: [patch 13/30] usb: ftdi-elan: Convert "mutex" to semaphore
References: <20100907124636.880953480@linutronix.de>
Content-Disposition: inline; filename=drivers-usb-ftdi-elan-sema.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The "mutex" ftdi->sw_lock is used as a lock and a completion. Convert
it to a real semaphore which allows both.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-usb@vger.kernel.org

---
 drivers/usb/misc/ftdi-elan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux-2.6/drivers/usb/misc/ftdi-elan.c
===================================================================
--- linux-2.6.orig/drivers/usb/misc/ftdi-elan.c
+++ linux-2.6/drivers/usb/misc/ftdi-elan.c
@@ -2769,7 +2769,7 @@ static int ftdi_elan_probe(struct usb_in
         ftdi->sequence_num = ++ftdi_instances;
         mutex_unlock(&ftdi_module_lock);
         ftdi_elan_init_kref(ftdi);
-        init_MUTEX(&ftdi->sw_lock);
+	sema_init(&ftdi->sw_lock, 1);
         ftdi->udev = usb_get_dev(interface_to_usbdev(interface));
         ftdi->interface = interface;
         mutex_init(&ftdi->u132_lock);


