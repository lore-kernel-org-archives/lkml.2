Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752063Ab1AOAon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 19:44:43 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:49847 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751213Ab1AOAom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 19:44:42 -0500
Date: Sat, 15 Jan 2011 11:44:16 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Jamie Iles <jamie@jamieiles.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCHv2] hwrng: add support for picoxcell TRNG
Message-ID: <20110115004416.GA19686@gondor.apana.org.au>
References: <20110114181609.GN2822@pulham.picochip.com> <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295030661-16364-1-git-send-email-jamie@jamieiles.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 14, 2011 at 06:44:21PM +0000, Jamie Iles wrote:
>
> +	/* Wait for some data to become available. */
> +	while (__raw_readl(csr) & CSR_OUT_EMPTY_MASK) {
> +		if (!wait)
> +			return 0;
> +		cpu_relax();
> +	}

This has the potential to loop indefinitely.  Please add a time-out
to prevent that (see existing RNG drivers for example).

Thanks!
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
