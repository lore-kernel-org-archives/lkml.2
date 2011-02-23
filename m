Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab1BWERE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 23:17:04 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58337 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab1BWERD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 23:17:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6265"; a="76089930"
Message-ID: <4D648A3D.7020402@codeaurora.org>
Date: Tue, 22 Feb 2011 20:17:01 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Paul Mundt <lethal@linux-sh.org>, Dima Zavin <dmitriyz@google.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>
Subject: Re: [PATCH] wip: convert imx27 to common struct clk
References: <1298256658.861611.43913489619.0.gpush@pororo> <1298417599-23522-1-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1298417599-23522-1-git-send-email-u.kleine-koenig@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 03:33 PM, Uwe Kleine-König wrote:
> Signed-off-by: Uwe Kleine-König<u.kleine-koenig@pengutronix.de>
> ---
> Hello,
>
> on top of .38-rc6 + making the clk_{un,}prepare stubs static inline,
> this patch makes use of Jeremy's common struct clk (v13) on a i.MX27 based
> machine.
>
> This is compile tested using mx21_defconfig and runtime tested using
> mx27_defconfig.
>
> I had to degrade one WARN_ON to WARN_ON_ONCE in drivers/clk/clk.c to
> actually make it work.  Otherwise console output results in a warning
> that results in console output ...

You won't be able to do mainline the WARN_ON_ONCE because that will only 
warn for the first clock that violates whatever condition it's warning 
about.

Your probably need to fix your serial driver. What serial driver are you 
using?

-Saravana

