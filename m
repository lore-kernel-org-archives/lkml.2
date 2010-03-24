Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756175Ab0CXM7u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 08:59:50 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34976 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983Ab0CXM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 08:59:49 -0400
Date: Wed, 24 Mar 2010 12:59:46 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dan Carpenter <error27@gmail.com>, Liam Girdwood <lrg@slimlogic.co.uk>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       Joonyoung Shim <jy0922.shim@samsung.com>, alsa-devel@alsa-project.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [rfc patch] wm8994: range checking issue
Message-ID: <20100324125946.GA26453@rakim.wolfsonmicro.main>
References: <20100324120107.GH21571@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324120107.GH21571@bicker>
X-Cookie: Santa Claus is watching!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 03:01:07PM +0300, Dan Carpenter wrote:
> Smatch complained about BUG_ON(reg > WM8994_MAX_REGISTER) because the
> actual number of elements in the array was WM8994_REG_CACHE_SIZE + 1.

> I changed the BUG_ON() to return -EINVAL.

Please don't introduce orthogonal changes like this in patches, it's bad
practice and increases the chances of your patch being nacked.

> I was confused why WM8994_REG_CACHE_SIZE was different from the actual
> size of ->reg_cache and I was concerned because some places used 
> ARRAY_SIZE() to find the end of the array and other places used 
> WM8994_REG_CACHE_SIZE.  In my patch, I made them the same.

This is caused by confusion with the MAX_CACHED_REGISTER definition in
the header.  Best to use that one consistently, I guess - I've got a
sneaking suspicion something has gone AWOL in the driver publication
process.
