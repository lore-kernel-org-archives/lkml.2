Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab2H0VYT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:24:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52429 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752648Ab2H0VYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:24:18 -0400
Date: Mon, 27 Aug 2012 14:24:14 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Jeff Mahoney <jeffm@suse.com>, Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
Message-ID: <20120827212412.GC4400@opensource.wolfsonmicro.com>
References: <503BE05F.40109@suse.com>
 <503BE429.7080301@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BE429.7080301@codeaurora.org>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 02:18:33PM -0700, Stephen Boyd wrote:
> On 8/27/2012 2:02 PM, Jeff Mahoney wrote:
> > The exynos-rng device is only found on Samsung EXYNOS devices but has
> > dependencies that allow it to be built on other architectures. This
> > can result in build failures on powerpc due to a missing clk_devm_get.

> > This patch makes it depend on ARCH_EXYNOS.

> Hmm the point of making it not depend on ARCH_EXYNOS was so that it
> would get more build coverage. Is it devm_clk_get() that's missing? I
> believe Mark Brown sent some patches that move devm_clk_get() to common
> code so that we don't have these failures[1]. Can you try that patch?

> [1] https://lkml.org/lkml/2012/6/5/186

Yeah, I sent patches for that - they're currently languishing in the
patch tracker.  I'm also working on trying to get the generic clock API
enabled on all architectures that don't have one currently but that's
going depressingly slowly.
