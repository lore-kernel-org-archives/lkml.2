Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751702Ab1K3TDW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 14:03:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50378 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750895Ab1K3TDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 14:03:20 -0500
Date: Wed, 30 Nov 2011 19:57:51 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Wilson <wilsons@start.ca>
Subject: Re: [PATCH v7 3.2-rc2 8/30] x86: analyze instruction and determine
	fixups.
Message-ID: <20111130185751.GA8160@redhat.com>
References: <20111118110631.10512.73274.sendpatchset@srdronam.in.ibm.com> <20111118110808.10512.72719.sendpatchset@srdronam.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111118110808.10512.72719.sendpatchset@srdronam.in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18, Srikar Dronamraju wrote:
>
> +static void handle_riprel_insn(struct mm_struct *mm, struct uprobe *uprobe,
> +							struct insn *insn)
> +{
> [...snip...]
> +	if (insn->immediate.nbytes) {
> +		cursor++;
> +		memmove(cursor, cursor + insn->displacement.nbytes,
> +						insn->immediate.nbytes);
> +	}
> +	return;
> +}

Of course I don not understand this code. But it seems that it can
rewrite uprobe->insn ?

If yes, don't we need to save the original insn for unregister_uprobe?

Oleg.

