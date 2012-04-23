Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2DWCvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 22:51:21 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:26456 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab2DWCvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 22:51:20 -0400
Date: Sun, 22 Apr 2012 22:45:58 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Martin Peres <martin.peres@labri.fr>, Ben Skeggs <bskeggs@redhat.com>,
        dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc4
Message-ID: <20120423024558.GD13840@phenom.dumpdata.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
 <20120422040715.GA30689@elliptictech.com>
 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
 <20120422164023.GA32342@elliptictech.com>
 <20120423000554.GA893@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120423000554.GA893@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 08:05:54PM -0400, Nick Bowler wrote:
> On 2012-04-22 12:40 -0400, Nick Bowler wrote:
> > On 2012-04-21 21:51 -0700, Linus Torvalds wrote:
> > > Nick, I realize you had trouble with a bisection already, but it might
> > > really be worth trying again. Do a
> > > 
> > >     git bisect visualize
> > > 
> > > and try to pick a good commit (avoding the problems you hit) when you
> > > hit a problem, and then do
> > > 
> > >    git reset --hard <that-point>
> > > 
> > > to force bisection to try another place. That way you can sometimes
> > > avoid the problem spots, and continue the bisection.
> > 
> > Unfortunately, I think the whole swath of commits bisect wants to test
> > are broken (as in, they panic before I get to see whether or not the VGA
> > is working), because the commit from which most of the drm trees were
> > based appears to be broken.  Nevertheless, I've included the new bisect
> > log (four new commits marked skip as opposed to last time).  I've also
> > included the boot log from a crashing kernel, in case someone recognizes
> > how I can avoid this during bisection.  Note that this crash is *not* a
> > regression that exists in current mainline -- bisecting this issue was
> > the first time I had ever seen it.
> 
> Following up on the above, the commit which introduces the panics during
> boot is this one:

I think

dea7e0a ttm: fix agp since ttm tt rework

fixed that.
> 
> commit 8e7e70522d760c4ccd4cd370ebfa0ba69e006c6e
> Author: Jerome Glisse <jglisse@redhat.com>
> Date:   Wed Nov 9 17:15:26 2011 -0500
> 
>     drm/ttm: isolate dma data from ttm_tt V4
>     
>     Move dma data to a superset ttm_dma_tt structure which herit
>     from ttm_tt. This allow driver that don't use dma functionalities
>     to not have to waste memory for it.
>     
>     V2 Rebase on top of no memory account changes (where/when is my
>        delorean when i need it ?)
>     V3 Make sure page list is initialized empty
>     V4 typo/syntax fixes
>     
>     Signed-off-by: Jerome Glisse <jglisse@redhat.com>
>     Reviewed-by: Thomas Hellstrom <thellstrom@vmware.com>
> 
> and the previous commit (3230cfc34fca: "drm/nouveau: enable the ttm dma
> pool when swiotlb is active V3") works properly.
> 
> Sometime this week I suppose I'll try to track down the commit which
> fixed the crashes...
> 
> Cheers,
> -- 
> Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
> 
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
