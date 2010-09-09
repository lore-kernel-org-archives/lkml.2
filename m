Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753643Ab0IILZR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:25:17 -0400
Received: from mtagate7.uk.ibm.com ([194.196.100.167]:48057 "EHLO
	mtagate7.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0IILZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:25:15 -0400
Date: Thu, 9 Sep 2010 13:25:12 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Tim Blechmann <tim@klingt.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        fabio de francesco <fabio@metanix.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [process scheduler] Possible bug in context_swich()?
Message-ID: <20100909112512.GA2228@osiris.boeblingen.de.ibm.com>
References: <201009081728.18227.fabio@metanix.org>
 <1283999539.9103.54.camel@marge.simson.net>
 <1284028746.23762.54.camel@laptop>
 <201009091312.25424.tim@klingt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009091312.25424.tim@klingt.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 09, 2010 at 01:12:18PM +0200, Tim Blechmann wrote:
> On Thursday, September 09, 2010 12:39:06 pm Peter Zijlstra wrote:
> > On Thu, 2010-09-09 at 04:32 +0200, Mike Galbraith wrote:
> > > On Wed, 2010-09-08 at 17:54 +0200, Peter Zijlstra wrote:
> > > > On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:
> > > > > In context_switch() (in linux/kernel/sched.c), starting with release
> > > > > 2.6.33, two "unlikely" macro  have been changed to "likely". I think
> > > > > the previous logic was right while the latter is wrong.
> > > > > 
> > > > > In case I am missing something I, please, ask someone to explain the
> > > > > above mentioned inversion of logic through releases.
> > > > 
> > > > It helps if you CC people, LKML alone is a bit of a gamble.
> > > > 
> > > > git blame kernel/sched.c, will tell you that the change you refer to
> > > > comes from:
> > > > 
> > > > commit 710390d90f143a9ebb87a475215140f426792efd
> > > > Author: Tim Blechmann <tim@klingt.org>
> > > > Date:   Tue Nov 24 11:55:27 2009 +0100
> > > > 
> > > >     sched: Optimize branch hint in context_switch()
> > > >     
> > > >     Branch hint profiling on my nehalem machine showed over 90%
> > > 
> > > >     incorrect branch hints:
> > > That change never made any sense to me, seems Tim must have been
> > > measuring a kthread load.  I benched at the time, and saw absolutely
> > > zero difference one way or the other wrt max ctx rate on my Q6600.
> > 
> > One option is to simply remove the whole branch hint.. But lets ask Tim
> > what kind of workload he used..
> 
> i was using a standard desktop workload, nothing special ...

Just out of curiosity I tried this with two kernel builds on a six way
machine with latest git head and got these numbers:

 correct incorrect  %        Function                  File              Line
 ------- ---------  -        --------                  ----              ----
  644387   484258  42 context_switch                 sched.c              2851
  677534   451199  39 context_switch                 sched.c              2858

So the hints seem to be rather pointless.
