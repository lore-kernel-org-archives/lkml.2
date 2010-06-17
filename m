Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933023Ab0FQQPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 12:15:12 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63284 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932948Ab0FQQPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 12:15:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=references:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:x-mailer:mime-version:subject:date:cc;
        b=IqvVGw+/dC2K0BMz+/e/PFH8oce6L9npKIWW/9J/vFzlQP6wryoSBsS8DDNqpG4xz1
         11sm4Tvbwbob7eChdHcwK5Kng7h7uBLxRwCje7g3N5OrrJgmvOjtJVO+bjx9H/FFmN+u
         RjpiMq2mZydyvjmSCZ3k+U5POQLowJHtmpYzs=
References: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
Message-Id: <0F1C0B07-60D6-405B-890B-F9C320820CA5@gmail.com>
From: Victor Lowther <victor.lowther@gmail.com>
To: Len Brown <lenb@kernel.org>
In-Reply-To: <alpine.LFD.2.00.1006161659140.24913@localhost.localdomain>
Content-Type: text/plain;
	charset=us-ascii;
	format=flowed;
	delsp=yes
Content-Transfer-Encoding: 7bit
X-Mailer: iPhone Mail (7D11)
Mime-Version: 1.0 (iPhone Mail 7D11)
Subject: Re: [linux-pm] RFC: /sys/power/policy_preference
Date: Thu, 17 Jun 2010 11:14:50 -0500
Cc: Linux Power Management List <linux-pm@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org





On Jun 16, 2010, at 4:05 PM, Len Brown <lenb@kernel.org> wrote:

> Create /sys/power/policy_preference, giving user-space
> the ability to express its preference for kernel based
> power vs. performance decisions in a single place.
>
> This gives kernel sub-systems and drivers a central place
> to discover this system-wide policy preference.
> It also allows user-space to not have to be updated
> every time a sub-system or driver adds a new power/perf knob.

I would prefer documenting all the current knobs and adding them to pm- 
utils so that pm-powersave knows about and can manage them. Once that  
is done, creating arbitrary powersave levels should be fairly simple.

> policy_preference has 5 levels, from max_performance
> through max_powersave.  Here is how 4 parts of the kernel
> might respond to those 5 levels:
>
> max_performance (unwilling to sacrifice any performance)
>    scheduler: default (optimized for performance)
>    cpuidle: disable all C-states except polling mode
>    ondemand: disable all P-states except max perf
>    msr_ia32_energy_perf_bias: 0 of 15
>
> performance (care primarily about performance)
>    scheduler: default (optimized for performance)
>    cpuidle: enable all C-states subject to QOS
>    ondemand: all P-states, using no bias
>    msr_ia32_energy_perf_bias: 3 of 15
>
> balanced (default)
>    scheduler: enable sched_mc_power_savings
>    cpuidle: enable all C-states subject to QOS
>    ondemand: all P-states, powersave_bias=5
>    msr_ia32_energy_perf_bias: 7 of 15
>
> powersave (can sacrifice measurable performance)
>    scheduler: enable sched_smt_power_savings
>    cpuidle: enable all C-states, subject to QOS
>    ondemand: disable turbo mode, powersave_bias=10
>    msr_ia32_energy_perf_bias: 11 of 15
>
> max_powersave (can sacrifice significant performance)
>    scheduler: enable sched_smt_power_savings
>    cpuidle: enable all C-states, subject to QOS
>    ondemand: min P-state (do not invoke T-states)
>    msr_ia32_energy_perf_bias: 15 of 15
>
> Note that today Linux is typically operating in the mode
> called "performance" above, rather than "balanced",
> which is proposed to be the default.  While a system
> should work well if left in "balanced" mode, it is likely
> that some users would want to use "powersave" when on
> battery and perhaps shift to "performance" on A/C.
>
> Please let me know what you think.
>
> thanks,
> Len Brown, Intel Open Source Technology Center
> _______________________________________________
> linux-pm mailing list
> linux-pm@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/linux-pm
