Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755097Ab0INWmh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 18:42:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56903 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab0INWmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 18:42:35 -0400
Date: Tue, 14 Sep 2010 15:41:41 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh@suse.de,
        Al Cho <acho@novell.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        driverdevel <devel@driverdev.osuosl.org>
Subject: [PATCH -next] staging/keucr: fix build when CONFIG_PM is not
 enabled
Message-Id: <20100914154141.9a95d40c.randy.dunlap@oracle.com>
In-Reply-To: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
References: <20100913134302.a77e9a3e.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

keucr driver has a build error when CONFIG_PM is not enabled, so fix that.

drivers/staging/keucr/usb.c:42: error: 'struct us_data' has no member named 'suspend_resume_hook'
drivers/staging/keucr/usb.c:43: error: 'struct us_data' has no member named 'suspend_resume_hook'
drivers/staging/keucr/usb.c:64: error: 'struct us_data' has no member named 'suspend_resume_hook'
drivers/staging/keucr/usb.c:65: error: 'struct us_data' has no member named 'suspend_resume_hook'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Al Cho <acho@novell.com>
---
 drivers/staging/keucr/usb.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- linux-next-20100913.orig/drivers/staging/keucr/usb.c
+++ linux-next-20100913/drivers/staging/keucr/usb.c
@@ -30,6 +30,7 @@ static struct usb_device_id eucr_usb_ids
 MODULE_DEVICE_TABLE (usb, eucr_usb_ids);
 
 
+#ifdef CONFIG_PM
 
 int eucr_suspend(struct usb_interface *iface, pm_message_t message)
 {
@@ -102,6 +103,14 @@ int eucr_reset_resume(struct usb_interfa
 }
 //EXPORT_SYMBOL_GPL(usb_stor_reset_resume);
 
+#else
+
+#define eucr_suspend		NULL
+#define eucr_resume		NULL
+#define eucr_reset_resume	NULL
+
+#endif
+
 //----- eucr_pre_reset() ---------------------
 static int eucr_pre_reset(struct usb_interface *iface)
 {
