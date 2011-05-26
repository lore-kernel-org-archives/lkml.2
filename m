Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab1EZSjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:39:13 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:37915 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758105Ab1EZSjL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:39:11 -0400
Date: Thu, 26 May 2011 20:38:06 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Avi Kivity <avi@redhat.com>, James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Kees Cook <kees.cook@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>, Will Drewry <wad@chromium.org>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        gnatapov@redhat.com, Chris Wright <chrisw@sous-sol.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 3/5] v2 seccomp_filters: Enable ftrace-based system call
 filtering
Message-ID: <20110526183806.GB2490@elte.hu>
References: <BANLkTimiLvtyKJe-+Fd+4N_rGLfYdUvSVA@mail.gmail.com>
 <alpine.LRH.2.00.1105261034200.29690@tundra.namei.org>
 <20110526082451.GB26775@elte.hu>
 <4DDE1419.3000708@redhat.com>
 <20110526093040.GB19536@elte.hu>
 <4DDE31D6.4070209@redhat.com>
 <20110526113842.GA27618@elte.hu>
 <4DDE96B7.8030006@redhat.com>
 <20110526181554.GB3572@elte.hu>
 <1306434167.2497.92.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306434167.2497.92.camel@laptop>
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


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, 2011-05-26 at 20:15 +0200, Ingo Molnar wrote:
>
> > Incidentally i suggested this to Pekka just yesterday: i think we 
> > should consider guest RAM images to be named files on the local 
> > filesystem (prefixed with the disk image's name or so, for easy 
> > identification),
> 
> That'll break THP and KSM, both rely and work on anon only.

No reason they should be limited to anon only though.

Also, don't we have some sort of anonfs, from which we could get an 
fd, which, if mmap()-ed produces regular anonymous shared memory?

That fd could be passed over to other processes, who could then 
mmap() the new piece of shared-anon memory as well.

Thanks,

	Ingo
