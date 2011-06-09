Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab1FIIDb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 04:03:31 -0400
Received: from ausxipps301.us.dell.com ([143.166.148.223]:35953 "EHLO
	ausxipps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982Ab1FIIDO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 04:03:14 -0400
X-Loopcount0: from 10.175.216.250
From: <Narendra_K@Dell.com>
To: <kernel@linuxace.com>, <linux-kernel@vger.kernel.org>
CC: <Jordan_Hargrave@Dell.com>, <jbarnes@virtuousgeek.org>
Date: Thu, 9 Jun 2011 01:03:00 -0700
Subject: RE: [PATCH] Fix embedded nic order on Dell PowerEdge systems
Thread-Topic: [PATCH] Fix embedded nic order on Dell PowerEdge systems
Thread-Index: AcwmGKvBGW/R5RVvTQeeG3VgoGPEMAAYiy9A
Message-ID: <E31FB011129F30488D5861F3839049151DA349A086@BLRX7MCDC201.AMER.DELL.COM>
References: <1307564053-2996-1-git-send-email-kernel@linuxace.com>
In-Reply-To: <1307564053-2996-1-git-send-email-kernel@linuxace.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Phil Oester [mailto:kernel@linuxace.com]
> Sent: Thursday, June 09, 2011 1:44 AM
> To: linux-kernel@vger.kernel.org
> Cc: K, Narendra; Hargrave, Jordan; jbarnes@virtuousgeek.org
> Subject: [PATCH] Fix embedded nic order on Dell PowerEdge systems
> 
>     In commit 6e8af08dfa40b747002207d3ce8e8b43a050d99f ("PCI: enable
> pci=bfsort
>     by default on future Dell systems"), the callback added was placed at the
>     top of the list, before the specific PowerEdge models.  This ends up
>     breaking the more specific models listed, since the new callback handles
>     all Dell systems but the older systems don't have the new 0xB1 smbios
>     entry.
> 
>     Fix this by placing the new check _after_ the more specific PowerEdge
>     sytems.
> 
>     Phil Oester
> 
>     Signed-off-by: Phil Oester <kernel@linuxace.com>
> 
> diff --git a/arch/x86/pci/common.c b/arch/x86/pci/common.c index
> 5fe7502..92df322 100644
> --- a/arch/x86/pci/common.c
> +++ b/arch/x86/pci/common.c
> @@ -247,13 +247,6 @@ static const struct dmi_system_id __devinitconst
> pciprobe_dmi_table[] = {
>  	},
>  #endif		/* __i386__ */
>  	{
> -		.callback = find_sort_method,
> -		.ident = "Dell System",
> -		.matches = {
> -			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> -		},
> -	},
> -	{
>  		.callback = set_bf_sort,
>  		.ident = "Dell PowerEdge 1950",
>  		.matches = {
> @@ -294,6 +287,13 @@ static const struct dmi_system_id __devinitconst
> pciprobe_dmi_table[] = {
>  		},
>  	},
>  	{
> +		.callback = find_sort_method,
> +		.ident = "Dell System",
> +		.matches = {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc"),
> +		},
> +	},
> +	{
>  		.callback = set_bf_sort,
>  		.ident = "HP ProLiant BL20p G3",
>  		.matches = {
[>] 

Hi, this issue is fixed and the fix is in Jesse's linux-next tree.

http://marc.info/?l=linux-pci&m=130108034729082 (x86/PCI: Preserve existing pci=bfsort whitelist for Dell systems)

With regards,
Narendra K

