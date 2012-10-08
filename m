Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab2JHM4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 08:56:33 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50753 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2JHM4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 08:56:30 -0400
Message-ID: <5072CD79.7060005@gmail.com>
Date: Mon, 08 Oct 2012 07:56:25 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
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
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org> <506D899C.6010705@gmail.com> <506DE1F4.9090309@codeaurora.org>
In-Reply-To: <506DE1F4.9090309@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04/2012 02:22 PM, Stephen Boyd wrote:
> On 10/04/12 06:05, Rob Herring wrote:
>> On 10/04/2012 03:50 AM, Stephen Boyd wrote:
>>> The TWD and SCU configs are selected by default as long as
>>> SCORPIONMP is false and/or MCT is false. Implementing the logic
>>> this way certainly saves lines in the Kconfig but it precludes
>>> those machines which select SCORPIONMP or MCT from participating
>>> in the single zImage effort because when those machines are
>>> combined with other SMP capable machines the TWD and SCU are no
>>> longer selected.
>>>
>>> Push the select out to the machine entries so that we can compile
>>> these machines together and still select the appropriate configs.
>> I think this is the wrong direction as I'd like to see the platform
>> selects shrink. I believe the local timers are run-time enabled now, so
>> can't we just drop the condition and always select TWD and SCU for
>> multi-platform?
> 
> That sounds fine for multi-platform but it penalizes the "optimized"
> images made for a particular device that doesn't want any extra code
> than is necessary. Isn't this why we have the Kconfig language?
> 

Yes, but neither of those are very much code. There has to be some
threshold.

>>
>> Or perhaps we need a CortexA9 config symbol that selects V7, GIC, TWD,
>> SCU, SMP, PL310, errata, etc. rather than duplicating those for every
>> platform.
>>
>>
> 
> This sounds like a good consolidation of lines that can be done in
> parallel to this patch. Care to send a patch on top?

So I would just go and delete most of the lines you are adding? Sounds
like churn to me. We should do this first if we are going to.

Also, your patch is not going to apply once Russell's alphabetizing of
selects patch goes in. I'm not sure if that is this merge window or next.

Rob

