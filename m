Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab0IQIsp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 04:48:45 -0400
Received: from smtp.nokia.com ([192.100.122.230]:59932 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751619Ab0IQIsn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 04:48:43 -0400
Date: Fri, 17 Sep 2010 11:44:11 +0300
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: ext Tony Luck <tony.luck@intel.com>
Cc: "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "linux-ia64@vger.kernel.org" <linux-ia64@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] ia64: possible module unwind table optimisation
Message-ID: <20100917084411.GC20325@esdhcp04044.research.nokia.com>
References: <1284115245-23876-1-git-send-email-ext-phil.2.carmody@nokia.com> <AANLkTi=RsA0tACWOg+8RTSuDHwa4LGOiyO-4TxpJ_rb5@mail.gmail.com> <20100915124831.GB27658@esdhcp04044.research.nokia.com> <AANLkTi=hPcXC1=Lrey1H_UHRJRJ-NdTsvmyxgP_n+dM8@mail.gmail.com> <20100915222216.GF27658@esdhcp04044.research.nokia.com> <AANLkTikgi38O3=MsVNc-X64PnLOFNktC_x9Y3vQ7CbD+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikgi38O3=MsVNc-X64PnLOFNktC_x9Y3vQ7CbD+@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 17 Sep 2010 08:45:23.0757 (UTC) FILETIME=[AB0AD5D0:01CB5644]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16/09/10 23:56 +0200, ext Tony Luck wrote:
> On Wed, Sep 15, 2010 at 3:22 PM, Phil Carmody
> <ext-phil.2.carmody@nokia.com> wrote:
> > Turn on kmemleak, or anything else which repeatedly runs up the stack just
> > for the fun of gathering backtraces. Kmemleak's what caused us to notice
> > the issue in our ARM-based environment.
> 
> kmemleak needs CONFIG_STACKTRACE - which I haven't got around to putting
> into ia64 yet.  I dug up an earlier attempt at doing so, and turned on kmemleak,
> but it crashes early in boot (before ever getting to my stack tracer)
> in possibly
> the first call to kmem_cache_alloc().  With SLUB the error is an unaligned
> reference to 0xffffffffffffffff, with SLAB I get a NULL deref.
> 
> :-(

This is a shame, but not a real problem in the context of my patch - you can't 
usefully optimise something that's seemingly almost never used. It can be filed
in the cylindrical filing cabinet.

Phil
