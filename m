Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754510Ab2ATQL7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 11:11:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:25646 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2ATQL5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 11:11:57 -0500
Date: Fri, 20 Jan 2012 11:09:38 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Jeremy Fitzhardinge Jeremy Fitzhardinge <jeremy@goop.org>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] xen-blkfront: use bitmap_set() and bitmap_clear()
Message-ID: <20120120160938.GC3959@phenom.dumpdata.com>
References: <1327072528-8479-1-git-send-email-akinobu.mita@gmail.com>
 <1327072528-8479-4-git-send-email-akinobu.mita@gmail.com>
 <20120120152819.GA3959@phenom.dumpdata.com>
 <CAC5umyi9vuOh9Bx_HoB8ieXcVjZsisKOG6mCEM2ZGL7zXCrVTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <CAC5umyi9vuOh9Bx_HoB8ieXcVjZsisKOG6mCEM2ZGL7zXCrVTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F199247.0090,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 21, 2012 at 12:41:56AM +0900, Akinobu Mita wrote:
> 2012/1/21 Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>:
> > On Sat, Jan 21, 2012 at 12:15:26AM +0900, Akinobu Mita wrote:
> >> Use bitmap_set and bitmap_clear rather than modifying individual bits
> >> in a memory region.
> >>
> >> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> >> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >> Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >> Cc: xen-devel@lists.xensource.com
> >> Cc: virtualization@lists.linux-foundation.org
> >> ---
> >>  drivers/block/xen-blkfront.c |    7 +++----
> >>  1 files changed, 3 insertions(+), 4 deletions(-)
> >>
> >> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> >> index 2f22874..619868d 100644
> >> --- a/drivers/block/xen-blkfront.c
> >> +++ b/drivers/block/xen-blkfront.c
> >> @@ -43,6 +43,7 @@
> >>  #include <linux/slab.h>
> >>  #include <linux/mutex.h>
> >>  #include <linux/scatterlist.h>
> >> +#include <linux/bitmap.h>
> >>
> >>  #include <xen/xen.h>
> >>  #include <xen/xenbus.h>
> >> @@ -177,8 +178,7 @@ static int xlbd_reserve_minors(unsigned int minor, unsigned int nr)
> >>
> >>       spin_lock(&minor_lock);
> >>       if (find_next_bit(minors, end, minor) >= end) {
> >> -             for (; minor < end; ++minor)
> >> -                     __set_bit(minor, minors);
> >> +             bitmap_set(minors, minor, nr);
> >
> > Hm, I would have thought the last argument should have been 'end'?
> 
> 'end' is the index of the last bit to clear.  But the last argument of
> bitmap_clear() is the number of bits to clear.  So I think 'nr' is correct.

Ah, I see it.
> 
> > Did you test this patch with a large amount of minors?
> 
> Sorry I didn't do runtime test.

Please do.
