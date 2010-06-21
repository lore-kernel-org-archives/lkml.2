Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab0FUL4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 07:56:47 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:36945 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932438Ab0FUL4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 07:56:30 -0400
MIME-version: 1.0
Content-transfer-encoding: 8BIT
Content-type: text/plain; charset=UTF-8
Date: Mon, 21 Jun 2010 13:57:04 +0200
From: Michal Nazarewicz <m.nazarewicz@samsung.com>
Subject: [PATCH] USB: gadget: section mismatch warning fixed
To: linux-usb@vger.kernel.org
Cc: David Brownell <dbrownell@users.sourceforge.net>,
       Alan Stern <stern@rowland.harvard.edu>, Bryan Wu <cooloney@kernel.org>,
       Cliff Cai <cliff.cai@analog.com>, Daniel Mack <daniel@caiaq.de>,
       Fabien Chouteau <fabien.chouteau@barco.com>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Laurent Pinchart <laurent.pinchart@skynet.be>,
       Mike Frysinger <vapier@gentoo.org>,
       Peter Korsgaard <peter.korsgaard@barco.com>,
       Takashi Iwai <tiwai@suse.de>, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <662381b24e04af307ec656b1250f4b33aef0d502.1277116502.git.m.nazarewicz@samsung.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In may gadgets bind and bind like functions were in a init section
as they were only run during initialisation.  However, being
callback functions they were referenced from structures in “normal”
sections.  Changing the tag from “__init” to “__ref” fixes the
warnings.

Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
---
That's what I'm getting without this patch (output somehow trimmed):

WARNING: drivers/usb/gadget/g_audio.o(.data+0x84): Section mismatch in reference from the variable audio_config_driver to the function .init.text:audio_do_config()
The variable audio_config_driver references
the function __init audio_do_config()

WARNING: drivers/usb/gadget/g_audio.o(.data+0x1b4): Section mismatch in reference from the variable audio_driver to the function .init.text:audio_bind()
The variable audio_driver references
the function __init audio_bind()

WARNING: drivers/usb/gadget/g_cdc.o(.data+0xc0): Section mismatch in reference from the variable cdc_config_driver to the function .init.text:cdc_do_config()
The variable cdc_config_driver references
the function __init cdc_do_config()

WARNING: drivers/usb/gadget/g_cdc.o(.data+0x310): Section mismatch in reference from the variable cdc_driver to the function .init.text:cdc_bind()
The variable cdc_driver references
the function __init cdc_bind()

WARNING: drivers/usb/gadget/g_ether.o(.data+0x28): Section mismatch in reference from the variable eth_config_driver to the function .init.text:eth_do_config()
The variable eth_config_driver references
the function __init eth_do_config()

WARNING: drivers/usb/gadget/g_ether.o(.data+0xc8): Section mismatch in reference from the variable rndis_config_driver to the function .init.text:rndis_do_config()
The variable rndis_config_driver references
the function __init rndis_do_config()

WARNING: drivers/usb/gadget/g_ether.o(.data+0x3b4): Section mismatch in reference from the variable eth_driver to the function .init.text:eth_bind()
The variable eth_driver references
the function __init eth_bind()

WARNING: drivers/usb/gadget/g_file_storage.o(.data+0x8): Section mismatch in reference from the variable fsg_driver to the function .init.text:fsg_bind()
The variable fsg_driver references
the function __init fsg_bind()

WARNING: drivers/usb/gadget/g_hid.o(.data+0x40): Section mismatch in reference from the variable config_driver to the function .init.text:do_config()
The variable config_driver references
the function __init do_config()

WARNING: drivers/usb/gadget/g_hid.o(.data+0x1bc): Section mismatch in reference from the variable hidg_driver to the function .init.text:hid_bind()
The variable hidg_driver references
the function __init hid_bind()

WARNING: drivers/usb/gadget/g_mass_storage.o(.data+0x40): Section mismatch in reference from the variable msg_config_driver to the function .init.text:msg_do_config()
The variable msg_config_driver references
the function __init msg_do_config()

