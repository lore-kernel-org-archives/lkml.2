Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab0DXDEQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 23:04:16 -0400
Received: from mail2.shareable.org ([80.68.89.115]:56094 "EHLO
	mail2.shareable.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755646Ab0DXDEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 23:04:14 -0400
Date: Sat, 24 Apr 2010 04:04:11 +0100
From: Jamie Lokier <jamie@shareable.org>
To: Nicolas Pitre <nico@fluxnic.net>
Cc: Paulius Zaleckas <paulius.zaleckas@gmail.com>,
       linux-kernel@vger.kernel.org, linux-mtd@lists.infradead.org,
       u.kleine-koenig@pengutronix.de, simon.kagstrom@netinsight.net,
       akpm@linux-foundation.org, dwmw2@infradead.org,
       linux-arm-kernel@lists.infradead.org, rth@twiddle.net
Subject: Re: [PATCH v2] MTD: Fix Orion NAND driver compilation with ARM OABI
Message-ID: <20100424030411.GK15349@shareable.org>
References: <20100325152505.17612.40158.stgit@pauliusz> <20100325204619.GC19308@shareable.org> <alpine.LFD.2.00.1004231443340.7232@xanadu.home> <20100424025858.GJ15349@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100424025858.GJ15349@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jamie Lokier wrote:
> Nicolas Pitre wrote:
> > On Thu, 25 Mar 2010, Jamie Lokier wrote:
> > > Any one of these should fix it:
> > > 
> > >    - Make io_base a pointer-to-volatile-u64 or cast it in the asm, and
> > >      make sure to dereference it and use an "m" constraint (or
> > >      tighter, such as "Q", if ldrd needs it).  It must be u64, not
> > >      pointer-to-void, to tell GCC the size.  That tells GCC which memory
> > >      the asm accesses, and the volatile dereference should tell GCC
> > >      not to reorder them in principle (but the GCC manual doesn't
> > >      make a specific promise about this for asms).
> > 
> > The LDRD has special range constraints on its addressing mode which is 
> > not expressable with any of the available gcc memory constraints.
> 
>     'Q'
>           A memory reference where the exact address is in a single
>           register (''m'' is preferable for 'asm' statements)
> 
> If 'r' is good enough for io_base, 'Q' should be good enough for *io_base.

And if that doesn't work, it's possible to pass both the pointer, and
the dereference, as separate input operands, and only use the pointer
in the asm template.  GCC will still treat the dereference input as a
dependency.

-- Jamie
