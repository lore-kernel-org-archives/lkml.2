Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab0CUB4k (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 21:56:40 -0400
Received: from xenotime.net ([72.52.64.118]:43064 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752659Ab0CUB4j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 21:56:39 -0400
Message-ID: <4BA57CD4.6020906@xenotime.net>
Date: Sat, 20 Mar 2010 18:56:36 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>,
       David Woodhouse <dwmw2@infradead.org>,
       linux-pci <linux-pci@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] panic: Add taint flag TAINT_FIRMWARE_WORKAROUND ('I')
References: <1269126097.18314.111.camel@localhost> <1269126410.18314.116.camel@localhost>
In-Reply-To: <1269126410.18314.116.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/10 16:06, Ben Hutchings wrote:
> This taint flag will initially be used when warning about invalid ACPI
> DMAR tables.
> 
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> ---
>  include/linux/kernel.h |    1 +
>  kernel/panic.c         |    2 ++
>  2 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/kernel.h b/include/linux/kernel.h
> index eaf7221..ab8072b 100644
> --- a/include/linux/kernel.h
> +++ b/include/linux/kernel.h
> @@ -344,6 +344,7 @@ extern enum system_states {
>  #define TAINT_OVERRIDDEN_ACPI_TABLE	8
>  #define TAINT_WARN			9
>  #define TAINT_CRAP			10
> +#define TAINT_FIRMWARE_WORKAROUND	11
>  
>  extern void dump_stack(void) __cold;
>  
> diff --git a/kernel/panic.c b/kernel/panic.c
> index 8b821bc..e9fa224 100644
> --- a/kernel/panic.c
> +++ b/kernel/panic.c
> @@ -178,6 +178,7 @@ static const struct tnt tnts[] = {
>  	{ TAINT_OVERRIDDEN_ACPI_TABLE,	'A', ' ' },
>  	{ TAINT_WARN,			'W', ' ' },
>  	{ TAINT_CRAP,			'C', ' ' },
> +	{ TAINT_FIRMWARE_WORKAROUND,	'I', ' ' },
>  };
>  
>  /**
> @@ -194,6 +195,7 @@ static const struct tnt tnts[] = {
>   *  'A' - ACPI table overridden.
>   *  'W' - Taint on warning.
>   *  'C' - modules from drivers/staging are loaded.
> + *  'I' - Firmware workaround was required.
>   *
>   *	The string is overwritten by the next call to print_tainted().
>   */

Please update Documentation/oops-tracing.txt also.

thanks,
-- 
~Randy
