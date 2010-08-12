Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933871Ab0HLPmv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 11:42:51 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:62137 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933662Ab0HLPmY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 11:42:24 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: TEXT/PLAIN; CHARSET=EUC-KR
Date: Thu, 12 Aug 2010 17:43:52 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCHv8 09/13] Revert "USB: gadget: section mismatch warning fixed"
In-reply-to: <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>
To: linux-usb@vger.kernel.org, Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Message-id: <ad117de19af4733f113c8631e53556cc308dbf06.1281625724.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
References: <cover.1281625724.git.m.nazarewicz@samsung.com>
 <76f0f5732bfbbb36d50baf05ecdd12bec3396275.1281625724.git.m.nazarewicz@samsung.com>
 <313ee18ecf53fb8f1c040656b697de869f0c0856.1281625724.git.m.nazarewicz@samsung.com>
 <48e2d6507f004252a012cf25bc0a06e5cb69808f.1281625724.git.m.nazarewicz@samsung.com>
 <f2f6babb8b593d5c6f6141604bd647658d59f124.1281625724.git.m.nazarewicz@samsung.com>
 <4addd8199cfd6a2aa582904cd6efa01bc77a5290.1281625724.git.m.nazarewicz@samsung.com>
 <9737a711d395932c8803511ba581722d46be5292.1281625724.git.m.nazarewicz@samsung.com>
 <f07e8ff5f36d5893e62764b9e372da0cc305a2b5.1281625724.git.m.nazarewicz@samsung.com>
 <550ddf8273d87cb418dd5716cbec906e74aa03d4.1281625724.git.m.nazarewicz@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts a commit which proposed an invalid solution
for a section mismatch.  Next 3 commits will fix it correctly.

Conflicts:

	drivers/usb/gadget/mass_storage.c

Signed-off-by: Michał Nazarewicz <m.nazarewicz@samsung.com>
---
 drivers/usb/gadget/audio.c        |    4 ++--
 drivers/usb/gadget/cdc2.c         |    4 ++--
 drivers/usb/gadget/ether.c        |    6 +++---
 drivers/usb/gadget/f_loopback.c   |    4 ++--
 drivers/usb/gadget/f_sourcesink.c |    2 +-
 drivers/usb/gadget/file_storage.c |    2 +-
 drivers/usb/gadget/gmidi.c        |    2 +-
 drivers/usb/gadget/hid.c          |    4 ++--
 drivers/usb/gadget/mass_storage.c |    4 ++--
 drivers/usb/gadget/printer.c      |    2 +-
 drivers/usb/gadget/serial.c       |    4 ++--
 drivers/usb/gadget/webcam.c       |    4 ++--
 drivers/usb/gadget/zero.c         |    2 +-
 13 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/usb/gadget/audio.c b/drivers/usb/gadget/audio.c
index b744ccd..a62af7b 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -89,7 +89,7 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref audio_do_config(struct usb_configuration *c)
+static int __init audio_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -113,7 +113,7 @@ static struct usb_configuration audio_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref audio_bind(struct usb_composite_dev *cdev)
+static int __init audio_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	int			status;
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 1f5ba2f..928137d 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -129,7 +129,7 @@ static u8 hostaddr[ETH_ALEN];
 /*
  * We _always_ have both CDC ECM and CDC ACM functions.
  */
