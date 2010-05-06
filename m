Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab0EFKov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 06:44:51 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:60811 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753084Ab0EFKot (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 06:44:49 -0400
Date: Thu, 6 May 2010 12:44:39 +0200
From: Ingo Molnar <mingo@elte.hu>
To: David Miller <davem@davemloft.net>
Cc: david.choi@micrel.com, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: tip: origin tree boot crash (in the new micrel phy driver)
Message-ID: <20100506104439.GA29100@elte.hu>
References: <20100505.012750.246538504.davem@davemloft.net>
 <20100506095940.GA12711@elte.hu>
 <20100506.031040.186321896.davem@davemloft.net>
 <20100506.031435.235688827.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100506.031435.235688827.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* David Miller <davem@davemloft.net> wrote:

> From: David Miller <davem@davemloft.net>
> Date: Thu, 06 May 2010 03:10:40 -0700 (PDT)
> 
> > From: Ingo Molnar <mingo@elte.hu>
> > Date: Thu, 6 May 2010 11:59:40 +0200
> > 
> >> I bisected it back to the following commit:
> >> 
> >> d05070091849015f8c5b7d55cd75b86ebb61b3ec is the first bad commit
> >> commit d05070091849015f8c5b7d55cd75b86ebb61b3ec
> >> Author: David J. Choi <david.choi@micrel.com>
> >> Date:   Thu Apr 29 06:12:41 2010 +0000
> >> 
> >>     drivers/net/phy: micrel phy driver
>  ...
> >> Disabling the driver fixes the crash.
> > 
> > David please fix this crash, thanks.
> 
> Nevermind, Ingo please test this fix:
> 
> diff --git a/drivers/net/phy/micrel.c b/drivers/net/phy/micrel.c
> index 0cd80e4..e67691d 100644
> --- a/drivers/net/phy/micrel.c
> +++ b/drivers/net/phy/micrel.c
> @@ -32,6 +32,7 @@ static int kszphy_config_init(struct phy_device *phydev)
>  
>  static struct phy_driver ks8001_driver = {
>  	.phy_id		= PHY_ID_KS8001,
> +	.name		= "Micrel KS8001",
>  	.phy_id_mask	= 0x00fffff0,
>  	.features	= PHY_BASIC_FEATURES,
>  	.flags		= PHY_POLL,

This fixes the crash, thanks Dave!

Tested-by: Ingo Molnar <mingo@elte.hu>

	Ingo
