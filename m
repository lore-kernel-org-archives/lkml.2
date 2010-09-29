Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753790Ab0I2Htj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 03:49:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42173 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752819Ab0I2Hti (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 03:49:38 -0400
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Wed, 29 Sep 2010 09:49:33 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.31.5-0.1-desktop; KDE/4.4.3; x86_64; ; )
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jean Pihet <jean.pihet@newoldbits.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Len Brown <len.brown@intel.com>, arjan@infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009282322.16291.rjw@sisk.pl> <4CA261F4.5070803@linux.intel.com>
In-Reply-To: <4CA261F4.5070803@linux.intel.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009290949.34245.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 September 2010 23:45:24 Arjan van de Ven wrote:
>   On 9/28/2010 2:22 PM, Rafael J. Wysocki wrote:
> > On Tuesday, September 28, 2010, Jean Pihet wrote:
> >> Hi,
> > Hi,
> >
> >> Here is what I am proposing, in reply to all your comments:
> >>
> >> 1) rename the events to match Thomas's proposal:
> >>     power:power_cpu_cstate
> >>     power:power_cpu_pstate
> >>     power:power_cpu_sstate
I'd not name it that X86/ACPI specific.
    power:processor_sleep
    power:processor_frequency
    power:system_suspend
This would map with X86/ACPI c/p/s states but the name would
also match fine with ARM and other archs.

> > If that sstate thing is going to mean "suspend", then please drop
> > it.
> > "Suspend" is not a state, let alone a CPU state.  It is a procedure
> > by which the (entire) system is put into a sleep state (that is not
> > confined to CPUs).
> 
> there are also non-suspend S states, like S0i1 and S0i3 (supported in 
> the current Intel "Moorestown" platform)
> 
> so it's slightly more complex than "just" suspend :)
Something specific for this arch could get introduced, similar as
Jean did for the ARM specifics, e.g.:
power:moorestown_suspend
Intel probably invented three names for this new technique, one
might fit as an event name?
Depending whether extra info needs passed through this event it
could also use
    power:system_suspend
and pass a suspend state of #define S0i1 0x100, #define S0i2 0x101...

I try to find time to come up with another cleanup patch.
I also want to look at perf timechart then where I remember some ugly
hacks with C-state accounting and the broken state_start, state_end and 
frequency_switch events. Hope it won't get too ugly and perf timechart 
can support both, the old and the cleaned up events for a while.

    Thomas