-static int __ref cdc_do_config(struct usb_configuration *c)
+static int __init cdc_do_config(struct usb_configuration *c)
 {
 	int	status;
 
@@ -159,7 +159,7 @@ static struct usb_configuration cdc_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref cdc_bind(struct usb_composite_dev *cdev)
+static int __init cdc_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 114fa02..400f803 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -237,7 +237,7 @@ static u8 hostaddr[ETH_ALEN];
  * the first one present.  That's to make Microsoft's drivers happy,
  * and to follow DOCSIS 1.0 (cable modem standard).
  */
-static int __ref rndis_do_config(struct usb_configuration *c)
+static int __init rndis_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -270,7 +270,7 @@ MODULE_PARM_DESC(use_eem, "use CDC EEM mode");
 /*
  * We _always_ have an ECM, CDC Subset, or EEM configuration.
  */
-static int __ref eth_do_config(struct usb_configuration *c)
+static int __init eth_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -297,7 +297,7 @@ static struct usb_configuration eth_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref eth_bind(struct usb_composite_dev *cdev)
+static int __init eth_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index 4322587..e91d1b1 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -324,7 +324,7 @@ static void loopback_disable(struct usb_function *f)
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref loopback_bind_config(struct usb_configuration *c)
+static int __init loopback_bind_config(struct usb_configuration *c)
 {
 	struct f_loopback	*loop;
 	int			status;
@@ -346,7 +346,7 @@ static int __ref loopback_bind_config(struct usb_configuration *c)
 	return status;
 }
 
-static  struct usb_configuration loopback_driver = {
+static struct usb_configuration loopback_driver = {
 	.label		= "loopback",
 	.strings	= loopback_strings,
 	.bind		= loopback_bind_config,
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index 685d768..6d3cc44 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -404,7 +404,7 @@ static void sourcesink_disable(struct usb_function *f)
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref sourcesink_bind_config(struct usb_configuration *c)
+static int __init sourcesink_bind_config(struct usb_configuration *c)
 {
 	struct f_sourcesink	*ss;
 	int			status;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index ab77792..aae04c2 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3348,7 +3348,7 @@ fill_serial:
 }
 
 
-static int __ref fsg_bind(struct usb_gadget *gadget)
+static int __init fsg_bind(struct usb_gadget *gadget)
 {
 	struct fsg_dev		*fsg = the_fsg;
 	int			rc;
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 1b413a5..b7bf880 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1157,7 +1157,7 @@ fail:
 /*
  * Creates an output endpoint, and initializes output ports.
  */
-static int __ref gmidi_bind(struct usb_gadget *gadget)
+static int __init gmidi_bind(struct usb_gadget *gadget)
 {
 	struct gmidi_device *dev;
 	struct usb_ep *in_ep, *out_ep;
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 735495b..7757226 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -127,7 +127,7 @@ static struct usb_gadget_strings *dev_strings[] = {
 
 /****************************** Configurations ******************************/
 
-static int __ref do_config(struct usb_configuration *c)
+static int __init do_config(struct usb_configuration *c)
 {
 	struct hidg_func_node *e;
 	int func = 0, status = 0;
@@ -156,7 +156,7 @@ static struct usb_configuration config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-static int __ref hid_bind(struct usb_composite_dev *cdev)
+static int __init hid_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	struct list_head *tmp;
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 493d153..05e9bd3 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -111,7 +111,7 @@ static int msg_thread_exits(struct fsg_common *common)
 	return 0;
 }
 
-static int __ref msg_do_config(struct usb_configuration *c)
+static int __init msg_do_config(struct usb_configuration *c)
 {
 	static const struct fsg_operations ops = {
 		.thread_exits = msg_thread_exits,
@@ -149,7 +149,7 @@ static struct usb_configuration msg_config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-static int __ref msg_bind(struct usb_composite_dev *cdev)
+static int __init msg_bind(struct usb_composite_dev *cdev)
 {
 	int status;
 
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index cf241c3..04c7bbf 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1347,7 +1347,7 @@ printer_unbind(struct usb_gadget *gadget)
 	set_gadget_data(gadget, NULL);
 }
 
-static int __ref
+static int __init
 printer_bind(struct usb_gadget *gadget)
 {
 	struct printer_dev	*dev;
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index b22eedb..f46a609 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -137,7 +137,7 @@ MODULE_PARM_DESC(n_ports, "number of ports to create, default=1");
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref serial_bind_config(struct usb_configuration *c)
+static int __init serial_bind_config(struct usb_configuration *c)
 {
 	unsigned i;
 	int status = 0;
@@ -161,7 +161,7 @@ static struct usb_configuration serial_config_driver = {
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
 };
 
-static int __ref gs_bind(struct usb_composite_dev *cdev)
+static int __init gs_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index de1deb7..288d211 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -308,7 +308,7 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
  * USB configuration
  */
 
-static int __ref
+static int __init
 webcam_config_bind(struct usb_configuration *c)
 {
 	return uvc_bind_config(c, uvc_control_cls, uvc_fs_streaming_cls,
@@ -330,7 +330,7 @@ webcam_unbind(struct usb_composite_dev *cdev)
 	return 0;
 }
 
-static int __ref
+static int __init
 webcam_bind(struct usb_composite_dev *cdev)
 {
 	int ret;
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index cf35392..807280d 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -264,7 +264,7 @@ static void zero_resume(struct usb_composite_dev *cdev)
 
 /*-------------------------------------------------------------------------*/
 
-static int __ref zero_bind(struct usb_composite_dev *cdev)
+static int __init zero_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
-- 
1.7.1

