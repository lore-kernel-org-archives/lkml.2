Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809Ab2CVUkl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 16:40:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:54395 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759749Ab2CVUkj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 16:40:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="122142743"
Message-ID: <4F6B8E1B.9080802@linux.intel.com>
Date: Thu, 22 Mar 2012 13:39:55 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Michael Brunner <mibru@gmx.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@linux.intel.com>, linux-serial@vger.kernel.org
Subject: Re: [PATCH] pch_uart: Add Kontron COMe-mTT10 uart clock quirk
References: <20120322211903.6776ab18@mail.gmx.de>
In-Reply-To: <20120322211903.6776ab18@mail.gmx.de>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/22/2012 01:19 PM, Michael Brunner wrote:
> Add UART clock quirk for the Kontron COMe-mTT10 module.
> The board has previously been called nanoETXexpress-TT, therefore this
> is also checked. 
> 
> This patch follows the patchset submitted by Darren Hart at
> commit a46f5533ecfc7bbdd646d84fdab8656031a715c6.
> 
> Signed-off-by: Michael Brunner <mibru@gmx.de>
> ---
>  drivers/tty/serial/pch_uart.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index 332f2eb..0ab5295 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -210,6 +210,7 @@ enum {
>  #define CMITC_UARTCLK   192000000 /* 192.0000 MHz */
>  #define FRI2_64_UARTCLK  64000000 /*  64.0000 MHz */
>  #define FRI2_48_UARTCLK  48000000 /*  48.0000 MHz */
> +#define NTC1_UARTCLK     64000000 /*  64.0000 MHz */
>  
>  struct pch_uart_buffer {
>  	unsigned char *buf;
> @@ -379,6 +380,10 @@ static int pch_uart_get_uartclk(void)
>  	cmp = dmi_get_system_info(DMI_BOARD_NAME);
>  	if (cmp && strstr(cmp, "CM-iTC"))
>  		return CMITC_UARTCLK;
> +	/* Kontron COMe-mTT10 (nanoETXexpress-TT) */
> +	if (cmp && (strstr(cmp, "COMe-mTT") ||
> +		    strstr(cmp, "nanoETXexpress-TT")))
> +		return NTC1_UARTCLK;

These boards should already be supported by the following BIOS check. As
the DMI_BOARD_NAME was changing, it was Kontron's recommendation to use
the FRI2 prefix in the DMI_BIOS_VERSION.


>  	cmp = dmi_get_system_info(DMI_BIOS_VERSION);
>  	if (cmp && strnstr(cmp, "FRI2", 4))

Is this not working for you? If not, what is the DMI_BIOS_VERSION
reported by your board?

And for clarification, we are talking about this right:
http://us.kontron.com/products/systems+and+platforms/m2m/m2m+smart+services+developer+kit.html

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
