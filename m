Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab1CKQzz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:55:55 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:43049 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928Ab1CKQzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:55:52 -0500
X-Auth-Info: 4FRB5DJAByHPqInn084cAMCztpQWK7tlZ0muQzXngeY=
Message-ID: <4D7A5497.4070801@grandegger.com>
Date: Fri, 11 Mar 2011 17:57:59 +0100
From: Wolfgang Grandegger <wg@grandegger.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Abhilash K V <abhilash.kv@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        Sriramakrishnan <srk@ti.com>
Subject: Re: [PATCH] can : AM3517EVM : add platform specific init
References: <1299775153-16766-1-git-send-email-abhilash.kv@ti.com>
In-Reply-To: <1299775153-16766-1-git-send-email-abhilash.kv@ti.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/10/2011 05:39 PM, Abhilash K V wrote:
> CAN module on AM3517 requires programming of IO expander
> as part of init sequence. Added transceiver_switch
> callback to handle this.
> 
> Signed-off-by: Sriramakrishnan <srk@ti.com>
> Reviewed-by:  Vaibhav Hiremath <hvaibhav@ti.com>
> Signed-off-by: Abhilash K V <abhilash.kv@ti.com>
> ---
>  arch/arm/mach-omap2/board-am3517evm.c |   18 ++++++++++++++++++
>  1 files changed, 18 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
> index 2e4aad2..782d72d 100644
> --- a/arch/arm/mach-omap2/board-am3517evm.c
> +++ b/arch/arm/mach-omap2/board-am3517evm.c
> @@ -734,6 +734,23 @@ static struct omap_board_mux board_mux[] __initdata = {
>  };
>  #endif
>  
> +/*
> + * HECC information
> + */
> +
> +#define CAN_STB         214
> +static void hecc_phy_control(int on)
> +{
> +        int r;
> +
> +        r = gpio_request(CAN_STB, "can_stb");
> +        if (r) {
> +                printk(KERN_ERR "failed to get can_stb \n");
> +                return;
> +        }
> +
> +        gpio_direction_output(CAN_STB, (on==1)?0:1);
> +}

This function is called ony *any* ifconfig up and down request. I would
expect gpio_request() will return -EBUSY when it's called more than once.

Wolfgang.

