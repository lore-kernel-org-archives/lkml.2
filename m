Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932495Ab1IIBzz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 21:55:55 -0400
Received: from relay1.sgi.com ([192.48.179.29]:60988 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932440Ab1IIBzx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 21:55:53 -0400
Date: Thu, 8 Sep 2011 20:55:50 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] UV2 - Bug fix for GRU global addresses
Message-ID: <20110909015550.GA15396@sgi.com>
References: <20110908182413.GA10782@sgi.com> <20110908165139.caa9ddef.akpm@linux-foundation.org> <20110909002916.GC11894@sgi.com> <20110908175044.3d3ee451.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908175044.3d3ee451.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 05:50:44PM -0700, Andrew Morton wrote:
> On Thu, 8 Sep 2011 19:29:16 -0500 Jack Steiner <steiner@sgi.com> wrote:
> 
> > On Thu, Sep 08, 2011 at 04:51:39PM -0700, Andrew Morton wrote:
> > > (cc x86 maintainers)
> > > 
> > > On Thu, 8 Sep 2011 13:24:13 -0500
> > > Jack Steiner <steiner@sgi.com> wrote:
> > > 
> > > > This patch is a workaround for a UV2 hub bug that affects the format
> > > > of system global addresses.
> > > > 
> > > > The GRU API for UV2 was inadvertently broken by a hardware change. The
> > > > format of the physical address used for TLB dropins and for addresses used
> > > > with instructions running in unmapped mode has changed. This change was not
> > > > documented and became apparent only when diags failed running on system simulators.
> > > > 
> > > > For UV1, TLB and GRU instruction physical addresses are identical to socket
> > > > physical addresses (although high NASID bits must be OR'ed into the
> > > > address).
> > > > 
> > > > For UV2, socket physical addresses need to be converted. The NODE portion of
> > > > the physical address needs to be shifted so that the low bit is in bit 39 or
> > > > bit 40, depending on an MMR value.
> > > > 
> > > > It is not yet clear if this bug will be fixed in a silicon respin. If it
> > > > is fixed, the hub revision will be incremented & the workaround disabled.
> > > 
> > > It's unclear to me whether this patch should be merged into 3.1 and/or
> > > into 3.0.x and earlier?
> > 
> > 3.1 is fine. I can push directly to the distros.
> 
> Don't do that.  It's better for a pile of reasons for this to come via
> kernel.org.
> 
> Again, what is the case for backporting?

The fix will be needed in distros based on 2.6.32+ & on 3.0+.

The 3.0 backport is fairly straightforward - have not tried it but I think
the patch should apply almost unchanged.

Not sure if you want to backport to 2.6.32+.
The 2.6.32+ backport for the distro is much more complicated due to KABI
issues. There is already code pushed to the distros that provides the hooks
for this change w/o breaking the KABI. However, these hooks were done with
the distro & were never pushed upstream (nor should they be).
The hack uses ugly macros and unused bytes in structures caused by sequences
of fields like

	long x;
	int  y;
	long z;

(The hack uses the bytes between y & z).


Does the community backport to 2.6.32+ need to preserve KABI compatibility
(not sure)? If so, I'd avoid the backport; if not, it would be helpful.


--- jack
