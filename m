Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753134Ab1C1H66 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 03:58:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:46347 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1C1H65 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 03:58:57 -0400
Subject: Re: [RFC] perf: EBNF for event syntax
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Matt Fleming <matt@console-pimps.org>,
        "2nddept-manager@sdl.hitachi.co.jp" 
	<2nddept-manager@sdl.hitachi.co.jp>
In-Reply-To: <4D901F58.4060902@hitachi.com>
References: <1300851416.31224.58.camel@minggr.sh.intel.com>
	 <1301051277.2250.195.camel@laptop>  <4D901F58.4060902@hitachi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 28 Mar 2011 09:58:10 +0200
Message-ID: <1301299090.4859.6.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-28 at 14:40 +0900, Masami Hiramatsu wrote:
> (2011/03/25 20:07), Peter Zijlstra wrote:
> > On Wed, 2011-03-23 at 11:36 +0800, Lin Ming wrote:
> >> Hi, all
> >>
> >> On Thu, Mar 17, 2011 at 2:02 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >>> How about we start writing proper EBNF syntax rules for this stuff, its
> >>> getting seriously out of hand.
> >> http://marc.info/?l=linux-kernel&m=130029871318866&w=2
> >>
> >> As Peter suggested, I wrote a simple EBNF for event syntax, as below.
> >> My first plan is to pass in extra config value for some events,
> >> for example, offcore response and load latency.
> >>
> >> perf record -e r100b(0004):p
> >>
> >> As above, the extra config value 0004 is passed in the parentheses.
> >>
> >> The EBNF
> >> ========
> >>
> >> EventList		:=	Event [',' EventList]
> > 
> > There was a suggestion a while back to make:
> > 
> >  -e ev1,ev2,ev3
> > 
> > create an event group with ev2 and ev3 siblings of ev1, and have
> > multiple -e instances create separate counters.
> > 
> > The problem is that its not backwards compatible, but something like
> > that would still be very nice to have.
> 
> I doubt that we really need to define those events are
> grouped at recording time, because group(event ratio)
> analysis must be done at analysis time(report etc.)

Uhm, grouping isn't at all related to event ratios, you can do event
ratios just fine without groups - there's some stronger correlation when
you do ratios with groups, but since its all statistics anyway, you can
get that same extra correlation by simply running longer too.

Groups are most useful in measuring events on another base, which is
basically mandatory if your primary event doesn't have sampling support
itself.

> IMHO, it should be done with a separate option instead of -e.

Possibly, but it would get pretty much the same syntax which might or
might not confuse people.
