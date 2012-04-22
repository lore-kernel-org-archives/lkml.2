Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab2DVUvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:51:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17753 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2DVUvt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:51:49 -0400
Date: Sun, 22 Apr 2012 22:04:59 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
Cc: pacman@kosh.dhis.org, linux-man <linux-man@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Denys Vlasenko <dvlasenk@redhat.com>, Tejun Heo <tj@kernel.org>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pedro Alves <palves@redhat.com>
Subject: Re: ptrace.2: PTRACE_KILL needs a stopped process too
Message-ID: <20120422200459.GA7519@redhat.com>
References: <20091216004533.22261.qmail@kosh.dhis.org> <CAKgNAkhtu8d0NKcTwWyCA8qWgz8Lag+GcpEE1=YMVe_Nh8XJ9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKgNAkhtu8d0NKcTwWyCA8qWgz8Lag+GcpEE1=YMVe_Nh8XJ9Q@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23, Michael Kerrisk (man-pages) wrote:
>
> [widening CC]

add more CC's

> The man page says "For requests other than PTRACE_KILL,

Argh, PTRACE_KILL again.

You know, I simply do not know what it was supposed to do. I can only
see what the code actually does.

> the child process
> must be stopped."

Yes and no.

Yes, ptrace(PTRACE_KILL) "succeeds" even if the tracee is not stopped.

No, it has no effect if the tracee is not stopped.

All I can say is: PTRACE_KILL should never exist. If you want to kill
the tracee, you can do kill(SIGKILL).

Roughly, ptrace(PTRACE_KILL) is equal to ptrace(PTRACE_CONT, SIGKILL)
except it always returns 0.

> If the man page is describing actual intended kernel behavior, then it's a
> fairly long-standing kernel bug.

Perhaps. May be it should simply do kill(SIGKILL), but then it is not
clear why do we have PTRACE_KILL. And once again, I was never able to
understand the supposed behaviour.

Personally, I think we should fix the documentation. And imho the only
possible fix is to add this note: do not ever use PTRACE_KILL.

Oleg.

