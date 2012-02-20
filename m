Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753004Ab2BTLEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 06:04:09 -0500
Received: from casper.infradead.org ([85.118.1.10]:49618 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752506Ab2BTLEG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 06:04:06 -0500
Message-ID: <1329735829.2293.309.camel@twins>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        linaro-kernel@lists.linaro.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Oleg Nesterov <oleg@redhat.com>, cpufreq@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mike Chan <mike@android.com>, Dave Jones <davej@redhat.com>,
        Todd Poynor <toddpoynor@google.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 20 Feb 2012 12:03:49 +0100
In-Reply-To: <20120217090022.GA24856@comet.dominikbrodowski.net>
References: <1328670355.2482.68.camel@laptop>
	 <20120208202314.GA28290@redhat.com> <1328736834.2903.33.camel@pasglop>
	 <20120209075106.GB18387@elte.hu> <4F35DD3E.4020406@codeaurora.org>
	 <20120211144530.GA497@elte.hu> <4F3AEC4E.9000303@codeaurora.org>
	 <1329313085.2293.106.camel@twins>
	 <20120215140245.GB27825@n2100.arm.linux.org.uk>
	 <1329318063.2293.136.camel@twins>
	 <20120217090022.GA24856@comet.dominikbrodowski.net>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 10:00 +0100, Dominik Brodowski wrote:
> 
> Well, we can actually have both: Adding a new cpufreq governor "scheduler"
> is easy. The scheduler stores the target frequency (in per-cent or
> per-mille) in (per-cpu) data available to this governor, and kick a
> (per-cpu?) thread which then handels the rest -- by existing cpufreq means.
> The cpufreq part is easy, the sched part less so (I think). 

You might not have been reading what I wrote, kicking a kthread (or
doing any other scheduler activity) from within the scheduler is way
ugly and something I'd really rather avoid if at all possible.

Yes I could do it, but I really really don't want to.
