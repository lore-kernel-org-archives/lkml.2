Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218Ab0DFT6g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 15:58:36 -0400
Received: from fifo99.com ([67.223.236.141]:43265 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752927Ab0DFT6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 15:58:30 -0400
Subject: Re: [RFC][PATCH] sched: cpuacct: Track cpuusage per cpu frequency
From: Daniel Walker <dwalker@fifo99.com>
To: Mike Chan <mike@android.com>
Cc: menage@google.com, balbir@in.ibm.com, cpufreq@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <p2n8bb80c381004061243w44590616jc2040bd7914d4d24@mail.gmail.com>
References: <1270496004-9715-1-git-send-email-mike@android.com>
	 <1270576127.9066.8.camel@c-dwalke-linux.qualcomm.com>
	 <p2n8bb80c381004061243w44590616jc2040bd7914d4d24@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 12:58:10 -0700
Message-ID: <1270583890.9066.23.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 12:43 -0700, Mike Chan wrote:
> On Tue, Apr 6, 2010 at 10:48 AM, Daniel Walker <dwalker@fifo99.com> wrote:
> > On Mon, 2010-04-05 at 12:33 -0700, Mike Chan wrote:
> >> New file: cpuacct.cpufreq when CONFIG_CPU_FREQ_STATS is enabled.
> >>
> >> cpuacct.cpufreq accounts for cpu time per-cpu frequency, time is exported
> >> in nano-seconds
> >>
> >> We do not know the cpufreq table size at compile time.
> >> So a new config option CONFIG_CPUACCT_CPUFREQ_TABLE_MAX is intruduced,
> >> to determine the cpufreq table per-cpu in the cpuacct struct.
> >>
> >> Signed-off-by: Mike Chan <mike@android.com>
> >> ---
> >>  init/Kconfig   |    5 +++
> >>  kernel/sched.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++
> >>  2 files changed, 104 insertions(+), 0 deletions(-)
> >>
> >> diff --git a/init/Kconfig b/init/Kconfig
> >> index eb77e8c..e1e86df 100644
> >> --- a/init/Kconfig
> >> +++ b/init/Kconfig
> >> @@ -534,6 +534,11 @@ config CGROUP_CPUACCT
> >>         Provides a simple Resource Controller for monitoring the
> >>         total CPU consumed by the tasks in a cgroup.
> >>
> >> +config CPUACCT_CPUFREQ_TABLE_MAX
> >> +     int "Max CPUFREQ table size"
> >> +     depends on CGROUP_CPUACCT && CPU_FREQ_TABLE
> >> +     default 32
> >> +
> >
> > I'd say make it just a regular define unless you can think of a reason
> > why a non-developer would want to touch this value.
> 
> I originally thought about doing this, but my concern here is for
> future (or existing) cpu's that have more than 32 speed stepping. This
> will have to be updated as new cpu's are supported in mainline (if
> they exceed the max). Which might be acceptable or not.
> 
> Ideally it would be nice to be able to pull the table size from the
> board-file, or determine the size at run-time instead of compile time.

You should try to discover any current cpu's that have more than 32, if
they exist. (32 seems like a lot)

Then it should be ok to just allow others to patch up the value as
needed, when new cpu's get added with more. There's nothing wrong with
that practice AFAIK ..

Daniel

