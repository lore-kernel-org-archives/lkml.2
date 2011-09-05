Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752780Ab1IER3g (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 13:29:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51300 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752761Ab1IER3W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 13:29:22 -0400
Date: Mon, 5 Sep 2011 10:29:17 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Scott Jiang <scott.jiang.linux@gmail.com>
Subject: Re: [PATCH 2/3] ASoC: Allow codecs to provide their own regmap
 configuration
Message-ID: <20110905172916.GG3889@opensource.wolfsonmicro.com>
References: <1315228682-1097-1-git-send-email-lars@metafoo.de>
 <1315228682-1097-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315228682-1097-2-git-send-email-lars@metafoo.de>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 03:18:01PM +0200, Lars-Peter Clausen wrote:
> Currently a codec can either do the whole regmap initialization on its own or
> provide only the register and value bit size and let the core handle
> initialization. This patch allows a codec to provide a complete regmap
> configuration while still letting ASoC core handle the regmap initialization
> and setup.

I'd rather not do this, the only value is the copying of the word size
setup out of the regmap config is to allow us to use the ASoC cache code
but the idea is to push the cache down out of ASoC into the regmap code
so this function should just be a trivial indirection for the regmap
init which isn't useful.

> - * Register formats are frequently shared between many I2C and SPI
> - * devices.  In order to promote code reuse the ASoC core provides
> - * some standard implementations of CODEC read and write operations
> - * which can be set up using this function.
> - *
> - * The caller is responsible for allocating and initialising the
> - * actual cache.
> - *
> - * Note that at present this code cannot be used by CODECs with
> - * volatile registers.
> + * Legacy and convenience wrapper around snd_soc_codec_regmap_init
>   */

This is a useful but unrelated change.
