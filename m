Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409Ab2DND3V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 23:29:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10813 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab2DND3U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 23:29:20 -0400
Date: Sat, 14 Apr 2012 05:28:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Alexander Gordeev <agordeev@redhat.com>,
        Chris Zankel <chris@zankel.net>, David Smith <dsmith@redhat.com>,
        "Frank Ch. Eigler" <fche@redhat.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Larry Woodman <lwoodman@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/3] task_work_add (was: task_work_queue)
Message-ID: <20120414032814.GA29002@redhat.com>
References: <20120414021201.GA23385@redhat.com> <CA+55aFyDy6VHtZ=SmXfn-AHT0QU8LV69U5NECGLA9pXg4Q=aZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyDy6VHtZ=SmXfn-AHT0QU8LV69U5NECGLA9pXg4Q=aZw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13, Linus Torvalds wrote:
>
> On Fri, Apr 13, 2012 at 7:12 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >
> > Changes based on review from Andrew:
> >
> >        - s/task_work_queue/task_work_add/
> >
> >        - don't create a secret dependency upon task_work.h
> >          including sched.h in tracehook.h and keys/internal.h
> >
> >        - add more includes into task_work.[ch] to not rely
> >          on "sched.h includes everything"
>
> I thought based on Andrew's comments that you were going to remove the
> extra code to do FIFO for no obvious reason.

No, I tried to defense fifo,

> Apparently nothing
> actually wanted/needed it,

True, currently nothing. And most probably never will. task_work_add()
should only be used for the "unlikely" events.

> so why do it?

I can remove it.

But, unless you strongly object, personally I'd prefer to keep fifo.

Once again. Imho of course, but fifo is simply "obviously better"
from the common sense pov when it comes to submit-the-work-for-
execution.

For example. keyctl_session_to_parent() does _cancel only to protect
from exploits doing keyctl(KEYCTL_SESSION_TO_PARENT) in an endless
loop. It could simply do task_work_add(), but in this case we need
fifo for correctness.

But, again, again, I am not going to argue too much.

Oleg.

