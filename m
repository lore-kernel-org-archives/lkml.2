Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934769Ab2JYO5o (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 10:57:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24522 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933068Ab2JYO5n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 10:57:43 -0400
Date: Thu, 25 Oct 2012 16:58:39 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Rabin Vincent <rabin@rab.in>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121025145839.GB26929@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/16, Rabin Vincent wrote:
>
> 2012/10/15 Oleg Nesterov <oleg@redhat.com>:
> > On 10/14, Rabin Vincent wrote:
> >> Flush the cache so that the instructions written to the XOL area are
> >> visible.
> >>
> >> Signed-off-by: Rabin Vincent <rabin@rab.in>
> >> ---
> >>  kernel/events/uprobes.c |    1 +
> >>  1 file changed, 1 insertion(+)
> >>
> >> diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
> >> index ca000a9..8c52f93 100644
> >> --- a/kernel/events/uprobes.c
> >> +++ b/kernel/events/uprobes.c
> >> @@ -1246,6 +1246,7 @@ static unsigned long xol_get_insn_slot(struct uprobe *uprobe, unsigned long slot
> >>       offset = current->utask->xol_vaddr & ~PAGE_MASK;
> >>       vaddr = kmap_atomic(area->page);
> >>       arch_uprobe_xol_copy(&uprobe->arch, vaddr + offset);
> >> +     flush_dcache_page(area->page);
> >>       kunmap_atomic(vaddr);
> >
> > I agree... but why under kmap_atomic?
>
> No real reason; I'll move it to after the unmap.

OK. I assume you will send v2.

But this patch looks like a bugfix, flush_dcache_page() is not a nop
on powerpc. So perhaps we should apply this fix right now?

OTOH, I do not understand this stuff, everything is nop on x86. And
when I look into Documentation/cachetlb.txt I am starting to think
that may be this needs flush_icache_user_range instead?

Rabin, Ananth could you clarify this?

Oleg.

