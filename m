Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab2DNDk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 23:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40258 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755027Ab2DNDk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 23:40:56 -0400
Date: Sat, 14 Apr 2012 05:39:53 +0200
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
Subject: Re: [PATCH v4 1/3] task_work_add: generic process-context callbacks
Message-ID: <20120414033953.GA29189@redhat.com>
References: <20120414021201.GA23385@redhat.com> <20120414021220.GA23393@redhat.com> <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyxV8v2mOjb1Ly=1ttPyLvUt6RZO8wgjD_9owtO=VM0hw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

probably I should also comment this part...

On 04/13, Linus Torvalds wrote:
>
> Alternatively, you must make the rule be that the data can only be
> freed by the caller *if* it was returned from "task_work_cancel()".

Exactly.

Once the caller does task_work_add(twork), it no longer "owns" this
twork.

But, if task_work_cancel() succeeds - you own it again.

> But then you can't allocate it on the stack any more, and have to
> allocate it separately.

Yes, unless you do task_work_add/cancel(current).

Oleg.

