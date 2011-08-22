Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755956Ab1HVJIc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 05:08:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:62190 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752960Ab1HVJI1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 05:08:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="40893120"
Date: Mon, 22 Aug 2011 11:10:27 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Convert pcf50633 to use new register map API
Message-ID: <20110822091027.GA8163@sortiz-mobl>
References: <1312602304-21504-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E3F5817.2090405@metafoo.de>
 <20110822090313.GD4607@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110822090313.GD4607@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 22, 2011 at 11:03:13AM +0200, Samuel Ortiz wrote:
> Hi Lars,
> 
> On Mon, Aug 08, 2011 at 05:29:27AM +0200, Lars-Peter Clausen wrote:
> > 
> > >  #include <linux/mfd/pcf50633/core.h>
> > >  
> > [...]
> > >  /* Read a block of up to 32 regs  */
> > >  int pcf50633_read_block(struct pcf50633 *pcf, u8 reg,
> > >  					int nr_regs, u8 *data)
> > >  {
> > > -	int ret;
> > > -
> > > -	mutex_lock(&pcf->lock);
> > > -	ret = __pcf50633_read(pcf, reg, nr_regs, data);
> > > -	mutex_unlock(&pcf->lock);
> > > -
> > > -	return ret;
> > > +	return regmap_raw_read(pcf->regmap, reg, data, nr_regs);
> > >  }
> > >  EXPORT_SYMBOL_GPL(pcf50633_read_block);
> > 
> > There are callers which expect pcf50633_read_block to return the number of
> > bytes read. We could change the wrapper to return nr_regs if regmap_raw_read
> > returns 0. But I guess it is best to just update the callers. Incremental patch
> > which does this at the end of the mail.
> I'd like to apply Mark's patch and yours. Could you please remove the
> unnecesary printk in your patch and I'll go ahead.
Nevermind, I just saw Mark's updated patch.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
