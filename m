Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753012Ab0ESO7S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 10:59:18 -0400
Received: from casper.infradead.org ([85.118.1.10]:41857 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab0ESO7R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 10:59:17 -0400
Subject: Re: [LKML] Re: [PATCH v3] ad7877: keep dma rx buffers in seperate
 cache lines
From: David Woodhouse <dwmw2@infradead.org>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: npiggin@suse.de, jw@emlix.com, marc@tensilica.com, vapier.adi@gmail.com,
       dmitry.torokhov@gmail.com, cl@linux.com, penberg@cs.helsinki.fi,
       mpm@selenic.com, akpm@linux-foundation.org, os@emlix.com,
       Michael.Hennerich@analog.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, dg@emlix.com, osw@emlix.com,
       rientjes@google.com, dbrownell@users.sourceforge.net,
       grant.likely@secretlab.ca, chris@zankel.net, Piet.Delaney@tensilica.com
In-Reply-To: <20100519234049C.fujita.tomonori@lab.ntt.co.jp>
References: <20100519133656.GY2516@laptop>
	 <20100519134429.GH26131@emlix.com> <20100519135226.GZ2516@laptop>
	 <20100519234049C.fujita.tomonori@lab.ntt.co.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 May 2010 15:58:37 +0100
Message-ID: <1274281117.6930.10190.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-05-19 at 23:38 +0900, FUJITA Tomonori wrote:
> 
> > I don't think we need to hide the fact that some platforms have
> > specific alignment restrictions for DMA. So if any drivers make use
> > of the alignment, I see no problem with __dma_aligned.
> 
> IIRC, such was proposed several times:
> 
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg12633.html
> 
> I guess that we agreed that it's better to tell driver writers to just
> use kmalloc. 

Perhaps -- but only a few days ago in this thread, they were being
advised to use ____cacheline_aligned instead!

And for this case it really does seem to make sense to keep the buffer
in the parent structure rather than allocating it separately. The DMA
buffers are tiny and on cache-coherent architectures it's _much_ more
efficient just to have them in the original structure and use
__dma_aligned.

-- 
dwmw2

