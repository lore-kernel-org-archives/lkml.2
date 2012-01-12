Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2ALRv7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 12:51:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43162 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754431Ab2ALRv5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 12:51:57 -0500
MIME-Version: 1.0
In-Reply-To: <20120112172315.GA26295@redhat.com>
References: <1326302710-9427-1-git-send-email-wad@chromium.org>
	<1326302710-9427-2-git-send-email-wad@chromium.org>
	<20120112162231.GA23960@redhat.com>
	<CABqD9hbjGYA-jAOe-3CZEUV3MG2Qgs6SJ2irN7N+JMB2wj-mzA@mail.gmail.com>
	<20120112172315.GA26295@redhat.com>
Date: Thu, 12 Jan 2012 11:51:54 -0600
Message-ID: <CABqD9hZg4sKiVMS-g5ed7-HKOaiUb06y05TL=QkfBkm9kVmquA@mail.gmail.com>
Subject: Re: [RFC,PATCH 1/2] seccomp_filters: system call filtering using BPF
From: Will Drewry <wad@chromium.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, eparis@redhat.com,
        djm@mindrot.org, torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, gregkh@suse.de, dhowells@redhat.com,
        daniel.lezcano@free.fr, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, olofj@chromium.org,
        mhalcrow@google.com, dlaor@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:23 AM, Oleg Nesterov <oleg@redhat.com> wrote:
> On 01/12, Will Drewry wrote:
>>
>> On Thu, Jan 12, 2012 at 10:22 AM, Oleg Nesterov <oleg@redhat.com> wrote:
>> >> +      */
>> >> +     regs = seccomp_get_regs(regs_tmp, &regs_size);
>> >
>> > Stupid question. I am sure you know what are you doing ;) and I know
>> > nothing about !x86 arches.
>> >
>> > But could you explain why it is designed to use user_regs_struct ?
>> > Why we can't simply use task_pt_regs() and avoid the (costly) regsets?
>>
>> So on x86 32, it would work since user_regs_struct == task_pt_regs
>> (iirc), but on x86-64
>> and others, that's not true.
>
> Yes sure, I meant that userpace should use pt_regs too.
>
>> If it would be appropriate to expose pt_regs to userspace, then I'd
>> happily do so :)
>
> Ah, so that was the reason. But it is already exported? At least I see
> the "#ifndef __KERNEL__" definition in arch/x86/include/asm/ptrace.h.
>
> Once again, I am not arguing, just trying to understand. And I do not
> know if this definition is part of abi.

I don't either :/  My original idea was to operate on task_pt_regs(current),
but I noticed that PTRACE_GETREGS/SETREGS only uses the
user_regs_struct. So I went that route.

I'd love for pt_regs to be fair game to cut down on the copying!
will
