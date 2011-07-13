Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755937Ab1GMP73 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 11:59:29 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16106 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab1GMP71 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 11:59:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=NmeAbHaMgYNtYXjMoL4jIf4nFWK1Fo6sLTQkWxk7lL3/QkbyOqh0muEwdjk6EL2WB
	qirRNI+06ZN41Gye6X/8A==
Date: Wed, 13 Jul 2011 08:59:05 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Christoph Lameter <cl@linux.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH next/mmotm] slab: fix DEBUG_SLAB build
In-Reply-To: <alpine.DEB.2.00.1107131037480.29034@router.home>
Message-ID: <alpine.LSU.2.00.1107130852590.6020@sister.anvils>
References: <alpine.LSU.2.00.1107111152290.13035@sister.anvils> <alpine.DEB.2.00.1107121045050.2530@router.home> <alpine.LSU.2.00.1107121349590.1951@sister.anvils> <alpine.DEB.2.00.1107131037480.29034@router.home>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Christoph Lameter wrote:
> On Tue, 12 Jul 2011, Hugh Dickins wrote:
> > On Tue, 12 Jul 2011, Christoph Lameter wrote:
> > > On Mon, 11 Jul 2011, Hugh Dickins wrote:
> > >
> > > > -#if ARCH_SLAB_MINALIGN
> > > > -	if ((u32)objp & (ARCH_SLAB_MINALIGN-1)) {
> > > > +	if ((unsigned long)objp & (ARCH_SLAB_MINALIGN-1)) {
> > > >  		printk(KERN_ERR "0x%p: not aligned to ARCH_SLAB_MINALIGN=%d\n",
> > >
> > > Change %d to %ul for consistencies sake and drop the cast of
> > > ARCH_SLAB_MINALIGN?
> >
> > I don't think we can drop the cast of ARCH_SLAB_MINALIGN, or not without
> > a wander through all the architectures: it could well be defined as a bare
> > integer in some of them, even if the default definition as __alignof__
> > comes out as an unsigned long (which itself surprised me).
> 
> A bare integer can be handled by a %lu in a printk without the need for a
> cast.

Really?  Here if I try that on x86_64 with #define ARCH_SLAB_MINALIGN 8, I get
mm/slab.c: In function `cache_alloc_debugcheck_after':
mm/slab.c:3160:10: warning: format `%lu' expects type `long unsigned int', but argument 3 has type `int'

Hugh
