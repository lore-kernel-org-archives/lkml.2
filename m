Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933326Ab2AIUhS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 15:37:18 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:52859 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933034Ab2AIUhP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 15:37:15 -0500
From: bastien ROUCARIES <roucaries.bastien@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] x86 / reboot: Blacklist Dell OptiPlex 990 known to require PCI reboot
Date: Mon, 9 Jan 2012 17:00:08 +0100
User-Agent: KMail/1.13.7 (Linux/3.1.0-1-amd64; KDE/4.6.5; x86_64; ; )
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org
References: <201111160019.51303.rjw@sisk.pl>
In-Reply-To: <201111160019.51303.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201201091700.09318.roucaries.bastien@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le Wednesday 16 November 2011 00:19:51, Rafael J. Wysocki a écrit :
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> Dell OptiPlex 990 is known to require PCI reboot, so add it to the reboot
> blacklist in pci_reboot_dmi_table[].


Sorry to hi jack this thread but it seems that dell made the same crap with my precision T1600. See 
http://www.centos.org/modules/newbb/print.php?form=1&topic_id=32948&forum=55&order=ASC&start=0
or
https://bugzilla.redhat.com/show_bug.cgi?id=698239

Thanks

Bastien

> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  arch/x86/kernel/reboot.c |    8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> Index: linux/arch/x86/kernel/reboot.c
> ===================================================================
> --- linux.orig/arch/x86/kernel/reboot.c
> +++ linux/arch/x86/kernel/reboot.c
> @@ -443,6 +443,14 @@ static struct dmi_system_id __initdata p
>  			DMI_MATCH(DMI_PRODUCT_NAME, "Latitude E6420"),
>  		},
>  	},
> +	{	/* Handle problems with rebooting on the OptiPlex 990. */
> +		.callback = set_pci_reboot,
> +		.ident = "Dell OptiPlex 990",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "OptiPlex 990"),
> +		},
> +	},
>  	{ }
>  };
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
