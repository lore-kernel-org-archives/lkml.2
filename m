Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933373Ab2EWKCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 06:02:09 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:51329 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933329Ab2EWKCH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 06:02:07 -0400
Date: Wed, 23 May 2012 14:44:11 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Subject: Re: [PATCH] Trivial sched: Pass domain_attr to build_sched_domains()
Message-ID: <20120523091411.GG5005@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <20120523064109.GB5005@linux.vnet.ibm.com>
 <1337759338.9698.45.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1337759338.9698.45.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12052309-3864-0000-0000-000003013309
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra <peterz@infradead.org> [2012-05-23 09:48:58]:

> On Wed, 2012-05-23 at 12:11 +0530, Kamalesh Babulal wrote:
> > sched: Pass domain_attr to build_sched_domains()
> > 
> > build_sched_domains() is called from init_sched_domains()
> > by explicitly passing NULL as second argument, which is
> > of type sched_domain_attr. This patch calls build_sched_domains()
> > with dattr_cur instead of NULL, as dattr_cur is also NULL.
> 
> So what's the point? Rather clean up the dattr crap, no?

Thanks for the review.

As suggested, this version of patch drops dattr_cur from
init_sched_domains().

sched: Remove NULL assignment to dattr_cur

Remove explicit NULL assignment of static pointer
dattr_cur from init_sched_domains().

Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
---
 kernel/sched/core.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 22a19ae..964bf9d 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6734,7 +6734,6 @@ static int init_sched_domains(const struct cpumask *cpu_map)
 	if (!doms_cur)
 		doms_cur = &fallback_doms;
 	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
-	dattr_cur = NULL;
 	err = build_sched_domains(doms_cur[0], NULL);
 	register_sched_domain_sysctl();

