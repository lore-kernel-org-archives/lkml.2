Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0KZOXr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 09:23:47 -0500
Received: from mail-out.m-online.net ([212.18.0.9]:36494 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab0KZOXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 09:23:46 -0500
X-Auth-Info: hfOjI8CXpfrefbiNRGnz+asYrq4s5C2Ud7Dl6n6Dt3M=
To: Rupjyoti Sarmah <rsarmah@amcc.com>
cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org, rsarmah@apm.com
From: Wolfgang Denk <wd@denx.de>
Subject: Re: [PATCH v3] ppc44x:PHY fixup for USB on canyonlands board
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
In-reply-to: <201011261110.oAQBANZL012455@amcc.com>
References: <201011261110.oAQBANZL012455@amcc.com>
Comments: In-reply-to Rupjyoti Sarmah <rsarmah@amcc.com>
   message dated "Fri, 26 Nov 2010 16:40:23 +0530."
Date: Fri, 26 Nov 2010 15:23:42 +0100
Message-Id: <20101126142342.E05A411D94F1@gemini.denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Rupjyoti Sarmah,

In message <201011261110.oAQBANZL012455@amcc.com> you wrote:
>
> +				cpld@2,0 {
> +					#address-cells = <1>;
> +					#size-cells = <1>;
> +					compatible = "apm,ppc460ex-bcsr";

This results in a mix of "amcc," and "apm," strings.

Are there any plans to unify this?


> diff --git a/arch/powerpc/platforms/44x/canyonlands.c b/arch/powerpc/platforms/44x/canyonlands.c
> new file mode 100644
> index 0000000..61e80ce
> --- /dev/null
> +++ b/arch/powerpc/platforms/44x/canyonlands.c
> @@ -0,0 +1,120 @@
> +/*
> + * This contain platform specific code for Canyonlands board based on
> + * APM ppc44x series of processors.

Canyonlands is always PPC460EX, or does it ever come with other
processors as well?

> +static int __init ppc44x_probe(void)
> +{
> +	unsigned long root = of_get_flat_dt_root();
> +		if (of_flat_dt_is_compatible(root, "amcc,canyonlands")) {
> +			ppc_pci_set_flags(PPC_PCI_REASSIGN_ALL_RSRC);
> +			return 1;
> +		}
> +	return 0;
> +}

Bad indentation.

> +	/* Disable USB, through the BCSR7 bits */
> +	setbits8(&bcsr[7], BCSR_USB_EN);
> +
> +	/* Wait for a while after reset */
> +	msleep(100);
> +
> +	/* Enable USB here */
> +	clrbits8(&bcsr[7], BCSR_USB_EN);
> +
> +	/*
> +	 * Configure multiplexed gpio16 and gpio19 as alternate1 output
> +	 * source after USB reset.This configuration is done through GPIO0_TSRH
> +	 * and GPIO0_OSRH bits 0:1 and 6:7.
> +	 */

Earlier versions of the patch included a delay after the clrbits8()
call as well. Is it intentional that you dropped this now?


Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Every program has at least one bug and can be shortened by  at  least
one instruction - from which, by induction, one can deduce that every
program can be reduced to one instruction which doesn't work.
