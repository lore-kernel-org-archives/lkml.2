Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab1FZXad (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 19:30:33 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17324 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab1FZX37 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 19:29:59 -0400
Date: Sun, 26 Jun 2011 16:29:08 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com,
        Grant Likely <grant.likely@secretlab.ca>,
        Randy Dunlap <randy.dunlap@oracle.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        David Woodhouse <dwmw2@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] mtd: make ofpart buildable as a separate module
Message-Id: <20110626162908.2f783471.randy.dunlap@oracle.com>
In-Reply-To: <1309122180-12838-2-git-send-email-dbaryshkov@gmail.com>
References: <1309122180-12838-1-git-send-email-dbaryshkov@gmail.com>
	<1309122180-12838-2-git-send-email-dbaryshkov@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: rtcsinet21.oracle.com [66.248.204.29]
X-CT-RefId: str=0001.0A090207.4E07C0D1.00E6:SCFSTAT5015188,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 01:02:59 +0400 Dmitry Eremin-Solenikov wrote:

> As ofpart now uses a standard mtd partitions parser interface, make it
> buildable as a separate module. Also provide MODULE_DESCRIPTION and
> MODULE_AUTHOR for this module.
> 
> Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>

Acked-by: Randy Dunlap <randy.dunlap@oracle.com>

Thanks.

> ---
>  drivers/mtd/Kconfig  |    3 ++-
>  drivers/mtd/Makefile |    2 +-
>  drivers/mtd/ofpart.c |    2 ++
>  3 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/mtd/Kconfig b/drivers/mtd/Kconfig
> index 4be8373..cc02e21 100644
> --- a/drivers/mtd/Kconfig
> +++ b/drivers/mtd/Kconfig
> @@ -137,7 +137,8 @@ config MTD_AFS_PARTS
>  	  'physmap' map driver (CONFIG_MTD_PHYSMAP) does this, for example.
>  
>  config MTD_OF_PARTS
> -	def_bool y
> +	tristate "OpenFirmware partitioning information support"
> +	default Y
>  	depends on OF
>  	help
>  	  This provides a partition parsing function which derives
> diff --git a/drivers/mtd/Makefile b/drivers/mtd/Makefile
> index 39664c4..9aaac3a 100644
> --- a/drivers/mtd/Makefile
> +++ b/drivers/mtd/Makefile
> @@ -5,8 +5,8 @@
>  # Core functionality.
>  obj-$(CONFIG_MTD)		+= mtd.o
>  mtd-y				:= mtdcore.o mtdsuper.o mtdconcat.o mtdpart.o
> -mtd-$(CONFIG_MTD_OF_PARTS)	+= ofpart.o
>  
> +obj-$(CONFIG_MTD_OF_PARTS)	+= ofpart.o
>  obj-$(CONFIG_MTD_REDBOOT_PARTS) += redboot.o
>  obj-$(CONFIG_MTD_CMDLINE_PARTS) += cmdlinepart.o
>  obj-$(CONFIG_MTD_AFS_PARTS)	+= afs.o
> diff --git a/drivers/mtd/ofpart.c b/drivers/mtd/ofpart.c
> index 41c4518..aa33b8a 100644
> --- a/drivers/mtd/ofpart.c
> +++ b/drivers/mtd/ofpart.c
> @@ -174,3 +174,5 @@ out:
>  module_init(ofpart_parser_init);
>  
>  MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Parser for MTD partitioning information in device tree");
> +MODULE_AUTHOR("Vitaly Wool, David Gibson");
> -- 

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
