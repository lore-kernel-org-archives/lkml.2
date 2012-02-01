Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2BAREy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:04:54 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:50112 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab2BAREw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:04:52 -0500
Date: Wed, 1 Feb 2012 18:04:47 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        linux-mm@kvack.org, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>, Sasha Levin <levinsasha928@gmail.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
Message-ID: <20120201170443.GE6731@somewhere.redhat.com>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
 <1327591185.2446.102.camel@twins>
 <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 29, 2012 at 10:25:46AM +0200, Gilad Ben-Yossef wrote:
> On Thu, Jan 26, 2012 at 5:19 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> >
> > On Thu, 2012-01-26 at 12:01 +0200, Gilad Ben-Yossef wrote:
> > > Gilad Ben-Yossef (8):
> > >   smp: introduce a generic on_each_cpu_mask function
> > >   arm: move arm over to generic on_each_cpu_mask
> > >   tile: move tile to use generic on_each_cpu_mask
> > >   smp: add func to IPI cpus based on parameter func
> > >   slub: only IPI CPUs that have per cpu obj to flush
> > >   fs: only send IPI to invalidate LRU BH when needed
> > >   mm: only IPI CPUs to drain local pages if they exist
> >
> > These patches look very nice!
> >
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >
> 
> Thank you :-)
> 
> If this is of interest, I keep a list tracking global IPI and global
> task schedulers sources in the core kernel here:
> https://github.com/gby/linux/wiki.
> 
> I plan to visit all these potential interference source to see if
> something can be done to lower their effect on
> isolated CPUs over time.

Very nice especially as many people seem to be interested in
CPU isolation.

When we get the adaptive tickless feature in place, perhaps we'll
also need to think about some way to have more control on the
CPU affinity of some non pinned timers to avoid disturbing
adaptive tickless CPUs. We still need to consider their cache affinity
though.
