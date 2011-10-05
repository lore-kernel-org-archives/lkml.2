Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934352Ab1JEKV0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 06:21:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934188Ab1JEKVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 06:21:24 -0400
Date: Wed, 5 Oct 2011 11:21:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [RFC][PATCH] ASoC: Fix sync reg_cache with the hardware in
 wm8990_resume
Message-ID: <20111005102122.GB9783@opensource.wolfsonmicro.com>
References: <1317809809.2374.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317809809.2374.5.camel@phoenix>
X-Cookie: You are magnetic in your bearing.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 06:16:49PM +0800, Axel Lin wrote:
> Current code has off-by-one bug of checking WM8990_RESET.
> Besides, according to wm8990 datasheet (2-wire serial control mode):
> A control word consists of 24 bits. The first 8 bits are address bits,
> the remaining 16 bits are data bits.
> Current code uses 7 bits address bits and 9 bits data bits which is incorrect.

We should just convert drivers like this to snd_soc_cache_sync().
