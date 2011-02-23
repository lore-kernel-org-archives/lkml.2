Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932098Ab1BWI6L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 03:58:11 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:50104 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751Ab1BWI6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 03:58:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=rAyKU9x2Jnv3+JtkmbOAfK6ydA8GOPrHizHsoYso6Qg65e/2RDSEYGTz9rALZieeFp
         hu+KY+/Tnv2AK8duwLawx+pJeuV9YJO5x1kDiSYgt1SNO+/iZ39gUg629qhwm7rDQYv5
         wIxddvUPWY+fm+cKUqqUndK/EiB9zpUrnXuBY=
From: Peter Korsgaard <jacmet@sunsite.dk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        devicetree-discuss@lists.ozlabs.org, sfr@canb.auug.org.au,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        sparclinux@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [RFC PATCH 07/15] dt: uartlite: merge platform and of_platform driver bindings
References: <20110223043015.20795.37090.stgit@localhost6.localdomain6>
	<20110223043411.20795.57850.stgit@localhost6.localdomain6>
Date: Wed, 23 Feb 2011 09:58:01 +0100
In-Reply-To: <20110223043411.20795.57850.stgit@localhost6.localdomain6> (Grant
	Likely's message of "Tue, 22 Feb 2011 21:34:11 -0700")
Message-ID: <877hcryvom.fsf@macbook.be.48ers.dk>
User-Agent: Gnus/5.110009 (No Gnus v0.9) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Grant" == Grant Likely <grant.likely@secretlab.ca> writes:

 Grant> of_platform_driver is getting removed, and a single platform_driver
 Grant> can now support both devicetree and non-devicetree use cases.  This
 Grant> patch merges the two driver registrations.

Wee!

 Grant>  static int __devinit ulite_probe(struct platform_device *pdev)
 Grant>  {
 Grant>  	struct resource *res, *res2;
 Grant> +	const __be32 *prop;
 Grant> +	int id = pdev->id;
 
 Grant>  	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 Grant>  	if (!res)
 Grant> @@ -583,7 +586,13 @@ static int __devinit ulite_probe(struct platform_device *pdev)
 Grant>  	if (!res2)
 Grant>  		return -ENODEV;
 
 Grant> -	return ulite_assign(&pdev->dev, pdev->id, res->start, res2->start);
 Grant> +#ifdef CONFIG_OF
 Grant> +	prop = of_get_property(pdev->dev.of_node, "port-number", NULL);
 Grant> +	if (prop)
 Grant> +		id = be32_to_cpup(prop);
 Grant> +#endif
 Grant> +
 Grant> +	return ulite_assign(&pdev->dev, id, res->start, res2->start);
 Grant>  }

Isn't this going to give a build warning about prop being unused on
!CONFIG_OF builds? Perhaps move it down into the CONFIG_OF conditional?

Other than that,

Acked-by: Peter Korsgaard <jacmet@sunsite.dk>

-- 
Bye, Peter Korsgaard
