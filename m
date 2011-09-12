Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755998Ab1ILXTb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 19:19:31 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:53773 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755611Ab1ILXTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 19:19:30 -0400
Date: Mon, 12 Sep 2011 19:19:08 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Hugh Dickins <hughd@google.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
Message-ID: <20110912231908.GA16475@phenom.oracle.com>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
 <20110705144140.23872.86541.stgit@localhost.localdomain>
 <alpine.LSU.2.00.1107071742250.10362@sister.anvils>
 <20110708093859.299958df@lxorguk.ukuu.org.uk>
 <alpine.LSU.2.00.1107080917430.1781@sister.anvils>
 <20110711172517.46907e62@lxorguk.ukuu.org.uk>
 <alpine.LSU.2.00.1107111033440.1752@sister.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.1107111033440.1752@sister.anvils>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4E6E9376.00D5:SCFMA922111,ss=1,re=-4.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 11, 2011 at 10:49:31AM -0700, Hugh Dickins wrote:
> On Mon, 11 Jul 2011, Alan Cox wrote:
> > > Your <4GB pages won't get swapped out while they're pinned.  But can
> > > it happen that they'd be unpinned, swapped out, swapped back in >4GB
> > > pages, then cause trouble for you when needed again?
> > 
> > It does look that way, in which case that will eventually need fixing. At
> > the moment you can't put enough memory into a device using these chips
> > but that won't always be true I imagine.
> 
> Thanks, I won't worry about it at this moment, but we'd better not forget.

I recall seeing the GMA driver using the TTM at some point
(but then those calls disappared), and I've written a patch to deal with
a similar issue (where the DMA and the virtual address needed to
be passed along to the code that programs the cards MMU).

It also survives suspend/resume, swap, etc.

https://lkml.org/lkml/2011/8/30/460

Don't know if it would be too complicated to make the GMA500 code
use TTM, and the URL I posted still needs a review, but perhaps
that could solve this problem in the future for you guys?

> 
> If it's easy for you to include a WARN_ON_ONCE check (perhaps
> on page_to_pfn(page)), that may be worth doing to remind us.
> 
> It's a bit sad to learn this requirement just after I'd completed
> removing the readpage copying code, and a bit strange to have shmem
> confined by hardware constraints; but I guess that's what we took on
> when we opened it up to GEM.
> 
> It will probably make sense for me to add synchronous migration when
> a shmem swap page is found not to match the contraints wanted by the
> mapping it goes into: mainly for NUMA, but covering your case too.
> 
> Hugh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
