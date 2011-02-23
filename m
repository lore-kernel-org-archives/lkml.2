Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753534Ab1BWSKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:10:47 -0500
Received: from mail-pv0-f174.google.com ([74.125.83.174]:36159 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752138Ab1BWSKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:10:45 -0500
Date: Wed, 23 Feb 2011 11:10:42 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Peter Korsgaard <jacmet@sunsite.dk>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 07/15] dt: uartlite: merge platform and of_platform
 driver bindings
Message-ID: <20110223181042.GK14597@angua.secretlab.ca>
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
 <20110223043411.20795.57850.stgit@localhost6.localdomain6>
 <877hcryvom.fsf@macbook.be.48ers.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <877hcryvom.fsf@macbook.be.48ers.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:58:01AM +0100, Peter Korsgaard wrote:
> >>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:
> 
>  Grant> of_platform_driver is getting removed, and a single platform_driver
>  Grant> can now support both devicetree and non-devicetree use cases.  This
>  Grant> patch merges the two driver registrations.
> 
> Wee!
> 
>  Grant>  static int __devinit ulite_probe(struct platform_device *pdev)
>  Grant>  {
>  Grant>  	struct resource *res, *res2;
>  Grant> +	const __be32 *prop;
>  Grant> +	int id = pdev->id;
>  
>  Grant>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
>  Grant>  	if (!res)
>  Grant> @@ -583,7 +586,13 @@ static int __devinit ulite_probe(struct platform_device *pdev)
>  Grant>  	if (!res2)
>  Grant>  		return -ENODEV;
>  
>  Grant> -	return ulite_assign(&pdev->dev, pdev->id, res->start, res2->start);
>  Grant> +#ifdef CONFIG_OF
>  Grant> +	prop = of_get_property(pdev->dev.of_node, "port-number", NULL);
>  Grant> +	if (prop)
>  Grant> +		id = be32_to_cpup(prop);
>  Grant> +#endif
>  Grant> +
>  Grant> +	return ulite_assign(&pdev->dev, id, res->start, res2->start);
>  Grant>  }
> 
> Isn't this going to give a build warning about prop being unused on
> !CONFIG_OF builds? Perhaps move it down into the CONFIG_OF conditional?

I'd actually like to be rid of 'port-number' entirely; but that's
another day's debate.  I'll fix this up.

g.

