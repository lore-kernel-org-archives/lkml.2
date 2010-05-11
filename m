Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755049Ab0EKQVu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 12:21:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:38565 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754522Ab0EKQVn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 12:21:43 -0400
Date: Tue, 11 May 2010 10:21:38 -0600
From: Alex Chiang <achiang@canonical.com>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
       Len Brown <len.brown@intel.com>
Subject: Re: [107/117] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
Message-ID: <20100511162138.GA1893@canonical.com>
Mail-Followup-To: Alex Chiang <achiang@canonical.com>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	stable@kernel.org, stable-review@kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	alan@lxorguk.ukuu.org.uk, Colin King <colin.king@canonical.com>,
	Len Brown <len.brown@intel.com>
References: <20100510223700.GA18404@kroah.com>
 <20100510223327.043329892@kvm.kroah.org>
 <20100511033825.GA7513@canonical.com>
 <20100511151049.GH14895@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100511151049.GH14895@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Greg KH <gregkh@suse.de>:
> 
> > Len, Greg, what would you like me to do? I think the cleanest
> > thing to do to help keep -stable clean would be to:
> > 
> >	a) drop this patch from current -stable queue
> >	b) revert 07bedca29b09 upstream
> >	c)  apply the patch from patchwork
> >	d) re-apply to -stable
>
> How about getting a fixup patch into Linus's tree and then I'll
> apply that fixup patch to stable as well?

Sure, here's a patch against Linus's latest. I'll leave it up to
Len to decide which approach he'd prefer.

From: Alex Chiang <achiang@canonical.com>

ACPI: sleep: eliminate duplicate entries in acpisleep_dmi_table[]

Duplicate entries ended up acpisleep_dmi_table[] by accident.
They don't hurt functionality, but they are ugly, so let's get
rid of them.

Cc: stable@kernel.org
Signed-off-by: Alex Chiang <achiang@canonical.com>
---
diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
index e2e9925..baa76bb 100644
--- a/drivers/acpi/sleep.c
+++ b/drivers/acpi/sleep.c
@@ -475,101 +475,13 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
 	},
 	{
 	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
+	.ident = "Lenovo ThinkPad X201[s]",
 	.matches = {
 		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
 		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
 		},
 	},
 	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T410",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad W510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T410",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad T510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad W510",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
-		},
-	},
-	{
-	.callback = init_set_sci_en_on_resume,
-	.ident = "Lenovo ThinkPad X201",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
-		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
-		},
-	},
-	{
 	.callback = init_old_suspend_ordering,
 	.ident = "Panasonic CF51-2L",
 	.matches = {
