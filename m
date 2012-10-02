Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2JBM4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 08:56:07 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:25967 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753176Ab2JBM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 08:56:04 -0400
Date: Tue, 2 Oct 2012 08:44:20 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the xen-two tree with the arm tree
Message-ID: <20121002124420.GA9009@phenom.dumpdata.com>
References: <20121002141141.827ca565a2722b72b1c2157e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002141141.827ca565a2722b72b1c2157e@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 02:11:41PM +1000, Stephen Rothwell wrote:
> Hi Konrad,
> 
> Today's linux-next merge of the xen-two tree got a conflict in
> arch/arm/Kconfig between commit bd51e2f59558 ("ARM: 7506/1: allow for
> ATAGS to be configured out when DT support is selected") from the arm
> tree and commit eff8d6447d5f ("xen/arm: introduce CONFIG_XEN on ARM")
> from the xen-two tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Thank you!
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc arch/arm/Kconfig
> index 7df4acc,3361466..0000000
> --- a/arch/arm/Kconfig
> +++ b/arch/arm/Kconfig
> @@@ -1897,6 -1891,22 +1897,16 @@@ config CC_STACKPROTECTO
>   	  neutralized via a kernel panic.
>   	  This feature requires gcc version 4.2 or above.
>   
>  -config DEPRECATED_PARAM_STRUCT
>  -	bool "Provide old way to pass kernel parameters"
>  -	help
>  -	  This was deprecated in 2001 and announced to live on for 5 years.
>  -	  Some old boot loaders still use this way.
>  -
> + config XEN_DOM0
> + 	def_bool y
> + 	depends on XEN
> + 
> + config XEN
> + 	bool "Xen guest support on ARM (EXPERIMENTAL)"
> + 	depends on EXPERIMENTAL && ARM && OF
> + 	help
> + 	  Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> + 
>   endmenu
>   
>   menu "Boot options"


