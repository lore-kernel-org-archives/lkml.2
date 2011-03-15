Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758000Ab1COOnB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 10:43:01 -0400
Received: from www.tglx.de ([62.245.132.106]:54854 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757887Ab1COOnA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 10:43:00 -0400
Date: Tue, 15 Mar 2011 15:41:20 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        SystemTap <systemtap@sources.redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20] 7: uprobes: store/restore original
 instruction.
In-Reply-To: <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
Message-ID: <alpine.LFD.2.00.1103151538200.2787@localhost6.localdomain6>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Mar 2011, Srikar Dronamraju wrote:
>  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
>  {
> -	int ret = 0;
> +	struct task_struct *tsk;
> +	int ret = -EINVAL;
>  
> -	/*TODO: install breakpoint */
> -	if (!ret)
> +	get_task_struct(mm->owner);

Increment task ref before checking for NULL ?

> +	tsk = mm->owner;
> +	if (!tsk)
> +		return ret;
> +
  
Thanks,

	tglx
