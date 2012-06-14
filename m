Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab2FNIif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 04:38:35 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53860 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752987Ab2FNIic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 04:38:32 -0400
Date: Thu, 14 Jun 2012 10:38:26 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes: don't use loff_t for the valid virtual
 address
Message-ID: <20120614083826.GA2964@gmail.com>
References: <20120613184933.GA13870@redhat.com>
 <20120613185106.GE13878@redhat.com>
 <20120614052430.GA9089@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614052430.GA9089@in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ananth N Mavinakayanahalli <ananth@in.ibm.com> wrote:

> On Wed, Jun 13, 2012 at 08:51:06PM +0200, Oleg Nesterov wrote:
> > loff_t looks confusing when it is used for the virtual address.
> > Change map_info and install_breakpoint/remove_breakpoint paths
> > to use "unsigned long".
> > 
> > The patch doesn't change vma_address(), it can't return "long"
> > because it is used to verify the mapping. But probably this
> > needs some cleanups too.
> 
> Oleg,
> 
> As you mentioned in another email, this conflicts with my 
> [1/2] preparatory patch for the powerpc port. [...]

Note, I already merged your preparatory patch into tip:perf/core 
a couple of days ago:

 7eb9ba5ed312 uprobes: Pass probed vaddr to arch_uprobe_analyze_insn()

So as long as Oleg is working on top of -tip there should be no 
conflict.

Thanks,

	Ingo
