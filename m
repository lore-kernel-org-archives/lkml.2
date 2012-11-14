Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933039Ab2KNRgz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 12:36:55 -0500
Received: from mx1.redhat.com ([209.132.183.28]:43353 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978Ab2KNRgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 12:36:54 -0500
Date: Wed, 14 Nov 2012 18:37:17 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Cc: Rabin Vincent <rabin@rab.in>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Subject: Re: [PATCH 6/9] uprobes: flush cache after xol write
Message-ID: <20121114173717.GA19466@redhat.com>
References: <1350242593-17761-1-git-send-email-rabin@rab.in> <1350242593-17761-6-git-send-email-rabin@rab.in> <20121015165756.GA11737@redhat.com> <CAH+eYFAv=UTZ1gQ5jXq8_ziNy1i3BL9y1bOUWMdTow=i3N0n+g@mail.gmail.com> <20121025145839.GB26929@redhat.com> <20121026055239.GA4862@in.ibm.com> <20121026163951.GA17742@redhat.com> <20121029053522.GC3400@in.ibm.com> <20121103163301.GA9496@redhat.com> <20121104142927.GA4087@in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121104142927.GA4087@in.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04, Ananth N Mavinakayanahalli wrote:
>
> On Sat, Nov 03, 2012 at 05:33:01PM +0100, Oleg Nesterov wrote:
> >
> > [PATCH] uprobes: flush cache after xol write
> >
> > From: Rabin Vincent <rabin@rab.in>
> >
> > Flush the cache so that the instructions written to the XOL area are
> > visible.
> >
> > Signed-off-by: Rabin Vincent <rabin@rab.in>
>
> Acked-by: Ananth N Mavinakayanahalli <ananth@in.ibm.com>

Thanks Ananth.

I assume that Srikar and Rabin agree, applied as 65b6ecc038

> >
> > --- x/kernel/events/uprobes.c
> > +++ x/kernel/events/uprobes.c
> > @@ -1199,6 +1199,11 @@ static unsigned long xol_get_insn_slot(s
> >  	vaddr = kmap_atomic(area->page);
> >  	memcpy(vaddr + offset, uprobe->arch.insn, MAX_UINSN_BYTES);
> >  	kunmap_atomic(vaddr);
> > +	/*
> > +	 * We probably need flush_icache_user_range() but it needs vma.
> > +	 * This should work on supported architectures too.
> > +	 */
> > +	flush_dcache_page(area->page);
> >
> >  	return current->utask->xol_vaddr;
> >  }

