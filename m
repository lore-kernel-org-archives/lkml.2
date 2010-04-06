Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab0DFOv3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 10:51:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:59150 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754745Ab0DFOvX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:51:23 -0400
Subject: Re: [PATCH V2 0/6][RFC] futex: FUTEX_LOCK with optional adaptive 
 spinning
From: Peter Zijlstra <peterz@infradead.org>
To: Ulrich Drepper <drepper@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Darren Hart <dvhltc@us.ibm.com>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@elte.hu>, Eric Dumazet <eric.dumazet@gmail.com>,
       "Peter W. Morreale" <pmorreale@novell.com>,
       Rik van Riel <riel@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Gregory Haskins <ghaskins@novell.com>,
       Sven-Thorsten Dietrich <sdietrich@novell.com>,
       Chris Mason <chris.mason@oracle.com>,
       John Cooper <john.cooper@third-harmonic.com>,
       Chris Wright <chrisw@sous-sol.org>
In-Reply-To: <m2ua36005b51004060747y1abf15edj28227274844db2e7@mail.gmail.com>
References: <1270499039-23728-1-git-send-email-dvhltc@us.ibm.com>
	 <4BBA5305.7010002@redhat.com> <1270543721.1597.748.camel@laptop>
	 <m2ua36005b51004060747y1abf15edj28227274844db2e7@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 06 Apr 2010 16:51:18 +0200
Message-ID: <1270565478.1595.529.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-04-06 at 07:47 -0700, Ulrich Drepper wrote:
> On Tue, Apr 6, 2010 at 01:48, Peter Zijlstra <peterz@infradead.org>
> wrote:
> >  try
> >  spin
> >  try
> >  syscall
> 
> This is available for a long time in the mutex implementation
> (PTHREAD_MUTEX_ADAPTIVE_NP mutex type).  It hasn't show much
> improvement if any.  There were some people demanding this support for
> as far as I know they are not using it now.  This is adaptive
> spinning, learning from previous calls how long to wait.  But it's
> still unguided.  There is no way to get information like "the owner
> has been descheduled". 

That's where the FUTEX_LOCK thing comes in, it does all those, the above
was a single spin loop to amortize the syscall overhead.

I wouldn't make it any more complex than a single pause ins, syscalls
are terribly cheap these days.

