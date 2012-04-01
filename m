Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2DAP0Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 11:26:16 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63661 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686Ab2DAP0N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 11:26:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6666"; a="175554190"
Message-ID: <4F787392.5040308@codeaurora.org>
Date: Sun, 01 Apr 2012 08:26:10 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Russell King <linux@arm.linux.org.uk>, Mike Turquette <mturquette@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clkdev: Implement managed clk_get()
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1333279960-8497-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/1/2012 4:32 AM, Mark Brown wrote:
> Allow clk API users to simplify their cleanup paths by providing a
> managed version of clk_get().

I was thinking the same thing last week.

>
> Due to the lack of a standard struct clk to look up the device from a
> managed clk_put() is not provided, it would be very unusual to use this
> function so it's not a big loss.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  Documentation/driver-model/devres.txt |    3 +++
>  drivers/clk/clkdev.c                  |   25 +++++++++++++++++++++++++
>  include/linux/clk.h                   |   20 ++++++++++++++++++++
>  3 files changed, 48 insertions(+), 0 deletions(-)
>

But why is this part of clkdev.c? devm_clk_get() should work regardless
of the implementation of clk_get() so can we put it into some other file
that is compiled if HAVE_CLK=y so everyone benefits from this and not
just users who select CLKDEV_LOOKUP?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

