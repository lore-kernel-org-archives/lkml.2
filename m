Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab1DRQsN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 12:48:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:55732 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755903Ab1DRQsF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 12:48:05 -0400
Subject: Re: [PATCH v3 2.6.39-rc1-tip 13/26] 13: uprobes: get the
 breakpoint address.
From: Peter Zijlstra <peterz@infradead.org>
To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Linux-mm <linux-mm@kvack.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Oleg Nesterov <oleg@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        SystemTap <systemtap@sources.redhat.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Roland McGrath <roland@hack.frob.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20110401143507.15455.87968.sendpatchset@localhost6.localdomain6>
References: <20110401143223.15455.19844.sendpatchset@localhost6.localdomain6>
	 <20110401143507.15455.87968.sendpatchset@localhost6.localdomain6>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 18 Apr 2011 18:47:22 +0200
Message-ID: <1303145242.32491.887.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-04-01 at 20:05 +0530, Srikar Dronamraju wrote:
> +/**
> + * uprobes_get_bkpt_addr - compute address of bkpt given post-bkpt regs
> + * @regs: Reflects the saved state of the task after it has hit a breakpoint
> + * instruction.
> + * Return the address of the breakpoint instruction.
> + */
> +unsigned long uprobes_get_bkpt_addr(struct pt_regs *regs)
> +{
> +       return instruction_pointer(regs) - UPROBES_BKPT_INSN_SIZE;
> +} 

This assumes the breakpoint instruction is trap like, not fault like, is
that true for all architectures?
