Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759261Ab2BONia (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 08:38:30 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34882 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758246Ab2BONiY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 08:38:24 -0500
Message-ID: <1329313084.2293.105.camel@twins>
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
Date: Wed, 15 Feb 2012 14:38:04 +0100
In-Reply-To: <20120211153324.GC31887@opensource.wolfsonmicro.com>
References: <20120208013959.GA24535@panacea>
	 <1328670355.2482.68.camel@laptop> <20120208202314.GA28290@redhat.com>
	 <1328736834.2903.33.camel@pasglop> <20120209075106.GB18387@elte.hu>
	 <4F35DD3E.4020406@codeaurora.org> <20120211143951.GA24564@sirena.org.uk>
	 <1328971983.11320.5.camel@laptop>
	 <20120211153324.GC31887@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-02-11 at 15:33 +0000, Mark Brown wrote:
> > Having to actually wait for this in software is quite ridiculous.
> 
> Well, it's also not terribly hard. 

Having to schedule from the scheduler is. Which is exactly the situation
you'll end up with if you want scheduler driven cpufreq, which I thought
everybody wanted because polling state sucks.

>  There's use cases for having this
> stuff offloaded but if you're not doing that stuff then why deal with
> the complication of designing the hardware? 

Because doing it in software is more expensive?

Penny-wise pound-foolish like thing.. you make the software requirements
more complex, which results in more bugs (more cost in debugging), more
runtime (for doing the 'software' thing), less power savings.

Esp since all this uC/system-controller stuff is already available and
validated.


