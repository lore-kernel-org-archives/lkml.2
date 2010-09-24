Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757509Ab0IXS4W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 14:56:22 -0400
Received: from imr4.ericy.com ([198.24.6.8]:50198 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab0IXS4U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 14:56:20 -0400
Date: Fri, 24 Sep 2010 11:55:09 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jan Beulich <jbeulich@novell.com>
CC: fenghua.yu@intel.com, khali@linux-fr.org, r.marek@assembler.cz,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
Message-ID: <20100924185509.GA20155@ericsson.com>
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4C8E18790200007800015AF7@vpn.id2.novell.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:26:33AM -0000, Jan Beulich wrote:
> PCI specific code is needed only when Atom CPUs are potentially
> supported by the kernel.
> 
> Signed-off-by: Jan Beulich <jbeulich@novell.com>
> Cc: Rudolf Marek <r.marek@assembler.cz>
> 
> ---
> drivers/hwmon/Kconfig |    3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> --- linux-2.6.36-rc4/drivers/hwmon/Kconfig	2010-09-13 08:45:02.000000000 +0200
> +++ 2.6.36-rc4-x86-coretemp-maybe-pci/drivers/hwmon/Kconfig	2010-09-10 16:24:16.000000000 +0200
> @@ -401,7 +401,8 @@ config SENSORS_GL520SM
>  
>  config SENSORS_CORETEMP
>  	tristate "Intel Core/Core2/Atom temperature sensor"
> -	depends on X86 && PCI && EXPERIMENTAL
> +	depends on X86 && EXPERIMENTAL
> +	depends on PCI || (!MATOM && !GENERIC_CPU && !X86_GENERIC)
>  	help
>  	  If you say yes here you get support for the temperature
>  	  sensor inside your CPU. Most of the family 6 CPUs

Resending my reply to this one as well. Again, apologies if there is duplication.

The coretemp code unconditionally calls pci functions, even if PCI is not defined.
I am concerned that this might cause problems. It might be better to stick with
the more generic dependency instead of trying to optimize too much.

Guenter
