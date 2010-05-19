Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753353Ab0ESSSk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 14:18:40 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:48545 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0ESSSc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 14:18:32 -0400
Message-ID: <4BF42B6F.6000009@linux.vnet.ibm.com>
Date: Wed, 19 May 2010 11:18:23 -0700
From: Corey Ashford <cjashfor@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, "greg@kroah.com" <greg@kroah.com>,
       Kay Sievers <kay.sievers@vrfy.org>, lkml <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH v2 11/11] perf top: demo of how to use the sysfs
 interface
References: <1274233792.3036.90.camel@localhost>
In-Reply-To: <1274233792.3036.90.camel@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 5/18/2010 6:49 PM, Lin Ming wrote:
> Just a temporary patch to show how to use the pmu sysfs interface...
> 
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>
> ---
>  tools/perf/builtin-top.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
> 
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index adc179d..eaa9405 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1206,6 +1206,7 @@ static void start_counter(int i, int counter)
>  	struct perf_event_attr *attr;
>  	int cpu;
>  	int thread_index;
> +	int sys_fd;
> 
>  	cpu = profile_cpu;
>  	if (target_tid == -1 && profile_cpu == -1)
> @@ -1226,9 +1227,21 @@ static void start_counter(int i, int counter)
> 
>  	for (thread_index = 0; thread_index < thread_num; thread_index++) {
>  try_again:
> +		/*
> +		 * This is just an ugly demo of how to use the sysfs interface.
> +		 * You can also parse the <event-name> and open sys file as,
> +		 * sys_fd = open("/sys/devices/system/cpu/events/<event-name>/event_source/id", O_RDONLY);
> +		 */

In this above case, does this sys_fd also specify the event I am going to open, in addition to its event source?  I'd assume not since event_source is a symlink to /sys/devices/system/cpu/event_source (right?)

How do I specify the exact event id via the sysfs interface?

Thanks,

- Corey

