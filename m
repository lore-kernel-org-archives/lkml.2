Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755470Ab0G1Wjh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 18:39:37 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16633 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0G1Wjg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 28 Jul 2010 18:39:36 -0400
Date: Wed, 28 Jul 2010 18:38:16 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: hpa@zytor.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
Message-ID: <20100728223816.GB32739@phenom.dumpdata.com>
References: <20100727194105.GA18647@phenom.dumpdata.com>
 <20100728083526J.fujita.tomonori@lab.ntt.co.jp>
 <4C4F779D.9060908@zytor.com>
 <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C50B173.011A:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > >>> Is there any way we can abstract this out a bit more instead of crapping
> > >>> on generic code?
> > > 
> > > I don't like this change much too, however I think that this is the
> > > most simple and straightforward.
> > > 
> > > Basically, Xen's swiotlb works like a new IOMMU implementation so we
> > > need to initialize it like other IOMMU implementations (call the
> > > detect and init functions in order).
> > > 
> > 
> > Even mentioning "xen" in generic code should be considered a bug.  I
> > think we *do* need to driverize the iommu stuff, and yes, Xen's swiotlb
> > should just be handled like one in the list.

I think we all don't like the way 'pci_iommu_alloc' does it. But it does
the job right now pretty well, and the code looks well, ok. Adding in
the extra '_detect' and '_init' does not detract from it all that much.

Long term I think the driverization is the way to go, and..

> > > I really don't think that this makes the code better. I prefer the
> > > current simple (dumb) code.
> > > 
> > 
> > The special handling of swiotlb here really looks wrong, but otherwise I
> > think it's the right idea.
> > 
> > > Even if SWIOTLB works, we see if hardware IOMMU is available. SWIOTLB
> > > is a last resort. We prefer hardware IOMMU.
> > 
> > Any reason to not just handle swiotlb like any of the other iommus, at
> > the bottom of the list?
> 
> we need to check if swiotlb usage is forced by the command line since:
> 
> - we skip hardware IOMMU initialization if so.

I think the flow a). check if we need SWIOTLB b), check all IOMMUs, c).
recheck SWIOTLB in case no IOMMUs volunteered MUST be preserved
irregardless if we driverize the IOMMUs/SWIOTLB or not.

Perhaps we should get together at one of these Linux conferences and
think this one through? Beers on me.

