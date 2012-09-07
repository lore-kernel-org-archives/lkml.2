Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751531Ab2IGPtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 11:49:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52699 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab2IGPtt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 11:49:49 -0400
Date: Fri, 7 Sep 2012 17:50:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Roland McGrath <roland@hack.frob.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: Do not (ab)use
	TIF_SINGLESTEP/user_*_single_step() for single-stepping
Message-ID: <20120907155057.GA1669@redhat.com>
References: <20120903152525.GA9028@redhat.com> <20120903152613.GA9078@redhat.com> <20120907151111.GQ30238@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120907151111.GQ30238@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07, Srikar Dronamraju wrote:
>
> Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

Thanks!

(and thanks, I'll fix the typo in 2/7 you pointed out)

> >  void arch_uprobe_enable_step(struct arch_uprobe *auprobe)
> >  {
> > -	struct uprobe_task	*utask		= current->utask;
> > -	struct arch_uprobe_task	*autask		= &utask->autask;
> > +	struct task_struct *task = current;
>
> Any particular reason to use task instead of current?

No particular reason, and I think in this case asm will be the same.

Please let me know if you prefer to remove this variable, I'll redo
this patch.

Oleg.

