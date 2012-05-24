Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934089Ab2EXS1F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 14:27:05 -0400
Received: from g1t0029.austin.hp.com ([15.216.28.36]:3151 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933458Ab2EXS1B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 14:27:01 -0400
Message-ID: <1337884020.2718.89.camel@lorien2>
Subject: Re: [PATCH v4 6/6] ACPI: Set hotplug _OST support bit to _OSC
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Toshi Kani <toshi.kani@hp.com>
Cc: shuahkhan@gmail.com, lenb@kernel.org, linux-acpi@vger.kernel.org,
        bhelgaas@google.com, liuj97@gmail.com, andi@firstfloor.org,
        linux-kernel@vger.kernel.org
Date: Thu, 24 May 2012 12:27:00 -0600
In-Reply-To: <1337826324-16802-7-git-send-email-toshi.kani@hp.com>
References: <1337826324-16802-1-git-send-email-toshi.kani@hp.com>
	 <1337826324-16802-7-git-send-email-toshi.kani@hp.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 20:25 -0600, Toshi Kani wrote:
> When ACPI_HOTPLUG_OST is defined, set hotplug _OST support bit
> OSC_SB_HOTPLUG_OST_SUPPORT to indicate that the OS supports hotplug
> _OST by calling the platform-wide ACPI Operating System Capabilities
> (_OSC).
> 
> Signed-off-by: Toshi Kani <toshi.kani@hp.com>
> ---
>  drivers/acpi/bus.c |    4 ++++
>  1 files changed, 4 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/acpi/bus.c b/drivers/acpi/bus.c
> index 3188da3..3d4fc7a 100644
> --- a/drivers/acpi/bus.c
> +++ b/drivers/acpi/bus.c
> @@ -548,6 +548,10 @@ static void acpi_bus_osc_support(void)
>  	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_PPC_OST_SUPPORT;
>  #endif
>  
> +#ifdef ACPI_HOTPLUG_OST
> +	capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_HOTPLUG_OST_SUPPORT;
> +#endif

Why isn't firmware response to _OSC checked to make sure firmware also
supports _OST? My general comments about compile time switch that is
enabled only a few cases _OST Ejection/Insertion is intended to be used
are applicable here.

-- Shuah




> +
>  	if (!ghes_disable)
>  		capbuf[OSC_SUPPORT_TYPE] |= OSC_SB_APEI_SUPPORT;
>  	if (ACPI_FAILURE(acpi_get_handle(NULL, "\\_SB", &handle)))


