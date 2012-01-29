Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751900Ab2A2IZs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 03:25:48 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:55931 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751439Ab2A2IZr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 03:25:47 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1327591185.2446.102.camel@twins>
References: <1327572121-13673-1-git-send-email-gilad@benyossef.com>
	<1327591185.2446.102.camel@twins>
Date: Sun, 29 Jan 2012 10:25:46 +0200
Message-ID: <CAOtvUMeAkPzcZtiPggacMQGa0EywTH5SzcXgWjMtssR6a5KFqA@mail.gmail.com>
Subject: Re: [v7 0/8] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.com>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>,
        Milton Miller <miltonm@bga.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 5:19 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
>
> On Thu, 2012-01-26 at 12:01 +0200, Gilad Ben-Yossef wrote:
> > Gilad Ben-Yossef (8):
> >   smp: introduce a generic on_each_cpu_mask function
> >   arm: move arm over to generic on_each_cpu_mask
> >   tile: move tile to use generic on_each_cpu_mask
> >   smp: add func to IPI cpus based on parameter func
> >   slub: only IPI CPUs that have per cpu obj to flush
> >   fs: only send IPI to invalidate LRU BH when needed
> >   mm: only IPI CPUs to drain local pages if they exist
>
> These patches look very nice!
>
> Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
>

Thank you :-)

If this is of interest, I keep a list tracking global IPI and global
task schedulers sources in the core kernel here:
https://github.com/gby/linux/wiki.

I plan to visit all these potential interference source to see if
something can be done to lower their effect on
isolated CPUs over time.

>
> >   mm: add vmstat counters for tracking PCP drains
> >
> I understood from previous postings this patch wasn't meant for
> inclusion, if it is, note that cpumask_weight() is a potentially very
> expensive operation.

Right. The only purpose of the patch is to show the usefulness
of the previous patch in the series. It is not meant for mainline.

Thanks,
Gilad



--
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML
