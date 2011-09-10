Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754034Ab1IJFxN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 01:53:13 -0400
Received: from na3sys009aog125.obsmtp.com ([74.125.149.153]:39346 "EHLO
	na3sys009aog125.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751190Ab1IJFxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 01:53:12 -0400
Message-ID: <4E6AFB3E.3020902@ti.com>
Date: Sat, 10 Sep 2011 11:23:02 +0530
From: Santosh <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Kevin Hilman <khilman@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org, rjw@sisk.pl, ccross@android.com
Subject: Re: [PATCH v2 0/5] CPU PM notifiers
References: <1315060755-4613-1-git-send-email-santosh.shilimkar@ti.com> <87ty8ly4rp.fsf@ti.com>
In-Reply-To: <87ty8ly4rp.fsf@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 September 2011 11:30 PM, Kevin Hilman wrote:
> Santosh Shilimkar<santosh.shilimkar@ti.com>  writes:
>
> [...]
>
>> This patch set tries to address concerns with platform pm code
>> calling into the driver for every block in the Cortex A9s
>> during idle, hotplug, and suspend.  The first patch adds cpu pm
>> notifiers that can be called by platform code, the second uses
>> the notifier to save and restore the GIC state, and the third
>> saves the VFP state.
>>
>> The notifiers are used for two types of events, CPU PM events and
>> CPU cluster PM events.  CPU PM events are used to save and restore
>> per-cpu context when a single CPU is preparing to enter or has
>> just exited a low power state.  For example, the VFP saves the
>> last thread context, and the GIC saves banked CPU registers.
>>
>> CPU cluster events are used after all the CPUs in a power domain
>> have been prepared for the low power state.  The GIC uses these
>> events to save global register state.
>
> Stepping back from my earlier objections, I think I had a fundamental
> misunderstanding about what these notifiers should be used for.
>
> The current assumptions/goals seem to be
>
> 1) used only for devices in the same power domain as the CPU (cluster)
> 2) use only for one specific power state of the CPU (cluster): off.
>
> For awhile now, we've been discussing how to better coordinate CPU PM
> transitions (CPUidle) with non-CPU PM transitions (runtime PM) for
> devices that are tightly coupled to the CPU, but not necessarily in the
> same powerdomain.
>
> I was assuming (and hoping) that CPU PM notifiers could be used to do
> that, but the more I think about it, I don't think we can achieve the
> current CPU PM goals and the coordination with runtime PM with this
> series.
>
> I think it's more likely that we'll need to do some work with Rafael's
> new PM domains to make that work correctly.
>
> So, I'll retract my objections to this series, and feel free to add
>
> Reviewed-by: Kevin Hilman<khilman@ti.com>
>
Will add.
Thanks for the review Kevin.

Regards
Santosh

Regards

