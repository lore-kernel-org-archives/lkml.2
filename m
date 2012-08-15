Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab2HOSAX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:00:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25868 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457Ab2HOSAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:00:18 -0400
Date: Wed, 15 Aug 2012 19:56:51 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Kees Cook <keescook@chromium.org>, Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
Message-ID: <20120815175651.GA17814@redhat.com>
References: <20120726134748.GA20605@localhost> <CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com> <20120810015222.GA19286@localhost> <CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com> <20120815030110.GA24836@localhost> <CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com> <20120815130159.GA3221@redhat.com> <1345041021.31459.88.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345041021.31459.88.camel@twins>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15, Peter Zijlstra wrote:
>
> On Wed, 2012-08-15 at 15:01 +0200, Oleg Nesterov wrote:
> > BTW, set_task_comm()->wmb() and memset() should die. There are
> > not needed afaics, and the comment is misleading.
>
> As long as we guarantee there's always a terminating '\0',

Yes, but we already have this guarantee?

Unless of course some buggy code does something wrong with task->comm[],
but nobody should do this.

IOW, task->comm[TASK_COMM_LEN - 1] is always 0, no?

> now strlcpy()
> doesn't pad the result,

afaics set_task_comm()->strlcpy() doesn't change the last byte too.

> however if we initialize the ->comm to all 0s in
> fork()

fork() is special, yes. ->comm is copied by dup_task_struct() and
the new task_struct can have everything in ->comm. But nobody can
see the new task yet, and nobody can play with its ->comm.

Or I misunderstood?

> That barrier is indeed completely pointless as there's no pairing
> barrier anywhere.

Yes, agreed.

Oleg.

