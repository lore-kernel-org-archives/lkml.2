Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932850Ab2AKEiK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jan 2012 23:38:10 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41500 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab2AKEiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jan 2012 23:38:08 -0500
Date: Tue, 10 Jan 2012 20:42:45 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Nikolay S." <nowhere@hakkenden.ath.cx>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan@kernel.org>, Dave Chinner <david@fromorbit.com>,
        Michal Hocko <mhocko@suse.cz>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: Kswapd in 3.2.0-rc5 is a CPU hog
Message-Id: <20120110204245.d24ed540.akpm@linux-foundation.org>
In-Reply-To: <1326252320.5973.13.camel@hakkenden.homenet>
References: <1324437036.4677.5.camel@hakkenden.homenet>
	<20111221095249.GA28474@tiehlicka.suse.cz>
	<20111221225512.GG23662@dastard>
	<1324630880.562.6.camel@rybalov.eng.ttk.net>
	<20111223102027.GB12731@dastard>
	<1324638242.562.15.camel@rybalov.eng.ttk.net>
	<20111223204503.GC12731@dastard>
	<20111227111543.5e486eb7.kamezawa.hiroyu@jp.fujitsu.com>
	<20111227035730.GA22840@barrios-laptop.redhat.com>
	<20111227135658.08c8016a.kamezawa.hiroyu@jp.fujitsu.com>
	<20120110143330.44cf1ccf.akpm@linux-foundation.org>
	<1326252320.5973.13.camel@hakkenden.homenet>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Jan 2012 07:25:20 +0400 "Nikolay S." <nowhere@hakkenden.ath.cx> wrote:

> __ ____., 10/01/2012 __ 14:33 -0800, Andrew Morton __________:
> > On Tue, 27 Dec 2011 13:56:58 +0900
> > KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > 
> > > Hmm, if I understand correctly,
> > > 
> > >  - dd's speed down is caused by kswapd's cpu consumption.
> > >  - kswapd's cpu consumption is enlarged by shrink_slab() (by perf)
> > >  - kswapd can't stop because NORMAL zone is small.
> > >  - memory reclaim speed is enough because dd can't get enough cpu.
> > > 
> > > I wonder reducing to call shrink_slab() may be a help but I'm not sure
> > > where lock conention comes from...
> > 
> > Nikolay, it sounds as if this problem has only recently started
> > happening?  Was 3.1 OK?
> > 
> > If so, we should work out what we did post-3.1 to cause this.
> 
> Yes, 3.1. was ok.
> Recently I have upgraded to 3.2, and I can not reproduce the problem.
> I'm now at 5 days uptime, the machine usage pattern, the software - all
> the same, but the problem is not visible anymore:
> 
>   PID USER      S %CPU %MEM    TIME+  SWAP COMMAND
> 14822 nowhere   R   30  0.2   0:01.52  10m dd
>   416 root      S    7  0.0   6:26.72    0 kswapd0
> 
> (also, kswapd run time after 5 days is only 6,5 seconds, whereas with
> -rc5 it was 22 seconds after 5 days).
> 
> I can provide similar traces to see what has changed in kswapd's
> activities (if it is of any value)

OK, thanks for the followup.  I suppose we assume this is fixed unless
someone reports it in 3.2.

