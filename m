Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab1C2Tn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 15:43:26 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:33011 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab1C2TnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 15:43:25 -0400
Date: Tue, 29 Mar 2011 15:43:24 -0400
From: "'Christoph Hellwig'" <hch@infradead.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: "'Christoph Hellwig'" <hch@infradead.org>,
        Sean Noonan <Sean.Noonan@twosigma.com>,
        "'Michel Lespinasse'" <walken@google.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        Martin Bligh <Martin.Bligh@twosigma.com>,
        Trammell Hudson <Trammell.Hudson@twosigma.com>,
        Christos Zoulas <Christos.Zoulas@twosigma.com>,
        "'linux-xfs@oss.sgi.com'" <linux-xfs@oss.sgi.com>,
        Stephen Degler <Stephen.Degler@twosigma.com>,
        "'linux-mm@kvack.org'" <linux-mm@kvack.org>
Subject: Re: XFS memory allocation deadlock in 2.6.38
Message-ID: <20110329194323.GA27840@infradead.org>
References: <081DDE43F61F3D43929A181B477DCA95639B52FD@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5327@MSXAOA6.twosigma.com>
 <20110324174311.GA31576@infradead.org>
 <AANLkTikwwRm6FHFtEdUg54NvmKdswQw-NPH5dtq1mXBK@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B5349@MSXAOA6.twosigma.com>
 <BANLkTin0jJevStg5P2hqsLbqMzo3o30sYg@mail.gmail.com>
 <081DDE43F61F3D43929A181B477DCA95639B534E@MSXAOA6.twosigma.com>
 <081DDE43F61F3D43929A181B477DCA95639B5359@MSXAOA6.twosigma.com>
 <20110329192434.GA10536@infradead.org>
 <20110329193907.GK2310@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110329193907.GK2310@cmpxchg.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 09:39:07PM +0200, Johannes Weiner wrote:
> > -	ptr = vmalloc(size);
> > +	ptr = __vmalloc(size, GFP_NOFS | __GFP_HIGHMEM, PAGE_KERNEL);
> >  	if (ptr)
> >  		memset(ptr, 0, size);
> >  	return ptr;
> 
> Note that vmalloc is currently broken in that it does a GFP_KERNEL
> allocation if it has to allocate page table pages, even when invoked
> with GFP_NOFS:
> 
> 	http://marc.info/?l=linux-mm&m=128942194520631&w=4

Oh great.  In that case we had a chance to hit the deadlock even before
the offending commit, just a much smaller one.

