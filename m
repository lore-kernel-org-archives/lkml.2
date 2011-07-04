Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1GDRcw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 13:32:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:15069 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754371Ab1GDRcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 13:32:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,474,1304319600"; 
   d="scan'208";a="21430797"
Date: Mon, 4 Jul 2011 19:33:20 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: Don't leak init_data in tps65910_i2c_probe
Message-ID: <20110704173320.GR3021@sortiz-mobl>
References: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1107022120171.16316@swampdragon.chaosbits.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper,

On Sat, Jul 02, 2011 at 09:21:38PM +0200, Jesper Juhl wrote:
> There are a couple of situations where we leak init_data in
> drivers/mfd/tps65910.c:tps65910_i2c_probe() - this patch should take
> care of them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  drivers/mfd/tps65910.c |    8 ++++++--
>  1 files changed, 6 insertions(+), 2 deletions(-)
> 
>  Compile tested only.
> 
> diff --git a/drivers/mfd/tps65910.c b/drivers/mfd/tps65910.c
> index 2229e66..0db62f4 100644
> --- a/drivers/mfd/tps65910.c
> +++ b/drivers/mfd/tps65910.c
> @@ -144,15 +144,17 @@ static int tps65910_i2c_probe(struct i2c_client *i2c,
>  		return -EINVAL;
>  
>  	init_data = kzalloc(sizeof(struct tps65910_platform_data), GFP_KERNEL);
> -	if (init_data == NULL)
> +	if (!init_data)
This is not a memory leak fix. And I actually prefer the == NULL check.
Please remove the == NULL check replacement with !* and keep only the memory
leak fixing part.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
