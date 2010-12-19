Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753068Ab0LSJTN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 04:19:13 -0500
Received: from mail.perches.com ([173.55.12.10]:2763 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab0LSJTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 04:19:09 -0500
Subject: Re: [PATCH 2/2] net: phy: Fixed some checkpatch errors
From: Joe Perches <joe@perches.com>
To: Jean-Michel Hautbois <jhautbois@gmail.com>
Cc: davem@davemloft.net, richard.cochran@omicron.at, shemminger@vyatta.com,
        tj@kernel.org, randy.dunlap@oracle.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1292697704-2886-2-git-send-email-jhautbois@gmail.com>
References: <1292697704-2886-1-git-send-email-jhautbois@gmail.com>
	 <1292697704-2886-2-git-send-email-jhautbois@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 01:19:07 -0800
Message-ID: <1292750347.22702.268.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 19:41 +0100, Jean-Michel Hautbois wrote:
> Fixes some coding style issues (errors and warnings).

Hi Jean-Michel.

> diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
[]
> @@ -47,11 +47,11 @@ void phy_print_status(struct phy_device *phydev)
>  	pr_info("PHY: %s - Link is %s", dev_name(&phydev->dev),
>  			phydev->link ? "Up" : "Down");
>  	if (phydev->link)
> -		printk(" - %d/%s", phydev->speed,
> +		pr_info(" - %d/%s", phydev->speed,
>  				DUPLEX_FULL == phydev->duplex ?
>  				"Full" : "Half");
>  
> -	printk("\n");
> +	pr_info("\n");

This isn't the right way to fix this actually.

The first pr_info is not terminated with a newline,
so the second printk should be printk(KERN_CONT or
pr_cont instead.

Ideally, you would make a different change.
There should be just one printk/pr_info.
Fewer messages, couldn't be interleaved with other
simultaneous output, easier to grep, etc...

I think something like this would be better:

 	if (phydev->link)
		pr_info("PHY: %s - Link is down\n", dev_name(&phydev->dev));
	else
		pr_info("PHY: %s - Link is up - %d/%s\n",
			dev_name(&phydev->dev),
			phydev->speed,
			phydev->duplex == DUPLEX_FULL ? "Full" : "Half");

or maybe use dev_info like this:

 	if (phydev->link)
		dev_info(&phydev->dev, "PHY: Link is down\n");
	else
		dev_info(&phydev->dev, "PHY: Link is up - %d/%s\n",
			 phydev->speed,
			 phydev->duplex == DUPLEX_FULL ? "Full" : "Half");

cheers, Joe

