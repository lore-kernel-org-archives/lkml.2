Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932774Ab1ALC4M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 21:56:12 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53962 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932648Ab1ALC4L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 21:56:11 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6223"; a="69914230"
Message-ID: <4D2D184A.8020405@codeaurora.org>
Date: Tue, 11 Jan 2011 18:56:10 -0800
From: Saravana Kannan <skannan@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Jeremy Kerr <jeremy.kerr@canonical.com>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>, linux-sh@vger.kernel.org,
        Ben Herrenschmidt <benh@kernel.crashing.org>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: Locking in the clk API
References: <201101111016.42819.jeremy.kerr@canonical.com> <20110111091607.GI12552@n2100.arm.linux.org.uk>
In-Reply-To: <20110111091607.GI12552@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/11/2011 01:16 AM, Russell King - ARM Linux wrote:
> On Tue, Jan 11, 2011 at 10:16:42AM +0800, Jeremy Kerr wrote:
>> At present, we can satisfy these with:
>>
>> * clk_enable: may sleep
>
> I object to this as one of the purposes behind the clk API is to allow
> power savings to be made, and unless we can perform clk enable/disable
> from atomic contexts, the best you can do is enable the clock when the
> device is probed and disable it when it's released.

Since dev_pm_ops.suspend is not atomic anymore (am I wrong?), what is 
the atomic context that you are having in mind that's related to power 
savings? How often do we really need to call clk enable/disable in that 
atomic context?

If the system VDD needed to be increased when a clock/core in enabled 
(in reality, when a core is enabled), how do we make sure that the 
voltage is reduced when the clock/core is turned off? Do we simply punt 
the voltage change problem to the driver and say "not our problem"?

I'm not saying that the voltage change should or shouldn't be handled by 
the clock driver. But it looks like the same methods used to handle the 
voltage change problem could be applied to how we could handle the clk 
enable/disable problem.

-Saravana

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
