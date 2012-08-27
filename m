Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754639Ab2H0VhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:37:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39357 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754329Ab2H0VhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:37:24 -0400
Date: Mon, 27 Aug 2012 14:37:20 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Jeff Mahoney <jeffm@suse.com>
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
Message-ID: <20120827213719.GD4400@opensource.wolfsonmicro.com>
References: <503BE05F.40109@suse.com>
 <503BE429.7080301@codeaurora.org>
 <503BE5E7.106@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <503BE5E7.106@suse.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 05:25:59PM -0400, Jeff Mahoney wrote:
> On 8/27/12 5:18 PM, Stephen Boyd wrote:

> > Hmm the point of making it not depend on ARCH_EXYNOS was so that
> > it would get more build coverage. Is it devm_clk_get() that's
> > missing? I believe Mark Brown sent some patches that move
> > devm_clk_get() to common code so that we don't have these
> > failures[1]. Can you try that patch?

> I'll give it a go since it should fix more than one issue for me. My
> question remains, though: If this hardware is never going to be found
> on powerpc hardware, what difference does it make if there is build
> coverage there?

If you're trying to do some generic API changes or similar it's *much*
easier if you can at least build test a good proportion of the kernel
(or subsytem) with one build even if you've no intention of running the
code.  Having to build lots of different configs to get coverage means
that's likely to get skipped which in turn increases the error rate with
these things.
