Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757921Ab0KOQHz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:07:55 -0500
Received: from mail.openrapids.net ([64.15.138.104]:39697 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756430Ab0KOQHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 11:07:54 -0500
Date: Mon, 15 Nov 2010 11:07:45 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: ltt-dev@lists.casi.polymtl.ca, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] New tools: lttngtrace and lttngreport
Message-ID: <20101115160745.GA7203@Krystal>
References: <20101115134243.GA2772@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101115134243.GA2772@Krystal>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 10:45:56 up 53 days, 19:48,  4 users,  load average: 0.10, 0.19,
	0.14
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Mathieu Desnoyers (mathieu.desnoyers@efficios.com) wrote:
> Hi everyone,
> 
> Recently, Linus came up with a request: a "super-strace" based on kernel
> tracing. So I just came up with two bash scripts that perform exactly this within
> LTTng: lttngtrace starts tracing, runs a program, stops tracing. lttngreport
> generates a wakeup dependency report. I'm appending the script below (depends on
> LTTng kernel tree, LTTng modules package, ltt-control and lttv).
> 
> It will report which interrupt/softirq and wakeup dependency chain caused each
> wakeup, along with the duration within each step of the wakeup chain. This
> includes I/O activity, traps, and syscalls.

Hi again,

I just enhanced the wakeup dependency chain output to make it more
understandable by humans. It's astonishing what we can do with a bit of ASCII
art. For instance, here I am showing piece of firefox start trace:

        --> Blocked in RUNNING, SYSCALL 142 [sys_select+0x0/0xc0], ([...], dur: 0.029567)
        |    --> Blocked in RUNNING, SYSCALL 168 [sys_poll+0x0/0xc0], ([...], dur: 1.187935)
        |    --- Woken up by an IRQ: IRQ 0 [timer]
        --- Woken up in context of 7401 [gnome-power-man] in high-level state RUNNING

As you see, firefox blocked for 29.5 microseconds on select() waiting for a file
descriptor, the wake up came from "gnome-power-manager" after the poll() timed
out (1 second timeout). (This specific scenario cannot be reproduced at every
firefox run, but it is still a good example of how these spurious delays can be
identified with the tool.)

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
