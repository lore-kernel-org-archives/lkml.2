Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab1JDJv2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Oct 2011 05:51:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58405 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755438Ab1JDJv1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Oct 2011 05:51:27 -0400
Date: Tue, 4 Oct 2011 10:51:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: ASoC: snd_soc_codec_set_cache_io does not set codec->hw_write
 callback now
Message-ID: <20111004095124.GA3250@opensource.wolfsonmicro.com>
References: <1317720272.2536.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317720272.2536.2.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 04, 2011 at 05:24:32PM +0800, Axel Lin wrote:

> I just found that after commit be3ea3b9e
> "SoC: Use new register map API for ASoC generic physical I/O",
> snd_soc_codec_set_cache_io does not set codec->hw_write any more.

> It is still used in some drivers. e.g.
> In wm8988_resume, we call codec->hw_write(codec->control_data, data, 2);

> For the drivers that is using snd_soc_codec_set_cache_io now,
> where is the place to set codec->hw_write callback now? 

These drivers should be using the standard I/O functions, probably
they're looking for the cache_bypass flag.  Either that or convert to
use regmap directly.
