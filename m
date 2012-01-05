Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932482Ab2AEOUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:20:30 -0500
Received: from gir.skynet.ie ([193.1.99.77]:40532 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753099Ab2AEOU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:20:29 -0500
Date: Thu, 5 Jan 2012 14:20:17 +0000
From: Mel Gorman <mel@csn.ul.ie>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH v5 7/8] mm: Only IPI CPUs to drain local pages if they
 exist
Message-ID: <20120105142017.GA27881@csn.ul.ie>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
 <1325499859-2262-8-git-send-email-gilad@benyossef.com>
 <4F033EC9.4050909@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4F033EC9.4050909@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 03, 2012 at 12:45:45PM -0500, KOSAKI Motohiro wrote:
> >   void drain_all_pages(void)
> >   {
> > -	on_each_cpu(drain_local_pages, NULL, 1);
> > +	int cpu;
> > +	struct per_cpu_pageset *pcp;
> > +	struct zone *zone;
> > +
> 
> get_online_cpu() ?
> 

Just a separate note;

I'm looking at some mysterious CPU hotplug problems that only happen
under heavy load. My strongest suspicion at the moment that the problem
is related to on_each_cpu() being used without get_online_cpu() but you
cannot simply call get_online_cpu() in this path without causing
deadlock.

If/when I get a patch that can complete a CPU hotplug stress test
successfully, I'll post it. It'll collide with this series but it should
be manageable.

-- 
Mel Gorman
SUSE Labs
