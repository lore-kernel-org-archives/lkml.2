Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab2LMXAS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 18:00:18 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37472 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab2LMXAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 18:00:16 -0500
Date: Thu, 13 Dec 2012 15:00:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Li Zhong <zhong@linux.vnet.ibm.com>
Subject: Re: [PATCH] context_tracking: Add comments on interface and
 internals
Message-Id: <20121213150015.e497a585.akpm@linux-foundation.org>
In-Reply-To: <CAFTL4hxPAq0pNOAhMc01iOygqdx=Ja=b5u9ozzdRmPLbtxMn+A@mail.gmail.com>
References: <1355432225-5878-1-git-send-email-fweisbec@gmail.com>
	<20121213131809.122fdd61.akpm@linux-foundation.org>
	<CAFTL4hxPAq0pNOAhMc01iOygqdx=Ja=b5u9ozzdRmPLbtxMn+A@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012 23:50:23 +0100
Frederic Weisbecker <fweisbec@gmail.com> wrote:

> >
> >> + * This call supports re-entrancy.
> >
> > Presumably the explanation for user_exit() applies here.
> 
> Not sure what you mean here.

It's unclear what it means to say "user_enter() supports reentrancy". 
I mean, zillions of kernel functions are surely reentrant - so what? 
It appears that you had something in mind when pointing this out, but
what was it?  The comment over user_exit() appears to tell us.

> > It's mainly this bit which makes me wonder why the code is in lib/.  Is
> > there any conceivable prospect that any other subsystem will use this
> > code for anything?
> 
> So that's because of that cputime accounting on dynticks CPUs which
> will need to know about user/kernel transitions. I'm preparing that
> for the 3.9 merge window.

Oh.  That's really the entire reason for the patch and should have been
in the changelog!
