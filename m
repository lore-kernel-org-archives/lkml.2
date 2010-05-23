Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754377Ab0EWMsp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 08:48:45 -0400
Received: from ozlabs.org ([203.10.76.45]:44131 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754061Ab0EWMso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 08:48:44 -0400
Date: Sun, 23 May 2010 22:11:59 +1000
From: Paul Mackerras <paulus@samba.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/10] perf, trace: Remove IRQ-disable from
 perf/tracepoint interaction
Message-ID: <20100523121159.GB3194@brick.ozlabs.ibm.com>
References: <20100521090201.326791353@chello.nl>
 <20100521090710.419716197@chello.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100521090710.419716197@chello.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 21, 2010 at 11:02:02AM +0200, Peter Zijlstra wrote:

>  	entry = (struct trace_entry *)raw_data;
> -	tracing_generic_entry_update(entry, *irq_flags, pc);
> +	tracing_generic_entry_update(entry, regs->flags, pc);
>  	entry->type = type;

This is breaking on powerpc -- we don't have a "flags" element in
struct pt_regs.  What is it trying to do?  Get the interrupt enable
state, as local_irq_save(flags) would provide?

Paul.
