Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904Ab2BHUYD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 15:24:03 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26431 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab2BHUYA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 15:24:00 -0500
Date: Wed, 8 Feb 2012 15:23:15 -0500
From: Dave Jones <davej@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Anton Vorontsov <anton.vorontsov@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        Russell King <linux@arm.linux.org.uk>, Oleg Nesterov <oleg@redhat.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
        Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
        kernel-team@android.com, linaro-kernel@lists.linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arjan Van De Ven <arjan@infradead.org>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
Message-ID: <20120208202314.GA28290@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Anton Vorontsov <anton.vorontsov@linaro.org>,
	Ingo Molnar <mingo@elte.hu>, Russell King <linux@arm.linux.org.uk>,
	Oleg Nesterov <oleg@redhat.com>,
	Benjamin Herrenschmidt <benh@kernel.crashing.org>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Nicolas Pitre <nico@fluxnic.net>, Mike Chan <mike@android.com>,
	Todd Poynor <toddpoynor@google.com>, cpufreq@vger.kernel.org,
	kernel-team@android.com, linaro-kernel@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	Arjan Van De Ven <arjan@infradead.org>
References: <20120208013959.GA24535@panacea>
 <1328670355.2482.68.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328670355.2482.68.camel@laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 04:05:55AM +0100, Peter Zijlstra wrote:
 
 > Argh, no.. cpufreq so sucks rocks. Can we please just scrap it and write
 > an entirely new infrastructure that is much more connected to the
 > scheduler and do away with this stupid need to set P-states from a
 > schedulable context.

Well there's bits of it that will live on regardless of implementation
(The lower level drivers are pretty much necessary). But all the rest..

If the new scheduler bits grew a per-task proc file for their power saving
policy (powersave/performance/scale on-demand), and a sysfs knob to set
the default policy, then I think a lot of the horrors in ondemand.c etc
could just go away.

Some of what the existing governors do would need reimplementing, but the
scheduler has the smarts to make the right decisions anyway.

The midlayer glue (cpufreq.c) could mostly go away, along with as many
of the user-facing knobs as possible.

I think the biggest mistake we ever made with cpufreq was making it
so configurable. If we redesign it, just say no to plugin governors, and
yes to a lot fewer sysfs knobs.

So, provide mechanism to kill off all the governors, and there's a
migration path from what we have now to something that just works
in a lot more cases, while remaining configurable enough for the corner-cases.

	Dave

