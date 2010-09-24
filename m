Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0IXHKL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 03:10:11 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:55612 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab0IXHKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 03:10:10 -0400
Date: Fri, 24 Sep 2010 01:10:06 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: christophe leroy <christophe.leroy@c-s.fr>
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Kumar Gala <galak@kernel.crashing.org>,
        Anton Vorontsov <avorontsov@ru.mvista.com>
Subject: Re: [PATCH] spi_mpc8xxx: issue with using definition of pram in
 Device Tree
Message-ID: <20100924071006.GA21318@angua.secretlab.ca>
References: <20100916070503.10046C7391@messagerie.si.c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100916070503.10046C7391@messagerie.si.c-s.fr>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 09:05:03AM +0200, christophe leroy wrote:
> This patch applies to 2.6.34.7 and 2.6.35.4
> It fixes an issue during the probe for CPM1 with definition of parameter ram from DTS
> 
> Signed-off-by: christophe leroy <christophe.leroy@c-s.fr>

I'm sorry, I don't understand the fix from the given description.
What is the problem, and why is cpm_muram_alloc_fixed() the wrong
thing to call on CPM1?  Does CPM2 still need it?

g.

> 
> diff -urN b/drivers/spi/spi_mpc8xxx.c c/drivers/spi/spi_mpc8xxx.c
> --- b/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:43:50.000000000 +0200
> +++ c/drivers/spi/spi_mpc8xxx.c	2010-09-08 16:44:03.000000000 +0200
> @@ -822,7 +822,7 @@
>  	if (!iprop || size != sizeof(*iprop) * 4)
>  		return -ENOMEM;
>  
> -	spi_base_ofs = cpm_muram_alloc_fixed(iprop[2], 2);
> +	spi_base_ofs = iprop[2];
>  	if (IS_ERR_VALUE(spi_base_ofs))
>  		return -ENOMEM;
>  
> @@ -844,7 +844,6 @@
>  			return spi_base_ofs;
>  	}
>  
> -	cpm_muram_free(spi_base_ofs);
>  	return pram_ofs;
>  }
