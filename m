Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751903Ab0HQTeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 15:34:24 -0400
Received: from smtp101.prem.mail.ac4.yahoo.com ([76.13.13.40]:22751 "HELO
	smtp101.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751024Ab0HQTeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 15:34:11 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: Vsu7_jYVM1m2EqaugcpaJPC_TBVGeB1Tg4piRPaUgAcAwBh
 xrqXITDpDU1eFm0PaSfaZQKbw6ggurCrSSQp52e3qc42kouDhdb_1RPJbaY1
 Dr8ZVEDKEwDU_brP_.YXb2N3tRd7Xm.wRV.Airf4IRUJtifsYwz4Iz1fiz4E
 M6ulWcJW4SCF_UrLxCAA1ZMh2MQyiRks44w5xUODKWshcJtnFYwuKDi7qn21
 B
X-Yahoo-Newman-Property: ymail-3
Date: Tue, 17 Aug 2010 14:34:05 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@kernel.dk>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008171153490.21770@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008171433160.14588@router.home>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com> <alpine.DEB.2.00.1008041115500.11084@router.home> <alpine.DEB.2.00.1008050136340.30889@chino.kir.corp.google.com> <alpine.DEB.2.00.1008051231400.6787@router.home>
 <alpine.DEB.2.00.1008151627450.27137@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171217440.11915@router.home> <alpine.DEB.2.00.1008171052500.6486@chino.kir.corp.google.com> <alpine.DEB.2.00.1008171346530.13665@router.home>
 <alpine.DEB.2.00.1008171153490.21770@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Aug 2010, David Rientjes wrote:

> On Tue, 17 Aug 2010, Christoph Lameter wrote:
>
> > > I didn't know if that was a debugging patch for me or if you wanted to
> > > push that as part of your series, I'm not sure if you actually need to
> > > move it to kmem_cache_init() now that slub_state is protected by
> > > slub_lock.  I'm not sure if we want to allocate DMA objects between
> > > kmem_cache_init() and kmem_cache_init_late().
> >
> > Drivers may allocate dma buffers during initialization.
> >
>
> Ok, I moved the DMA cache creation from kmem_cache_init_late() to
> kmem_cache_init().  Note: the kasprintf() will need to use GFP_NOWAIT and
> not GFP_KERNEL now.

ok. I have revised the patch since there is also a problem with the
indirection on kmalloc_caches.


