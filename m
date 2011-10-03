Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab1JCUN1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:13:27 -0400
Received: from gw1.transmode.se ([195.58.98.146]:39159 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755231Ab1JCUNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:13:21 -0400
In-Reply-To: <20111003160036.GX11984@tux1.beaverton.ibm.com>
References: <OF1BEE9025.31A1BE17-ONC125791B.00203167-C125791B.00211B4A@transmode.se> <20110930161223.GW11984@tux1.beaverton.ibm.com> <OF34B3D797.8C95417C-ONC125791C.00497BA8-C125791C.004C2C5A@transmode.se> <20111003160036.GX11984@tux1.beaverton.ibm.com>
Subject: Re: [PATCH v3] crc32c: Implement CRC32c with slicing-by-8 algorithm
X-KeepSent: DEA4FB6B:CBB97DA3-C125791E:006E5FDA;
 type=4; name=$KeepSent
To: djwong@us.ibm.com
Cc: linux-crypto <linux-crypto@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
X-Mailer: Lotus Notes Release 8.5.2FP3 Aug 10, 2010
Message-ID: <OFDEA4FB6B.CBB97DA3-ONC125791E.006E5FDA-C125791E.006F14E4@transmode.se>
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Date: Mon, 3 Oct 2011 22:13:18 +0200
X-MIMETrack: Serialize by Router on mail1/Transmode(Release 8.5.2FP3|July 10, 2011) at
 10/03/2011 22:13:18
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/10/03 18:00:36:
>
> On Sat, Oct 01, 2011 at 03:52:00PM +0200, Joakim Tjernlund wrote:
> > "Darrick J. Wong" <djwong@us.ibm.com> wrote on 2011/09/30 18:12:23:
> > >
> > > [putting mailing lists on cc]

[SNIP]

> > >
> > > <shrug> I suppose I could make CRC32C_BITS configurable.  What is the hardware
> > > profile of your ppc32 processor?  How much L1D/L2 cache?  slice-by-8 does have
> > > a big cache footprint.  On the other hand it's faster than the slice-by-4
> > > (crc32) and Sarwate (crc32c) code in the kernel, even on old slow 32-bit x86
> > > processors (PII, PIII, P4).
> >
> > It is a low end embedded 333 MHz CPU with only L1 cache. How much faster
> > is slice by 8 than slice by 4 on these old x86 machines?
>
> How much L1 cache?  Or, if you'd rather not give away specifics, has the CPU
> more than 8KB L1 cache?  I'm willing to concede that with little cache the
> added memory pressure could be painful.
>
> As for the old x86 machines, please have a look at:
> http://djwong.org/docs/ext4_metadata_checksums.html#Benchmarking
>
> ~15% faster on a 2GHz Via C7
> ~20% faster on a 2.7GHz P4
> ~25% faster on a 500MHz P3
>
> I vaguely recall it was ~20% faster on a 400MHz P2, but all the kernel.org
> wikis are still down. :(
>
> So I suspect the key factor here is memory hierachy, since all of those systems
> have at least 16K of L1 cache.  Slice by 8 might actually suck on a Pentium
> Proor earlier.  Unfortunately I don't have anything older than a PII...

It is 16KB cache on this CPU. I don't know why it was so much slower. Could be a
gcc thing as gcc does a fairly lame job at optimizing crc32. Still think making this
configurable is a good thing. At least until the verdict is in from other CPUs.

  Jocke

