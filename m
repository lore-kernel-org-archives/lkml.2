Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376Ab1EZSvM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:51:12 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:56541 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1EZSvK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:51:10 -0400
Date: Thu, 26 May 2011 20:50:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Valdis.Kletnieks@vt.edu
Cc: Avi Kivity <avi@redhat.com>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526185045.GA3476@elte.hu>
References: <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <4DDE31D6.4070209@redhat.com>
 <20110526113842.GA27618@elte.hu>
 <4DDE96B7.8030006@redhat.com>
 <20110526181554.GB3572@elte.hu>
 <4DDE99F6.4030804@redhat.com>
 <20110526183635.GA2490@elte.hu>
 <20614.1306435422@turing-police.cc.vt.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20614.1306435422@turing-police.cc.vt.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Valdis.Kletnieks@vt.edu <Valdis.Kletnieks@vt.edu> wrote:

> On Thu, 26 May 2011 20:36:35 +0200, Ingo Molnar said:
> 
> > I suspect we are really offtopic here, but an initial rsync, then 
> > stopping the guest, final rsync + restart the guest at the target 
> > would work with minimal interruption.
> 
> Actually, after you kick off the migrate, you really want to be 
> tracking in real time what pages get dirtied while you're doing the 
> initial copy, so that the second rsync doesn't have to walk through 
> the file finding the differences.  But that requires some extra 
> instrumentation.

Yeah, and that's how socket based live migration works - it's 
completely seemless.

But note that the rsync re-scan should not be an issue: both the 
source and the target system will obviously have a *lot* more RAM 
than the guest RAM image size.

Thanks,

	Ingo
