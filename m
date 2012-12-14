Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932308Ab2LNUCt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:02:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41814 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932188Ab2LNUCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:02:48 -0500
Date: Fri, 14 Dec 2012 21:02:41 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, ananth@in.ibm.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 4/4] uprobes/powerpc: Make use of generic routines
	to enable single step
Message-ID: <20121214200241.GA27195@redhat.com>
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150946.7727.82735.stgit@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203150946.7727.82735.stgit@suzukikp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03, Suzuki K. Poulose wrote:
>
> Replace the ptrace helpers with the powerpc generic routines to
> enable/disable single step. We save/restore the MSR (and DCBR for BookE)
> across for the operation. We don't have to disable the single step,
> as restoring the MSR/DBCR would restore the previous state.

Obviously I can't review this series (although it looks fine to me).

Just one note,

> @@ -121,7 +132,7 @@ int arch_uprobe_post_xol(struct arch_uprobe *auprobe, struct pt_regs *regs)
>
>  	WARN_ON_ONCE(current->thread.trap_nr != UPROBE_TRAP_NR);
>
> -	uprobe_restore_context_sstep(&utask->autask);
> +	uprobe_restore_context_sstep(&utask->autask, regs);

I am not sure ppc needs this, but note that x86 does a bit more.

Not only we need to restore the "single-step" state, we need to
send SIGTRAP if it was not set by us. The same for _skip_sstep.

But even if I am right I do not suggest to change this series,
this can be done as a separate patch.

Oleg.

