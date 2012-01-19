Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932789Ab2ASTbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 14:31:06 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:53708 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932675Ab2ASTbE convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 14:31:04 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
References: <49017bd7edab7010cd9ac767e39d99e4.squirrel@webmail.greenhost.nl>
 <20120118015013.GR11715@one.firstfloor.org> <20120118020453.GL7180@jl-vm1.vm.bytemark.co.uk>
 <20120118022217.GS11715@one.firstfloor.org> <fc8f165e541482d136ff8fc115fe6875.squirrel@webmail.greenhost.nl>
 <CA+55aFysH3h8sLHwNcaLnYMsgA28vmHgd3DSLPVw-=TzgfBrbg@mail.gmail.com>
 <CA+55aFzk6OOHoQ_e3pPQNUGN80tjXT7vYTNaRjXbWiQUnNRiTA@mail.gmail.com>
 <fd4ccb42a25876131e411299d24d9151.squirrel@webmail.greenhost.nl>
 <CA+55aFzcSVmdDj9Lh_gdbz1OzHyEm6ZrGPBDAJnywm2LF_eVyg@mail.gmail.com>
 <CAObL_7FsNQaPQg-3=AO9RuMNZZsRgDSJYPhPevDKERws9vQJWg@mail.gmail.com>
 <20120119160113.GN7180@jl-vm1.vm.bytemark.co.uk> <CA+55aFyZ-=4J1hVSAJiBiZKgpvuh-t54KPjLijRmU=cBtdi3-w@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 19 Jan 2012 11:30:41 -0800
X-Google-Sender-Auth: hmjmieYWQFH92cl3lYQ2T7QeAqM
Message-ID: <CAObL_7Gigcvurpa5J9FHrrdFkBHw7GSrP=e6nT4FFweGZz4+fg@mail.gmail.com>
Subject: Re: Compat 32-bit syscall entry from 64-bit task!?
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jamie Lokier <jamie@shareable.org>, Indan Zupancic <indan@nul.nu>,
        Andi Kleen <andi@firstfloor.org>, Oleg Nesterov <oleg@redhat.com>,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        segoon@openwall.com, rostedt@goodmis.org, jmorris@namei.org,
        scarybeasts@gmail.com, avi@redhat.com, penberg@cs.helsinki.fi,
        viro@zeniv.linux.org.uk, mingo@elte.hu, akpm@linux-foundation.org,
        khilman@ti.com, borislav.petkov@amd.com, amwang@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        Roland McGrath <mcgrathr@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 11:21 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Jan 19, 2012 at 8:01 AM, Jamie Lokier <jamie@shareable.org> wrote:
>> Andrew Lutomirski wrote:
>>> It's reasonable, obvious, and even more wrong than it appears.  On
>>> Xen, there's an extra 64-bit GDT entry, and it gets used by default.
>>> (I got bitten by this in some iteration of the vsyscall emulation
>>> patches -- see user_64bit_mode for the correct and
>>> unusable-from-user-mode way to do this.)
>>
>> Here it is:
>>
>>        static inline bool user_64bit_mode(struct pt_regs *regs)
>
> This is pointless, even if it worked, which it clearly doesn't on Xen
> (or other random situations).
>
> Why would you care?
>
> The issue is *not* whether somebody is running in 32-bit mode or 64-bit mode.
>
> The problem is the system call itself, and that can be 32-bit or
> 64-bit independently of the execution mode. So knowing the user-mode
> mode is simply not relevant.

Unless you're writing a debugger and you want to disassemble the code
that's being executed (i.e. normal code, not a system call).  I wonder
how gdb guesses whether the cpu is in long mode.

--Andy
