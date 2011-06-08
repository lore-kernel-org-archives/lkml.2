Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756578Ab1FHWMl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 18:12:41 -0400
Received: from mout.perfora.net ([74.208.4.194]:54206 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754015Ab1FHWMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 18:12:40 -0400
Date: Wed, 8 Jun 2011 18:11:41 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Steven Rostedt <rostedt@goodmis.org>, Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>, Hugh Dickins <hughd@google.com>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v4 3.0-rc2-tip 13/22] 13: uprobes: Handing int3 and
 singlestep exception.
Message-ID: <20110608221141.GB9965@wicker.gateway.2wire.net>
References: <20110607125804.28590.92092.sendpatchset@localhost6.localdomain6>
 <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607130051.28590.68088.sendpatchset@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:zo3MUd9PZ+vqDTvawJqV25HPvjo25OlNrPzg6epjSWS
 j6aErHIcChBL3ipnqrBBw/DfMniYZ2Wgx43dwH4LyP+XE6VdmC
 QXDydtV7LYjQ1FoCls+5lGmpYSUK3e9/y1lJEs1FFH++6Zoliy
 WEkRaoPmZ3tcmmKeFSjqSQ84car5NRXT0O8uT89MurjUuqUfhi
 z4UG1SS8FKEF0TUwV7ytw9QPSkJkzlc4JVJ4Os9bAI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tue, Jun 07, 2011 at 06:30:51PM +0530, Srikar Dronamraju wrote:
> +/*
> + * uprobe_post_notifier gets called in interrupt context.
> + * It completes the single step operation.
> + */
> +int uprobe_post_notifier(struct pt_regs *regs)
> +{
> +	struct uprobe *uprobe;
> +	struct uprobe_task *utask;
> +
> +	if (!current->mm || !current->utask || !current->utask->active_uprobe)
> +		/* task is currently not uprobed */
> +		return 0;
> +
> +	utask = current->utask;
> +	uprobe = utask->active_uprobe;
> +	if (!uprobe)
> +		return 0;
> +
> +	set_thread_flag(TIF_UPROBE);
> +	return 1;
> +}

Looks like this can be simplified.  If current->utask->active_uprobe is
non-null then surely the assignment to uprobe will be too?


-- 
steve

