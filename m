Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751450Ab2ERQnZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 12:43:25 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62292 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758613Ab2ERQnT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 12:43:19 -0400
MIME-Version: 1.0
In-Reply-To: <1337282386.4281.77.camel@twins>
References: <1335314100-532-1-git-send-email-roland@kernel.org>
 <alpine.LSU.2.00.1204251411460.4188@eggly.anvils> <1337198420-5062-1-git-send-email-roland@kernel.org>
 <1337282386.4281.77.camel@twins>
From: Roland Dreier <roland@kernel.org>
Date: Fri, 18 May 2012 09:42:58 -0700
X-Google-Sender-Auth: KK2B3g8Z6wRyXa9Dg9KMMct1NxM
Message-ID: <CAG4TOxM9-hHxSyu3XHFgACRYP8Rr3ogAgk=StGxbr2KCkrR81Q@mail.gmail.com>
Subject: Re: lockdep false positive in double_lock_balance()?
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> *phew* you actually made me think there ;-)

Sorry for that.

> The race you describe exists, except that's not how lockdep works. Both
> cpu's would have a different task (one would hope to presume) and the
> held lock stack is per task. So even if busiest_rq on cpu1 (lock case)
> is the same lock as this_rq on cpu0 (unlock case), they're in different
> stacks with different states.

Got it.  I confused myself between user processes (which might have
multiple threads on multiple CPUs) and kernel tasks.

> Something like this should fix it I think..

Thanks, I'll throw this in and let you know if we see this again.
But it's very rare so hard to know one way or another for quite
a while.

 - R.
