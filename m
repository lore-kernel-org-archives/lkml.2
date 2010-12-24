Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab0LXP7T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 10:59:19 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:55032 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750943Ab0LXP7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 10:59:18 -0500
Date: Fri, 24 Dec 2010 15:59:30 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3/9] ASoC: codecs: wm8523: Fix register cache
 incoherency
Message-ID: <20101224155929.GC16614@opensource.wolfsonmicro.com>
References: <1293198484-1902-1-git-send-email-lars@metafoo.de>
 <1293198484-1902-4-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293198484-1902-4-git-send-email-lars@metafoo.de>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 24, 2010 at 02:47:58PM +0100, Lars-Peter Clausen wrote:

>  	/* Change some default settings - latch VU and enable ZC */
> -	wm8523->reg_cache[WM8523_DAC_GAINR] |= WM8523_DACR_VU;
> -	wm8523->reg_cache[WM8523_DAC_CTRL3] |= WM8523_ZC;
> +	reg_cache[WM8523_DAC_GAINR] |= WM8523_DACR_VU;
> +	reg_cache[WM8523_DAC_CTRL3] |= WM8523_ZC;

All the drivers where you're making this substitution should in
principle be changed to use snd_soc_update_bits() since we now have
support for multiple cache memory formats so may not have this flat in
memory structure, though for the sake of getting the fixes in it's
probably best to ignore that and fix it up later.
