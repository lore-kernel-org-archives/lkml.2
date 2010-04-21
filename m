Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753663Ab0DUMOE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 08:14:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752940Ab0DUMOA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 08:14:00 -0400
Date: Wed, 21 Apr 2010 14:12:53 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>, linux-rt-users@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Clark Williams <williams@redhat.com>,
       "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [PATCH v3] lockdep: Make MAX_STACK_TRACE_ENTRIES configurable.
In-Reply-To: <1271849823.1776.87.camel@laptop>
Message-ID: <alpine.LFD.2.00.1004211407510.4506@localhost.localdomain>
References: <alpine.LFD.2.00.1004161329030.11320@localhost.localdomain> <alpine.LFD.2.00.1004161727000.11320@localhost.localdomain> <alpine.LFD.2.00.1004191841230.6259@localhost> <20100420140941.d085007d.akpm@linux-foundation.org> <alpine.LFD.2.00.1004211309560.6646@localhost>
 <1271849823.1776.87.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 21 Apr 2010, Peter Zijlstra wrote:

> On Wed, 2010-04-21 at 13:12 +0200, John Kacur wrote:
> > 
> > Certain configurations that have LOCKDEP turned on, run into the limit
> > where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply
> > turning of the locking correctness validator let the user configure this
> > value to something reasonable for their system.
> 
> I'm not sure its worth having a CONFIG_ value for this, that'll just be
> yet another random value nobody knows what to do with.
> 
> Do you actually have a machine that reproduces this? Can you see how
> many classes, avg stacktraces per class and the avg entries per
> stacktrace there are?

This triggers every single time when I boot my T500 laptop with 
2.6.33.2-rt13 with lots of debug options enabled. The problem is not
specific to this kernel though.

> 
> Also, is there's lots of classes, are there many with a similar name?
> 
> That is, is it a valid depletion or is there something wonkey with those
> setups?

Here are the top 10 lines or so of /proc/lockdep_stats

 lock-classes:                         1330 [max: 8191]
 direct dependencies:                 12754 [max: 16384]
 indirect dependencies:               33245
 all direct dependencies:             49074
 dependency chains:                   19641 [max: 32768]
 dependency chain hlocks:             73246 [max: 163840]
 in-hardirq chains:                      25
 in-softirq chains:                       0
 in-process chains:                   19616
 stack-trace entries:                262144 [max: 262144]


I'm looking at more details in /proc/lockdep and friends to see if
I can find any more details, or something that looks amiss.

John
