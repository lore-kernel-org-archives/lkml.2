Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756971Ab2EBAUT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 20:20:19 -0400
Received: from mail131.messagelabs.com ([216.82.242.99]:39088 "EHLO
	mail131.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab2EBAUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 20:20:17 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-12.tower-131.messagelabs.com!1335918015!18661042!2
X-Originating-IP: [216.166.12.32]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: Add helper macro for comedi_driver boilerplate
Date: Tue, 1 May 2012 17:20:04 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205011720.04599.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce the module_comedi_driver macro which is a convenience
macro for comedi driver modules similar to module_platform_driver.
It is intended to be used by drivers where the init/exit section
does nothing but register/unregister the comedi driver. By using
this macro it is possible to eliminate a few lines of boilerplate
code per comedi driver.

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation

---

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 02e4ae0..8828609 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -298,6 +298,18 @@ int comedi_device_attach(struct comedi_device *dev,
 int comedi_driver_register(struct comedi_driver *);
 int comedi_driver_unregister(struct comedi_driver *);
 
+/**
+ * module_comedi_driver() - Helper macro for registering a comedi driver
+ * @__comedi_driver: comedi_driver struct
+ *
+ * Helper macro for comedi drivers which do not do anything special in module
+ * init/exit. This eliminates a lot of boilerplate. Each module may only use
+ * this macro once, and calling it replaces module_init() and module_exit().
+ */
+#define module_comedi_driver(__comedi_driver) \
+	module_driver(__comedi_driver, comedi_driver_register, \
+			comedi_driver_unregister)
+
 void init_polling(void);
 void cleanup_polling(void);
 void start_polling(struct comedi_device *);
