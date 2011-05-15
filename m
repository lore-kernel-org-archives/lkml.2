Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752460Ab1EOULS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 16:11:18 -0400
Received: from christianhoffmann.info ([88.175.101.52]:37479 "EHLO
	christianhoffmann.info" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1EOULR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 16:11:17 -0400
Message-ID: <4DD0335A.6050400@christianhoffmann.info>
Date: Sun, 15 May 2011 22:11:06 +0200
From: Christian Hoffmann <email@christianhoffmann.info>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: john stultz <johnstul@us.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Long timeout when booting >= 2.6.38
References: <4DBEFCBA.3070501@christianhoffmann.info>  <1304363375.3226.5.camel@work-vm> <4DBF1725.3030800@christianhoffmann.info>  <1304372955.3226.15.camel@work-vm>  <4DBF2FB4.8000304@christianhoffmann.info> <1304470839.3037.12.camel@work-vm> <4DC100D0.1030302@christianhoffmann.info> <alpine.LFD.2.02.1105041015220.3005@ionos> <4DC1832E.5030806@christianhoffmann.info> <alpine.LFD.2.02.1105041931510.3005@ionos> <4DC1AB9B.8080501@christianhoffmann.info> <alpine.LFD.2.02.1105042154410.3005@ionos> <4DC2DE2C.40108@christianhoffmann.info> <alpine.LFD.2.02.1105091020450.2895@ionos>
In-Reply-To: <alpine.LFD.2.02.1105091020450.2895@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Thanks, can you please add the following patch and generate another
> trace ?
>
> Thanks,
>
> 	Thomas
>
> --- linux-2.6.orig/kernel/timer.c
> +++ linux-2.6/kernel/timer.c
> @@ -1268,11 +1268,14 @@ unsigned long get_next_timer_interrupt(u
>   	if (cpu_is_offline(smp_processor_id()))
>   		return now + NEXT_TIMER_MAX_DELTA;
>   	spin_lock(&base->lock);
> +	trace_printk("nx: %lx tj: %lx\n", base->next_timer, base->timer_jiffies);
>   	if (time_before_eq(base->next_timer, base->timer_jiffies))
>   		base->next_timer = __next_timer_interrupt(base);
>   	expires = base->next_timer;
>   	spin_unlock(&base->lock);
>
> +	trace_printk("ex: %lx nw: %lx\n", expires, now);
> +
>   	if (time_before_eq(expires, now))
>   		return now;
>

Hi,

new trace:
http://dl.dropbox.com/u/21820416/traceing2.log.bz2

Sorry for delay.

Regards,
Chris
