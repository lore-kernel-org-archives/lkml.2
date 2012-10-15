Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751657Ab2JOIvk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 04:51:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54574 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751073Ab2JOIvj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 04:51:39 -0400
Date: Mon, 15 Oct 2012 10:51:37 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: rjw@sisk.pl, tglx@linutronix.de, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org,
        Robin.Randhawa@arm.com
Subject: Re: [PATCH] cpufreq: timer: Move tick-sched specific code outside of
 cpufreq governors
Message-ID: <20121015085137.GD29069@dhcp22.suse.cz>
References: <10f0412be71dec50a3e57732c1f2aa5b94fe1df8.1350288504.git.viresh.kumar@linaro.org>
 <20121015083533.GB29356@dhcp22.suse.cz>
 <CAKohponUigqKOkj3i2=LDgVG0bi4dXsbrJCDpzv6M3k1E_Y6Ew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKohponUigqKOkj3i2=LDgVG0bi4dXsbrJCDpzv6M3k1E_Y6Ew@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 15-10-12 14:11:53, Viresh Kumar wrote:
> On 15 October 2012 14:05, Michal Hocko <mhocko@suse.cz> wrote:
[...]
> > I would suggest moving the common functionality into drivers/cpufreq/
> > (e.g. cpufreq_common.c).
> 
> Initially i did that only, but then thought these routines must be present in
> more generic files if possible, available across frameworks.
> 
> Can we try renaming these to show there exact functionality and then put
> them in generic files like, tick-sched.c?

But we already do have generic generic functionality for nohz case
get_cpu_{idle,iowait}_time_us and kcpustat_cpu for !nohz. The only one
that cares for both is /proc/stat code and it has its own helpers
get_{idle,iowait}_time and as you can see it's demands are different
from what governors want.

-- 
Michal Hocko
SUSE Labs
