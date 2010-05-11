Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758191Ab0EKOoH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 10:44:07 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:46151 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752729Ab0EKOoC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 10:44:02 -0400
Date: Tue, 11 May 2010 08:57:01 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Oskar Schirmer <os@emlix.com>,
       Michael Hennerich <Michael.Hennerich@analog.com>,
       linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
       =?ISO-8859-15?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>,
       Oliver Schneidewind <osw@emlix.com>, Johannes Weiner <jw@emlix.com>,
       Nick Piggin <npiggin@suse.de>, David Rientjes <rientjes@google.com>,
       Matt Mackall <mpm@selenic.com>
Subject: Re: [PATCH v3] ad7877: keep dma rx buffers in seperate cache lines
In-Reply-To: <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1005110854560.1500@router.home>
References: <1273487642-2169-1-git-send-email-os@emlix.com>  <1273488154-2993-1-git-send-email-os@emlix.com>  <20100510142225.4bf215ef.akpm@linux-foundation.org>  <20100511060547.GA9644@core.coreip.homeip.net>  <AANLkTikA9s6lpO2uDuIup8BwGOYYHQ9yQxS36PBSIttX@mail.gmail.com>
  <20100511062110.GB9644@core.coreip.homeip.net>  <AANLkTiktu7N5IXknkkJ9D5L4z5plhuGvD45IVqJm9zG1@mail.gmail.com>  <20100511063309.GC9644@core.coreip.homeip.net> <y2k84144f021005102342m18bce930g53599c9112565f78@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010, Pekka Enberg wrote:

> > The data is kmalloced, kmalloc aligns on cacheline boundary AFAIK which
> > means that next kmalloc data chunk will not share "our" cacheline.
>
> No, there are no such guarantees. kmalloc() aligns on
> ARCH_KMALLOC_MINALIGN or ARCH_SLAB_MINALIGN depending on which is
> bigger but beyond that, there are no guarantees. You can, of course,
> use kmem_cache_create() with SLAB_HWCACHE_ALIGN to align on cacheline
> boundary.

Note the difference between kmalloc aligment and the alignment of manually
created slabs.

Kmalloc data is often aligned on cacheline boundary due to the allocator
methods of placing data in pages. But there is no guarantee that this will
always be the case. In particular if slab debugging is on then the
alignments become different.

