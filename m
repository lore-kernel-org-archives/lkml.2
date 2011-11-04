Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089Ab1KDHQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Nov 2011 03:16:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46767 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab1KDHQM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Nov 2011 03:16:12 -0400
Message-ID: <4EB39139.3090709@suse.de>
Date: Fri, 04 Nov 2011 08:16:09 +0100
From: Ismail Donmez <idoenmez@suse.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0a1) Gecko/20111103 Thunderbird/10.0a1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, stable@kernel.org
Subject: Re: [PATCH] x86: Fix reboot issue for Dell Optiplex 990 V2
References: <1320373797-4393-1-git-send-email-trenn@suse.de>
In-Reply-To: <1320373797-4393-1-git-send-email-trenn@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi;

On 11/04/2011 03:29 AM, Thomas Renninger wrote:
> This was the only (reboot=p) option that worked for this desktop.
> Default does not reboot as well.
>
> V2: Remove copy and paste left over from another machine
>
> CC: Ismail Donmez<idoenmez@suse.de>
> CC: stable@kernel.org
> Signed-off-by: Thomas Renninger<trenn@suse.de>
> ---
>   arch/x86/kernel/reboot.c |    9 +++++++++
>   1 files changed, 9 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
> index e334be1..42f8cd7 100644
> --- a/arch/x86/kernel/reboot.c
> +++ b/arch/x86/kernel/reboot.c
> @@ -443,6 +443,15 @@ static struct dmi_system_id __initdata pci_reboot_dmi_table[] = {
>   			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
>   		},
>   	},
> +	{
> +		.callback = set_pci_reboot,
> +		.ident = "Dell Optiplex 990",
> +		.matches = {
> +			/* Found in BIOS version A06 */
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
> +		},
> +	},
>   	{ }
>   };

I have this machine and can confirm reboot=pci is only way to get it to 
reboot. But also Dell's very recent Latitude E6520 laptop needs the same 
workaround. It would be nice to send a patch for it too.

Regards.

-- 
İsmail Dönmez - openSUSE Booster
SUSE LINUX Products GmbH
Maxfeldstr. 5, 90409 Nürnberg, Germany
GF: Jeff Hawn, Jennifer Guild, Felix Imendörffer, HRB 16746 (AG Nürnberg)
