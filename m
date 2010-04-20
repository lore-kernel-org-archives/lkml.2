Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab0DTQ4t (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 12:56:49 -0400
Received: from adelie.canonical.com ([91.189.90.139]:35995 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752926Ab0DTQ4q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 12:56:46 -0400
Subject: Re: [PATCH] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
From: Jerone Young <jerone.young@canonical.com>
To: Alex Chiang <achiang@canonical.com>
Cc: lenb@kernel.org, colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <20100420140314.GA5573@canonical.com>
References: <20100420140314.GA5573@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 11:56:41 -0500
Message-ID: <1271782601.25170.105.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't think this patch should go in as Lenovo is issuing a BIOS to
address this issue. On these Thinkpads listed and more. Seems to add
uneeded quirks in my opinion.

Though some over all patch may be good for all machines. As Windows
seems to be setting this bit on it's own.

				Jerone

On Tue, 2010-04-20 at 08:03 -0600, Alex Chiang wrote:
> Multiple Lenovo ThinkPad models with Intel Core i5/i7 CPUs can
> successfully suspend/resume once, and then hang on the second s/r
> cycle.
> 
> We got confirmation that this was due to a BIOS defect. The BIOS
> did not properly set SCI_EN coming out of S3. The BIOS guys
> hinted that The Other Leading OS ignores the fact that hardware
> owns the bit and sets it manually.
> 
> In any case, an existing DMI table exists for machines where this
> defect is a known problem. Lenovo promise to fix their BIOS, but
> for folks who either won't or can't upgrade their BIOS, allow
> Linux to workaround the issue.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15407
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/532374
> 
> Confirmed by numerous testers in the launchpad bug that using
> acpi_sleep=sci_force_enable fixes the issue. We add the machines
> to acpisleep_dmi_table[] to automatically enable this workaround.
> 
> Cc: stable@kernel.org
> Cc: Colin King <colin.king@canonical.com>
> Signed-off-by: Alex Chiang <achiang@canonical.com>
> ---
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index f74834a..ce54cd0 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -450,6 +450,46 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
>  		},
>  	},
>  	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad T410",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T410"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad T510",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad T510"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad W510",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad W510"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad X201",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),
> +		},
> +	},
> +	{
> +	.callback = init_set_sci_en_on_resume,
> +	.ident = "Lenovo ThinkPad X201",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201s"),
> +		},
> +	},
> +	{
>  	.callback = init_old_suspend_ordering,
>  	.ident = "Panasonic CF51-2L",
>  	.matches = {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-acpi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


