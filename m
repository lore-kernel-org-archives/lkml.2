Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756856Ab1JMXeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:34:16 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:53236 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752717Ab1JMXeP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:34:15 -0400
Date: Fri, 14 Oct 2011 00:34:14 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to
 regmap_read
Message-ID: <20111013233414.GB21690@sirena.org.uk>
References: <1318490575.2857.8.camel@phoenix>
 <20111013165129.GO5193@opensource.wolfsonmicro.com>
 <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
 <20111013225237.GA2952@opensource.wolfsonmicro.com>
 <CAF+7xWm-X6ydYVp5j+HzMZaFkja+2cEMC2BnXRBoNJTqj=x7OA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWm-X6ydYVp5j+HzMZaFkja+2cEMC2BnXRBoNJTqj=x7OA@mail.gmail.com>
X-Cookie: Do not exceed recommended dosage.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 07:29:33AM +0800, Axel Lin wrote:

> I check the regmap code, it seems cache_bypsss is only set
> if map->cache_type == REGCACHE_NONE or by regcache_cache_bypass().

That's in regmap.  Any ASoC drivers which haven't been converted to
directly use regmap will still use the ASoC copy of the cache code.

> +       regcache_cache_bypass(codec->control_data, true);
> +       for (i = 0 ; i < codec->driver->reg_cache_size ; i += step) {
> +               regmap_read(codec->control_data, i, &val);
> +               cache[i] = val;
> +       }
> +       regcache_cache_bypass(codec->control_data, false);

This is what a driver which uses regmap directly should do.
