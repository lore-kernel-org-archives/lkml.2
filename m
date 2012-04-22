Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342Ab2DVS5H (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 14:57:07 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33734 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180Ab2DVS5F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 14:57:05 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <20091216004533.22261.qmail@kosh.dhis.org>
References: <20091216004533.22261.qmail@kosh.dhis.org>
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Date: Mon, 23 Apr 2012 06:56:43 +1200
Message-ID: <CAKgNAkhtu8d0NKcTwWyCA8qWgz8Lag+GcpEE1=YMVe_Nh8XJ9Q@mail.gmail.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
To: pacman@kosh.dhis.org
Cc: linux-man <linux-man@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[widening CC]

Denys, (Oleg, Tejun,)

Would you be able to take a look at this report that is now already a
long time in my inbox. Is there something here that still needs to be
fixed after your recent changes to ptrace.2, Denys?

Thanks,

Michael



---------- Forwarded message ----------
From:  <pacman@kosh.dhis.org>
Date: Wed, Dec 16, 2009 at 1:45 PM
Subject: ptrace.2: PTRACE_KILL needs a stopped process too
To: mtk.manpages@gmail.com


The man page says "For requests other than PTRACE_KILL, the child process
must be stopped."

But experience[1] shows that PTRACE_KILL also requires the child process to
be stopped. gdb older than 7.0 doesn't always make sure its child process is
stopped before attempting a PTRACE_KILL (try SIGTERMing gdb while the child
process is running).

That was fixed in gdb 7.0 by the addition of a SIGSTOP and wait before the
PTRACE_KILL, so the kernel and latest gdb get along well now, which leaves
the man page as the only thing that's out of sync.

If the man page is describing actual intended kernel behavior, then it's a
fairly long-standing kernel bug. But I get the feeling this was just an
assumption by the original man page author that never got checked.

[1] http://lists.gnu.org/archive/html/bug-coreutils/2009-11/msg00267.html
   http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00025.html
   http://lists.gnu.org/archive/html/bug-coreutils/2009-12/msg00094.html


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
