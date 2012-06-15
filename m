Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab2FOPoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 11:44:09 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:48571 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754326Ab2FOPoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 11:44:08 -0400
Date: Fri, 15 Jun 2012 16:43:59 +0100
From: Will Deacon <will.deacon@arm.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Matt Fleming <matt@console-pimps.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [PATCH] oprofile: perf: use NR_CPUS instead or nr_cpumask_bits
 for static array
Message-ID: <20120615154359.GE12031@mudshark.cambridge.arm.com>
References: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339168564-30008-1-git-send-email-will.deacon@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Fri, Jun 08, 2012 at 04:16:04PM +0100, Will Deacon wrote:
> The OProfile perf backend uses a static array to keep track of the
> perf events on the system. When compiling with CONFIG_CPUMASK_OFFSTACK=y
> && SMP, nr_cpumask_bits is not a compile-time constant and the build
> will fail with:
> 
> oprofile_perf.c:28: error: variably modified 'perf_events' at file scope
> 
> This patch uses NR_CPUs instead of nr_cpumask_bits for the array
> initialisation. If this causes space problems in the future, we can
> always move to dynamic allocation for the events array.
> 
> Cc: Matt Fleming <matt@console-pimps.org>
> Cc: Robert Richter <robert.richter@amd.com>
> Reported-by: Russell King - ARM Linux <linux@arm.linux.org.uk>
> Signed-off-by: Will Deacon <will.deacon@arm.com>
> ---
>  drivers/oprofile/oprofile_perf.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/oprofile/oprofile_perf.c b/drivers/oprofile/oprofile_perf.c
> index da14432..efc4b7f 100644
> --- a/drivers/oprofile/oprofile_perf.c
> +++ b/drivers/oprofile/oprofile_perf.c
> @@ -25,7 +25,7 @@ static int oprofile_perf_enabled;
>  static DEFINE_MUTEX(oprofile_perf_mutex);
>  
>  static struct op_counter_config *counter_config;
> -static struct perf_event **perf_events[nr_cpumask_bits];
> +static struct perf_event **perf_events[NR_CPUS];
>  static int num_counters;
>  
>  /*
> -- 
> 1.7.4.1

Given both the lack of feedback and the trivial nature of this patch would
you be able to pick this up please? I'd rather not push it via the ARM tree
as the change is under drivers/.

Thanks,

Will
