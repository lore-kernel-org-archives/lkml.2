Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab2KZOfV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 09:35:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33387 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab2KZOfU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 09:35:20 -0500
Subject: Re: linux-next: build failure after merge of the final tree (tty
 tree related)
From: Steven Rostedt <srostedt@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
References: <20121127004948.6e7973525843529de827ed0e@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Mon, 26 Nov 2012 09:35:12 -0500
Message-ID: <1353940512.22512.38.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-27 at 00:49 +1100, Stephen Rothwell wrote:
> Hi all,
> 
> After merging the final tree, today's linux-next build (powerpc
> allyesconfig) failed like this:
> 
> In file included from drivers/staging/sb105x/sb_pci_mp.c:1:0:
> drivers/staging/sb105x/sb_pci_mp.h:22:25: fatal error: asm/segment.h: No such file or directory

I haven't tested this with any other arch than x86. That said, what
about this instead:


> 
> Caused by commit 68a81291ff66 ("staging: Add SystemBase Multi-2/PCI
> driver").
> 
> I have disabled this driver with this patch:
> 
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 27 Nov 2012 00:45:07 +1100
> Subject: [PATCH] disable the SB105X driver
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  drivers/staging/sb105x/Kconfig |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/sb105x/Kconfig b/drivers/staging/sb105x/Kconfig
> index ac87c5e..c957e32 100644
> --- a/drivers/staging/sb105x/Kconfig
> +++ b/drivers/staging/sb105x/Kconfig
> @@ -2,6 +2,7 @@ config SB105X
>  	tristate "SystemBase PCI Multiport UART"
>  	select SERIAL_CORE
>  	depends on PCI
> +	depends on BROKEN

	depends on X86

You can add my SOB if you want. I don't care either way.

-- Steve

>  	help
>  	  A driver for the SystemBase Multi-2/PCI serial card
>  
> -- 
> 1.7.10.280.gaa39
> 


