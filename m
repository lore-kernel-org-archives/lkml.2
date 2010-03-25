Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751215Ab0CYEUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 00:20:49 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:50899 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab0CYEUr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 00:20:47 -0400
Subject: Re: [tpmdd-devel] [PATCH] TPM: Provide a tpm_tis OF driver
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: tpmdd-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100309200135.GF30462@obsidianresearch.com>
References: <20100309200135.GF30462@obsidianresearch.com>
Content-Type: text/plain
Organization: IBM
Date: Thu, 25 Mar 2010 01:20:41 -0300
Message-Id: <1269490841.12676.32.camel@blackbox.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Just a minor comment

On Tue, 2010-03-09 at 13:01 -0700, Jason Gunthorpe wrote:

> @@ -703,7 +747,17 @@ static int __init init_tis(void)
>  		return rc;
>  	}
> 
> -	return pnp_register_driver(&tis_pnp_driver);
> +#ifdef CONFIG_OF
> +	rc = of_register_platform_driver(&tis_of_driver);
> +	if (rc)
> +		return rc;
> +#endif
> +#ifdef CONFIG_PNP
> +	rc = pnp_register_driver(&tis_pnp_driver);
> +	if (rc)
> +		return rc;
> +#endif
> +	return 0;
>  }
> 

Why not 

+#ifdef CONFIG_OF
+	return of_register_platform_driver(&tis_of_driver);
+#elif CONFIG_PNP
+	return pnp_register_driver(&tis_pnp_driver);
+#endif

?

Other than this it looks nice.

Acked-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>


Thanks,
Rajiv

