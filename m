Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab2K1Q52 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 11:57:28 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59727 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2K1Q5Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 11:57:25 -0500
Message-ID: <50B64258.7020001@canonical.com>
Date: Wed, 28 Nov 2012 11:56:56 -0500
From: Joseph Salisbury <joseph.salisbury@canonical.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121017 Thunderbird/16.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Norbert Warmuth <nwarmuth@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7+ suspend to RAM/offline CPU fails with nmi_watchdog=0
 (bisected)
References: <86sj83pbwy.fsf@belegost.ivcecceob.t-online.de> <alpine.LFD.2.02.1211231033230.2701@ionos> <868v9s4g7m.fsf@belegost.ivcecceob.t-online.de>
In-Reply-To: <868v9s4g7m.fsf@belegost.ivcecceob.t-online.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/23/2012 08:11 AM, Norbert Warmuth wrote:
> Thomas Gleixner writes:
>> On Wed, 21 Nov 2012, Norbert Warmuth wrote:
>>> 3.7-rc6 booted with nmi_watchdog=0 fails to suspend to RAM or
>>> offline CPUs. It's reproducable with a KVM guest and physical
>>> system.
>> Does the patch below fix it?
> Yes.
>
> - Norbert
>
>> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
>> index 9d4c8d5..e3ef521 100644
>> --- a/kernel/watchdog.c
>> +++ b/kernel/watchdog.c
>> @@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
>>   {
>>   	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>>   
>> +	if (!watchdog_enabled)
>> +		return;
>> +
>>   	watchdog_set_prio(SCHED_NORMAL, 0);
>>   	hrtimer_cancel(hrtimer);
>>   	/* disable the perf event */
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

Hi Thomas,

Your patch also fixes a bug[0] reported against Ubuntu.  I assume the 
window for v3.7 is closed.  Will you be submitting this patch for 
inclusion in v3.8?

Thanks,

Joe

[0] http://bugs.launchpad.net/bugs/1079534

