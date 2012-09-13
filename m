Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757804Ab2IMMEE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 08:04:04 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51008 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755032Ab2IMMEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 08:04:00 -0400
Date: Thu, 13 Sep 2012 20:03:53 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Ashish Chavan <ashish.chavan@kpitcummins.com>
Cc: lrg <lrg@ti.com>, alsa-devel <alsa-devel@alsa-project.org>,
        David Dajun Chen <david.chen@diasemi.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [alsa-devel] [PATCH] ASoC: codecs: Add DA9055 codec driver
Message-ID: <20120913120351.GA8374@opensource.wolfsonmicro.com>
References: <1347375823.12329.14.camel@matrix>
 <20120912025709.GD9162@opensource.wolfsonmicro.com>
 <1347538116.16763.6.camel@matrix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347538116.16763.6.camel@matrix>
X-Cookie: You will be surrounded by luxury.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 05:38:36PM +0530, Ashish Chavan wrote:
> On Wed, 2012-09-12 at 10:57 +0800, Mark Brown wrote:

> > > +	aif_ctrl |= (DA9055_AIF_OE | DA9055_AIF_EN);

> > DAPM.

> Here the trouble in making it DAPM based is that there is no separate
> control for AIF input and output. It is confirmed that AIF_EN is the
> master control bit, which enables both output as well as input. The AIF
> _OE bit is redundant. If we use the same control bit(i.e AIF_EN) for
> both DAPM_AIF_IN and DAPM_AIF_OUT, there will be obvious side effects.
> Is there any other way to take care of this? Or should we leave it
> outside DAPM?

Use a supply widget.
