Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757226Ab0DFCkz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 22:40:55 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:37096 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757202Ab0DFCks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 22:40:48 -0400
MIME-Version: 1.0
In-Reply-To: <20100406021559.GD3630@balbir.in.ibm.com>
References: <1270496004-9715-1-git-send-email-mike@android.com>
	 <w2l6599ad831004051252mbf8c4cedz293540bfc7b2f87a@mail.gmail.com>
	 <20100406021559.GD3630@balbir.in.ibm.com>
Date: Mon, 5 Apr 2010 19:40:43 -0700
Message-ID: <z2s8bb80c381004051940t27e513fbr3b4ec282666b8398@mail.gmail.com>
Subject: Re: [RFC][PATCH] sched: cpuacct: Track cpuusage per cpu frequency
From: Mike Chan <mike@android.com>
To: balbir@linux.vnet.ibm.com
Cc: Paul Menage <menage@google.com>, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 5, 2010 at 7:15 PM, Balbir Singh <balbir@linux.vnet.ibm.com> wrote:
> * menage@google.com <menage@google.com> [2010-04-05 12:52:57]:
>
>> On Mon, Apr 5, 2010 at 12:33 PM, Mike Chan <mike@android.com> wrote:
>> > New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
>> >
>> > cpuacct.cpufreq accounts for cpu time per-cpu frequency, time is exported
>> > in nano-seconds
>>
>> Can you clarify the wording of this (and describe it in the relevant
>> Documentation/... file)? It's not clear.
>>
>> From the code, it appears that the file reports a breakdown of how
>> much CPU time the cgroup has been consuming at each different CPU
>> frequency level. If so, then you probably want to reword the
>> description to avoid "per-cpu", since that makes it sounds as though
>> it's reporting something, well, "per CPU".
>>
>> Also, what's the motivation here? If it's for power monitoring
>> purposes, might it be simpler to just report a single number, that's
>> the integral of the CPU usage by frequency index (i.e. calculated from
>> the same information that this patch is already gathering in
>> cpuacct_charge()) rather than dumping a whole table on userspace?
>
> As utilization increases, won't the integral quickly overflow? BTW,
> Mike have you looked at the scaled accounting infrastructure we have
> in taskstats?
>

I just looked (thanks for pointed that out, it was new to me, thx!).
The problem here is that the accounting scales time based of cpu
speed. As it currently stands it will not represent power tracking
accurately as the power consumption of running at 1ghz / 2 != 500mhz.
We would have to register a weight factor for each speed and those
would have to be registered from the board files (at least in the ARM
world), since voltage levels can vary across projects.

-- Mike

> --
>        Three Cheers,
>        Balbir
>
