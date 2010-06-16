Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759591Ab0FPUiQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 16:38:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48091 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595Ab0FPUiP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 16:38:15 -0400
Date: Wed, 16 Jun 2010 22:37:33 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Peter Zijlstra <peterz@infradead.org>
cc: Thomas Gleixner <tglx@linutronix.de>, lkml <linux-kernel@vger.kernel.org>,
       rt-users <linux-rt-users@vger.kernel.org>,
       Clark Williams <williams@redhat.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Sven-Thorsten Dietrich <sven@thebigcorporation.com>,
       ghaskins@novell.com
Subject: Re: [PATCH 2/6: v4] lockdep: Make MAX_STACK_TRACE_ENTRIES
 configurable.
In-Reply-To: <1276714154.1745.623.camel@laptop>
Message-ID: <alpine.LFD.2.00.1006162213220.28756@localhost.localdomain>
References: <1276554087-3632-1-git-send-email-jkacur@redhat.com> <1276554087-3632-3-git-send-email-jkacur@redhat.com> <1276714154.1745.623.camel@laptop>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 16 Jun 2010, Peter Zijlstra wrote:

> On Tue, 2010-06-15 at 00:21 +0200, John Kacur wrote:
> > Certain debug configurations that have LOCKDEP turned on, run into the limit
> > where the MAX_STACK_TRACE_ENTRIES are too small. Rather than simply turning
> > off the locking correctness validator, let the user configure this value
> > to something reasonable for their system.
> > 
> > This patch was generated against 2.6.33.5-rt23 but is also intended to be
> > picked-up for mainline.
> 
> NACK
> 
> patches like 4726f2a617ebd868a4fdeb5679613b897e5f1676 are the way to go.

I've been testing 4726f2a617ebd868a4fdeb5679613b897e5f1676 in rt
(Thomas has it in tip/rt/2.6.33 now) and so far it is doing the trick for 
me, at least on my laptop. I still need to test it on larger machines.
However, this problem seems to continuably come up, and I'm not the only 
one who has expessed the wish / need to have this tunable.
See Message-Id	 <4BCEAD7B0200005A0006513E@soto.provo.novell.com>

and here in the same thread is even an argument that some configs
might tune it down. (I needed to increase it for rt-debug configs)
See Message-Id	 <1271861581.29617.13.camel@sven.thebigcorporation.com>

fwiw regarding a nacked patch, v4 is the least intrusive version
(smallest number of changes), based on a bit of trout wacking induced 
hints.  

Thanks
