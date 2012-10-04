Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756359Ab2JDTWa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 15:22:30 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17095 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755995Ab2JDTW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 15:22:29 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6855"; a="245825904"
Message-ID: <506DE1F4.9090309@codeaurora.org>
Date: Thu, 04 Oct 2012 12:22:28 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>, Pawel Moll <pawel.moll@arm.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Tony Lindgren <tony@atomide.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-kernel@vger.kernel.org,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Viresh Kumar <viresh.linux@gmail.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org> <506D899C.6010705@gmail.com>
In-Reply-To: <506D899C.6010705@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/12 06:05, Rob Herring wrote:
> On 10/04/2012 03:50 AM, Stephen Boyd wrote:
>> The TWD and SCU configs are selected by default as long as
>> SCORPIONMP is false and/or MCT is false. Implementing the logic
>> this way certainly saves lines in the Kconfig but it precludes
>> those machines which select SCORPIONMP or MCT from participating
>> in the single zImage effort because when those machines are
>> combined with other SMP capable machines the TWD and SCU are no
>> longer selected.
>>
>> Push the select out to the machine entries so that we can compile
>> these machines together and still select the appropriate configs.
> I think this is the wrong direction as I'd like to see the platform
> selects shrink. I believe the local timers are run-time enabled now, so
> can't we just drop the condition and always select TWD and SCU for
> multi-platform?

That sounds fine for multi-platform but it penalizes the "optimized"
images made for a particular device that doesn't want any extra code
than is necessary. Isn't this why we have the Kconfig language?

>
> Or perhaps we need a CortexA9 config symbol that selects V7, GIC, TWD,
> SCU, SMP, PL310, errata, etc. rather than duplicating those for every
> platform.
>
>

This sounds like a good consolidation of lines that can be done in
parallel to this patch. Care to send a patch on top?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

