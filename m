Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab2ITBZK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 21:25:10 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:39626 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750913Ab2ITBZI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 21:25:08 -0400
Message-ID: <1348104303.4836.63.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [PATCH 1/2] aoe: mark AoE packets as requiring no checksumming
From: Ben Hutchings <bhutchings@solarflare.com>
To: Ed Cashin <ecashin@coraid.com>
CC: <davem@davemloft.net>, <akpm@linux-foundation.org>, <jesse@nicira.com>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Thu, 20 Sep 2012 02:25:03 +0100
In-Reply-To: <72368962c6414543ce7d2c3f1ab5f36154fdd710.1348088283.git.ecashin@coraid.com>
References: <1348079358.4585@cat.he.net>
	 <cover.1348088283.git.ecashin@coraid.com>
	 <72368962c6414543ce7d2c3f1ab5f36154fdd710.1348088283.git.ecashin@coraid.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.96.1.126]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-09-19 at 18:17 -0700, Ed Cashin wrote:
> In order for the network layer to see that AoE requires
> no checksumming in a generic way, packets should be marked
> CHECKSUM_NONE.

Which they are by default.

> Rather than relying on the current behavior of alloc_skb,
> this change causes the aoe driver to explicitly mark its
> packets as requiring no checksum.
>
> Signed-off-by: Ed Cashin <ecashin@coraid.com>
> ---
>  drivers/block/aoe/aoecmd.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
> index de0435e..0ba1b63 100644
> --- a/drivers/block/aoe/aoecmd.c
> +++ b/drivers/block/aoe/aoecmd.c
> @@ -35,6 +35,7 @@ new_skb(ulong len)
>  		skb_reset_mac_header(skb);
>  		skb_reset_network_header(skb);
>  		skb->protocol = __constant_htons(ETH_P_AOE);
> +		skb->ip_summed = CHECKSUM_NONE;

Can be written as:
		skb_checksum_none_assert(skb);
if you really want to be sure.

Ben.

>  	}
>  	return skb;
>  }

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

