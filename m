Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab0GODhK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 23:37:10 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29726 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab0GODhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 23:37:07 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6043"; a="47374168"
Message-ID: <4C3E8261.60307@codeaurora.org>
Date: Wed, 14 Jul 2010 20:37:05 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-arm-msm@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        David Brownell <david-b@pacbell.net>
Subject: Re: Meaning of clk_round_rate()?
References: <4C3DFC7A.8020002@codeaurora.org> <20100714200324.GA18138@n2100.arm.linux.org.uk>
In-Reply-To: <20100714200324.GA18138@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 07/14/2010 01:03 PM, Russell King - ARM Linux wrote:
> clk_round_rate() returns the clock rate which will be set if you ask
> clk_set_rate() to set that rate.  It provides a way to query from
> the implementation exactly what rate you'll get if you use clk_set_rate()
> with that same argument.
>
> So essentially, clk_set_rate() should be:
>
> static int clk_set_rate(struct clk *clk, unsigned long rate)
> {
> 	rate = clk_round_rate(clk, rate);
> 	return set_actual_rate(clk, rate);
> }

 From what I understand, you're saying clk_round_rate() is defined as 
what clk_set_rate() would do, which is call clk_round_rate() and then 
set the rate with whatever is returned by clk_round_rate()? Isn't that a 
recursive definition?

I'll play along though. The use of the function is to determine what the 
rate will be if I call clk_set_rate(), but what is the implementation of 
it suppose to be. I guess now I'm asking what should clk_set_rate() do? 
Round up, down, to the closest value, or just fail if it's not exact.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

