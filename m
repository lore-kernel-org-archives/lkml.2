Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2BLVeX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 16:34:23 -0500
Received: from gate.crashing.org ([63.228.1.57]:41214 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755901Ab2BLVeV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 16:34:21 -0500
Message-ID: <1329082390.3019.17.camel@pasglop>
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        Todd Poynor <toddpoynor@google.com>,
        Russell King <linux@arm.linux.org.uk>,
        Nicolas Pitre <nico@fluxnic.net>, Oleg Nesterov <oleg@redhat.com>,
        cpufreq@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        linaro-kernel@lists.linaro.org, Mike Chan <mike@android.com>,
        Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        kernel-team@android.com, linux-arm-kernel@lists.infradead.org,
        Arjan Van De Ven <arjan@infradead.org>
Date: Mon, 13 Feb 2012 08:33:10 +1100
In-Reply-To: <1328971983.11320.5.camel@laptop>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org>  <20120211143951.GA24564@sirena.org.uk>
	 <1328971983.11320.5.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 15:53 +0100, Peter Zijlstra wrote:
> On Sat, 2012-02-11 at 14:39 +0000, Mark Brown wrote:
> > 
> > For step downs this isn't such a big deal as we don't often care if the
> > voltage drops immediately but for step ups it's critical as if the
> > voltage hasn't ramped before the CPU tries to run at the higher
> > frequency the CPU will brown out. 
> 
> Why isn't all this done by micro-controllers, software writes a desired
> state in some machine register (fast), micro-controller sets about
> making it so in an asynchronous way. If it finds the settings have
> changed by the time it reached its former goal, goto 1.
> 
> Having to actually wait for this in software is quite ridiculous.

Not necessarily micro-controllers no. Or rather, it's generally done by
uC (or system controllers) on desktop or server machines, but not on
embedded (ie. phones) where arguably that's where it is the most
important :-)

Now often (but not always) the trigger to initiate a change is indeed a
simple register or register-based gpio, so that's fast. But you also
often have to wait for a transition to be complete before initiating
another one, or sychronize between voltage and frequency.

For example, if you are ramping up, you need to up the voltage first,
then wait for it to reach the nominal value & stabilize, then ramp up
the frequency. It's not that often automated.

Then there's the case where to communicate with those chips, you have to
go via a bus such as i2c which requires schedulable contexts.

Cheers,
Ben.


