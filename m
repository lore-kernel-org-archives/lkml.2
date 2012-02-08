Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab2BHVe6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 16:34:58 -0500
Received: from gate.crashing.org ([63.228.1.57]:37615 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750864Ab2BHVe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 16:34:56 -0500
Message-ID: <1328736834.2903.33.camel@pasglop>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Dave Jones <davej@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Russell King <linux@arm.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arjan Van De Ven <arjan@infradead.org>
Date: Thu, 09 Feb 2012 08:33:54 +1100
In-Reply-To: <20120208202314.GA28290@redhat.com>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-08 at 15:23 -0500, Dave Jones wrote:
> I think the biggest mistake we ever made with cpufreq was making it
> so configurable. If we redesign it, just say no to plugin governors,
> and
> yes to a lot fewer sysfs knobs.
> 
> So, provide mechanism to kill off all the governors, and there's a
> migration path from what we have now to something that just works
> in a lot more cases, while remaining configurable enough for the
> corner-cases.

On the other hand, the need for schedulable contxts may not necessarily
go away.

If you look beyond x86, there's several issues that get into the
picture. i2c clock chips & power control chips are slow (the i2c bus
itself is). You don't want to spin for hundreds of microsecs while you
do those transactions.

I have seen many cases where the clock control can be done quite
quickly, but on the other hand, the voltage control takes dozens of ms
to reach the target value & stabilize.

That could be done asynchronously .. as long as the scheduler doesn't
constantly hammer it with change requests.

Cheers,
Ben.


