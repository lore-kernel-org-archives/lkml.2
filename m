Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1GVIGJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 04:06:09 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:64929 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147Ab1GVIGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 04:06:05 -0400
Date: Fri, 22 Jul 2011 10:06:00 +0200
From: Tejun Heo <tj@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110722080600.GE2622@htj.dyndns.org>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au>
 <20110721080240.GZ3455@htj.dyndns.org>
 <20110721144447.GA7580@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110721144447.GA7580@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:44:47PM +0200, Oleg Nesterov wrote:
> On 07/21, Tejun Heo wrote:
> > Also, I think we really should standardize what gets reported in these
> > debug traps instead of letting each arch do its own thing.
> 
> May be we can standardize .si_info within the single arch at least ;)
> 
> I never understood what TRAP_HWBKPT/TRAP_BRKPT actually means, and
> I can be easily wrong. But, afaics, on x86 PTRACE_SINGLESTEP results
> in TRAP_TRACE. Unless the tracee steps over syscall, in this case
> user_single_step_siginfo() sets TRAP_BRKPT. Hmm.
> 
> And unless I misread 248bed4b0f3c s390 thinks we need TRAP_HWBKPT.

Yeah, it looks like a proper mess.  It seems ptrace left too much for
archs to decide.  Events to be reported should be defined by generic
ptrace code (there can be some exceptions but only few) and archs
should provide the mechanisms to implement them.  I'm planning on
going through ptrace arch specifics soonish.  Hopefully it can be
cleaned up somehow.

Thanks.

-- 
tejun
