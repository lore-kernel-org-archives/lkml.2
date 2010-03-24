Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932447Ab0CXRku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 13:40:50 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:47119 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327Ab0CXRkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 13:40:46 -0400
Message-ID: <4BAA4E81.8070405@mvista.com>
Date: Wed, 24 Mar 2010 20:40:17 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Manuel Lauss <manuel.lauss@googlemail.com>
CC: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Manuel Lauss <manuel.lauss@gmail.com>
Subject: Re: [RFC PATCH 2/2] Alchemy: UART PM through serial framework.
References: <1269450986-3714-1-git-send-email-manuel.lauss@gmail.com> <1269450986-3714-3-git-send-email-manuel.lauss@gmail.com>
In-Reply-To: <1269450986-3714-3-git-send-email-manuel.lauss@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Manuel Lauss wrote:

> Hook up the Alchemy on-chip uarts with the platform 8250 PM callback
> and enable/disable the uart blocks as needed.
>
> Tested on Au1200.
>
> Signed-off-by: Manuel Lauss <manuel.lauss@gmail.com>
> ---
>  arch/mips/alchemy/common/platform.c |   17 +++++++++++++++++
>  arch/mips/alchemy/common/power.c    |   32 --------------------------------
>  2 files changed, 17 insertions(+), 32 deletions(-)
>
> diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
> index 2580e77..70f4abd 100644
> --- a/arch/mips/alchemy/common/platform.c
> +++ b/arch/mips/alchemy/common/platform.c
> @@ -21,6 +21,22 @@
>  #include <asm/mach-au1x00/au1100_mmc.h>
>  #include <asm/mach-au1x00/au1xxx_eth.h>
>  
> +static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
> +			    unsigned int old_state)
> +{
> +	if (state == 0) {		/* power on */
> +		__raw_writel(0, port->membase + UART_MOD_CNTRL);
> +		wmb();
> +		__raw_writel(1, port->membase + UART_MOD_CNTRL);
> +		wmb();
> +		__raw_writel(3, port->membase + UART_MOD_CNTRL);
> +		wmb();
> +	} else if (state == 3) {	/* power off */
> +		__raw_writel(0, port->membase + UART_MOD_CNTRL);
> +		wmb();
> +	}
> +}

   A *switch* statement seems more fitting here...

WBR, Sergei

