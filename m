Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1GVOvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 10:51:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754669Ab1GVOvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 10:51:37 -0400
Date: Fri, 22 Jul 2011 16:49:07 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: linux-next: manual merge of the ptrace tree with the s390 tree
Message-ID: <20110722144907.GA7408@redhat.com>
References: <20110720153320.a7f33784158ccb04fafcb5d6@canb.auug.org.au> <20110721080240.GZ3455@htj.dyndns.org> <20110721144447.GA7580@redhat.com> <20110722080600.GE2622@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722080600.GE2622@htj.dyndns.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/22, Tejun Heo wrote:
>
> Yeah, it looks like a proper mess.

Yes.

> It seems ptrace left too much for
> archs to decide.  Events to be reported should be defined by generic
> ptrace code

I agree very much. Right now I am not sure if it really makes sense
to avoid the SIGTRAP signals, but in any case I think that at least
we need the generic ptrace_sigtrap(si_code, ...) helper which hides
all details.

And note that force_sig*() we use currently is wrong in this case,
it removes SIGNAL_UNKILLABLE.

And we should also cleanup the force_* mess. Also, it would be
nice to remove the "task_struct *t" argument, force_sig_info()
should be only used for synchronous signals. Afaics, only oom
killer really needs force_sig_info() with t != current. And this
reminds me, we need send_sigkill().

Oleg.

