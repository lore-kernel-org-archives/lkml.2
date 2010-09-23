Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754870Ab0IWWkN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 18:40:13 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:35181 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753498Ab0IWWkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 18:40:11 -0400
Date: Thu, 23 Sep 2010 16:39:04 -0700
From: Andres Salomon <dilinger@queued.net>
To: Daniel Drake <dsd@laptop.org>
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] OLPC: Only enable PCI configuration type override
 on XO-1
Message-ID: <20100923163904.7fd9a790@debxo>
In-Reply-To: <20100923162805.0F6549D401B@zog.reactivated.net>
References: <20100923162805.0F6549D401B@zog.reactivated.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me!

Acked-by: Andres Salomon <dilinger@queued.net>


On Thu, 23 Sep 2010
17:28:04 +0100 (BST) Daniel Drake <dsd@laptop.org> wrote:

> This configuration type override is for XO-1 only and must not happen
> on XO-1.5.
> 
> Signed-off-by: Daniel Drake <dsd@laptop.org>
> ---
> 
> Replaces earlier patches:
> [PATCH 1/3] OLPC: extended board revision detection
> [PATCH 2/3] PCI: OLPC configuration cleanup
> 
> Due to the fact that CONFIG_OLPC is associated with multiple laptop
> models (not only the XO-1), it makes sense to keep this as a separate
> configuration option.
> 
> We decided against adding functions to distinguish between
> XO-1/XO-1.5 as we don't want to encourage laptop checking in this
> way. There should only be one or two cases where this actually
> matters (here is one of them).
> 
>  arch/x86/Kconfig       |    2 +-
>  arch/x86/kernel/olpc.c |    6 ++++--
>  arch/x86/pci/olpc.c    |    2 +-
>  3 files changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index cea0cd9..0ed4c9b 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -1900,7 +1900,7 @@ config PCI_GODIRECT
>  	bool "Direct"
>  
>  config PCI_GOOLPC
> -	bool "OLPC"
> +	bool "OLPC XO-1"
>  	depends on OLPC
>  
>  config PCI_GOANY
> diff --git a/arch/x86/kernel/olpc.c b/arch/x86/kernel/olpc.c
> index 0e0cdde..635888c 100644
> --- a/arch/x86/kernel/olpc.c
> +++ b/arch/x86/kernel/olpc.c
> @@ -242,8 +242,10 @@ static int __init olpc_init(void)
>  			(unsigned char *) &olpc_platform_info.ecver,
> 1); 
>  #ifdef CONFIG_PCI_OLPC
> -	/* If the VSA exists let it emulate PCI, if not emulate in
> kernel */
> -	if (!cs5535_has_vsa2())
> +	/* If the VSA exists let it emulate PCI, if not emulate in
> kernel.
> +	 * XO-1 only. */
> +	if (olpc_platform_info.boardrev < olpc_board_pre(0xd0) &&
> +			!cs5535_has_vsa2())
>  		x86_init.pci.arch_init = pci_olpc_init;
>  #endif
>  
> diff --git a/arch/x86/pci/olpc.c b/arch/x86/pci/olpc.c
> index b348154..13700ec 100644
> --- a/arch/x86/pci/olpc.c
> +++ b/arch/x86/pci/olpc.c
> @@ -304,7 +304,7 @@ static struct pci_raw_ops pci_olpc_conf = {
>  
>  int __init pci_olpc_init(void)
>  {
> -	printk(KERN_INFO "PCI: Using configuration type OLPC\n");
> +	printk(KERN_INFO "PCI: Using configuration type OLPC
> XO-1\n"); raw_pci_ops = &pci_olpc_conf;
>  	is_lx = is_geode_lx();
>  	return 0;

