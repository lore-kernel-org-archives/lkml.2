Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753235Ab0INJzI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 05:55:08 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35236 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0INJzF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 05:55:05 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Vasily Khoruzhick <anarsoul@gmail.com>
Cc: Venkatesh Pallipadi <venki@google.com>, intel-gfx@lists.freedesktop.org,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: Interrupt latency on some 945GM platforms
References: <201009132336.17310.anarsoul@gmail.com>
	<201009140104.03135.anarsoul@gmail.com>
	<AANLkTi=UCvj9prjv9WzurUg8Gb4i3LZxVJeNwvLtYieN@mail.gmail.com>
	<201009141109.41596.anarsoul@gmail.com>
Date: Tue, 14 Sep 2010 11:55:00 +0200
In-Reply-To: <201009141109.41596.anarsoul@gmail.com> (Vasily Khoruzhick's
	message of "Tue, 14 Sep 2010 11:09:36 +0300")
Message-ID: <87tyls7iq3.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vasily Khoruzhick <anarsoul@gmail.com> writes:

>> Whats the clockevent in this case ("Tick Device" section of
>> /proc/timer_list). clocksource= option only changes the clocksource used
>> to maintain
>> timeofday. But, timer interrupt (clockevent) source will not change.
>> Wondering how just the clocksource change is making the diff here..
>> 
>> Also, if clocksource tsc has a higher rating than HPET. The reason
>> HPET is getting used as clocksource in the first place seems to be due
>> to TSC is not a dependable clocksource on this platform (may be it
>> stops in C3). So, I am not sure forcing it to tsc will be a good
>> thing. May be clocksource=acpi_pm is a better thing to try.
>> 
>> Thanks,
>> Venki
>
> I investigated it a bit and found out that single nohz=off option helps. Just 
> changing clocksource doesn't help, but it works smoothly with any clocksource 
> with nohz=off. So, it seems that something wrong with intel driver while 
> system is in tickless mode. 

It could be simply that nohz=off prevents the system from
going into lower idle states and it is related to that.

You could test this theory by running with processor.max_cstate=1

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
