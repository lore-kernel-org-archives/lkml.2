Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753341Ab1GURSb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 13:18:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64064 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751355Ab1GURS2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 13:18:28 -0400
Date: Thu, 21 Jul 2011 18:51:37 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: mtk.manpages@gmail.com, Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace
	quirks
Message-ID: <20110721165137.GA21345@redhat.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Denys Vlasenko wrote:
>
> Deleted several outright false statements:
> - pid 1 can be traced
> - tracer is not shown as parent in ps output
> - PTRACE_ATTACH is not "the same behavior as if tracee had done
>   a PTRACE_TRACEME": PTRACE_ATTACH delivers a SIGSTOP.
> - SIGSTOP _can_ be injected.

Yes, this is correct, thanks.

> +Tracer can not assume that tracee ALWAYS ends its life by reporting
> +WIFEXITED(status) or WIFSIGNALED(status).
> +.LP
> +.\" or can it? Do we include such a promise into ptrace API?

IIRC, we already discussed this... The traced group leader can
disappear during mt-exec, otherwise the tracee can never go away
silently.

> +Tracer can kill a tracee with ptrace(PTRACE_KILL, pid, 0, 0). This
> +operation is deprecated, use kill(SIGKILL) or tgkill(SIGKILL) instead.
> +The problem with this operation is that it requires tracee to be in
> +signal-delivery-stop, otherwise it may not work (may complete
> +successfully but won't kill the tracee),

In short, ptrace(PTRACE_KILL) is more or less ptrace(PTRACE_CONT, SIGKILL),
but it always returns 0. IOW, it never worked as decribed in the man
page. And I guess today nobody can explain why PTRACE_KILL exists.

Oleg.

