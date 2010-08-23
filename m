Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0HWVjL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 17:39:11 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:45527 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754130Ab0HWVjH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 17:39:07 -0400
Date: Mon, 23 Aug 2010 23:39:01 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Dan Carpenter <error27@gmail.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch] pda_power: remove unneeded assignment
Message-ID: <20100823213901.GJ17833@buzzloop.caiaq.de>
References: <20100823212103.GA7340@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100823212103.GA7340@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:21:03PM +0200, Dan Carpenter wrote:
> We never use the "ret" value from this assignment, and also
> PTR_ERR(NULL) is zero.  I looked at it and this driver is designed to
> accept a NULL value for "ac_draw".  So there isn't a bug in the original
> code and we can just remove this confusing assignment.
> 
> Signed-off-by: Dan Carpenter <error27@gmail.com>

Looks reasonable.

Acked-by: Daniel Mack <daniel@caiaq.de>

> diff --git a/drivers/power/pda_power.c b/drivers/power/pda_power.c
> index 69f8aa3..63a6a4d 100644
> --- a/drivers/power/pda_power.c
> +++ b/drivers/power/pda_power.c
> @@ -279,7 +279,6 @@ static int pda_power_probe(struct platform_device *pdev)
>  	if (IS_ERR(ac_draw)) {
>  		dev_dbg(dev, "couldn't get ac_draw regulator\n");
>  		ac_draw = NULL;
> -		ret = PTR_ERR(ac_draw);
>  	}
>  
>  	if (pdata->is_ac_online) {
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
