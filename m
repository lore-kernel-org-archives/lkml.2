Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1CNSJ6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 14:09:58 -0400
Received: from mout.perfora.net ([74.208.4.195]:64366 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753588Ab1CNSJ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 14:09:56 -0400
Date: Mon, 14 Mar 2011 14:09:14 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
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
Subject: Re: [PATCH v2 2.6.38-rc8-tip 7/20]  7: uprobes: store/restore
	original instruction.
Message-ID: <20110314180914.GA18855@fibrous.localdomain>
References: <20110314133403.27435.7901.sendpatchset@localhost6.localdomain6> <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110314133522.27435.45121.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Provags-ID: V02:K0:NDRdorU/LK5525DMTUY/EkldqLnWPwOwI4AIaVLHLUC
 TBsdrEAGAic+gOdjH6rPZwOvP5s/CivqZAI3p0RqGxh5XXN8T2
 G1xgLC8zlVAxrORCvxgXDq8p9yZMzsmk0H6NTiLmwXJ51tmL2C
 xymRVs8gKV0Ol/zy6voSVWq0BM1MX6VA+VrAgAJ3SDlK2eFXla
 SiSuxdkgPsAiAmAf+7GvrFYbkrdCwoULxAPcU/tlWU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 14, 2011 at 07:05:22PM +0530, Srikar Dronamraju wrote:
>  static int install_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
>  {
> -	int ret = 0;
> +	struct task_struct *tsk;
> +	int ret = -EINVAL;
>  
> -	/*TODO: install breakpoint */
> -	if (!ret)
> +	get_task_struct(mm->owner);
> +	tsk = mm->owner;
> +	if (!tsk)
> +		return ret;

I think you need to check that tsk != NULL before calling
get_task_struct()...


>  static int remove_uprobe(struct mm_struct *mm, struct uprobe *uprobe)
>  {
> -	int ret = 0;
> +	struct task_struct *tsk;
> +	int ret;
> +
> +	get_task_struct(mm->owner);
> +	tsk = mm->owner;
> +	if (!tsk)
> +		return -EINVAL;

And here as well.

-- 
steve

