Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab1KGBy5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 20:54:57 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62414 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752182Ab1KGByz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 20:54:55 -0500
Message-ID: <4EB73A6A.5010900@kernel.org>
Date: Sun, 06 Nov 2011 20:54:50 -0500
From: Len Brown <lenb@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.22) Gecko/20110906 Fedora/3.1.14-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.14
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>, x86@kernel.org
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org
Subject: Re: [PATCH] X86: Solve Dell Latitudes do not reboot on x86_64 more
 generally
References: <4EB39139.3090709@suse.de> <1320453843-938-1-git-send-email-trenn@suse.de>
In-Reply-To: <1320453843-938-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2011 08:44 PM, Thomas Renninger wrote:

> There are quite some reports that those do not reboot:
> https://bugs.launchpad.net/ubuntu/+source/linux/+bug/833705
> ->E6520, E6220
> http://www.linux-club.de/viewtopic.php?f=29&t=114459&start=20
> ->E5520
> and some more already are blacklisted
> 
> This patch improves the blacklist for all E6xxx and E5xxx Latitudes.
> 
> Strange is that on above Ubuntu bug it was mentioned that 32 bit
> reboots just fine, which should use the same mechanism than 64 bit
> by default (ACPI).
> 
> While this should solve the problem on short term for quite some users,
> hopefully a more generic way is found sooner or later...
> 
> 
> Signed-off-by: Thomas Renninger <trenn@suse.de>
> CC: stable@kernel.org


Acked-by: Len Brown <len.brown@intel.com>

Although this may be an issue with ACPI,
looks like this patch should go though TIP
because of the file changed.

thanks,
-Len


> ---
>  arch/x86/kernel/reboot.c |   20 ++++++--------------
>  1 files changed, 6 insertions(+), 14 deletions(-)
> 
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index 42f8cd7..7fcb20a 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -419,28 +419,20 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>  			DMI_MATCH(DMI_PRODUCT_NAME, "iMac9,1"),
>  		},
>  	},
> -	{	/* Handle problems with rebooting on the Latitude E6320. */
> -		.callback = set_pci_reboot,
> -		.ident = "Dell Latitude E6320",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6320"),
> -		},
> -	},
> -	{	/* Handle problems with rebooting on the Latitude E5420. */
> +	{
>  		.callback = set_pci_reboot,
> -		.ident = "Dell Latitude E5420",
> +		.ident = "Dell Latitude E5xxx",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5420"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E5"),
>  		},
>  	},
> -	{	/* Handle problems with rebooting on the Latitude E6420. */
> +	{
>  		.callback = set_pci_reboot,
> -		.ident = "Dell Latitude E6420",
> +		.ident = "Dell Latitude E6xxx",
>  		.matches = {
>  			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> -			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6"),
>  		},
>  	},
>  	{


