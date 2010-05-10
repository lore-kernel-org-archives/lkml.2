Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933197Ab0EJXFF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 19:05:05 -0400
Received: from kroah.org ([198.145.64.141]:45405 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932948Ab0EJW6f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 18:58:35 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Mon May 10 15:35:42 2010
Message-Id: <20100510223542.221366082@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Mon, 10 May 2010 15:35:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Colin King <colin.king@canonical.com>,
       Alex Chiang <achiang@canonical.com>, Len Brown <len.brown@intel.com>
Subject: [87/98] ACPI: DMI init_set_sci_en_on_resume for multiple Lenovo ThinkPads
In-Reply-To: <20100510223714.GA18416@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Alex Chiang <achiang@canonical.com>

commit 07bedca29b0973f36a6b6db36936deed367164ed upstream.

Multiple Lenovo ThinkPad models with Intel Core i5/i7 CPUs can
successfully suspend/resume once, and then hang on the second s/r
cycle.

We got confirmation that this was due to a BIOS defect. The BIOS
did not properly set SCI_EN coming out of S3. The BIOS guys
hinted that The Other Leading OS ignores the fact that hardware
owns the bit and sets it manually.

In any case, an existing DMI table exists for machines where this
defect is a known problem. Lenovo promise to fix their BIOS, but
for folks who either won't or can't upgrade their BIOS, allow
Linux to workaround the issue.

https://bugzilla.kernel.org/show_bug.cgi?id=15407
https://bugs.launchpad.net/ubuntu/+source/linux/+bug/532374

Confirmed by numerous testers in the launchpad bug that using
acpi_sleep=sci_force_enable fixes the issue. We add the machines
to acpisleep_dmi_table[] to automatically enable this workaround.

Cc: Colin King <colin.king@canonical.com>
Signed-off-by: Alex Chiang <achiang@canonical.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/acpi/sleep.c |  120 +++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 120 insertions(+)

--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -450,6 +450,126 @@ static struct dmi_system_id __initdata a
 		},
 	},
 	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T410",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad W510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T410",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad W510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T410",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad T510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad W510",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
+		},
+	},
+	{
+	.callback = init_set_sci_en_on_resume,
+	.ident = "Lenovo ThinkPad X201",
+	.matches = {
+		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
+		},
+	},
+	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {


