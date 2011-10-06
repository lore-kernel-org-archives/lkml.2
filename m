Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758386Ab1JFNSQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 09:18:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43578 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758364Ab1JFNSP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 09:18:15 -0400
Date: Thu, 6 Oct 2011 14:18:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 06/10] ASoC: wm8940: Convert to snd_soc_cache_sync
Message-ID: <20111006131811.GA16404@opensource.wolfsonmicro.com>
References: <1317881417.13399.1.camel@phoenix>
 <1317881863.13399.10.camel@phoenix>
 <4E8D90E9.5060208@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E8D90E9.5060208@cam.ac.uk>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 06, 2011 at 12:28:41PM +0100, Jonathan Cameron wrote:
> On 10/06/11 07:17, Axel Lin wrote:

> > +static int wm8940_volatile_register(struct snd_soc_codec *codec,
> > +				    unsigned int reg)
> > +{
> > +	switch (reg) {
> > +	case WM8940_SOFTRESET:
> > +		return 1;
> > +	default:
> > +		return 0;
> > +	}
> > +}

> I guess this makes sense from point of view of keeping things inline with
> more complex drivers.  Otherwise I'd expect to see something like:
> {
> 	return !!(reg == WM894_SOFTRESET);
> }

On the other hand we actually want people to be able to read the code
(though the !! there which is the major complication isn't actually
doing anything...).
