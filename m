Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682Ab1EPRuD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:50:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39410 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866Ab1EPRuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:50:01 -0400
Date: Mon, 16 May 2011 19:48:14 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Denys Vlasenko <vda.linux@googlemail.com>, jan.kratochvil@redhat.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, indan@nul.nu
Subject: Re: Ptrace documentation, draft #1
Message-ID: <20110516174814.GA21391@redhat.com>
References: <201105152235.32073.vda.linux@googlemail.com> <20110516153122.GA15856@redhat.com> <20110516155253.GA20624@htj.dyndns.org> <20110516165352.GA18727@redhat.com> <20110516172058.GD20624@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516172058.GD20624@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/16, Tejun Heo wrote:
>
> On Mon, May 16, 2011 at 06:53:52PM +0200, Oleg Nesterov wrote:
> > > If you do GETSIGINFO and look at si->si_code, user generated signals
> > > can't have non-zero value there
> >
> > Hmm. The can? sys_kill() sets si_code = 0, but tkill() or queueinfo()
> > can pass any si_code < 0. Also, the kernel can generate the signal
> > with si_code > 0.
>
> Yeah, sure, not non-zero then, but it's still distinguishible, no?

Hmm. Now it is me who is missing context. And probably I misunderstood
the original question:

	Kernel delivers an extra SIGTRAP to tracee after execve syscall
	returns. This is an ordinary signal
	...
	??? can this SIGTRAP be distinguished from "real" user-generated SIGTRAP
	    by looking at its siginfo?

I meant, we can't distinguish this SIGTRAP. But if PTRACE_O_TRACEEXEC is
set then the tracee reports PTRACE_EVENT_EXEC, this is probably
distinguishible. IIUC, si_code > 0 if the tracee reports an event.

Oleg.

