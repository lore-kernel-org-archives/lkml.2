Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030857Ab2CGXAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 18:00:09 -0500
Received: from moutng.kundenserver.de ([212.227.17.8]:62879 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030246Ab2CGXAH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 18:00:07 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: David Howells <dhowells@redhat.com>
Subject: Re: [RFC][PATCH 00/29] Disintegrate and kill asm/system.h
Date: Wed, 7 Mar 2012 22:59:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: paul.gortmaker@windriver.com, hpa@zytor.com, torvalds@linux-foundation.org,
        sfr@canb.auug.org.au, mingo@redhat.com, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <201203072146.51494.arnd@arndb.de> <20120307194548.15987.36073.stgit@warthog.procyon.org.uk> <20425.1331160006@redhat.com>
In-Reply-To: <20425.1331160006@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201203072259.06012.arnd@arndb.de>
X-Provags-ID: V02:K0:fUszJ+ZGEO6g6LCiiQSGbgcxGL3UnsEFXV5ct7N/rTS
 2jq2YUiAYMx1tndy98bBve8+V7D9dPU4xttoqhOdwbgUWhPZDw
 ajjH5+feAi1CBTUBtRSx97Imx0EapmsETPxB5k7CL7xae5CvoE
 4Evi2x6Zmv6iNINHMdZZs1bHqobElDfvlGyXDwe82hWCVFcT+P
 zH60cobiFwLOZQn0aCXpnYXYgZKPKKxknFV+rwQby0ZMMHN9e6
 6+LGHyy3Echv/Ymk8XRpsjtOLKIBp8H9bGC3NLd0a6jntvMrEr
 2b9Vo64yWpJXaRkqZt0Kj1rdLuEOX8Auc/iBK+Df2y9/A1hSB6
 u/pSYD51OC3ZrCaT0QrA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 March 2012, David Howells wrote:
> Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > One part you were missing seems to be include/asm-generic/system.h, which is
> > used on openrisc and contains a lot of the things you move to other
> > places. It would be helpful to split that up as well.
> 
> Hmmm...  okay.  How that is used from an arch that doesn't have an
> asm/system.h?

We're migration towards using generic-y in arch/*/include/arm/Kbuild now.
When you create header files that have reasonable defaults that can be
shared across multiple architectures, I think you should do that for the
new header files as well.

> > >     (4) asm/atomic.h
> > >
> > >         Move xchg() and cmpxchg() here as they're full word atomic ops and
> > >         frequently used by atomic_xchg() and atomic_cmpxchg().
> > 
> > Well, the thing with xchg and cmpxchg is that they operate on arbirary-sized
> > integers, not atomic_t, unlike everything else in atomic.h.
> > 
> > Some architectures already have an asm/cmpxchg.h, which seems more appropriate
> > here.
> 
> So I saw.  It might be worth making an asm/xchg.h and asm/cmpxchg.h for each
> arch - or maybe just put both in asm/xchg.h or asm/cmpxchg.h.  Where do I
> include it from though?  One nice thing about sticking them in asm/atomic.h is
> that usually gets all instances, and they're frequently used from there.  How
> about I have asm/atomic.h #include asm/{,cmp}xchg.h?

Yes, that makes sense and is probably required anyway for the obvious implementation
of atomic_cmpxchg().

	Arnd
