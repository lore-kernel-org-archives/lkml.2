Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933516Ab1ETGol (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 02:44:41 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42720 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933375Ab1ETGok convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 02:44:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=G206E0s1nhGSAxUeY1YOlWBUKnXbdQpamAGRTFu89k7TUNqQo8KW8AcqpHQls+Byct
         +Ijw9LffWT73jKVhrE3IsSLb1ta2AX3z/QlCIcMHbFDrn85mX7jIZWjkhpVqodyWqwFV
         +aKAyCf0sXspm7ApyNUG1gmiVqnKCxV42hyQI=
MIME-Version: 1.0
In-Reply-To: <201105191834.56577.toralf.foerster@gmx.de>
References: <201105191526.31904.toralf.foerster@gmx.de>
	<201105191834.56577.toralf.foerster@gmx.de>
Date: Fri, 20 May 2011 08:44:39 +0200
Message-ID: <BANLkTi=8NW9Q+8Q=kuUJY1L=FcQGapqDLA@mail.gmail.com>
Subject: Re: kernel 2.6.39 (user mode linux) crashes (2.6.38 works fine)
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        user-mode-linux-devel@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

a few more questions/ideas. :)

2011/5/19 Toralf Förster <toralf.foerster@gmx.de>:
> FWIW I got :
>
> * Starting local

What is this "Starting local",
was UML crashing while starting your distro?

> Kernel panic - not syncing: Segfault with no mm
> 08335ed4:  [<082b0b3b>] dump_stack+0x22/0x24
> 08335eec:  [<082b0ba0>] panic+0x63/0x167
> 08335f14:  [<080614af>] segv+0x27f/0x2f0
> 08335fcc:  [<08061561>] segv_handler+0x41/0x60
> 08335fec:  [<08071da4>] sig_handler_common+0x44/0xb0
>
>
> EIP: 0000:[<00000000>] CPU: 0 Not tainted EFLAGS: 00000000
>    Not tainted
> EAX: 00000000 EBX: 00000000 ECX: 00000000 EDX: 00000000
> ESI: 00000000 EDI: 00000000 EBP: 00000000 DS: 0000 ES: 0000
> 08335e88:  [<0807935d>] show_regs+0xed/0x120
> 08335ea4:  [<0806179c>] panic_exit+0x2c/0x50
> 08335eb4:  [<080a2b9c>] notifier_call_chain+0x4c/0x70
> 08335edc:  [<080a2c13>] atomic_notifier_call_chain+0x23/0x30
> 08335eec:  [<082b0bc8>] panic+0x8b/0x167
> 08335f14:  [<080614af>] segv+0x27f/0x2f0
> 08335fcc:  [<08061561>] segv_handler+0x41/0x60
> 08335fec:  [<08071da4>] sig_handler_common+0x44/0xb0
>
>
> and gdb gives in another session to reproduce the bug this:
>
> (gdb) c
> Continuing.

GDB stopped here and UML got SIGSEGV after you continued?
GDB has to ignore SIGSEGV. UML uses this signal to handle page faults.
type: handle SIGSEGV noprint nostop pass

I fear the backtrace is garbage.

Can you reproduce the issue using the default config?
Are you using hostfs?
What exactly is the output when it crashes? (Without GDB)

Your host's kernel ring buffer should contain a line like this one
after the crash:
linux[123]: segfault at 0 ip xxx sp xxx error 4 in linux[xxx+yyy]
Please share this line with me.

-- 
Thanks,
//richard
