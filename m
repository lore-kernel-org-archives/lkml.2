Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab2AYOEe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 09:04:34 -0500
Received: from smtp6-g21.free.fr ([212.27.42.6]:45013 "EHLO smtp6-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab2AYOEc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 09:04:32 -0500
Message-ID: <4F200BE2.2070301@free.fr>
Date: Wed, 25 Jan 2012 15:04:18 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Kevin Hilman <khilman@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Trinabh Gupta <g.trinabh@gmail.com>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        linux-omap@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] coupled cpuidle state support
References: <1324426147-16735-1-git-send-email-ccross@android.com> <4F1929E9.7070707@linaro.org> <CAMbhsRTbVqV6p0py9NGZrpFPf2yvp-B0dr+o-m7qbdja_-Lfzw@mail.gmail.com>
In-Reply-To: <CAMbhsRTbVqV6p0py9NGZrpFPf2yvp-B0dr+o-m7qbdja_-Lfzw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2012 09:40 PM, Colin Cross wrote:
> On Fri, Jan 20, 2012 at 12:46 AM, Daniel Lezcano
> <daniel.lezcano@linaro.org>  wrote:
>> Hi Colin,
>>
>> this patchset could be interesting to resolve in a generic way the cpu
>> dependencies.
>> What is the status of this patchset ?
> I can't do much with it right now, because I don't have any devices
> that can do SMP idle with a v3.2 kernel.  I've started working on an
> updated version that avoids the spinlock, but it might be a while
> before I can test and post it.  I'm mostly looking for feedback on the
> approach taken in this patch, and whether it will be useful for other
> SoCs besides Tegra and OMAP4.

Hi Colin,

I will be happy to test your patchset. Do you have a pointer to a more 
recent kernel ?


>> Did you have the opportunity to measure the power consumption with and
>> without this patchset ?
> Power consumption will be very dependent on the specific SoC in
> question.  The most important factors are the power savings of the
> independent cpuidle state (normally WFI) vs. the hotplug state
> (normally 1 cpu in OFF), and the workload being tested.
>
> On a very idle system, these patches result in the same total power as
> hotplugging one cpu and letting the other idle normally.  On a 25%
> busy system, you might see a slight increase in power, as the best
> independent cpuidle state might be WFI, vs 1 cpu in OFF mode in
> hotplug.  On OMAP4, that difference is small, on the order of 10 mW.
> Once you hit the threshold where a hotplug governor would have
> hotplugged in the second cpu (lets say 40%), the savings from these
> patches are enormous, as you can hit the lowest power state up to 60%
> of the time, where the hotplug solution would never be going below WFI
> on both cpus.  On OMAP4, that can be well over 100 mW.

Interesting.


Thanks

   -- Daniel

