Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756632Ab1JMQvd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 12:51:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41707 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753572Ab1JMQvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 12:51:32 -0400
Date: Thu, 13 Oct 2011 17:51:30 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Arnaud Patard <arnaud.patard@rtp-net.org>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH 1/3] ASoC: alc5623: Convert codec->hw_read to regmap_read
Message-ID: <20111013165129.GO5193@opensource.wolfsonmicro.com>
References: <1318490575.2857.8.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318490575.2857.8.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 03:22:55PM +0800, Axel Lin wrote:
> codec->hw_read is broken now, let's covert to regmap_read.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

I'd rather not fix these like this because when we convert these drivers
to use regmap directly it won't be quite so obvious what's going on and
we'll easily introduce bugs where we start using the cached values from
a regmap level cache.

Probably the best thing here is to convert all these drivers to use
cache_bypass to read directly through the cache - the same thing will
then work with direct regmap usage.
