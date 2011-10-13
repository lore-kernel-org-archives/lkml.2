Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1JMWwl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 18:52:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53175 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752538Ab1JMWwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 18:52:40 -0400
Date: Thu, 13 Oct 2011 23:52:37 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to regmap_read
Message-ID: <20111013225237.GA2952@opensource.wolfsonmicro.com>
References: <1318490575.2857.8.camel@phoenix>
 <20111013165129.GO5193@opensource.wolfsonmicro.com>
 <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAF+7xWkVLNgToGiEn+xqgnii7QozNu0QAf2U-kXRNRtVK0dkqA@mail.gmail.com>
X-Cookie: Excellent day to have a rotten day.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 06:39:43AM +0800, Axel Lin wrote:
> 2011/10/14 Mark Brown <broonie@opensource.wolfsonmicro.com>:

> > Probably the best thing here is to convert all these drivers to use
> > cache_bypass to read directly through the cache - the same thing will
> > then work with direct regmap usage.

> I don't complete understand "use cache_bypass to read directly through
> the cache".

Set the cache_bypass flag in the device struct.

> Or do you mean changes like below instead of calling regmap_read directly?

No, this isn't going to work.  snd_soc_read() will use the cache.
