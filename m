Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab0HRQOM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:14:12 -0400
Received: from mga02.intel.com ([134.134.136.20]:27933 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750862Ab0HRQOK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:14:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,228,1280732400"; 
   d="scan'208";a="648957022"
Date: Thu, 19 Aug 2010 00:13:46 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Webb <chris@arachsys.com>
Cc: Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Over-eager swapping
Message-ID: <20100818161346.GA12932@localhost>
References: <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com>
 <20100804032400.GA14141@localhost>
 <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost>
 <20100804120430.GB23551@arachsys.com>
 <20100818143801.GA9086@localhost>
 <20100818144655.GX2370@arachsys.com>
 <20100818152103.GA11268@localhost>
 <1282147034.77481.33.camel@useless.localdomain>
 <20100818155825.GA2370@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100818155825.GA2370@arachsys.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 18, 2010 at 11:58:25PM +0800, Chris Webb wrote:
> Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:
> 
> > On Wed, 2010-08-18 at 23:21 +0800, Wu Fengguang wrote:
> > > Andi, Christoph and Lee:
> > > 
> > > This looks like an "unbalanced NUMA memory usage leading to premature
> > > swapping" problem.
> > 
> > What is the value of the vm.zone_reclaim_mode sysctl?  If it is !0, the
> > system will go into zone reclaim before allocating off-node pages.
> > However, it shouldn't "swap" in this case unless (zone_reclaim_mode & 4)
> > != 0.  And even then, zone reclaim should only reclaim file pages, not
> > anon.  In theory...
> 
> Hi. This is zero on all our machines:
> 
> # sysctl vm.zone_reclaim_mode
> vm.zone_reclaim_mode = 0

Chris, can you post /proc/vmstat on the problem machines?

Thanks,
Fengguang
