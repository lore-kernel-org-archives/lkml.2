Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933044Ab2EXKh5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:37:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52928 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755564Ab2EXKhz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:37:55 -0400
Date: Thu, 24 May 2012 11:37:49 +0100
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
Message-ID: <20120524103749.GJ5361@opensource.wolfsonmicro.com>
References: <201205221053.21792.marc@cpdesign.com.au>
 <20120524064635.GP3710@pengutronix.de>
 <20120524073315.GE7843@S2100-06.ap.freescale.net>
 <201205241908.38278.marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205241908.38278.marc@cpdesign.com.au>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 07:08:37PM +1000, Marc Reilly wrote:

> I'm wondering about regmap_init where the buf_size is set up. I think it will 
> only end up being 3 bytes. I think line 249 should be something like:

> 	map->format.buf_size = (config->reg_bits 
>                           + config->val_bits 
> 					         + (config->pad_bits % 8)) / 8;

> or perhaps better:
> 	map->reg_shift = config->pad_bits % 8;
> 	map->format.buf_size = (config->reg_bits 
>                           + config->val_bits 
> 					         + map->reg_shift) / 8;

Yes, that's been missed in the addition of padding.  We should also be
using DIV_ROUND_UP() which we aren't at the minute.  We could also do
reg_bytes + pad_bytes + val_bytes which should cover everything I think?
