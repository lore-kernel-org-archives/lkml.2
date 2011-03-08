Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab1CHStH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 13:49:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:35179 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab1CHStB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 13:49:01 -0500
Date: Tue, 8 Mar 2011 10:47:57 -0800
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Subhasish Ghosh <subhasish@mistralsolutions.com>
Cc: davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, m-watkins@ti.com, nsekhar@ti.com,
        sachi@mistralsolutions.com,
        Greg.Kroah-Hartman@rcsinet15.oracle.com (maintainer:TTY LAYER
	<gregkh@suse.de>, commit_signer:2/4=50%, commit_signer:1/2=50%),
        Andrew Morton (commit_signer:1/4=25%) 
	<akpm@linux-foundation.org>,
        Randy Dunlap (commit_signer:1/4=25%) <randy.dunlap@oracle.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [PATCH v3 7/7] tty: add pruss SUART driver
Message-Id: <20110308104757.0f75409b.randy.dunlap@oracle.com>
In-Reply-To: <1299592667-21367-8-git-send-email-subhasish@mistralsolutions.com>
References: <1299592667-21367-1-git-send-email-subhasish@mistralsolutions.com>
	<1299592667-21367-8-git-send-email-subhasish@mistralsolutions.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D7679EF.006C,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  8 Mar 2011 19:27:46 +0530 Subhasish Ghosh wrote:

> This patch adds support for the TTY compliant
> Soft-UART device emulated on PRUSS.
> 
> This patch depends on:
> davinci: macro rename DA8XX_LPSC0_DMAX to DA8XX_LPSC0_PRUSS.
> 		https://patchwork.kernel.org/patch/615681/
> davinci: changed SRAM allocator to shared ram.
> 		https://patchwork.kernel.org/patch/549351/
> 
> Signed-off-by: Subhasish Ghosh <subhasish@mistralsolutions.com>
> ---
>  drivers/tty/serial/Kconfig             |   22 +
>  drivers/tty/serial/Makefile            |   10 +
>  drivers/tty/serial/pruss_suart.c       | 1058 +++++++++++++++++++
>  drivers/tty/serial/pruss_suart.h       | 1081 ++++++++++++++++++++
>  drivers/tty/serial/pruss_suart_api.c   | 1757 ++++++++++++++++++++++++++++++++
>  drivers/tty/serial/pruss_suart_utils.c |  391 +++++++
>  include/linux/serial_core.h            |    2 +
>  7 files changed, 4321 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/tty/serial/pruss_suart.c
>  create mode 100644 drivers/tty/serial/pruss_suart.h
>  create mode 100644 drivers/tty/serial/pruss_suart_api.c
>  create mode 100644 drivers/tty/serial/pruss_suart_utils.c
> 
> diff --git a/drivers/tty/serial/Kconfig b/drivers/tty/serial/Kconfig
> index 2b83346..14ea0a3 100644
> --- a/drivers/tty/serial/Kconfig
> +++ b/drivers/tty/serial/Kconfig
> @@ -1596,4 +1596,26 @@ config SERIAL_PCH_UART
>  	  This driver is for PCH(Platform controller Hub) UART of Intel EG20T
>  	  which is an IOH(Input/Output Hub) for x86 embedded processor.
>  	  Enabling PCH_DMA, this PCH UART works as DMA mode.
> +
> +#
> +# SUART Kernel Configuration
> +#
> +
> +config SERIAL_PRUSS_SUART
> +	depends on ARCH_DAVINCI && ARCH_DAVINCI_DA850
> +	select SERIAL_CORE
> +	tristate "PRUSS based SoftUART emulation on DA8XX"
> +	---help---
> +	This driver emulates upto eight different UARTs on the PRUSS.

	                     up to

> +	You may modify the NR_SUARTS macro in the driver to emulate
> +	less number of UARTS as per your requirement.
> +	If not sure, mark N

	             mark N.

> +
> +config PRUSS_SUART_MCASP
> +    int "McASP number"
> +    depends on ARCH_DAVINCI && ARCH_DAVINCI_DA830 && SERIAL_PRUSS_SUART
> +    default "0"
> +    ---help---
> +    Enter the McASP number to use with SUART (0, 1 or 2).
> +	You will need to recompile the kernel if this is changed.

The 2 help text lines should be indented the same.

>  endmenu


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
