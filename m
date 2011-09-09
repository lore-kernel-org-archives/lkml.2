Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757003Ab1IIA3U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 20:29:20 -0400
Received: from relay2.sgi.com ([192.48.179.30]:52155 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756771Ab1IIA3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 20:29:18 -0400
Date: Thu, 8 Sep 2011 19:29:16 -0500
From: Jack Steiner <steiner@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] UV2 - Bug fix for GRU global addresses
Message-ID: <20110909002916.GC11894@sgi.com>
References: <20110908182413.GA10782@sgi.com> <20110908165139.caa9ddef.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110908165139.caa9ddef.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 04:51:39PM -0700, Andrew Morton wrote:
> (cc x86 maintainers)
> 
> On Thu, 8 Sep 2011 13:24:13 -0500
> Jack Steiner <steiner@sgi.com> wrote:
> 
> > This patch is a workaround for a UV2 hub bug that affects the format
> > of system global addresses.
> > 
> > The GRU API for UV2 was inadvertently broken by a hardware change. The
> > format of the physical address used for TLB dropins and for addresses used
> > with instructions running in unmapped mode has changed. This change was not
> > documented and became apparent only when diags failed running on system simulators.
> > 
> > For UV1, TLB and GRU instruction physical addresses are identical to socket
> > physical addresses (although high NASID bits must be OR'ed into the
> > address).
> > 
> > For UV2, socket physical addresses need to be converted. The NODE portion of
> > the physical address needs to be shifted so that the low bit is in bit 39 or
> > bit 40, depending on an MMR value.
> > 
> > It is not yet clear if this bug will be fixed in a silicon respin. If it
> > is fixed, the hub revision will be incremented & the workaround disabled.
> 
> It's unclear to me whether this patch should be merged into 3.1 and/or
> into 3.0.x and earlier?

3.1 is fine. I can push directly to the distros.

--- jack
