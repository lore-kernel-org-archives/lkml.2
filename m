Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab1JMUug (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 16:50:36 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:47808 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1JMUuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 16:50:35 -0400
Date: Thu, 13 Oct 2011 13:50:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Christoph Lameter <cl@gentwo.org>
Cc: Dimitri Sivanich <sivanich@sgi.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] Reduce vm_stat cacheline contention in
 __vm_enough_memory
Message-Id: <20111013135032.7c2c54cd.akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1110131052300.18473@router.home>
References: <20111012160202.GA18666@sgi.com>
	<20111012120118.e948f40a.akpm@linux-foundation.org>
	<alpine.DEB.2.00.1110121452220.31218@router.home>
	<20111013152355.GB6966@sgi.com>
	<alpine.DEB.2.00.1110131052300.18473@router.home>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Oct 2011 10:54:30 -0500 (CDT)
Christoph Lameter <cl@gentwo.org> wrote:

> On Thu, 13 Oct 2011, Dimitri Sivanich wrote:
> 
> > > increase the allowed delta per zone if frequent updates occur via the
> > > overflow checks in vmstat.c. See calculate_*_threshold there.
> >
> > I tried changing the threshold in both directions, with slower throughput in
> > both cases.
> 
> If that is the case check for the vm_stat cacheline being shared with
> another hot kernel variable variable. Maybe that causes cacheline
> eviction.

yup.  `nm -n vmlinux'.

> If there are no updates occurring for a while (due to increased deltas
> and/or vmstat updates) then the vm_stat cacheline should be able to stay
> in shared mode in multiple processors and the performance should increase.
> 

We could cacheline align vm_stat[].  But the thing is pretty small - we
couild put each entry in its own cacheline.


