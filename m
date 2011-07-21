Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751933Ab1GUOrU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:47:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:25389 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751297Ab1GUOrS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:47:18 -0400
Date: Thu, 21 Jul 2011 16:44:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110721144447.GA7580@redhat.com>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au> <20110721080240.GZ3455@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721080240.GZ3455@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21, Tejun Heo wrote:
>
>
> On Wed, Jul 20, 2011 at 03:33:20PM +1000, Stephen Rothwell wrote:
> > Today's linux-next merge of the ptrace tree got a conflict in
> > arch/s390/kernel/traps.c between commit 248bed4b0f3c ("[S390] use siginfo
> > for sigtrap signals") from the s390 tree and commit a288eecce525
> > ("ptrace: kill trivial tracehooks") from the ptrace tree.
> >
> > It looks like the former is a superset of the latter, so I used the
> > former.
>
> Yeap, pretty much.  Martin, testing if (current->ptrace) is enough.
> If PT_PTRACED is not set, no other flag there is allowed to set.

Agreed,

> Also, I think we really should standardize what gets reported in these
> debug traps instead of letting each arch do its own thing.

May be we can standardize .si_info within the single arch at least ;)

I never understood what TRAP_HWBKPT/TRAP_BRKPT actually means, and
I can be easily wrong. But, afaics, on x86 PTRACE_SINGLESTEP results
in TRAP_TRACE. Unless the tracee steps over syscall, in this case
user_single_step_siginfo() sets TRAP_BRKPT. Hmm.

And unless I misread 248bed4b0f3c s390 thinks we need TRAP_HWBKPT.

Oleg.

