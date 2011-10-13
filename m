Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754695Ab1JMVYi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 17:24:38 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:56874 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752731Ab1JMVYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 17:24:36 -0400
Date: Thu, 13 Oct 2011 14:24:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
Message-Id: <20111013142434.4d05cbdc.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1110131602020.26553@router.home>
References: <20111012160202.GA18666@sgi.com>
	<20111012120118.e948f40a.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1110121452220.31218@router.home>
	<20111013152355.GB6966@sgi.com>
	<alpine.DEB.2.00.1110131052300.18473@router.home>
	<20111013135032.7c2c54cd.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1110131602020.26553@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011 16:02:58 -0500 (CDT)
Christoph Lameter <cl@gentwo.org> wrote:

> On Thu, 13 Oct 2011, Andrew Morton wrote:
> 
> > > If there are no updates occurring for a while (due to increased deltas
> > > and/or vmstat updates) then the vm_stat cacheline should be able to stay
> > > in shared mode in multiple processors and the performance should increase.
> > >
> >
> > We could cacheline align vm_stat[].  But the thing is pretty small - we
> > couild put each entry in its own cacheline.
> 
> Which in turn would increase the cache footprint of some key kernel
> functions (because they need multiple vm_stat entries) and cause eviction
> of other cachelines that then reduce overall system performance again.

Sure, but we gain performance by not having different CPUs treading on
each other when they update different vmstat fields.  Sometimes one
effect will win and other times the other effect will win.  Some
engineering is needed..

