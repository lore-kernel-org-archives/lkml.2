Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab1FBNQk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 09:16:40 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:46452 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752911Ab1FBNQj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 09:16:39 -0400
Message-ID: <4DE78D30.6020900@ti.com>
Date: Thu, 02 Jun 2011 18:46:32 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mattias Wallin <mattias.wallin@stericsson.com>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        john stultz <johnstul@us.ibm.com>
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk> <4DE7637B.3060901@stericsson.com> <20110602110137.GU3660@n2100.arm.linux.org.uk> <4DE77D9A.6090301@stericsson.com> <4DE788B2.5060308@ti.com> <20110602130406.GW3660@n2100.arm.linux.org.uk>
In-Reply-To: <20110602130406.GW3660@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/2/2011 6:34 PM, Russell King - ARM Linux wrote:
> On Thu, Jun 02, 2011 at 06:27:22PM +0530, Santosh Shilimkar wrote:
>> Earlier this year at ELC SFO, I had a discussion with
>> John and Thomas on how to have a high-resolution clock-source
>> and a low-resolution clock-source working together to cover
>> the low power scenario and still manage to get the highest
>> timer resolution.
>> The idea was to do dynamic switching of clock-source
>> which initially looked simple. Here the idea was to
>> have this working for suspend and as well as cupidle.
>
> I don't think you can do this, because you'll lose precision whenever you
> switch from the high resolution clocksource to the low resolution
> clocksource.
>
> While you can quickly update the current time of day from the highres one,
> the lowres may or may not be a long way from its next tick rollover.  So
> you lose the precision whenever you switch.
>
> However, over a suspend/resume cycle, the precision loss is normally very
> small compared to the time which you have been suspended, so the %age
> error also becomes very small.
>
> With cpuidle, it becomes a completely different matter.  Here, the %age
> error is much larger because of the smaller sleep periods, and chances
> are we can't wait for the low-res timer to change.
>
> So if you're using cpuidle, you really need a clocksource which runs
> continuously, even in whatever states cpuidle drops you into.

According to John, that's what the meta-clock source will for.
It will be continuous and will make use of underneath high res,
low res clock-sources based on the availability.

I let John comment on this on details but I think any other
method would have shortcoming.

Regards
Santosh



