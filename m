Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756014Ab2FNRlb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:41:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122Ab2FNRla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:41:30 -0400
Date: Thu, 14 Jun 2012 19:39:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] uprobes: don't use loff_t for the valid virtual
	address
Message-ID: <20120614173919.GA7959@redhat.com>
References: <20120613184933.GA13870@redhat.com> <20120613185106.GE13878@redhat.com> <20120614052430.GA9089@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120614052430.GA9089@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14, Ananth N Mavinakayanahalli wrote:
>
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
> As you mentioned in another email, this conflicts with my [1/2]
> preparatory patch for the powerpc port.

Yes, sorry. I didn't notice it was already applied.

As I said, I do not really agree with this change,
arch_uprobe_analyze_insn() shouldn't use addr/vaddr.

However this is minor, we can change this later. And this code needs
more changes anyway.

I'll rebase this series on top of your "1/2" and resend.


> Do you think it just makes sense
> to make the arch_uprobe_analyze_insn() prototype change to take vaddr as
> part of this set itself?

Yes, Anton already did the necessary fixup (thanks Anton ;)

Oleg.

