Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab1KJTMK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 14:12:10 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:5232 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1KJTMJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 14:12:09 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6526"; a="134149801"
Message-ID: <4EBC2208.7020102@codeaurora.org>
Date: Thu, 10 Nov 2011 11:12:08 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <marc.zyngier@arm.com>
Subject: Re: [PATCH 0/8] MSM timer fixes and cleanups
References: <1320777250-23263-1-git-send-email-sboyd@codeaurora.org> <20111110183321.GA16832@huya.qualcomm.com>
In-Reply-To: <20111110183321.GA16832@huya.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/11 10:33, David Brown wrote:
> On Tue, Nov 08, 2011 at 10:34:02AM -0800, Stephen Boyd wrote:
>> Currently the MSM timers use the same physical counter
>> for the clockevent and clocksource. This works as long
>> as the clocksource isn't stopped from ticking during normal
>> operation but unfortunately that isn't the case and the
>> clocksource is stopped when the clockevent is shutdown.
>> Even worse, switching the clocksource via sysfs at runtime will
>> hang the system.
>>
>> This series reorganizes the MSM timer code so that one counter
>> is only used for either a clocksource or a clockevent, and not 
>> both. In the process we reduce the lines of code and fix
>> a few long-standing bugs.
> How do you test these on the upstream kernel?  Booting successfully is
> probably a good starting point, though.
>

Booting is good because that means you're getting timer interrupts.
After that, do some sleep 10, 20, 30, etc. tests with a stopwatch to
make sure that time isn't completely off.

You can also check bogoMIPS and see what the before and after is. Beyond
that I suppose some kind of ntp or gettimeofday test would be good.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

