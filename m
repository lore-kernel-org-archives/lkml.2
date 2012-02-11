Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758808Ab2BKOxT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 09:53:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:40301 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254Ab2BKOxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 09:53:18 -0500
Subject: Re: [PATCH RFC 0/4] Scheduler idle notifiers and users
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Saravana Kannan <skannan@codeaurora.org>, Ingo Molnar <mingo@elte.hu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
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
In-Reply-To: <20120211143951.GA24564@sirena.org.uk>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org>  <20120211143951.GA24564@sirena.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 11 Feb 2012 15:53:03 +0100
Message-ID: <1328971983.11320.5.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 14:39 +0000, Mark Brown wrote:
> 
> For step downs this isn't such a big deal as we don't often care if the
> voltage drops immediately but for step ups it's critical as if the
> voltage hasn't ramped before the CPU tries to run at the higher
> frequency the CPU will brown out. 

Why isn't all this done by micro-controllers, software writes a desired
state in some machine register (fast), micro-controller sets about
making it so in an asynchronous way. If it finds the settings have
changed by the time it reached its former goal, goto 1.

Having to actually wait for this in software is quite ridiculous.

