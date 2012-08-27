Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754718Ab2H0VTj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 17:19:39 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:30956 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab2H0VSx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 17:18:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6817"; a="230020181"
Message-ID: <503BE429.7080301@codeaurora.org>
Date: Mon, 27 Aug 2012 14:18:33 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Jeff Mahoney <jeffm@suse.com>
CC: Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [PATCH] exynos-rng: Depend on ARCH_EXYNOS
References: <503BE05F.40109@suse.com>
In-Reply-To: <503BE05F.40109@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/27/2012 2:02 PM, Jeff Mahoney wrote:
> The exynos-rng device is only found on Samsung EXYNOS devices but has
> dependencies that allow it to be built on other architectures. This
> can result in build failures on powerpc due to a missing clk_devm_get.
>
> This patch makes it depend on ARCH_EXYNOS.

Hmm the point of making it not depend on ARCH_EXYNOS was so that it
would get more build coverage. Is it devm_clk_get() that's missing? I
believe Mark Brown sent some patches that move devm_clk_get() to common
code so that we don't have these failures[1]. Can you try that patch?

[1] https://lkml.org/lkml/2012/6/5/186

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

