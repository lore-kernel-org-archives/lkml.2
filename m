Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965312Ab2CGWkt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:40:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:27132 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965295Ab2CGWkk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:40:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <201203072146.51494.arnd@arndb.de>
References: <201203072146.51494.arnd@arndb.de> <20120307194548.15987.36073.stgit@warthog.procyon.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: dhowells@redhat.com, paul.gortmaker@windriver.com, hpa@zytor.com,
        torvalds@linux-foundation.org, sfr@canb.auug.org.au, mingo@redhat.com,
        tglx@linutronix.de, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: [RFC][PATCH 00/29] Disintegrate and kill asm/system.h
Date: Wed, 07 Mar 2012 22:40:06 +0000
Message-ID: <20425.1331160006@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnd Bergmann <arnd@arndb.de> wrote:

> One part you were missing seems to be include/asm-generic/system.h, which is
> used on openrisc and contains a lot of the things you move to other
> places. It would be helpful to split that up as well.

Hmmm...  okay.  How that is used from an arch that doesn't have an
asm/system.h?

> >     (4) asm/atomic.h
> >
> >         Move xchg() and cmpxchg() here as they're full word atomic ops and
> >         frequently used by atomic_xchg() and atomic_cmpxchg().
> 
> Well, the thing with xchg and cmpxchg is that they operate on arbirary-sized
> integers, not atomic_t, unlike everything else in atomic.h.
> 
> Some architectures already have an asm/cmpxchg.h, which seems more appropriate
> here.

So I saw.  It might be worth making an asm/xchg.h and asm/cmpxchg.h for each
arch - or maybe just put both in asm/xchg.h or asm/cmpxchg.h.  Where do I
include it from though?  One nice thing about sticking them in asm/atomic.h is
that usually gets all instances, and they're frequently used from there.  How
about I have asm/atomic.h #include asm/{,cmp}xchg.h?

> >     (6) asm/auxvec.h
> >
> >         Move AT_VECTOR_SIZE_ARCH here.
> 
> These two look suboptimal, but I don't have a better idea either.

Well, AT_VECTOR_SIZE_ARCH is at least auxvec-related, so I think that's
probably in the right place.

> How about adding a '-include asm/system.h' gcc switch for each architecture
> in one patch in the beginning, so that the header becomes included all the
> time, but then remove that for each arch you go through?

That might circularly dependerise, but it's worth a try.

David
