Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0JRPvE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 11:51:04 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:54215 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755302Ab0JRPvC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 11:51:02 -0400
Date: Mon, 18 Oct 2010 09:50:52 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, jaxboe@fusionio.com, hch@infradead.org,
        smaclennan@pikatech.com, michal.simek@petalogix.com,
        john.williams@petalogix.com
Subject: Re: [PATCH] of: xsysace: Fix OF probing on little-endian systems
Message-ID: <20101018155052.GM19399@angua.secretlab.ca>
References: <1287379989-10772-1-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287379989-10772-1-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 03:33:09PM +1000, Michal Simek wrote:
> Convert big-endian DTB to little-endian if necessary.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>

Applied, thanks.

g.

> ---
>  drivers/block/xsysace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/block/xsysace.c b/drivers/block/xsysace.c
> index 057413b..66911d3 100644
> --- a/drivers/block/xsysace.c
> +++ b/drivers/block/xsysace.c
> @@ -1224,7 +1224,8 @@ ace_of_probe(struct platform_device *op, const struct of_device_id *match)
>  		bus_width = ACE_BUS_WIDTH_8;
>  
>  	/* Call the bus-independant setup code */
> -	return ace_alloc(&op->dev, id ? *id : 0, physaddr, irq, bus_width);
> +	return ace_alloc(&op->dev, id ? be32_to_cpup(id) : 0,
> +						physaddr, irq, bus_width);
>  }
>  
>  static int __devexit ace_of_remove(struct platform_device *op)
> -- 
> 1.6.4.182.g9ebfd
> 
