Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2J3Xy4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:54:56 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40286 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755548Ab2J3Xyy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:54:54 -0400
MIME-Version: 1.0
In-Reply-To: <1351623668.4004.28.camel@gandalf.local.home>
References: <20121029202711.062749374@goodmis.org>
	<20121029203848.109112386@goodmis.org>
	<1351623668.4004.28.camel@gandalf.local.home>
Date: Wed, 31 Oct 2012 00:54:53 +0100
Message-ID: <CAFTL4hxAW5fG4SFQMaEueFQgbc3yDgUWQ_dzKEyYuecsdGMf+A@mail.gmail.com>
Subject: Re: [PATCH 10/32] nohz/cpuset: Restart the tick if printk needs it
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Alessio Igor Bogani <abogani@kernel.org>, Avi Kivity <avi@redhat.com>,
        Chris Metcalf <cmetcalf@tilera.com>, Christoph Lameter <cl@linux.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Geoff Levand <geoff@infradead.org>,
        Gilad Ben Yossef <gilad@benyossef.com>,
        Hakan Akkan <hakanakkan@gmail.com>, Kevin Hilman <khilman@ti.com>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Sven-Thorsten Dietrich <thebigcorporation@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/30 Steven Rostedt <rostedt@goodmis.org>:
> Probably need to at least disable preemption. I don't see any
> requirement that wake_up_klogd() needs to be called with preemption
> disabled.
>
> The this_cpu_or() doesn't care which CPU it triggers, but the enabling
> of nohz does.

This patch is deemed to be replaced with the printk in nohz patchset
I'm working on. But it indeed to disable preemption as well and its
irq work should be made per cpu.
