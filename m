Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab1JGSfS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 14:35:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46271 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752664Ab1JGSfP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 14:35:15 -0400
Date: Fri, 7 Oct 2011 20:31:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v5 3.1.0-rc4-tip 13/26]   x86: define a x86 specific
	exception notifier.
Message-ID: <20111007183102.GB1655@redhat.com>
References: <20110920115938.25326.93059.sendpatchset@srdronam.in.ibm.com> <20110920120238.25326.71868.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110920120238.25326.71868.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20, Srikar Dronamraju wrote:
>
> +int uprobe_exception_notify(struct notifier_block *self,
> +				       unsigned long val, void *data)
> +{
> +	struct die_args *args = data;
> +	struct pt_regs *regs = args->regs;
> +	int ret = NOTIFY_DONE;
> +
> +	/* We are only interested in userspace traps */
> +	if (regs && !user_mode_vm(regs))
> +		return NOTIFY_DONE;
> +
> +	switch (val) {
> +	case DIE_INT3:
> +		/* Run your handler here */
> +		if (uprobe_bkpt_notifier(regs))
> +			ret = NOTIFY_STOP;
> +		break;

OK, but I simply can't understand do_int3(). It uses DIE_INT3 or
DIE_TRAP depending on CONFIG_KPROBES.

Oleg.

