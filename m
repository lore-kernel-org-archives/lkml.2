Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752867Ab1BAU7O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 15:59:14 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:22849 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752737Ab1BAU7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 15:59:12 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6244"; a="72828978"
Message-ID: <4D48741F.8060006@codeaurora.org>
Date: Tue, 01 Feb 2011 12:59:11 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Saravana Kannan <skannan@codeaurora.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, linux-kernel@vger.kernel.org,
        Dima Zavin <dmitriyz@google.com>, Ben Dooks <ben-linux@fluff.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API, part 2: clk_prepare/clk_unprepare
References: <201102011711.31258.jeremy.kerr@canonical.com>	<20110201105449.GY1147@pengutronix.de>	<20110201131512.GH31216@n2100.arm.linux.org.uk>	<20110201141837.GA1147@pengutronix.de>	<20110201143932.GK31216@n2100.arm.linux.org.uk>	<20110201151846.GD1147@pengutronix.de> <20110201152458.GP31216@n2100.arm.linux.org.uk>
In-Reply-To: <20110201152458.GP31216@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/01/2011 07:24 AM, Russell King - ARM Linux wrote:
>
> I'd also be tempted at this stage to build-in a no-op dummy clock,
> that being the NULL clk:
>
> int clk_prepare(struct clk *clk)
> {
> 	int ret = 0;
>
> 	if (clk) {
> 		mutex_lock(&clk->mutex);
> 		if (clk->prepared == 0)
> 			ret = clk->ops->prepare(clk);
> 		if (ret == 0)
> 			clk->prepared++;
> 		mutex_unlock(&clk->mutex);
> 	}
>
> 	return ret;
> }

I'm afraid this will hide enable/disable imbalances on some targets and
then expose them on others. Maybe its not a big problem though since
this also elegantly handles the root(s) of the tree.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

