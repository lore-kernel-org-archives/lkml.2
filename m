Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab0EJW4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 18:56:04 -0400
Received: from kroah.org ([198.145.64.141]:33432 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932408Ab0EJWxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:53:03 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:33:27 2010
Message-Id: <20100510223327.218678447@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:33:20 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kamal Mostafa <kamal@canonical.com>,
       Alex Chiang <achiang@canonical.com>, Len Brown <len.brown@intel.com>
Subject: [109/117] ACPI: sleep: init_set_sci_en_on_resume for Dell Studio 155x
In-Reply-To: <20100510223700.GA18404@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kamal Mostafa <kamal@canonical.com>

commit ea5bc73f4f56449b2d450068d492bcd17a675d7a upstream.

Add Dell Studio models (1558, 1557, 1555) to the 'set_sci_en_on_resume'
list to fix hang on resume.

BugLink: http://bugs.launchpad.net/bugs/553498

Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Acked-by: Alex Chiang <achiang@canonical.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep.c |   24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -578,6 +578,30 @@ static struct dmi_system_id __initdata a
 		DMI_MATCH(DMI_BOARD_NAME, "CF51-2L"),
 		},
 	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1558",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1558"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1557",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1557"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Dell Studio 1555",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Studio 1555"),
+		},
+	},
 	{},
 };
 #endif /* CONFIG_SUSPEND */


