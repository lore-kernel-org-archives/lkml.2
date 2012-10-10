Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab2JJNCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:02:08 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51826 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755907Ab2JJNCE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:02:04 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+9xfsKZrC92QLTR66IlrEXhIs/4D5jt9stPP8ufq
	bmDR6jwiYY041i
Message-ID: <1349874121.6992.80.camel@marge.simpson.net>
Subject: Re: Netperf UDP_STREAM regression due to not sending IPIs in
 ttwu_queue()
From: Mike Galbraith <efault@gmx.de>
To: Mel Gorman <mgorman@suse.de>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Wed, 10 Oct 2012 15:02:01 +0200
In-Reply-To: <20121010122921.GX29125@suse.de>
References: <20121002065143.GK29125@suse.de>
	 <1349164176.7086.43.camel@marge.simpson.net>
	 <20121002084501.GL29125@suse.de>
	 <1349170282.7086.56.camel@marge.simpson.net>
	 <20121002131421.GN29125@suse.de>
	 <1349247011.4465.24.camel@marge.simpson.net>
	 <1349251997.4465.42.camel@marge.simpson.net>
	 <1349271001.4465.66.camel@marge.simpson.net>
	 <20121010122921.GX29125@suse.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-10 at 13:29 +0100, Mel Gorman wrote: 
> On Wed, Oct 03, 2012 at 03:30:01PM +0200, Mike Galbraith wrote:

> > nohz=off, pipe-test with one half pinned to CPU0, the other to CPU1.
> > 
> > procs -----------memory---------- ---swap-- -----io---- -system-- -----cpu------
> >  r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa st
> > TTW_QUEUE
> >  1  0      0 3039488  50948 444720    0    0     0     0 539724 1013417  1 15 84  0  0
> >  1  0      0 3039488  50956 444720    0    0     0     1 540853 1015679  1 15 84  0  0
> >  1  0      0 3039364  50956 444720    0    0     0     0 541630 1017239  1 16 83  0  0
> >  2  0      0 3038992  50956 444720    0    0     0     0 335550 1096569  4 20 76  0  0
> > NO_TTWU_QUEUE
> >  1  0      0 3038992  50956 444720    0    0     0     0 33100 1318984  1 27 71  0  0
> >  1  0      0 3038868  50956 444720    0    0     0     0 33100 1319126  2 27 71  0  0
> >  1  0      0 3038868  50956 444720    0    0     0     0 33097 1317968  1 27 72  0  0
> >  2  0      0 3038868  50964 444720    0    0     0     1 33104 1318558  2 27 71  0  0
> > 
> > We can switch faster with NO_TTWU_QUEUE, so we switch more, and that
> > hurts netperf UDP_STREAM throughput.. somehow.  Fatter is better is not
> > the way context switch happy benchmarks usually work.
> > 
> 
> Do we really switch more though?

Yup, pipe-test measures the full round trip, and agrees with vmstat.
netperf TCP_RR agrees, tbench agrees... this STREAM thingy is the only
high frequency switcher I've seen go all weird like this.

(hm, wonder how fast box can blast IPIs.. 1MHz?)

-Mike

