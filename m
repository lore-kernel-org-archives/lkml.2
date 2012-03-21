Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758578Ab2CUUEp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 16:04:45 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:20353 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756977Ab2CUUEo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 16:04:44 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6656"; a="172254259"
Message-ID: <4F6A3446.9020809@codeaurora.org>
Date: Wed, 21 Mar 2012 13:04:22 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Tony Lindgren <tony@atomide.com>, Paul Walmsley <paul@pwsan.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org,
        Amit Kucheria <amit.kucheria@linaro.org>, linaro-dev@lists.linaro.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Deepak Saxena <dsaxena@linaro.org>, patches@linaro.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Zhao <richard.zhao@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 1/3] Documentation: common clk API
References: <4F6A2042.9030302@codeaurora.org> <20120321190741.GL3226@opensource.wolfsonmicro.com> <20120321193304.GO9859@atomide.com> <4F6A2EF5.3010008@codeaurora.org> <20120321195656.GN3226@opensource.wolfsonmicro.com>
In-Reply-To: <20120321195656.GN3226@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 12:56 PM, Mark Brown wrote:
> On Wed, Mar 21, 2012 at 12:41:41PM -0700, Saravana Kannan wrote:
>> On 03/21/2012 12:33 PM, Tony Lindgren wrote:
>>> * Mark Brown<broonie@opensource.wolfsonmicro.com>   [120321 12:11]:
>
>>>> These aren't new APIs, the clock API has been around since forever.
>
>> I disagree. When I say clock API, I mean the actual functions and
>> their semantics. Not the existence of a header file.
>
>> The meaning of clk_enable/disable has been changed and they won't
>> work without calling clk_prepare/unprepare. So, these are definitely
>> new APIs. If it weren't new APIs, then none of the general drivers
>> would need to change.
>
> clk_prepare() and clk_unprepare() are already there for any clk.h user
> and are stubbed in no matter what, they're really not a meaningful
> barrier here.

Isn't this whole experimental vs non-experimental discussion about the 
actual external facing clock APIs and not the platform driver facing APIs?

Sure, prepare/unprepare are already there in the .h file. But they are 
stubs and have no impact till we move to the common clock framework or 
platforms move to them with their own implementation (certainly not 
happening in upstream, so let's leave that part out of this discussion).

So. IMO, for all practical purposes, common clk fwk forces the move to 
these new APIs and hence IMO forces the new APIs.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
