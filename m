Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab1IEKAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 06:00:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44423 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751894Ab1IEKAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 06:00:18 -0400
Date: Mon, 5 Sep 2011 11:00:15 +0100
From: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Samuel Oritz <sameo@linux.intel.com>
Subject: Re: [PATCH 1/8] regmap: Introduce caching support
Message-ID: <20110905100015.GE30114@opensource.wolfsonmicro.com>
References: <1314978375-11539-1-git-send-email-dp@opensource.wolfsonmicro.com> <1314978375-11539-2-git-send-email-dp@opensource.wolfsonmicro.com> <4E61363A.9050607@metafoo.de> <20110905094337.GA30114@opensource.wolfsonmicro.com> <4E649C81.3070203@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E649C81.3070203@metafoo.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 11:55:13AM +0200, Lars-Peter Clausen wrote:
> On 09/05/2011 11:43 AM, Dimitris Papastamos wrote:
> > [...]
> >>>  /**
> >>>   * Default value for a register.  We use an array of structs rather
> >>>   * than a simple array as many modern devices have very sparse
> >>> @@ -50,9 +55,11 @@ struct reg_default {
> >>>   *                (eg, a clear on read interrupt status register).
> >>>   *
> >>>   * @max_register: Optional, specifies the maximum valid register index.
> >>> - * @reg_defaults: Power on reset values for registers (for use with
> >>> - *                register cache support).
> >>> - * @num_reg_defaults: Number of elements in reg_defaults.
> >>> + *
> >>> + * @cache_type: The actual cache type.
> >>> + * @cache_defaults_raw: Power on reset values for registers (for use with
> >>> + *                 register cache support).
> >>> + * @num_cache_defaults_raw: Number of elements in cache_defaults_raw.
> >>>   */
> >>>  struct regmap_config {
> >>>  	int reg_bits;
> >>> @@ -64,8 +71,10 @@ struct regmap_config {
> >>>  	bool (*precious_reg)(struct device *dev, unsigned int reg);
> >>>  
> >>>  	unsigned int max_register;
> >>> -	struct reg_default *reg_defaults;
> >>> -	int num_reg_defaults;
> >>
> >> I guess these were removed by accident due to some merge conflict as they were
> >> added just recently. It would be good if you could re-add them and if they are
> >> set initialize cache_defaults using a memdup instead of reading cache_defaults_raw.
> >>
> >>> +
> >>> +	enum regcache_type cache_type;
> >>> +	const void *cache_defaults_raw;
> >>> +	unsigned num_cache_defaults_raw;
> >>>  };
> >>>  
> >>>  typedef int (*regmap_hw_write)(struct device *dev, const void *data,
> > 
> > I was merely renaming these.
> 
> And you changed the type. We need the reg_default type register defaults for
> devices which have a sparse registers set or where the base register address is
> at a larger offset.
> 
> - Lars

Aw duh, yes.  Will add support to regcache to be able to use directly
the reg_defaults if they have been provided by the user without having
to derive this from cache_defaults_raw.

Thanks,
Dimitris
