Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0FUULF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:11:05 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:34853 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab0FUULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:11:01 -0400
Date: Tue, 22 Jun 2010 01:40:56 +0530
From: Dipankar Sarma <dipankar@in.ibm.com>
To: Len Brown <lenb@kernel.org>
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
Message-ID: <20100621201056.GE27750@in.ibm.com>
Reply-To: dipankar@in.ibm.com
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 16, 2010 at 05:05:26PM -0400, Len Brown wrote:
> Create /sys/power/policy_preference, giving user-space
> the ability to express its preference for kernel based
> power vs. performance decisions in a single place.
> 
> policy_preference has 5 levels, from max_performance
> through max_powersave.  Here is how 4 parts of the kernel
> might respond to those 5 levels:

In theory this makes sense. We have been toying with something
like this, but the difficulty is that outside of benchmarking
environment, it is hard to figure out what mode to set when.
Also, the impact could be different for different workloads.
We should probably have a broader discussion around this
with data - I will share some measurements on impact
of such power modes.


> max_performance (unwilling to sacrifice any performance)
> 	scheduler: default (optimized for performance)
> 	cpuidle: disable all C-states except polling mode
> 	ondemand: disable all P-states except max perf
> 	msr_ia32_energy_perf_bias: 0 of 15
> 
> performance (care primarily about performance)
> 	scheduler: default (optimized for performance)
> 	cpuidle: enable all C-states subject to QOS
> 	ondemand: all P-states, using no bias
> 	msr_ia32_energy_perf_bias: 3 of 15
> 
> balanced (default)
> 	scheduler: enable sched_mc_power_savings
> 	cpuidle: enable all C-states subject to QOS
> 	ondemand: all P-states, powersave_bias=5
> 	msr_ia32_energy_perf_bias: 7 of 15

Would there be sufficient difference between performance
and balanced ?


> 
> powersave (can sacrifice measurable performance)
> 	scheduler: enable sched_smt_power_savings
> 	cpuidle: enable all C-states, subject to QOS
> 	ondemand: disable turbo mode, powersave_bias=10
> 	msr_ia32_energy_perf_bias: 11 of 15
> 
> max_powersave (can sacrifice significant performance)
> 	scheduler: enable sched_smt_power_savings
> 	cpuidle: enable all C-states, subject to QOS
> 	ondemand: min P-state (do not invoke T-states)
> 	msr_ia32_energy_perf_bias: 15 of 15


Thanks
Dipankar
