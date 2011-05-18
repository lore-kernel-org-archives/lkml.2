Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab1ERQ2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 12:28:23 -0400
Received: from orion.CARNet.hr ([161.53.160.90]:36011 "EHLO orion.carnet.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab1ERQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 12:28:22 -0400
X-Greylist: delayed 2580 seconds by postgrey-1.27 at vger.kernel.org; Wed, 18 May 2011 12:28:21 EDT
Date: Wed, 18 May 2011 17:45:17 +0200
To: Milton Miller <miltonm@bga.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: [PATCH] of: fix race when matching drivers
Message-ID: <20110518154517.GA26070@entuzijast.net>
References: <BANLkTikhKqcpdadpM3RQdYvDrPn46_v6_Q@mail.gmail.com>
 <20110517.134312.226762699.davem@davemloft.net>
 <alpine.SOC.1.00.1105021259220.6200@math.ut.ee>
 <1305732459_6563@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305732459_6563@mail4.comsite.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: Josip Rodin <joy@entuzijast.net>
X-SA-Exim-Connect-IP: <locally generated>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 10:27:39AM -0500, Milton Miller wrote:
> --- work.git.orig/include/linux/of_device.h	2011-05-18 09:57:01.014386816 -0500
> +++ work.git/include/linux/of_device.h	2011-05-18 09:58:27.537431575 -0500
> @@ -21,8 +21,15 @@ extern void of_device_make_bus_id(struct
>  static inline int of_driver_match_device(struct device *dev,
>  					 const struct device_driver *drv)
>  {
> -	dev->of_match = of_match_device(drv->of_match_table, dev);
> -	return dev->of_match != NULL;
> +	const struct of_device_id *match;
> +
> +	match = of_match_device(drv->of_match_table, dev);
> +	if (match) {
> +		dev->of_match = of_match_device(drv->of_match_table, dev);
> +		return 1;
> +	}
> +
> +	return 0;
>  }

Err, is there some reason to avoid simply assigning the existing result:
dev->of_match = match; ?

-- 
     2. That which causes joy or happiness.
