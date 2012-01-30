Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753679Ab2A3Vx4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 16:53:56 -0500
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:49135 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752028Ab2A3Vxz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 16:53:55 -0500
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: Xjlh5mQVM1mKGI9UimGTGjhy.b4oh9KyBNvMeqD3JuA8F4m
 zEku3uAqYUxWK8UZf.qLiYxVCUF0zZ9h8JWonl4CVU47oZGgwz1XTSibdu2I
 ScG1LbmQro1PZO4LB8ek69h4lL8wplGt3nnrvCwjJ7fYmA6OwFP9Y.F3pT0V
 OGljNZAOzH7bKqS.5fn0_ypRbgdMpOiDLByzIm1p_TbjpvjSrvbV1p_uebi2
 ioiRxHrOBTmr9T_96KJHfsXx37SpdBwCnQ1gqRXldTtQJHo0PWdu4XfrNyur
 g.RQFZadpP62hPosbkEkeks6a_SKZiSzeQsFlFMxH.uV8r2pJl0hzly_aPq7
 cYacxnZqOWDV6EQap8ge3T7npie3pIwII.DFT7xaBuOTRaBbyuY_Q2Ql9JJ5
 8mlgHpu3o6VNKl028K7Rw0xtuPoV5i6Iy7kj1SbGgJcr_hIMC7RmZt9kVUFW
 pvhqb7K_oztscIO9RPpe3y5i_2zZheyNC8XBpo5p26PxiZwv67S5WRsHvja0
 iAtmHj5t16Kilp8218dEjvXovTA--
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Mon, 30 Jan 2012 15:53:51 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Geert Uytterhoeven <geert@linux-m68k.org>
cc: Pekka Enberg <penberg@kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>, "Alex,Shi" <alex.shi@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Matt Mackall <mpm@selenic.com>,
        Linux-Next <linux-next@vger.kernel.org>
Subject: Re: [PATCH] slub: prefetch next freelist pointer in slab_alloc()
In-Reply-To: <CAMuHMdW-RbD-uxpOGmhv0LCsHLG-2Q0LvSRrB0cdM2efGRAYnw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1201301549240.3895@router.home>
References: <1324049134.25554.29.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.DEB.2.00.1112161030270.26651@router.home> <alpine.LFD.2.02.1201242152480.1658@tux.localdomain> <CAMuHMdW-RbD-uxpOGmhv0LCsHLG-2Q0LvSRrB0cdM2efGRAYnw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 30 Jan 2012, Geert Uytterhoeven wrote:

> On Tue, Jan 24, 2012 at 20:54, Pekka Enberg <penberg@kernel.org> wrote:
> > On Fri, 16 Dec 2011, Eric Dumazet wrote:
> >>> Recycling a page is a problem, since freelist link chain is hot on
> >>> cpu(s) which freed objects, and possibly very cold on cpu currently
> >>> owning slab.
> >
> > On Fri, 16 Dec 2011, Christoph Lameter wrote:
> >> Good idea. How do the tcp benchmarks look after this?
> >>
> >> Looks sane.
> >>
> >> Acked-by: Christoph Lameter <cl@linux.com>
> >
> > Applied, thanks!
>
> m68k/allmodconfig at http://kisskb.ellerman.id.au/kisskb/buildresult/5527349/
>
> mm/slub.c:274: error: implicit declaration of function 'prefetch'
>
> Sorry, didn't notice it earlier due to other build breakage in -next.

Does this fix it?


Subject: slub: include include for prefetch

Otherwise m68k breaks.

Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Christoph Lameter <cl@linux.com>


---
 mm/slub.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6/mm/slub.c
===================================================================
--- linux-2.6.orig/mm/slub.c	2012-01-13 10:04:06.000000000 -0600
+++ linux-2.6/mm/slub.c	2012-01-30 15:51:55.000000000 -0600
@@ -29,6 +29,7 @@
 #include <linux/math64.h>
 #include <linux/fault-inject.h>
 #include <linux/stacktrace.h>
+#include <linux/prefetch.h>

 #include <trace/events/kmem.h>

