Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab0DBQHd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 12:07:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58648 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753450Ab0DBQHR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 12:07:17 -0400
Date: Fri, 2 Apr 2010 18:04:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, Alan Cox <alan@linux.intel.com>,
       Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
       Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
       linux-kernel@vger.kernel.org, Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>, stable@kernel.org
Subject: [PATCH 0/1] tty: release_one_tty() forgets to put pids
Message-ID: <20100402160447.GA19920@redhat.com>
References: <201003272121.ADE39095.JLFHOOMtSVOFQF@I-love.SAKURA.ne.jp> <tnxbpe5ygfy.fsf@e102109-lin.cambridge.arm.com> <20100331151719.8a92b302.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100331151719.8a92b302.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add cc's.

On 03/31, Andrew Morton wrote:
>
> On Tue, 30 Mar 2010 16:31:13 +0100
> Catalin Marinas <catalin.marinas@arm.com> wrote:
>
> > Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp> wrote:
> > > I got below report with 2.6.33.1 .
> > >
> > > unreferenced object 0xde144600 (size 64):
> > >   comm "init", pid 1, jiffies 4294678101 (age 291.508s)
> >
> > [... snip ...]
> >
> > I reported similar leaks last year -
> > http://lkml.org/lkml/2009/7/8/422. There is some analysis in the thread
> > above of the reference counting but I couldn't figure out where it goes
> > wrong. It looks to me like there isn't any reference to a struct pid
> > block but its reference count is 2.
> >
> > There is a bugzilla entry as well -
> > https://bugzilla.kernel.org/show_bug.cgi?id=13868

OK. I do not undertand ttys, absolutely. This means the patch
should not be applied without acks. And in fact I feel the patch
probably fixes the symptom, not the problem. But the logic in
disassociate_ctty() is beyond my understanding.

However, I think it is easy to explain the leak.

Catalin, Tetsuo, could you try this patch?

Oleg.

