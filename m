Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab2AHQ6n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jan 2012 11:58:43 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53810 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753985Ab2AHQ6l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jan 2012 11:58:41 -0500
Date: Sun, 8 Jan 2012 08:58:24 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: Laxman Dewangan <ldewangan.com@nvidia.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Subject: Re: [PATCH V1] TPS62360: Add tps62360 regulator driver
Message-ID: <20120108165819.GB29065@opensource.wolfsonmicro.com>
References: <1325668818-1096-1-git-send-email-ldewangan@nvidia.com>
 <20120105062919.GI11867@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9E9B@BGMAIL01.nvidia.com>
 <20120106185755.GC2893@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0DE@BGMAIL01.nvidia.com>
 <20120107191047.GA3590@opensource.wolfsonmicro.com>
 <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <96C9D994977DD0439FB6D3FE3B13DD907DBD3AA0E4@BGMAIL01.nvidia.com>
X-Cookie: You will get what you deserve.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 08, 2012 at 01:12:47PM +0530, Laxman Dewangan wrote:

> > Taking multiple different regulator_init_data is definitely not what we
> > want, there's a whole bunch of information in there, not just the
> > voltages.  You should just use platform data to specify the GPIOs (and
> > a set of voltages if you go with that approach).

> How do you pass the voltages along with gpios? If I understand correctly
> then it may be wither in range form or discrete form.
> Like in range form 500-700 for VSEL:00, 710-800 VSEL:01 etc.
> In discrete form VSEL00:500, 540, 550..
> For, VSEL01, VSEL00:510, 900,

Why would you have ranges?  If you've set the VSEL pins to a particular
value I'd expect the chip to produce whatever voltage is programmed for
that VSEL.

> In range form, the disadvantages is that, most of time, the voltage
> requirement is surrounding operating voltage and so it will use only
> one combination of VSEL in most of time and will not get the benefit.
> The discrete form have long list of voltage and filling table is pain.
> Also need to maintain the big list of lookuptable to select voltage
> configuration register.

You only have four possible VSELs so I don't see a concern there.
