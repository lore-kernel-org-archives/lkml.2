Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755282Ab1KQTIx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 14:08:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:19523 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab1KQTIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 14:08:52 -0500
Date: Thu, 17 Nov 2011 20:04:07 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Pavel Emelyanov <xemul@parallels.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
	pids
Message-ID: <20111117190407.GB20552@redhat.com>
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com> <CA+55aFwep=g-ZSEgeJoO1dANjTYSb71jD_PR_7urb5=DrrJ8Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwep=g-ZSEgeJoO1dANjTYSb71jD_PR_7urb5=DrrJ8Sw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17, Linus Torvalds wrote:
>
> Ok. Patches 1-2 look sane on their own. I think we can merge them
> regardless in the next cycle if Oleg & co agree. Oleg?

I am not sure 1/3 really makes sense without 3/3... although it
cleanups the "goto out" logic in alloc_pid().

Anyway I agree, the patches look fine.

> Patch 3 obviously is generating discussion and actually introduces new
> functionality, so this one is the contentious one..
>
>                   Linus
>
> On Thu, Nov 17, 2011 at 9:43 AM, Pavel Emelyanov <xemul@parallels.com> wrote:
> >
> > When restoring a task (or a set of tasks) we need to recreate them
> > with exactly the same pid(s) as they had before.  [...]

Yes.

Just in case, I believe technically 3/3 is correct too, modulo the
small problem with the unchecked access to ->pidmap[] (unless I missed
something again).

I am not sure about pid_max... probably we do not care in this case?

Oleg.