WARNING: drivers/usb/gadget/g_mass_storage.o(.data+0x190): Section mismatch in reference from the variable msg_driver to the function .init.text:msg_bind()
The variable msg_driver references
the function __init msg_bind()

WARNING: drivers/usb/gadget/g_midi.o(.data+0x8): Section mismatch in reference from the variable gmidi_driver to the function .init.text:gmidi_bind()
The variable gmidi_driver references
the function __init gmidi_bind()

WARNING: drivers/usb/gadget/g_printer.o(.data+0x8): Section mismatch in reference from the variable printer_driver to the function .init.text:printer_bind()
The variable printer_driver references
the function __init printer_bind()

WARNING: drivers/usb/gadget/g_serial.o(.data+0xc8): Section mismatch in reference from the variable serial_config_driver to the function .init.text:serial_bind_config()
The variable serial_config_driver references
the function __init serial_bind_config()

WARNING: drivers/usb/gadget/g_serial.o(.data+0x240): Section mismatch in reference from the variable gserial_driver to the function .init.text:gs_bind()
The variable gserial_driver references
the function __init gs_bind()

WARNING: drivers/usb/gadget/g_webcam.o(.data+0x74): Section mismatch in reference from the variable webcam_config_driver to the function .init.text:webcam_config_bind()
The variable webcam_config_driver references
the function __init webcam_config_bind()

WARNING: drivers/usb/gadget/g_webcam.o(.data+0x188): Section mismatch in reference from the variable webcam_driver to the function .init.text:webcam_bind()
The variable webcam_driver references
the function __init webcam_bind()

WARNING: drivers/usb/gadget/g_zero.o(.data+0x28): Section mismatch in reference from the variable sourcesink_driver to the function .init.text:sourcesink_bind_config()
The variable sourcesink_driver references
the function __init sourcesink_bind_config()

WARNING: drivers/usb/gadget/g_zero.o(.data+0xb8): Section mismatch in reference from the variable loopback_driver to the function .init.text:loopback_bind_config()
The variable loopback_driver references
the function __init loopback_bind_config()

WARNING: drivers/usb/gadget/g_zero.o(.data+0x25c): Section mismatch in reference from the variable zero_driver to the function .init.text:zero_bind()
The variable zero_driver references
the function __init zero_bind()


PS. Sorry about a long Cc list -- I want to notify everyone whos files
I'm touching.


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
index a62af7b..b744ccd 100644
--- a/drivers/usb/gadget/audio.c
+++ b/drivers/usb/gadget/audio.c
@@ -89,7 +89,7 @@ static const struct usb_descriptor_header *otg_desc[] = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init audio_do_config(struct usb_configuration *c)
+static int __ref audio_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -113,7 +113,7 @@ static struct usb_configuration audio_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init audio_bind(struct usb_composite_dev *cdev)
+static int __ref audio_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	int			status;
diff --git a/drivers/usb/gadget/cdc2.c b/drivers/usb/gadget/cdc2.c
index 928137d..1f5ba2f 100644
--- a/drivers/usb/gadget/cdc2.c
+++ b/drivers/usb/gadget/cdc2.c
@@ -129,7 +129,7 @@ static u8 hostaddr[ETH_ALEN];
 /*
  * We _always_ have both CDC ECM and CDC ACM functions.
  */
