Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754902Ab1CKMVO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:21:14 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55822 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab1CKMVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:21:11 -0500
Message-ID: <4D7A135F.5030004@ru.mvista.com>
Date: Fri, 11 Mar 2011 15:19:43 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Abhilash K V <abhilash.kv@ti.com>
CC: linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, tony@atomide.com, linux@arm.linux.org.uk,
        Sriramakrishnan <srk@ti.com>
Subject: Re: [PATCH] can : AM3517EVM : add platform specific init
References: <1299775153-16766-1-git-send-email-abhilash.kv@ti.com>
In-Reply-To: <1299775153-16766-1-git-send-email-abhilash.kv@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 10-03-2011 19:39, Abhilash K V wrote:

> CAN module on AM3517 requires programming of IO expander
> as part of init sequence. Added transceiver_switch
> callback to handle this.

> Signed-off-by: Sriramakrishnan<srk@ti.com>
> Reviewed-by:  Vaibhav Hiremath<hvaibhav@ti.com>
> Signed-off-by: Abhilash K V<abhilash.kv@ti.com>
> ---
>   arch/arm/mach-omap2/board-am3517evm.c |   18 ++++++++++++++++++
>   1 files changed, 18 insertions(+), 0 deletions(-)

> diff --git a/arch/arm/mach-omap2/board-am3517evm.c b/arch/arm/mach-omap2/board-am3517evm.c
> index 2e4aad2..782d72d 100644
> --- a/arch/arm/mach-omap2/board-am3517evm.c
> +++ b/arch/arm/mach-omap2/board-am3517evm.c
> @@ -734,6 +734,23 @@ static struct omap_board_mux board_mux[] __initdata = {
>   };
>   #endif
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

    Have you run the patch thru checkpatch.pl? IIRC, it warns about spaces 
before '\n'...

WBR, Sergei
