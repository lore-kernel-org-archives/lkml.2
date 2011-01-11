Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751380Ab1AKFL4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 00:11:56 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45153 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab1AKFLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 00:11:51 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6222"; a="69998500"
Message-ID: <4D2BE696.80000@codeaurora.org>
Date: Mon, 10 Jan 2011 21:11:50 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Abhijeet Dharmapurikar <adharmap@codeaurora.org>, tglx@linutronix.de,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: interrupt latency while resuming.
References: <4D2897D1.3040609@codeaurora.org> <20110108171332.GB31708@n2100.arm.linux.org.uk>
In-Reply-To: <20110108171332.GB31708@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2011 09:13 AM, Russell King - ARM Linux wrote:
>
> We know it takes something like 200ms to run the lpg calibration, and
> this is responsible for the majority of the time when bringing a CPU
> online.
>
> One solution is to sort out whether we need to re-run the lpj calibration
> each time we resume a CPU.  At the moment, we're just using the boot CPU
> loops_per_jiffy for every udelay(), assuming that all CPUs are running
> at the same clock rate - so we _could_ skip the calibration as its
> never used.
>
> Or we could fix things so that it is used (which also sorts udelay for
> asymetrically clocked secondary CPUs) but then we always have to re-run
> the calibration, or we have to stipulate that secondary CPUs come up at
> the same clock rate as they went down.  I suspect there's systems out
> there where the latter is not true at present, so it's not something we
> can impose - which means we're stuck having to do 200ms of recalibration
> per CPU.

We're actually using a timer based udelay() (which uses
calibrate_delay_direct() instead of the more expensive delay loop) and
thus lpj is calculated in about 50ms. You raise an interesting point
though since we don't need to recalibrate as our timesource is constant.
It would be great to skip the recalibration in such a situation and
speed up onlining CPUs.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

