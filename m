Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1LVKjx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 05:39:53 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753785Ab1LVKjv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 05:39:51 -0500
Date: Thu, 22 Dec 2011 10:39:47 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Lars-Peter Clausen <lars@metafoo.de>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Mike Frysinger <vapier@gentoo.org>, Daniel Mack <zonque@gmail.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 3/3 v2] sound/soc/lapis: add platform driver for ML7213
 IOH I2S
Message-ID: <20111222103946.GA4546@opensource.wolfsonmicro.com>
References: <1324349144-12784-1-git-send-email-tomoya.rohm@gmail.com>
 <1324349144-12784-3-git-send-email-tomoya.rohm@gmail.com>
 <20111220132314.GQ2866@opensource.wolfsonmicro.com>
 <CANKRQng8N3oS2o17HPUZeonXB3KLBK9oNQj-zd9+aUUvWcTo0A@mail.gmail.com>
 <20111222005816.GB27144@opensource.wolfsonmicro.com>
 <CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANKRQnjCTAX02wJt7StjB0rXkg3Q6bPBRYCbkgq6vS5NFd97Fg@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:10:24PM +0900, Tomoya MORINAGA wrote:

> I can understand your saying.
> However, in case of Tx interrupt, only ALMOST-EMPTY occurs. in case of
> Rx, only Rx ALMOST-FULL occurs.
> So as long as a user uses ML7213 I2S, your mentioned behavior is never happened.

That's not what your code says...  it may be that the other interrupts
are very rare but that's not the same thing.

> They have the "filter" function immediately next to the code uses
> "dma_request_channel".

That's a rather large function...

> Anyway, if you want me to change the name, I can change the name.
> Please decide it.

Rename.

> > You're implementing some sort of custom buffering in your driver?  That
> > sounds terribly unidiomatic - pretty much all DMA drivers are very thin
> > and manage to work well, I'd expect this is masking some problems in the
> > code rather than anything else.  Can you provide more detail on what
> > this is working around?

> Not sorted but queuing only.
> In sound/voice control system, queuing is not rare, I think.
> If necessary, though this method is very common, I can send the method
> of the queue.

No, please describe the problem you're trying to fix.  If nothing else
think about what you're saying here - if this is a common need then it's
something that's going to be handled in generic code, not open coded in
individual drivers.  Like I say I would expect that you have problems
elsewhere in your code which you are masking with this.
