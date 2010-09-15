Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754305Ab0IOPZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 11:25:57 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:56148 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753132Ab0IOPZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 11:25:56 -0400
Date: Wed, 15 Sep 2010 08:20:14 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arun Murthy <arun.murthy@stericsson.com>
Cc: <sameo@linux.intel.com>, <linux-kernel@vger.kernel.org>,
        <linus.walleij@stericsson.com>, <mattias.wallin@stericsson.com>,
        <srinidhi.kasagar@stericsson.com>
Subject: Re: [PATCH] mfd: ab8500: update kconfig for ab8500 core driver
Message-Id: <20100915082014.99d702e4.randy.dunlap@oracle.com>
In-Reply-To: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com>
References: <1284549823-6246-1-git-send-email-arun.murthy@stericsson.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 16:53:43 +0530 Arun Murthy wrote:

> This patch add a dependancy for ab8500-core driver so as to depend on
> u8500 platform.
> 
> This patch also fixes the build issues(powerpc_allyesconfig) for the
> patch 03f582a93ecca6e9584b622570022abf08ed03ec (misc: Add ab8500 pwm
> driver)

Please list build errors/warnings that are fixed in your patch description.

This patch will certainly keep i386 builds from failing, like I saw
yesterday.  However, since this driver uses some spi_*() functions,
it should also depend on SPI_MASTER IMO.
See this patch:  http://lkml.org/lkml/2010/9/14/412


> Signed-off-by: Arun Murthy <arun.murthy@stericsson.com>
> Acked-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/mfd/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/Kconfig b/drivers/mfd/Kconfig
> index fbfe14a..841ce47 100644
> --- a/drivers/mfd/Kconfig
> +++ b/drivers/mfd/Kconfig
> @@ -475,7 +475,7 @@ config EZX_PCAP
>  
>  config AB8500_CORE
>  	bool "ST-Ericsson AB8500 Mixed Signal Power Management chip"
> -	depends on GENERIC_HARDIRQS && ABX500_CORE
> +	depends on GENERIC_HARDIRQS && ABX500_CORE && ARCH_U8500
>  	select MFD_CORE
>  	help
>  	  Select this option to enable access to AB8500 power management
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
