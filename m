Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757696Ab2EXQh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 12:37:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33300 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750864Ab2EXQh5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 12:37:57 -0400
Date: Thu, 24 May 2012 17:37:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        Philippe =?iso-8859-1?Q?R=E9tornaz?= <philippe.retornaz@epfl.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: mc13xxx-core: kernel hangs after 'regmap_read'
Message-ID: <20120524163752.GN5361@opensource.wolfsonmicro.com>
References: <201205221053.21792.marc@cpdesign.com.au>
 <201205242122.29648.marc@cpdesign.com.au>
 <20120524121451.GL5361@opensource.wolfsonmicro.com>
 <201205242306.09053.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205242306.09053.marc@cpdesign.com.au>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:06:08PM +1000, Marc Reilly wrote:

> -	map->format.buf_size = (config->reg_bits + config->val_bits) / 8;
> +	map->format.buf_size = DIV_ROUND_UP(config->reg_bits +
> +					    config->val_bits +
> +					    config->pad_bits % 8, 8);

Yup, though probably without the % 8 (I'd need to reread the context to
confirm) as if pad_bits isn't a multiple of 8 you ought to find that
reg_bits isn't either.
