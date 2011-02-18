Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab1BRPs3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:48:29 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3409 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753393Ab1BRPs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:48:26 -0500
Subject: Re: [PATCH] gpio: add trace events for setting direction and value
From: Steven Rostedt <srostedt@redhat.com>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
In-Reply-To: <20110218095803.GY22310@pengutronix.de>
References: <1297875784-2302-1-git-send-email-u.kleine-koenig@pengutronix.de>
	 <1297876371.26768.7235.camel@fedora>
	 <20110218095803.GY22310@pengutronix.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat
Date: Fri, 18 Feb 2011 10:48:06 -0500
Message-ID: <1298044086.26768.7242.camel@fedora>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 10:58 +0100, Uwe Kleine-König wrote:
> Hi Steven, hi Grant,
> 
> On Wed, Feb 16, 2011 at 12:12:51PM -0500, Steven Rostedt wrote:
> > Note: to save the memory footprint of these tracepoints, you can use
> > DEFINE_EVENT_PRINT(). You can see the usage for this in the
> > include/trace/events/kmem.h.
> > But to do this, you will need to have a single TP_STRUCT__entry() for
> > both. Not sure if this is what you want.
> > 
> > 	TP_STRUCT__entry(
> > 		__field(unsigned, gpiq)
> > 		__field(int, get_in)
> > 		__field(int, value_err)
> > 
> > ??
> > 
> > Just a suggestion, but may not be worth it.
> Yeah, I saw that, still I think it's sane to keep them seperated.
> Or how much would we save?  Can you estimate that?

You can do it :)   Especially since it can vary by archs.

Just compile the kernel once this way, and then try it with
DEFINE_EVENT_PRINT(), compile the kernel and run size on the two.

Then you can see the difference it makes. It may end up not being worth
the difference. But as embedded uses gpio the most, I'll leave that up
to you.

-- Steve



