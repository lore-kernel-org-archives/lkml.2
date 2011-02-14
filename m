Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1BNWrb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:47:31 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:50220 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab1BNWr0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:47:26 -0500
Date: Tue, 15 Feb 2011 09:47:12 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Matt Mackall <mpm@selenic.com>
Cc: Julia Lawall <julia@diku.dk>, Deepak Saxena <dsaxena@plexity.net>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] drivers/char/hw_random/omap-rng.c: Convert
	release_resource to release_region/release_mem_region
Message-ID: <20110214224712.GA25913@gondor.apana.org.au>
References: <1297599132-7226-1-git-send-email-julia@diku.dk> <1297599132-7226-3-git-send-email-julia@diku.dk> <1297723344.5929.28.camel@calx>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297723344.5929.28.camel@calx>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 14, 2011 at 04:42:24PM -0600, Matt Mackall wrote:
> On Sun, 2011-02-13 at 13:12 +0100, Julia Lawall wrote:
> > Request_region should be used with release_region, not release_resource.
> > 
> > The local variable mem, storing the result of request_mem_region, is
> > dropped and instead the pointer res is stored in the drvdata field of the
> > platform device.  This information is retrieved in omap_rng_remove to
> > release the region.  The drvdata field is not used elsewhere.
> > 
> > The semantic match that finds this problem is as follows:
> > (http://coccinelle.lip6.fr/)
> 
> Looks ok to me, Herbert?

Yes I will apply it today.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
