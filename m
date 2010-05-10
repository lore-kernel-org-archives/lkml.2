Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753678Ab0EJTdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 15:33:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28808 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0EJTdJ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 10 May 2010 15:33:09 -0400
Date: Mon, 10 May 2010 15:31:18 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es, linux@eikelenboom.it, chrisw@sous-sol.org,
       Ian.Campbell@eu.citrix.com, jeremy@goop.org, dwmw2@infradead.org,
       alex.williamson@hp.com
Subject: Re: [PATCH 2/6] swiotlb: swiotlb_tbl_map_single: abstract out
	swiotlb_virt_to_bus calls out.
Message-ID: <20100510193118.GA5906@phenom.dumpdata.com>
References: <1270672170-31833-1-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-2-git-send-email-konrad.wilk@oracle.com> <1270672170-31833-3-git-send-email-konrad.wilk@oracle.com> <20100509223623X.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100509223623X.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BE85F5D.0117:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 09, 2010 at 10:41:15PM +0900, FUJITA Tomonori wrote:
> On Wed,  7 Apr 2010 16:29:26 -0400
> Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> 
> > We want to move that function out of swiotlb_tbl_map_single so that the caller
> > of this function does the virt->phys->bus address translation.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  lib/swiotlb.c |   22 ++++++++++++++--------
> >  1 files changed, 14 insertions(+), 8 deletions(-)
> 
> It would be better to do something like that instead of spreading
> swiotlb_virt_to_bus()?

Yes! Thought I am confused by the name. In the past you mentioned 'tbl',
but here it is 'tlb'. I presume 'tbl' is the right one?

> Subject: [PATCH] swiotlb: add swiotlb_tlb_map_single library function
> 
> swiotlb_tlb_map_single() takes the dma address of iotlb instead of
> using swiotlb_virt_to_bus().
