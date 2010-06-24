Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab0FXJhT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 05:37:19 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:49438 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754402Ab0FXJhQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 05:37:16 -0400
Date: Thu, 24 Jun 2010 11:36:25 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <peterz@infradead.org>,
       Greg KH <greg@kroah.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Paul Mundt <lethal@linux-sh.org>,
       "eranian@gmail.com" <eranian@gmail.com>,
       "Gary.Mohr@Bull.com" <Gary.Mohr@bull.com>,
       "arjan@linux.intel.com" <arjan@linux.intel.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>,
       Russell King <rmk+kernel@arm.linux.org.uk>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Will Deacon <will.deacon@arm.com>, Maynard Johnson <mpjohn@us.ibm.com>,
       Carl Love <carll@us.ibm.com>, Kay Sievers <kay.sievers@vrfy.org>,
       lkml <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [rfc] Describe events in a structured way via sysfs
Message-ID: <20100624093625.GA26931@elte.hu>
References: <20100520231229.GB8335@kroah.com>
 <1274429038.1674.1684.camel@laptop>
 <20100521094053.GA4658@elte.hu>
 <AANLkTimf1Z0N9cv2Pu2qTTUscn4utC37zOPelCbqQoPv@mail.gmail.com>
 <1277110509.18390.28.camel@minggr.sh.intel.com>
 <1277112858.3618.16.camel@jlt3.sipsolutions.net>
 <1277187920.4467.3.camel@minggr.sh.intel.com>
 <1277189971.3637.5.camel@jlt3.sipsolutions.net>
 <1277191359.5025.4.camel@minggr.sh.intel.com>
 <1277192007.3637.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277192007.3637.8.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -1.1
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.1 required=5.9 tests=BAYES_05 autolearn=no SpamAssassin version=3.2.5
	-1.1 BAYES_05               BODY: Bayesian spam probability is 1 to 5%
	[score: 0.0159]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Johannes Berg <johannes@sipsolutions.net> wrote:

> On Tue, 2010-06-22 at 15:22 +0800, Lin Ming wrote:
> 
> > > > net/wlan0/events/
> > > > net/waln1/events/
> > > > ....
> > > > net/walnN/events/
> > > 
> > > That's not appropriate either though since you may have multiple network 
> > > interfaces on the same hardware :)
> > 
> > Doesn't net/wlan0...wlanN mean multiple network interfaces on the same 
> > hardware?
> 
> Yes, but the trace points aren't per network interface but rather per 
> hardware piece.

Yeah - we generally want events to live at their 'natural' source in sysfs.

So if it's a per device hardware event, it should live with the hardware 
piece. If it's a higher level chipset event, it should live where the chipset 
driver is in sysfs. If it's a subsystem level event then it should live there.

I think what you mentioned in your other posting makes the most sense: give 
flexibility to tracepoint authors to place the event in the most sensible 
sysfs place. It is them who define the tracepoints and the events so any 
second guessing by a generic layer will probably get in the way. The generic 
tool layer will be content with having the event_source class in sysfs, to see 
'all' event sources ttheir topological structure.

That's probably best achieved via a TRACE_EVENT() variant, by passing in the 
sysfs location.

It might even make sense to make this a part of TRACE_EVENT() itself and make 
'NULL' the current default, non-sysfs-enumerated behavior. That way we can 
gradually (and non-intrusively) find all the right sysfs places for events.

Thanks,

	Ingo