-static int __init cdc_do_config(struct usb_configuration *c)
+static int __ref cdc_do_config(struct usb_configuration *c)
 {
 	int	status;
 
@@ -159,7 +159,7 @@ static struct usb_configuration cdc_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init cdc_bind(struct usb_composite_dev *cdev)
+static int __ref cdc_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/ether.c b/drivers/usb/gadget/ether.c
index 400f803..114fa02 100644
--- a/drivers/usb/gadget/ether.c
+++ b/drivers/usb/gadget/ether.c
@@ -237,7 +237,7 @@ static u8 hostaddr[ETH_ALEN];
  * the first one present.  That's to make Microsoft's drivers happy,
  * and to follow DOCSIS 1.0 (cable modem standard).
  */
-static int __init rndis_do_config(struct usb_configuration *c)
+static int __ref rndis_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -270,7 +270,7 @@ MODULE_PARM_DESC(use_eem, "use CDC EEM mode");
 /*
  * We _always_ have an ECM, CDC Subset, or EEM configuration.
  */
-static int __init eth_do_config(struct usb_configuration *c)
+static int __ref eth_do_config(struct usb_configuration *c)
 {
 	/* FIXME alloc iConfiguration string, set it in c->strings */
 
@@ -297,7 +297,7 @@ static struct usb_configuration eth_config_driver = {
 
 /*-------------------------------------------------------------------------*/
 
-static int __init eth_bind(struct usb_composite_dev *cdev)
+static int __ref eth_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/f_loopback.c b/drivers/usb/gadget/f_loopback.c
index e91d1b1..4322587 100644
--- a/drivers/usb/gadget/f_loopback.c
+++ b/drivers/usb/gadget/f_loopback.c
@@ -324,7 +324,7 @@ static void loopback_disable(struct usb_function *f)
 
 /*-------------------------------------------------------------------------*/
 
-static int __init loopback_bind_config(struct usb_configuration *c)
+static int __ref loopback_bind_config(struct usb_configuration *c)
 {
 	struct f_loopback	*loop;
 	int			status;
@@ -346,7 +346,7 @@ static int __init loopback_bind_config(struct usb_configuration *c)
 	return status;
 }
 
-static struct usb_configuration loopback_driver = {
+static  struct usb_configuration loopback_driver = {
 	.label		= "loopback",
 	.strings	= loopback_strings,
 	.bind		= loopback_bind_config,
diff --git a/drivers/usb/gadget/f_sourcesink.c b/drivers/usb/gadget/f_sourcesink.c
index 6d3cc44..685d768 100644
--- a/drivers/usb/gadget/f_sourcesink.c
+++ b/drivers/usb/gadget/f_sourcesink.c
@@ -404,7 +404,7 @@ static void sourcesink_disable(struct usb_function *f)
 
 /*-------------------------------------------------------------------------*/
 
-static int __init sourcesink_bind_config(struct usb_configuration *c)
+static int __ref sourcesink_bind_config(struct usb_configuration *c)
 {
 	struct f_sourcesink	*ss;
 	int			status;
diff --git a/drivers/usb/gadget/file_storage.c b/drivers/usb/gadget/file_storage.c
index 2b6d364..d57c09f 100644
--- a/drivers/usb/gadget/file_storage.c
+++ b/drivers/usb/gadget/file_storage.c
@@ -3335,7 +3335,7 @@ fill_serial:
 }
 
 
-static int __init fsg_bind(struct usb_gadget *gadget)
+static int __ref fsg_bind(struct usb_gadget *gadget)
 {
 	struct fsg_dev		*fsg = the_fsg;
 	int			rc;
diff --git a/drivers/usb/gadget/gmidi.c b/drivers/usb/gadget/gmidi.c
index 2b56ce6..e92c20e 100644
--- a/drivers/usb/gadget/gmidi.c
+++ b/drivers/usb/gadget/gmidi.c
@@ -1157,7 +1157,7 @@ fail:
 /*
  * Creates an output endpoint, and initializes output ports.
  */
-static int __init gmidi_bind(struct usb_gadget *gadget)
+static int __ref gmidi_bind(struct usb_gadget *gadget)
 {
 	struct gmidi_device *dev;
 	struct usb_ep *in_ep, *out_ep;
diff --git a/drivers/usb/gadget/hid.c b/drivers/usb/gadget/hid.c
index 7757226..735495b 100644
--- a/drivers/usb/gadget/hid.c
+++ b/drivers/usb/gadget/hid.c
@@ -127,7 +127,7 @@ static struct usb_gadget_strings *dev_strings[] = {
 
 /****************************** Configurations ******************************/
 
-static int __init do_config(struct usb_configuration *c)
+static int __ref do_config(struct usb_configuration *c)
 {
 	struct hidg_func_node *e;
 	int func = 0, status = 0;
@@ -156,7 +156,7 @@ static struct usb_configuration config_driver = {
 
 /****************************** Gadget Bind ******************************/
 
-static int __init hid_bind(struct usb_composite_dev *cdev)
+static int __ref hid_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	struct list_head *tmp;
diff --git a/drivers/usb/gadget/mass_storage.c b/drivers/usb/gadget/mass_storage.c
index 2b11e20..2a0536e 100644
--- a/drivers/usb/gadget/mass_storage.c
+++ b/drivers/usb/gadget/mass_storage.c
@@ -141,7 +141,7 @@ static int msg_thread_exits(struct fsg_common *common)
 	return 0;
 }
 
-static int __init msg_do_config(struct usb_configuration *c)
+static int __ref msg_do_config(struct usb_configuration *c)
 {
 	static struct fsg_common common;
 
@@ -179,7 +179,7 @@ static struct usb_configuration msg_config_driver = {
 /****************************** Gadget Bind ******************************/
 
 
-static int __init msg_bind(struct usb_composite_dev *cdev)
+static int __ref msg_bind(struct usb_composite_dev *cdev)
 {
 	struct usb_gadget *gadget = cdev->gadget;
 	int status;
diff --git a/drivers/usb/gadget/printer.c b/drivers/usb/gadget/printer.c
index 43abf55..c9a628e 100644
--- a/drivers/usb/gadget/printer.c
+++ b/drivers/usb/gadget/printer.c
@@ -1346,7 +1346,7 @@ printer_unbind(struct usb_gadget *gadget)
 	set_gadget_data(gadget, NULL);
 }
 
-static int __init
+static int __ref
 printer_bind(struct usb_gadget *gadget)
 {
 	struct printer_dev	*dev;
diff --git a/drivers/usb/gadget/serial.c b/drivers/usb/gadget/serial.c
index f46a609..b22eedb 100644
--- a/drivers/usb/gadget/serial.c
+++ b/drivers/usb/gadget/serial.c
@@ -137,7 +137,7 @@ MODULE_PARM_DESC(n_ports, "number of ports to create, default=1");
 
 /*-------------------------------------------------------------------------*/
 
-static int __init serial_bind_config(struct usb_configuration *c)
+static int __ref serial_bind_config(struct usb_configuration *c)
 {
 	unsigned i;
 	int status = 0;
@@ -161,7 +161,7 @@ static struct usb_configuration serial_config_driver = {
 	.bmAttributes	= USB_CONFIG_ATT_SELFPOWER,
 };
 
-static int __init gs_bind(struct usb_composite_dev *cdev)
+static int __ref gs_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
diff --git a/drivers/usb/gadget/webcam.c b/drivers/usb/gadget/webcam.c
index 98e9c8b..44c3d8c 100644
--- a/drivers/usb/gadget/webcam.c
+++ b/drivers/usb/gadget/webcam.c
@@ -308,7 +308,7 @@ static const struct uvc_descriptor_header * const uvc_hs_streaming_cls[] = {
  * USB configuration
  */
 
-static int __init
+static int __ref
 webcam_config_bind(struct usb_configuration *c)
 {
 	return uvc_bind_config(c, uvc_control_cls, uvc_fs_streaming_cls,
@@ -330,7 +330,7 @@ webcam_unbind(struct usb_composite_dev *cdev)
 	return 0;
 }
 
-static int __init
+static int __ref
 webcam_bind(struct usb_composite_dev *cdev)
 {
 	int ret;
diff --git a/drivers/usb/gadget/zero.c b/drivers/usb/gadget/zero.c
index 807280d..cf35392 100644
--- a/drivers/usb/gadget/zero.c
+++ b/drivers/usb/gadget/zero.c
@@ -264,7 +264,7 @@ static void zero_resume(struct usb_composite_dev *cdev)
 
 /*-------------------------------------------------------------------------*/
 
-static int __init zero_bind(struct usb_composite_dev *cdev)
+static int __ref zero_bind(struct usb_composite_dev *cdev)
 {
 	int			gcnum;
 	struct usb_gadget	*gadget = cdev->gadget;
-- 
1.7.1

