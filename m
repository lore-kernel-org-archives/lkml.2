Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759604Ab2BOOyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 09:54:17 -0500
Received: from casper.infradead.org ([85.118.1.10]:41737 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab2BOOyO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 09:54:14 -0500
Message-ID: <1329317650.2293.129.camel@twins>
Subject: Re: [PATCH] hrtimers: Special-case zero length sleeps
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Matthew Garrett <mjg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Date: Wed, 15 Feb 2012 15:54:10 +0100
In-Reply-To: <alpine.LFD.2.02.1202151537500.2794@ionos>
References: <1317308372-6810-1-git-send-email-mjg@redhat.com>
	 <alpine.LFD.2.02.1202151537500.2794@ionos>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-02-15 at 15:40 +0100, Thomas Gleixner wrote:
> On Thu, 29 Sep 2011, Matthew Garrett wrote:
> 
> > sleep(0) is a common construct used by applications that want to trigger
> > the scheduler. sched_yield() might make more sense, but only appeared in
> > POSIX.1-2001 and so plenty of example code still uses the sleep(0) form.

Note that sched_yield() is unspecified for SCHED_OTHER, so any
application using it that is not a real-time application is outside spec
anyway.

Furthermore, both sched_yield() and sleep(0) are fair indications the
application is broken, wait for proper events, not random delays.

> > This wouldn't normally be a problem, but it means that event-driven
> > applications that are merely trying to avoid starving other processes may
> > actually end up sleeping due to having large timer_slack values. Special-
> > casing this seems reasonable.

Again, sleep granularity isn't specified and thus this behaviour isn't
actually buggy, all the spec promises is we won't sleep shorter than
asked.

Also, starvation avoidance isn't something that userspace should concern
itself with.
