Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0I1VXT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 17:23:19 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:50736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315Ab0I1VXS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 17:23:18 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jean Pihet <jean.pihet@newoldbits.com>
Subject: Re: [PATCH] tracing, perf: add more power related events
Date: Tue, 28 Sep 2010 23:22:15 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Thomas Renninger <trenn@suse.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Peter Zijlstra <peterz@infradead.org>, Len Brown <len.brown@intel.com>,
        arjan@infradead.org, Kevin Hilman <khilman@deeprootsystems.com>,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-omap@vger.kernel.org, linux-perf-users@vger.kernel.org,
        linux-trace-users@vger.kernel.org
References: <AANLkTinUmbSUUuxUzc8++pcb9gd1CZFdyTQFrveTBXyV@mail.gmail.com> <201009222049.18154.rjw@sisk.pl> <AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com>
In-Reply-To: <AANLkTinJU5+s_1S6i4GpRuiOfsAPiL9UFtrxCCbtoumt@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009282322.16291.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 28, 2010, Jean Pihet wrote:
> Hi,

Hi,

> Here is what I am proposing, in reply to all your comments:
> 
> 1) rename the events to match Thomas's proposal:
>    power:power_cpu_cstate
>    power:power_cpu_pstate
>    power:power_cpu_sstate

If that sstate thing is going to mean "suspend", then please drop it.
"Suspend" is not a state, let alone a CPU state.  It is a procedure by which
the (entire) system is put into a sleep state (that is not confined to CPUs).

>    ...
> 
> 2) introduce a new Kconfig option CONFIG_DEPRECATED_POWER_EVENTS and
> conditionally map a subset of the new events to the old ones for
> backward compatibility with the existing user apps. The apps should be
> converted to the new API asap,
> 
> 3) update documentation

Sounds reasonable.

> Other remarks here below:
> 
> On Wed, Sep 22, 2010 at 8:49 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> ...
> > This POWER_SSTATE thing seems to be totally artificial and omap-specific.
> >
> > Why do you want it to be done this way?
> >
> > Or is the ACPI handling added in the ACPI patch?  In which case, why don't you
> > put that power_switch_state(POWER_SSTATE, 1, 0, cpu) into
> > kernel/power/suspend.c:suspend_enter() (and analogously for
> > power_switch_state(POWER_SSTATE, 0, 0, cpu)).
> The ACPI code is not using the SSTATE event.
> Indeed inserting a tracepoint at
> kernel/power/suspend.c:suspend_enter() is more generic. I will correct
> this.

OK

> > Moreover, why is the cpu argument necessary for POWER_SSTATE at all?
> The cpu_id parameter is present in all events prototypes. This is not
> needed. I will correct this.

OK

Thanks,
Rafael
