Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753135Ab2DBQsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:48:33 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18296 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2DBQsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:48:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6668"; a="178093809"
Message-ID: <4F79D85F.4020909@codeaurora.org>
Date: Mon, 02 Apr 2012 09:48:31 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com> <4F787392.5040308@codeaurora.org> <20120401153450.GC8971@opensource.wolfsonmicro.com>
In-Reply-To: <20120401153450.GC8971@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/12 08:34, Mark Brown wrote:
> On Sun, Apr 01, 2012 at 08:26:10AM -0700, Stephen Boyd wrote:
>> But why is this part of clkdev.c? devm_clk_get() should work regardless
>> of the implementation of clk_get() so can we put it into some other file
>> that is compiled if HAVE_CLK=y so everyone benefits from this and not
>> just users who select CLKDEV_LOOKUP?
> Mostly just because clk_get() is part of clkdev.c and I didn't feel like
> creating a new file, though also because I really hope that we're going
> to be moving away from open coding clock framework things so that we can
> start to push clock API usage into non-SoC code.  Things like adding new
> clocks are going to be a part of that.
>
> To put it another way, why would a platform want to avoid clkdev?

I hope we get a better clk_get() implementation with the unified struct
clk. Don't get me wrong, clkdev is a great improvement over open coding
clock framework stuff in each platform. But clkdev is really just
another platform specific implementation that most platforms decide to
use. Each platform has to select the option and it breaks if two
platforms implement __clk_get()/__clk_put() in conflicting ways. Ideally
the unified struct clk code guts clkdev and uses the core parts of it
for its own clk_get() implementation.

Sticking devm_clk_get() into clkdev.c is simple, no new file, smaller
diff. Great. But linking it to clkdev doesn't sound much better when
we're trying to get rid of platform specific code and this code is
entirely platform independent.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

