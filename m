Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1GGWeo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 18:34:44 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:46901 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751632Ab1GGWen (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 18:34:43 -0400
From: Kevin Hilman <khilman@ti.com>
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Colin Cross <ccross@android.com>
Subject: Re: [PATCH 0/3] Add generic idle notifiers
Organization: Texas Instruments, Inc.
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
	<87ei22dnsp.fsf@ti.com> <20110707201748.GB32199@google.com>
Date: Thu, 07 Jul 2011 15:34:38 -0700
In-Reply-To: <20110707201748.GB32199@google.com> (Todd Poynor's message of
	"Thu, 7 Jul 2011 13:17:48 -0700")
Message-ID: <87tyaxd8jl.fsf@ti.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Todd Poynor <toddpoynor@google.com> writes:

> On Thu, Jul 07, 2011 at 10:05:10AM -0700, Kevin Hilman wrote:
>> Todd Poynor <toddpoynor@google.com> writes:
>> 
>> > Add notifiers for idle entry and exit, called with IDLE_START when a
>> > CPU goes idle and IDLE_END when it goes out of idle, based on the
>> > existing idle notifiers for the x86_64 arch.
>> >
>> > Convert x86_64 to use these notifiers, and call the notifiers on ARM.
>> >
>> > Convert the ARM LEDs events for idle start/end to these notifiers.
>> 
>> Is this intended to replace the more general CPU PM notifiers proposed
>> by Colin:
>> 
>> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-June/052827.html
>
> This is intended to coexist with the CPU PM notifiers.  The idle
> notifiers proposed here are notifying of a change in kernel scheduler
> state: the scheduler has no task to run and is entering its "idle
> loop", or now has something to run and is exiting idle state.
> Things that can use this include power management hints such as the
> existing drivers/idle/i7300_idle.c usage, the ARM LEDs idle triggers,
> and there's probably other existing potential uses in other arch'es that
> I should go track down.
>
> The CPU PM notifiers notify of changes in hardware power state that
> affect the CPU and closely associated IP blocks (such as an OMAP
> power state transition that causes one or more CPU power domains to
> hit OFF).  These changes may be due to cpuidle power state management
> when the system is idle, or may be due to suspending or resuming the
> system (such as a suspend-to-RAM), or may be due to a CPU hotplug event.
> In the case of an idle loop entry, if cpuidle decides it is not
> appropriate to change CPU power state (as when insufficient time
> remains until next timer expiry to enter such a power state due to
> entry and exit latency), there may be no CPU PM notification
> generated.  The callbacks for CPU PM notifiers on ARM do things such
> as save/restore GIC interrupt controller state and VFP floating-point
> coprocessor state.
>
> That's the intent, anyhow, but ideas are welcome, thanks,

OK, thanks for the clarification.

Kevin
