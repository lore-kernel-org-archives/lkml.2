Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab1GREBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 00:01:19 -0400
Received: from ozlabs.org ([203.10.76.45]:50521 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750698Ab1GREBR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 00:01:17 -0400
Date: Mon, 18 Jul 2011 14:01:15 +1000
From: Tony Breeds <tony@bakeyournoodle.com>
To: Ayman Elkhashab <aymane@elkhashab.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Ayman El-Khashab <ayman@elkhashab.com>
Subject: Re: [v2 PATCH 1/1] powerpc/4xx: enable and fix pcie gen1/gen2 on the
 460sx
Message-ID: <20110718040115.GK20597@ozlabs.org>
Mail-Followup-To: Ayman Elkhashab <aymane@elkhashab.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	Ayman El-Khashab <ayman@elkhashab.com>
References: <1310603611-8960-2-git-send-email-ayman@elkhashab.com>
 <1310748027-31956-1-git-send-email-aymane@elkhashab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1310748027-31956-1-git-send-email-aymane@elkhashab.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 11:40:27AM -0500, Ayman Elkhashab wrote:

> @@ -1582,8 +1628,8 @@ static int __init ppc4xx_setup_one_pciex_POM(struct ppc4xx_pciex_port	*port,
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAH, lah);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2BAL, lal);
>  		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKH, 0x7fffffff);
> -		/* Note that 3 here means enabled | single region */
> -		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL, sa | 3);
> +		dcr_write(port->dcrs, DCRO_PEGPL_OMR2MSKL,
> +				sa | DCRO_PEGPL_OMRxMSKL_VAL);

Didn't you just change "sa | 3" to "sa | 1" ?

<snip>

> index 56d9e5d..61b3659 100644
> --- a/arch/powerpc/sysdev/ppc4xx_pci.h
> +++ b/arch/powerpc/sysdev/ppc4xx_pci.h
> @@ -464,6 +464,18 @@
>  #define PECFG_POM2LAL		0x390
>  #define PECFG_POM2LAH		0x394
>  
> +/* 460sx only */
> +#define PECFG_460SX_DLLSTA     0x3f8
> +
> +/* 460sx Bit Mappings */
> +#define PECFG_460SX_DLLSTA_LINKUP	 0x00000010
> +#define DCRO_PEGPL_460SX_OMR1MSKL_UOT	 0x00000004
> +
> +/* PEGPL Bit Mappings */
> +#define DCRO_PEGPL_OMRxMSKL_VAL	 0x00000001
> +#define DCRO_PEGPL_OMR1MSKL_UOT	 0x00000002
> +#define DCRO_PEGPL_OMR3MSKL_IO	 0x00000002
> +
>  /* SDR Bit Mappings */
>  #define PESDRx_RCSSET_HLDPLB	0x10000000
>  #define PESDRx_RCSSET_RSTGU	0x01000000

Yours Tony
