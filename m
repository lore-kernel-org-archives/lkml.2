Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751483Ab2JOIl4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:41:56 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:62267 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751003Ab2JOIly (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:41:54 -0400
MIME-Version: 1.0
In-Reply-To: <20121015083533.GB29356@dhcp22.suse.cz>
References: <10f0412be71dec50a3e57732c1f2aa5b94fe1df8.1350288504.git.viresh.kumar@linaro.org>
	<20121015083533.GB29356@dhcp22.suse.cz>
Date: Mon, 15 Oct 2012 14:11:53 +0530
Message-ID: <CAKohponUigqKOkj3i2=LDgVG0bi4dXsbrJCDpzv6M3k1E_Y6Ew@mail.gmail.com>
Subject: Re: [PATCH] cpufreq: timer: Move tick-sched specific code outside of
 cpufreq governors
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: rjw@sisk.pl, tglx@linutronix.de, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Robin.Randhawa@arm.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 October 2012 14:05, Michal Hocko <mhocko@suse.cz> wrote:
> On Mon 15-10-12 13:41:20, Viresh Kumar wrote:
>> Multiple cpufreq governers have defined similar get_cpu_idle_time_***()
>> routines. These routines must be moved to some common place, so that all
>> governors can use them.
>>
>> So moving them to tick-sched.c, which seems to be a better place for keeping
>> these routines.
>
> I do agree that this code duplication should be removed but tick-sched.c
> is not a right place IMO. Who, apart from governors, should use those
> "common" functions?

Nobody leaving cpufreq for now.

> Having a generic get_cpu_idle_time, which in fact includes iowait time
> as well is definitely not good. It is confusing and it doesn't match
> get_cpu_idle_time_us.

ok

> I would suggest moving the common functionality into drivers/cpufreq/
> (e.g. cpufreq_common.c).

Initially i did that only, but then thought these routines must be present in
more generic files if possible, available across frameworks.

Can we try renaming these to show there exact functionality and then put
them in generic files like, tick-sched.c?

--
viresh
