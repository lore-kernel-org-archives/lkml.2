Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755975Ab0EJTgP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:36:15 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:49273 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755733Ab0EJTgN (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 May 2010 15:36:13 -0400
Date: Mon, 10 May 2010 15:35:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es, linux@eikelenboom.it, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 5/6] swiotlb: Make swiotlb bookkeeping functions
	visible in the header file.
Message-ID: <20100510193531.GC5906@phenom.dumpdata.com>
References: <1270672170-31833-4-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-5-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-6-git-send-email-konrad.wilk@oracle.com> <20100509224534X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100509224534X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE8601B.00B7:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +extern void swiotlb_full(struct device *dev, size_t size,
> > +			 enum dma_data_direction dir, int do_panic);
> > +
> 
> Please don't. You create a new IOMMU implementation with the helper
> function. We don't want another IOMMU implementation that has broken
> 'overflow buffer' concept.

Of course. Will remove that. Thanks again for your review, much
appreciated.

> 
> swiotlb-xen should handle DMA mapping errors properly instead of
> calling swiotlb_full().

<nods>
> 
> btw, if you try to push xen swiotlb stuff to mainline, please don't
> put xen swiotlb stuff to include/linux/swiotlb.h.

OK.
