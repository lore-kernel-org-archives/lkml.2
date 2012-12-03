Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab2LCPQF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:16:05 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:47936 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751412Ab2LCPQC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:16:02 -0500
Date: Mon, 3 Dec 2012 20:45:44 +0530
From: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
To: "Suzuki K. Poulose" <suzuki@in.ibm.com>
Cc: bigeasy@linutronix.de, oleg@redhat.com, srikar@linux.vnet.ibm.com,
        peterz@infradead.org, benh@kernel.crashing.org, mingo@elte.hu,
        anton@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/4] uprobes/powerpc: Introduce routines for
	save/restore context
Message-ID: <20121203151544.GB6333@in.ibm.com>
Reply-To: ananth@in.ibm.com
References: <20121203150438.7727.74924.stgit@suzukikp> <20121203150849.7727.53296.stgit@suzukikp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121203150849.7727.53296.stgit@suzukikp>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12120315-5806-0000-0000-00001C7BFBA8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 08:39:35PM +0530, Suzuki K. Poulose wrote:
> From: Suzuki K. Poulose <suzuki@in.ibm.com>
> 
> Introduce routines for saving and restoring the context
> befre/after the single step. No functional changes involved.
> 
> These will be extended later to save/restore more info about
> the process once we replace the ptrace helpers.
> 
> Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>
> ---
>  arch/powerpc/kernel/uprobes.c |   16 +++++++++++++---
>  1 file changed, 13 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/powerpc/kernel/uprobes.c b/arch/powerpc/kernel/uprobes.c
> index bc77834..1a62353 100644
> --- a/arch/powerpc/kernel/uprobes.c
> +++ b/arch/powerpc/kernel/uprobes.c
> @@ -52,6 +52,16 @@ int arch_uprobe_analyze_insn(struct arch_uprobe *auprobe,
>  	return 0;
>  }
> 
> +static void uprobe_save_context_sstep(struct arch_uprobe_task *autask)
> +{
> +	autask->saved_trap_nr = current->thread.trap_nr;
> +}
> +
> +static void uprobe_restore_context_sstep(struct arch_uprobe_task *autask)
> +{
> +	current->thread.trap_nr = autask->saved_trap_nr;
> +}

Can't the two above be inline?

Ananth

