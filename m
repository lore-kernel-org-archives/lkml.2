Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932992Ab2EWHtG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 03:49:06 -0400
Received: from casper.infradead.org ([85.118.1.10]:44903 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2EWHtE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 03:49:04 -0400
Message-ID: <1337759338.9698.45.camel@twins>
Subject: Re: [PATCH] Trivial sched: Pass domain_attr to build_sched_domains()
From: Peter Zijlstra <peterz@infradead.org>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com
Date: Wed, 23 May 2012 09:48:58 +0200
In-Reply-To: <20120523064109.GB5005@linux.vnet.ibm.com>
References: <20120523064109.GB5005@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 12:11 +0530, Kamalesh Babulal wrote:
> sched: Pass domain_attr to build_sched_domains()
> 
> build_sched_domains() is called from init_sched_domains()
> by explicitly passing NULL as second argument, which is
> of type sched_domain_attr. This patch calls build_sched_domains()
> with dattr_cur instead of NULL, as dattr_cur is also NULL.

So what's the point? Rather clean up the dattr crap, no?

> Signed-off-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
> ---
> diff --git a/kernel/sched/core.c b/kernel/sched/core.c
> index 22a19ae..32ccf13 100644
> --- a/kernel/sched/core.c
> +++ b/kernel/sched/core.c
> @@ -6735,7 +6735,7 @@ static int init_sched_domains(const struct cpumask *cpu_map)
>  		doms_cur = &fallback_doms;
>  	cpumask_andnot(doms_cur[0], cpu_map, cpu_isolated_map);
>  	dattr_cur = NULL;
> -	err = build_sched_domains(doms_cur[0], NULL);
> +	err = build_sched_domains(doms_cur[0], dattr_cur);
>  	register_sched_domain_sysctl();
> 
>  	return err;
> 

