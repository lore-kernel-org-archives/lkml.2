Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab2HOSJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 14:09:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:44611 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab2HOSJc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 14:09:32 -0400
MIME-Version: 1.0
In-Reply-To: <20120815175651.GA17814@redhat.com>
References: <20120726134748.GA20605@localhost>
	<CAGXu5j+xjud3w4cYXADM-KvFPvnkaKp49j5x-wdZ66wUJjkX0g@mail.gmail.com>
	<20120810015222.GA19286@localhost>
	<CAGXu5jK_ZJqmcJ7JcnpwNb5R3x8=ay_shD16ZA3q-7Lwi8S=qg@mail.gmail.com>
	<20120815030110.GA24836@localhost>
	<CAGXu5j+0FUYdBqsotn_vp1EbG=dcURAA1sxv+yFzaJuUkdAh0A@mail.gmail.com>
	<20120815130159.GA3221@redhat.com>
	<1345041021.31459.88.camel@twins>
	<20120815175651.GA17814@redhat.com>
Date: Wed, 15 Aug 2012 11:09:30 -0700
X-Google-Sender-Auth: pJIR4kWC6ztmYl5fF8FWKSvPqKY
Message-ID: <CAGXu5jJ+HOdSxS7Ec=TW06h6KEpEmi-rF+Jk8L5LiQsp9gyAtg@mail.gmail.com>
Subject: Re: yama_ptrace_access_check(): possible recursive locking detected
From: Kees Cook <keescook@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Fengguang Wu <fengguang.wu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 10:56 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 08/15, Peter Zijlstra wrote:
>>
>> On Wed, 2012-08-15 at 15:01 +0200, Oleg Nesterov wrote:
>> > BTW, set_task_comm()->wmb() and memset() should die. There are
>> > not needed afaics, and the comment is misleading.
>>
>> As long as we guarantee there's always a terminating '\0',
>
> Yes, but we already have this guarantee?
>
> Unless of course some buggy code does something wrong with task->comm[],
> but nobody should do this.
>
> IOW, task->comm[TASK_COMM_LEN - 1] is always 0, no?
>
>> now strlcpy()
>> doesn't pad the result,
>
> afaics set_task_comm()->strlcpy() doesn't change the last byte too.
>
>> however if we initialize the ->comm to all 0s in
>> fork()
>
> fork() is special, yes. ->comm is copied by dup_task_struct() and
> the new task_struct can have everything in ->comm. But nobody can
> see the new task yet, and nobody can play with its ->comm.
>
> Or I misunderstood?
>
>> That barrier is indeed completely pointless as there's no pairing
>> barrier anywhere.
>
> Yes, agreed.

It sounds like get_task_comm shouldn't have locking at all then? It
should just do a length-limited copy and make sure there is a trailing
0-byte?

-Kees

-- 
Kees Cook
Chrome OS Security
