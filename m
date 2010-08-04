Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756465Ab0HDQRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 12:17:51 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:38048 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752630Ab0HDQRu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 12:17:50 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: 3730LKsVM1l1qJEfrBCjFyMr.ZyZsz_1XZymPrCdJqTHvR4
 ElDRbtbw5HByp.BhrPD5__xkPVyzBkHPqNwX0qkg9tm832Smb8zZaXD0cLS_
 bdA4gwUZUiqwgmIJJRxAbBQidoNyoUctNmmvHybCZ3ej3_W1kFS6dSOh5rb4
 Lf_OhXsVXLxPpO72UuhshEu1plxO3Hw_JuUxzRpBxABEMtcLX3.zsNoDtCdN
 1
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 4 Aug 2010 11:17:47 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Pekka Enberg <penberg@cs.helsinki.fi>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Nick Piggin <npiggin@suse.de>
Subject: Re: [S+Q3 00/23] SLUB: The Unified slab allocator (V3)
In-Reply-To: <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008041115500.11084@router.home>
References: <20100804024514.139976032@linux.com> <alpine.DEB.2.00.1008032138160.20049@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Aug 2010, David Rientjes wrote:

> On Tue, 3 Aug 2010, Christoph Lameter wrote:
>
> > The following is a first release of an allocator based on SLAB
> > and SLUB that integrates the best approaches from both allocators. The
> > per cpu queuing is like the two prior releases. The NUMA facilities
> > were much improved vs V2. Shared and alien cache support was added to
> > track the cache hot state of objects.
> >
>
> This insta-reboots on my netperf benchmarking servers (but works with
> numa=off), so I'll have to wait until I can hook up a serial before
> benchmarking this series.

There are potential issues with

1. The size of per cpu reservation on bootup and the new percpu code that
allows allocations for per cpu areas during bootup. Sometime I wonder if I
should just go back to static allocs for that.

2. The topology information provided by the machine for the cache setup.

3. My code of course.

Bootlog would be appreciated.

