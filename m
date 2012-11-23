Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab2KWNLr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 08:11:47 -0500
Received: from mailout11.t-online.de ([194.25.134.85]:59744 "EHLO
	mailout11.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751120Ab2KWNLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 08:11:46 -0500
From: Norbert Warmuth <nwarmuth@t-online.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [regression] 3.7+ suspend to RAM/offline CPU fails with nmi_watchdog=0 (bisected)
In-Reply-To: <alpine.LFD.2.02.1211231033230.2701@ionos> (Thomas Gleixner's
	message of "Fri, 23 Nov 2012 10:33:54 +0100 (CET)")
References: <86sj83pbwy.fsf@belegost.ivcecceob.t-online.de>
	<alpine.LFD.2.02.1211231033230.2701@ionos>
Date: Fri, 23 Nov 2012 14:11:09 +0100
Message-ID: <868v9s4g7m.fsf@belegost.ivcecceob.t-online.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-ID: Ew7lg-Zr8h8+Z48iapWSw2PejD1r3gqP9dy9AvItAs8dnxtdj0NASWTHi7dNvDFZsx
X-TOI-MSGID: 21c47c49-cf0e-4442-904b-b76581d175d4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Gleixner writes:
> On Wed, 21 Nov 2012, Norbert Warmuth wrote:
>> 3.7-rc6 booted with nmi_watchdog=0 fails to suspend to RAM or
>> offline CPUs. It's reproducable with a KVM guest and physical
>> system. 
>
> Does the patch below fix it?

Yes. 

- Norbert

> diff --git a/kernel/watchdog.c b/kernel/watchdog.c
> index 9d4c8d5..e3ef521 100644
> --- a/kernel/watchdog.c
> +++ b/kernel/watchdog.c
> @@ -368,6 +368,9 @@ static void watchdog_disable(unsigned int cpu)
>  {
>  	struct hrtimer *hrtimer = &__raw_get_cpu_var(watchdog_hrtimer);
>  
> +	if (!watchdog_enabled)
> +		return;
> +
>  	watchdog_set_prio(SCHED_NORMAL, 0);
>  	hrtimer_cancel(hrtimer);
>  	/* disable the perf event */
