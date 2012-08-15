Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335Ab2HORD0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 13:03:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22675 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2HORDY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 13:03:24 -0400
Date: Wed, 15 Aug 2012 18:59:31 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, lkml <linux-kernel@vger.kernel.org>,
        benh@kernel.crashing.org, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, michael@ellerman.id.au,
        Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 2/2] powerpc: Uprobes port to powerpc
Message-ID: <20120815165931.GA10059@redhat.com>
References: <20120726051902.GA29466@in.ibm.com> <20120726052029.GB29466@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120726052029.GB29466@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26, Ananth N Mavinakayanahalli wrote:
>
> From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>
> This is the port of uprobes to powerpc. Usage is similar to x86.

I am just curious why this series was ignored by powerpc maintainers...

Of course I can not review this code, I know nothing about powerpc,
but the patches look simple/straightforward.

Paul, Benjamin?





Just one question... Shouldn't arch_uprobe_pre_xol() forbid to probe
UPROBE_SWBP_INSN (at least) ?

(I assume that emulate_step() can't handle this case but of course I
 do not understand arch/powerpc/lib/sstep.c)

Note that uprobe_pre_sstep_notifier() sets utask->state = UTASK_BP_HIT
without any checks. This doesn't look right if it was UTASK_SSTEP...

But again, I do not know what powepc will actually do if we try to
single-step over UPROBE_SWBP_INSN.

Oleg.

