Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1BJQQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:16:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38600 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752287Ab1BJQQL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:16:11 -0500
Date: Thu, 10 Feb 2011 14:15:37 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Mike Galbraith <efault@gmx.de>
Cc: Ingo Molnar <mingo@elte.hu>, mingo@redhat.com, hpa@zytor.com,
        paulus@samba.org, eranian@google.com, linux-kernel@vger.kernel.org,
        tzanussi@gmail.com, peterz@infradead.org, fweisbec@gmail.com,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] perf annotate: Fix annotate context lines
	regression
Message-ID: <20110210161537.GA20676@ghostprotocols.net>
References: <new-submission> <tip-d5e3d747007fdb541e57ed72e020ff0b94db3470@git.kernel.org> <1297224378.8035.7.camel@marge.simson.net> <20110209164154.GA15607@ghostprotocols.net> <1297309313.7996.11.camel@marge.simson.net> <20110210121559.GA26094@elte.hu> <1297341811.5512.36.camel@marge.simson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297341811.5512.36.camel@marge.simson.net>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 01:43:31PM +0100, Mike Galbraith escreveu:
> On Thu, 2011-02-10 at 13:15 +0100, Ingo Molnar wrote:
> > * Mike Galbraith <efault@gmx.de> wrote:
> > 
> > > Initial impression: can I have a pony too? :)
> > > 
> > > I like this a lot, great for live rummaging.  One thing that would help with large 
> > > files maybe - a jump to next spot hotter than N%, but as is is quite nice.

It already does that if you use TAB/shift-TAB, first one goes to the
hottest line, next one to the 2nd place, etc, shift-TAB goes the other
direction.

There are some problems with that as on the first snapshot, just after
parsing the sources, all lines have zero hits, I plan to fix that doing
something like 'top' does, which is to wait a bit, say 2 seconds
collecting samples, then show the annotation centered on the hottest
line so far.

> > > I managed to lock it up once, but shiny new gizmos usually do hiccup.
> > 
> > The TUI locked up or the kernel? If it's the TUI then a gdb dump of the lockup would 
> > be nice.
> 
> TUI stopped responding to my key poking.  I'll see if it'll repeat
> (weekend).

Probably is something I already noticed and fixed, some mutex lock
inbalance, I'll repost it soon.

- Arnaldo
