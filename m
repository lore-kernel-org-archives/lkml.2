Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab0LAShk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:37:40 -0500
Received: from casper.infradead.org ([85.118.1.10]:48994 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab0LAShk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:37:40 -0500
Subject: Re: [BUG(?)] perf_events: combining multiple tracepoint events
 into a group produces no counts on member events
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
In-Reply-To: <20101201182910.GC3438@nowhere>
References: <4CF59E20.1040301@linux.vnet.ibm.com>
	 <1291203990.4023.16.camel@twins> <1291205078.32004.1381.camel@laptop>
	 <20101201182910.GC3438@nowhere>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 01 Dec 2010 19:37:04 +0100
Message-ID: <1291228624.32004.1852.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-01 at 19:29 +0100, Frederic Weisbecker wrote:
> > +static int perf_event_add_tp(struct perf_event *event, int tp_id)
> > +{
> > +     if (event->attr.type != PERF_TYPE_TRACEPOINT &&
> 
> Should it be || instead?
> 
> > +         event->attr.config != ~0ULL)
> > +             return -EINVAL;
> > +
> > +     return __perf_event_add_tp(event, tp_id);
> > +} 

Probably,.. yeah.
