Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab0K3Q27 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 11:28:59 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1751164Ab0K3Q26 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 11:28:58 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+h6OZiXZ+hyH1FU34Nxkh++9U+WAjFlM9sO7L6gO
	tnqRqZrDV8UIE6
Subject: Re: [PATCH v4] sched: automated per session task groups
From: Mike Galbraith <efault@gmx.de>
To: Ingo Molnar <mingo@elte.hu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Paul Turner <pjt@google.com>
In-Reply-To: <20101130141804.GB22588@elte.hu>
References: <1290700829.4759.16.camel@maggy.simson.net>
	 <1290954299.30515.15.camel@marge.simson.net>
	 <AANLkTin5Z_WdAPDfcS3V3DCcN40HLDfpzK-o0XeSMiQh@mail.gmail.com>
	 <20101128201851.GA20555@elte.hu> <1291031593.32004.19.camel@laptop>
	 <AANLkTimQ2Kp2=um9ip7J2=-joskmz4P-0b_SrexFbTh0@mail.gmail.com>
	 <1291052268.32004.171.camel@laptop>
	 <1291057565.20709.2.camel@marge.simson.net>
	 <20101129192033.GA18372@elte.hu>
	 <1291103647.24405.5.camel@marge.simson.net>
	 <20101130141804.GB22588@elte.hu>
Content-Type: text/plain
Date: Tue, 30 Nov 2010 17:28:51 +0100
Message-Id: <1291134531.28239.27.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-30 at 15:18 +0100, Ingo Molnar wrote:
> * Mike Galbraith <efault@gmx.de> wrote:
> 
> > On Mon, 2010-11-29 at 20:20 +0100, Ingo Molnar wrote:
> > > * Mike Galbraith <efault@gmx.de> wrote:
> > > 
> > > > > I know, from the testing so far we _thought_ it was fairly sane. Apparently 
> > > > > there's still some work to do.
> > > > 
> > > > Damn thing bisected to:
> > > > 
> > > > commit 92fd4d4d67b945c0766416284d4ab236b31542c4
> > > > Merge: fe7de49 e53beac
> > > > Author: Ingo Molnar <mingo@elte.hu>
> > > > Date:   Thu Nov 18 13:22:14 2010 +0100
> > > > 
> > > >     Merge commit 'v2.6.37-rc2' into sched/core
> > > > 
> > > >     Merge reason: Move to a .37-rc base.
> > > > 
> > > >     Signed-off-by: Ingo Molnar <mingo@elte.hu>
> > > > 
> > > > 92fd4d4d67b945c0766416284d4ab236b31542c4 is the first bad commit
> > > 
> > > Hm, i'd suggest to double check the two originator points:
> > > 
> > >   e53beac - is it really 'bad' ?
> > >   fe7de49 - is it really 'good'?
> > 
> > Nope.   I did a bisection this morning in text mode with a pipe-test
> > based measurement proggy, and it bisected cleanly.
> > 
> > 2069dd75c7d0f49355939e5586daf5a9ab216db7 is the first bad commit
> > 
> > commit 2069dd75c7d0f49355939e5586daf5a9ab216db7
> > Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Date:   Mon Nov 15 15:47:00 2010 -0800
> > 
> >     sched: Rewrite tg_shares_up)
> 
> Ok. And has this fixed it:
> 
>   822bc180a7f7: sched: Fix unregister_fair_sched_group()
> 
> ... or are there two bugs?

Two bugs.  822bc180a7f7 fixes the explosions that were happening in tip.
The interactivity issue is some problem in the update_shares() stuff.

	-Mike

