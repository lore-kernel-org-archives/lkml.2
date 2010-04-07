Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117Ab0DGTXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 15:23:53 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:25847 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0DGTXw (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 7 Apr 2010 15:23:52 -0400
Date: Wed, 7 Apr 2010 15:22:46 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
       albert_herranz@yahoo.es, Ian.Campbell@eu.citrix.com, jeremy@goop.org,
       chrisw@sous-sol.org, dwmw2@infradead.org, alex.williamson@hp.com
Subject: Re: [PATCH 4/5] swiotlb: Make swiotlb bookkeeping functions
	visible in the header file.
Message-ID: <20100407192246.GA5040@phenom.dumpdata.com>
References: <1269011062-25915-3-git-send-email-konrad.wilk@oracle.com> <1269011062-25915-4-git-send-email-konrad.wilk@oracle.com> <1269011062-25915-5-git-send-email-konrad.wilk@oracle.com> <20100405111222G.fujita.tomonori@lab.ntt.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405111222G.fujita.tomonori@lab.ntt.co.jp>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0207.4BBCDBA7.0262:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > +extern char *swiotlb_bk_start;
> > +extern char *swiotlb_bk_end;
> > +extern unsigned long swiotlb_bk_nslabs;
> 
> exporting swiotlb_bk_start and swiotlb_bk_nslabs aren't enough?

It is. 
> 
> 
> > +extern void *swiotlb_bk_overflow_buffer;
> > +extern unsigned long swiotlb_bk_overflow;

> > +extern int is_swiotlb_buffer(phys_addr_t paddr);
> > +extern void *swiotlb_bk_map_single(struct device *hwdev, phys_addr_t phys,
> > +			    unsigned long start_dma_addr, size_t size, int dir);
> 
> enum dma_data_direction is better for 'dir'.

Done. I had to make a bigger change that would also change other
functions usage of 'int dir' -> 'enum ..' otherwise we had compiler
warnings.

