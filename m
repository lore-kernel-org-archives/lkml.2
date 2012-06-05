Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383Ab2FEWRz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:17:55 -0400
Received: from gate.crashing.org ([63.228.1.57]:54665 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753251Ab2FEWRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:17:54 -0400
Message-ID: <1338934659.7150.113.camel@pasglop>
Subject: Re: [PATCH] powerpc: Fix assmption of end_of_DRAM() returns end
 address
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Bharat Bhushan <r65777@freescale.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        galak@kernel.crashing.org,
        Bharat Bhushan <bharat.bhushan@freescale.com>
Date: Wed, 06 Jun 2012 08:17:39 +1000
In-Reply-To: <1338904504-2750-1-git-send-email-bharat.bhushan@freescale.com>
References: <1338904504-2750-1-git-send-email-bharat.bhushan@freescale.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-05 at 19:25 +0530, Bharat Bhushan wrote:
> memblock_end_of_DRAM() returns end_address + 1, not end address.
> While some code assumes that it returns end address.

Shouldn't we instead fix it the other way around ? IE, make
memblock_end_of_DRAM() does what the name implies, which is to return
the last byte of DRAM, and fix the -other- callers not to make bad
assumptions ?

Cheers,
Ben.

> Signed-off-by: Bharat Bhushan <bharat.bhushan@freescale.com>
> ---
> This patch is based on next branch of https://git.kernel.org/pub/scm/linux/kernel/git/benh/powerpc.git
> 
>  arch/powerpc/platforms/44x/currituck.c     |    2 +-
>  arch/powerpc/platforms/85xx/corenet_ds.c   |    2 +-
>  arch/powerpc/platforms/85xx/ge_imp3a.c     |    2 +-
>  arch/powerpc/platforms/85xx/mpc8536_ds.c   |    2 +-
>  arch/powerpc/platforms/85xx/mpc85xx_ds.c   |    2 +-
>  arch/powerpc/platforms/85xx/mpc85xx_mds.c  |    2 +-
>  arch/powerpc/platforms/85xx/p1022_ds.c     |    2 +-
>  arch/powerpc/platforms/86xx/mpc86xx_hpcn.c |    2 +-
>  8 files changed, 8 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/powerpc/platforms/44x/currituck.c b/arch/powerpc/platforms/44x/currituck.c
> index 583e67f..9f6c33d 100644
> --- a/arch/powerpc/platforms/44x/currituck.c
> +++ b/arch/powerpc/platforms/44x/currituck.c
> @@ -160,7 +160,7 @@ static void __init ppc47x_setup_arch(void)
>  	/* No need to check the DMA config as we /know/ our windows are all of
>   	 * RAM.  Lets hope that doesn't change */
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > 0xffffffff) {
> +	if ((memblock_end_of_DRAM() - 1) > 0xffffffff) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/corenet_ds.c b/arch/powerpc/platforms/85xx/corenet_ds.c
> index dd3617c..925b028 100644
> --- a/arch/powerpc/platforms/85xx/corenet_ds.c
> +++ b/arch/powerpc/platforms/85xx/corenet_ds.c
> @@ -77,7 +77,7 @@ void __init corenet_ds_setup_arch(void)
>  #endif
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/ge_imp3a.c b/arch/powerpc/platforms/85xx/ge_imp3a.c
> index 1801462..b6a728b 100644
> --- a/arch/powerpc/platforms/85xx/ge_imp3a.c
> +++ b/arch/powerpc/platforms/85xx/ge_imp3a.c
> @@ -125,7 +125,7 @@ static void __init ge_imp3a_setup_arch(void)
>  	mpc85xx_smp_init();
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/mpc8536_ds.c b/arch/powerpc/platforms/85xx/mpc8536_ds.c
> index 585bd22..767c7cf 100644
> --- a/arch/powerpc/platforms/85xx/mpc8536_ds.c
> +++ b/arch/powerpc/platforms/85xx/mpc8536_ds.c
> @@ -75,7 +75,7 @@ static void __init mpc8536_ds_setup_arch(void)
>  #endif
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_ds.c b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> index 1fd91e9..d30f6c4 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_ds.c
> @@ -173,7 +173,7 @@ static void __init mpc85xx_ds_setup_arch(void)
>  	mpc85xx_smp_init();
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/mpc85xx_mds.c b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> index d208ebc..8e4b094 100644
> --- a/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> +++ b/arch/powerpc/platforms/85xx/mpc85xx_mds.c
> @@ -359,7 +359,7 @@ static void __init mpc85xx_mds_setup_arch(void)
>  	mpc85xx_mds_qe_init();
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/85xx/p1022_ds.c b/arch/powerpc/platforms/85xx/p1022_ds.c
> index f700c81..74e310b 100644
> --- a/arch/powerpc/platforms/85xx/p1022_ds.c
> +++ b/arch/powerpc/platforms/85xx/p1022_ds.c
> @@ -450,7 +450,7 @@ static void __init p1022_ds_setup_arch(void)
>  	mpc85xx_smp_init();
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;
> diff --git a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> index 3755e61..817245b 100644
> --- a/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> +++ b/arch/powerpc/platforms/86xx/mpc86xx_hpcn.c
> @@ -102,7 +102,7 @@ mpc86xx_hpcn_setup_arch(void)
>  #endif
>  
>  #ifdef CONFIG_SWIOTLB
> -	if (memblock_end_of_DRAM() > max) {
> +	if ((memblock_end_of_DRAM() - 1) > max) {
>  		ppc_swiotlb_enable = 1;
>  		set_pci_dma_ops(&swiotlb_dma_ops);
>  		ppc_md.pci_dma_dev_setup = pci_dma_dev_setup_swiotlb;


