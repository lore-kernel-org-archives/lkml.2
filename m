Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991Ab0IILa7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 07:30:59 -0400
Received: from smtp207.alice.it ([82.57.200.103]:44496 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752705Ab0IILa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 07:30:56 -0400
X-Greylist: delayed 332 seconds by postgrey-1.27 at vger.kernel.org; Thu, 09 Sep 2010 07:30:56 EDT
From: fabio de francesco <fabio@metanix.org>
Organization: metanix.org
To: Tim Blechmann <tim@klingt.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [process scheduler] Possible bug in context_swich()?
Date: Thu, 9 Sep 2010 13:25:19 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-tuxonice-r1-100826; KDE/4.4.5; x86_64; ; )
Cc: Peter Zijlstra <peterz@infradead.org>, Mike Galbraith <efault@gmx.de>,
        Ingo Molnar <mingo@elte.hu>
References: <201009081728.18227.fabio@metanix.org> <1284028746.23762.54.camel@laptop> <201009091312.25424.tim@klingt.org>
In-Reply-To: <201009091312.25424.tim@klingt.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201009091325.20641.fabio@metanix.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 09 September 2010 13:12:18 Tim Blechmann wrote:
> On Thursday, September 09, 2010 12:39:06 pm Peter Zijlstra wrote:
> > On Thu, 2010-09-09 at 04:32 +0200, Mike Galbraith wrote:
> > > On Wed, 2010-09-08 at 17:54 +0200, Peter Zijlstra wrote:
> > > > On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:
> > > > > In context_switch() (in linux/kernel/sched.c), starting with
> > > > > release 2.6.33, two "unlikely" macro  have been changed to
> > > > > "likely". I think the previous logic was right while the latter is
> > > > > wrong.
> > > > > 
> > > > > In case I am missing something I, please, ask someone to explain
> > > > > the above mentioned inversion of logic through releases.
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

There could have been just kernel threads ready to run... Could a server or 
workstation workload behave differently?

fabio

