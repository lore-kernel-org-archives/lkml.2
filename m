Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759594Ab1FATqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 15:46:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:55676 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759552Ab1FATqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 15:46:45 -0400
Date: Wed, 1 Jun 2011 21:46:37 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Rientjes <rientjes@google.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Mel Gorman <mel@csn.ul.ie>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
 instead of failing
In-Reply-To: <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com>
Message-ID: <alpine.LFD.2.02.1106012134120.3078@ionos>
References: <1306922672-9012-1-git-send-email-dbaryshkov@gmail.com> <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com>
 <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos> <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Jun 2011, David Rientjes wrote:
> On Wed, 1 Jun 2011, Thomas Gleixner wrote:
> 
> > > That is NOT an unreasonable request, but it seems that its far too much
> > > to ask of you.
> > 
> > Full ack.
> > 
> > David,
> > 
> > stop that nonsense already. You changed the behaviour and broke stuff
> > which was working fine before for whatever reason. That behaviour was
> > in the kernel for ages and we tolerated the abuse.
> > 
> 
> Did I nack this patch and not realize it?

No, you did not realize anything.
 
> Does my patch fix the warning for pxaficp_ir that would still be emitted 
> with this patch?  If the driver uses GFP_DMA and nobody from the arm side 

Your patch does not fix anything. It papers over the problem and
that's the f@&^%%@^#ing wrong approach.

And just to be clear. You CANNOT fix a warning. You can fix the code
which causes the warning, but that's not what your patch is
doing. Your patch HIDES the problem.

> is prepared to remove it yet, then I'd suggest merging my patch until that 
> can be determined.  Otherwise, you have no guarantees about where the 
> memory is actually coming from.

Did you actually try to understand what I wrote? 

You decided that it's a BUG just because it should not be allowed. So
you changed the behaviour, which was perfectly fine before.

Now you try to paper over the problem by selecting ZONE_DMA and refuse
to give a grace period of _ONE_ kernel release.

IOW, you are preventing that the abusers of GFP_DMA are fixed
properly.

I can see that you neither have the bandwidth nor the knowledge to
analyse each user of GFP_DMA. And that should tell you something.

If you cannot fix it yourself, then f*(&!@$#ng not break it.

Thanks,

	tglx


