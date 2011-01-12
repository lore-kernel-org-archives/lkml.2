Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1ALByt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 20:54:49 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28003 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932364Ab1ALByn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 20:54:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6223"; a="69908200"
Message-ID: <4D2D09E2.5030305@codeaurora.org>
Date: Tue, 11 Jan 2011 17:54:42 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Paul Mundt <lethal@linux-sh.org>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        Uwe Kleine-K?nig <u.kleine-koenig@pengutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com>	<201101111744.59712.jeremy.kerr@canonical.com>	<20110111101314.GA774@linux-sh.org>	<201101111830.18597.jeremy.kerr@canonical.com> <20110111121816.GB774@linux-sh.org>
In-Reply-To: <20110111121816.GB774@linux-sh.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 04:18 AM, Paul Mundt wrote:
> Again, you are approaching it from the angle that an atomic clock is a
> special requirement rather than the default behaviour. Sleeping for
> lookup, addition, and deletion are all quite acceptable, but
> enable/disable pairs have always been intended to be usable from atomic
> context. Anyone that doesn't count on that fact is either dealing with
> special case clocks (PLLs, root clocks, etc.) or simply hasn't bothered
> implementing any sort of fine grained runtime power management for their
> platform.

Paul,

I see you repeating this point a couple of times and I'm a bit confused 
how you handle the clock tree/dependencies.

Does your clock driver NOT hide the details of what root clock/PLL a 
branch clock is sourced from? If you do hide the details of the root/PLL 
source, how do you get the branch clk_enable() to be done atomically if 
the root/PLL enables are not possible in atomic context?

Is it simply a matter of your hardware having PLLs and root clocks that 
can be turned on/off quickly?

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
