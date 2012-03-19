Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032730Ab2CSTtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 15:49:12 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:33831 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932089Ab2CSTtK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 15:49:10 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6653"; a="173813709"
Message-ID: <4F678DB6.5090006@codeaurora.org>
Date: Mon, 19 Mar 2012 12:49:10 -0700
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: "Turquette, Mike" <mturquette@ti.com>
CC: Russell King <linux@arm.linux.org.uk>, Paul Walmsley <paul@pwsan.com>,
        Linus Walleij <linus.walleij@stericsson.com>, patches@linaro.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-kernel@vger.kernel.org,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Richard Zhao <richard.zhao@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Deepak Saxena <dsaxena@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>, linaro-dev@lists.linaro.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 2/3] clk: introduce the common clock framework
References: <1331878280-2758-1-git-send-email-mturquette@linaro.org> <1331878280-2758-3-git-send-email-mturquette@linaro.org> <4F6404C2.7000506@codeaurora.org> <CAJOA=zP1HHqBNS4V2dN=Q9oOcOErQj8W__fB_qRyZeNLBk7VJg@mail.gmail.com> <4F678561.3040105@codeaurora.org> <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
In-Reply-To: <CAJOA=zN2cSSpM92oRnW0RyU_ZzyoQ=jthc-fAkf-P3z37uWt7w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/19/2012 12:33 PM, Turquette, Mike wrote:
> On Mon, Mar 19, 2012 at 12:13 PM, Saravana Kannan
> <skannan@codeaurora.org>  wrote:
>> I saw some responses from you over the weekend but not to mine. So, I
>> assumed you were busy with other stuff and I started working on a patch on
>> top of v7.
>
> I only answer trivial emails on the weekend ;-)
>
>> I will send that out if I get around to finishing it before you
>> do. Hope that's alright with you.
>
> I'm happy to for you to take a crack at it.  I don't know what your
> implementation looks like, but here are a couple concerns I have:
>
> 1) if you're copying the data from the initializer over to the struct
> clk then make sure you handle the __init data aspects of it properly

Not copying them into clk again. Just leaving them in clk_hw and using 
them as is. The only fields moved into clk_hw are:
+       const char              *name;
+       const struct clk_ops    *ops;
+       char                    **parent_names;
+       u8                      num_parents;
+       unsigned long           flags;

>
> 2) are the members of struct clk_hw visible to the rest of the world?
> Are they modifiable (i.e., not const)?  This is undesirable.

I'm leaving the const as is. Some of them you can't mark as const if you 
want to dynamically create them.

Yes, they are visible to all the platform drivers (not the rest of the 
world). But these values are provided by the platform drivers anyway, so 
I don't see a problem with it.

I also don't see any useful hacks a platform driver can do by messing 
with this fields without crashing the kernel since they don't have 
access to the locks.

flags might be the one that provides some possibilities since I think 
you look at them often in the core code. We could just copy it into clk 
if people really feel strongly about it. At the worst case, we can have 
a full copy of all these fields inside clk and copy all of them over, 
but I think that would be overkill for things like names, ops and parent 
info.

Thanks,
Saravana
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
