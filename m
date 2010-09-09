Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0IIKjO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 06:39:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:35990 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab0IIKjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 06:39:11 -0400
Subject: Re: [process scheduler] Possible bug in context_swich()?
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: fabio de francesco <fabio@metanix.org>,
        LKML <linux-kernel@vger.kernel.org>, Tim Blechmann <tim@klingt.org>,
        Ingo Molnar <mingo@elte.hu>
In-Reply-To: <1283999539.9103.54.camel@marge.simson.net>
References: <201009081728.18227.fabio@metanix.org>
	 <1283961258.23762.33.camel@laptop>
	 <1283999539.9103.54.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 09 Sep 2010 12:39:06 +0200
Message-ID: <1284028746.23762.54.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-09-09 at 04:32 +0200, Mike Galbraith wrote:
> On Wed, 2010-09-08 at 17:54 +0200, Peter Zijlstra wrote:
> > On Wed, 2010-09-08 at 17:28 +0200, fabio de francesco wrote:
> > 
> > > In context_switch() (in linux/kernel/sched.c), starting with release 2.6.33, 
> > > two "unlikely" macro  have been changed to "likely". I think the previous 
> > > logic was right while the latter is wrong.
> > > 
> > > In case I am missing something I, please, ask someone to explain the above 
> > > mentioned inversion of logic through releases.
> > 
> > It helps if you CC people, LKML alone is a bit of a gamble.
> > 
> > git blame kernel/sched.c, will tell you that the change you refer to
> > comes from:
> > 
> > commit 710390d90f143a9ebb87a475215140f426792efd
> > Author: Tim Blechmann <tim@klingt.org>
> > Date:   Tue Nov 24 11:55:27 2009 +0100
> > 
> >     sched: Optimize branch hint in context_switch()
> >     
> >     Branch hint profiling on my nehalem machine showed over 90%
> >     incorrect branch hints:
> 
> That change never made any sense to me, seems Tim must have been
> measuring a kthread load.  I benched at the time, and saw absolutely
> zero difference one way or the other wrt max ctx rate on my Q6600.

One option is to simply remove the whole branch hint.. But lets ask Tim
what kind of workload he used..
