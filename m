Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753721Ab1FJJNN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:13:13 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49812 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab1FJJNM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:13:12 -0400
Date: Fri, 10 Jun 2011 10:12:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, tglx@linutronix.de,
        rientjes@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        mel@csn.ul.ie, kamezawa.hiroyu@jp.fujitsu.com, riel@redhat.com,
        pavel@ucw.cz
Subject: Re: [PATCH] Make GFP_DMA allocations w/o ZONE_DMA emit a warning
	instead of failing
Message-ID: <20110610091233.GJ24424@n2100.arm.linux.org.uk>
References: <BANLkTinBkdVd90g3-uiQP41z1S1sXUdRmQ@mail.gmail.com> <BANLkTikrRRzGLbMD47_xJz+xpgftCm1C2A@mail.gmail.com> <alpine.DEB.2.00.1106011017260.13089@chino.kir.corp.google.com> <20110601181918.GO3660@n2100.arm.linux.org.uk> <alpine.LFD.2.02.1106012043080.3078@ionos> <alpine.DEB.2.00.1106011205410.17065@chino.kir.corp.google.com> <alpine.LFD.2.02.1106012134120.3078@ionos> <4DF1C9DE.4070605@jp.fujitsu.com> <20110610004331.13672278.akpm@linux-foundation.org> <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTimC8K2_H7ZEu2XYoWdA09-3XxpV7Q@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 12:11:42PM +0400, Dmitry Eremin-Solenikov wrote:
> On 6/10/11, Andrew Morton <akpm@linux-foundation.org> wrote:
> > On Fri, 10 Jun 2011 16:38:06 +0900 KOSAKI Motohiro
> > <kosaki.motohiro@jp.fujitsu.com> wrote:
> >
> >> Subject: [PATCH] Revert "mm: fail GFP_DMA allocations when ZONE_DMA is not
> >> configured"
> >
> > Confused.  We reverted this over a week ago.
> 
> Should one submit a patch adding a warning to GFP_DMA allocations
> w/o ZONE_DMA, or the idea of the original patch is wrong?

Linus was far from impressed by the original commit, saying:
| Using GFP_DMA is reasonable in a driver - on platforms where that
| matters, it should allocate from the DMA zone, on platforms where it
| doesn't matter it should be a no-op.

So no, not even a warning.

What is a useful exercise though is to remove GFP_DMA from those
allocations which should never have had GFP_DMA added - such as those
used for data structures which have nothing to do with DMA at all.
Also dma_alloc_coherent() should not be given GFP_DMA in any case.
