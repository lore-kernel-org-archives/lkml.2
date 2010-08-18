Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0HRQAz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 12:00:55 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:55464 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753376Ab0HRQAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 12:00:52 -0400
Date: Wed, 18 Aug 2010 16:58:25 +0100
From: Chris Webb <chris@arachsys.com>
To: Lee Schermerhorn <Lee.Schermerhorn@hp.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>, Minchan Kim <minchan.kim@gmail.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Lameter <cl@linux-foundation.org>
Subject: Re: Over-eager swapping
Message-ID: <20100818155825.GA2370@arachsys.com>
References: <20100804022148.GA5922@localhost>
 <AANLkTi=wRPXY9BTuoCe_sDCwhnRjmmwtAf_bjDKG3kXQ@mail.gmail.com>
 <20100804032400.GA14141@localhost>
 <20100804095811.GC2326@arachsys.com>
 <20100804114933.GA13527@localhost>
 <20100804120430.GB23551@arachsys.com>
 <20100818143801.GA9086@localhost>
 <20100818144655.GX2370@arachsys.com>
 <20100818152103.GA11268@localhost>
 <1282147034.77481.33.camel@useless.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282147034.77481.33.camel@useless.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lee Schermerhorn <Lee.Schermerhorn@hp.com> writes:

> On Wed, 2010-08-18 at 23:21 +0800, Wu Fengguang wrote:
> > Andi, Christoph and Lee:
> > 
> > This looks like an "unbalanced NUMA memory usage leading to premature
> > swapping" problem.
> 
> What is the value of the vm.zone_reclaim_mode sysctl?  If it is !0, the
> system will go into zone reclaim before allocating off-node pages.
> However, it shouldn't "swap" in this case unless (zone_reclaim_mode & 4)
> != 0.  And even then, zone reclaim should only reclaim file pages, not
> anon.  In theory...

Hi. This is zero on all our machines:

# sysctl vm.zone_reclaim_mode
vm.zone_reclaim_mode = 0

Cheers,

Chris.
