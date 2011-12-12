Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab1LLOZj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 09:25:39 -0500
Received: from mga11.intel.com ([192.55.52.93]:48927 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752557Ab1LLOZi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 09:25:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="101262236"
Date: Mon, 12 Dec 2011 15:30:43 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: tps65910: Handle clear-mask correctly
Message-ID: <20111212143043.GF13952@sortiz-mobl>
References: <marcus.folkesson@gmail.com>
 <1321969191-8604-1-git-send-email-marcus.folkesson@gmail.com>
 <1321969191-8604-2-git-send-email-marcus.folkesson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1321969191-8604-2-git-send-email-marcus.folkesson@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marcus,

On Tue, Nov 22, 2011 at 02:39:51PM +0100, Marcus Folkesson wrote:
> The function is not actually cleaing the bitmask.

This looks like a valid fix, and all the tps65910_clear_bits() callers seem to
expect that behaviour. Graeme, I'm going to try to push this one for 3.2,
unless you object to it.

Cheers,
Samuel.

> Signed-off-by: Marcus Folkesson <marcus.folkesson@gmail.com>
> ---
>  drivers/mfd/tps65910.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 6f5b8cf..c1da84b 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -120,7 +120,7 @@ int tps65910_clear_bits(struct tps65910 *tps65910, u8 reg, u8 mask)
>  		goto out;
>  	}
>  
> -	data &= mask;
> +	data &= ~mask;
>  	err = tps65910_i2c_write(tps65910, reg, 1, &data);
>  	if (err)
>  		dev_err(tps65910->dev, "write to reg %x failed\n", reg);
> -- 
> 1.7.5.4
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
