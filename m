Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0JDRoL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:44:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754878Ab0JDRoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:44:09 -0400
Message-ID: <4CAA1247.2050408@zytor.com>
Date: Mon, 04 Oct 2010 10:43:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Daniel Drake <dsd@laptop.org>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org, mjg@redhat.com,
        linux-kernel@vger.kernel.org, dilinger@queued.net
Subject: Re: [PATCH] OLPC: register XO-1 RF kill device
References: <20101004171419.E3F3E9D401B@zog.reactivated.net>
In-Reply-To: <20101004171419.E3F3E9D401B@zog.reactivated.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2010 10:14 AM, Daniel Drake wrote:
> The upcoming XO-1 rfkill driver (for drivers/platform/x86) will register
> itself with the name "xo1-rfkill"
> 
> Add the necessary mechanics so that this is properly probed and
> initialized on XO-1 laptops.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
>  arch/x86/kernel/olpc.c |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 37c49934..d57f26a 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -17,6 +17,7 @@
>  #include <linux/spinlock.h>
>  #include <linux/io.h>
>  #include <linux/string.h>
> +#include <linux/platform_device.h>
>  
>  #include <asm/geode.h>
>  #include <asm/setup.h>
> @@ -248,6 +249,15 @@ static int __init olpc_init(void)
>  			olpc_platform_info.boardrev >> 4,
>  			olpc_platform_info.ecver);
>  
> +	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0)) { /* XO-1 */
> +		struct platform_device *pdev;
> +
> +		/* register any relevant platform devices */
> +		pdev = platform_device_register_simple("xo1-rfkill", -1, NULL, 0);
> +		if (IS_ERR(pdev))
> +			return PTR_ERR(pdev);
> +	}
> +
>  	return 0;
>  }
>  

Please put this in a separate file, or at least a separate function
(adding all the XO-1 platform devices.)

	-hpa
