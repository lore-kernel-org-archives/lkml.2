Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755961Ab0DWVlO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:41:14 -0400
Received: from adelie.canonical.com ([91.189.90.139]:55705 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615Ab0DWVlM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:41:12 -0400
Subject: Re: [PATCH v2] ACPI: DMI init_set_sci_en_on_resume for multiple
 Lenovo ThinkPads
From: Jerone Young <jerone.young@canonical.com>
To: Alex Chiang <achiang@canonical.com>
Cc: lenb@kernel.org, colin.king@canonical.com, linux-acpi@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org
In-Reply-To: <20100423162015.GA27760@canonical.com>
References: <20100423162015.GA27760@canonical.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Apr 2010 16:41:06 -0500
Message-ID: <1272058866.1594.7.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

You made a small mistake..point out below.

**mumble** .. still not a fan of quirk tables when a bios coming out to
resolve this issue is coming out..one out for T410 came out yesterday.

On Fri, 2010-04-23 at 10:20 -0600, Alex Chiang wrote:
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
> Confirmed by numerous testers in the launchpad bug that using
> acpi_sleep=sci_force_enable fixes the issue. We add the machines
> to acpisleep_dmi_table[] to automatically enable this workaround.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=15407
> BugLink: https://bugs.launchpad.net/ubuntu/+source/linux/+bug/532374
> 
> Cc: stable@kernel.org
> Signed-off-by: Alex Chiang <achiang@canonical.com>
> ---
> We want to get this patch upstream so that we can get it into
> -stable. Matthew Garrett's patch titled "Fall back to manually
> changing SCI_EN" is the plan for dealing with future platforms
> that will likely have this same BIOS bug.
> 
> v1 -> v2:
> 	- remove separate X201s entry, as the X201 entry will match it too
> ---
>  sleep.c |   32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> ---
> diff --git a/drivers/acpi/sleep.c b/drivers/acpi/sleep.c
> index f74834a..317794f 100644
> --- a/drivers/acpi/sleep.c
> +++ b/drivers/acpi/sleep.c
> @@ -450,6 +450,38 @@ static struct dmi_system_id __initdata acpisleep_dmi_table[] = {
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
> +	.ident = "Lenovo ThinkPad X201[s]",
> +	.matches = {
> +		DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +		DMI_MATCH(DMI_PRODUCT_VERSION, "ThinkPad X201"),

The X201s identifies it's self as an X201s .. So you would need two
separate entries.

Here is dmidecode data from a X201s:
http://launchpadlibrarian.net/45050202/dmidecode


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


