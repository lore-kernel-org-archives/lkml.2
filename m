Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932295Ab2E3DVS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 23:21:18 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56943 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932279Ab2E3DVQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 23:21:16 -0400
Date: Tue, 29 May 2012 20:21:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Luck, Tony" <tony.luck@intel.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH] sched: Don't try allocating memory from offline nodes
In-Reply-To: <4fc507a211523c4a14@agluck-desktop.sc.intel.com>
Message-ID: <alpine.DEB.2.00.1205292019560.14373@chino.kir.corp.google.com>
References: <4fc507a211523c4a14@agluck-desktop.sc.intel.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 May 2012, Luck, Tony wrote:

> Index: linux-2.6/kernel/sched/core.c
> ===================================================================
> --- linux-2.6.orig/kernel/sched/core.c
> +++ linux-2.6/kernel/sched/core.c
> @@ -6449,7 +6449,7 @@ static void sched_init_numa(void)
>  			return;
>  
>  		for (j = 0; j < nr_node_ids; j++) {
> -			struct cpumask *mask = kzalloc_node(cpumask_size(), GFP_KERNEL, j);
> +			struct cpumask *mask = kzalloc(cpumask_size(), GFP_KERNEL);
>  			if (!mask)
>  				return;
>  

It's definitely better if we can allocate on the node, though, so perhaps 
do the same thing that I did in 
http://marc.info/?l=linux-kernel&m=133778739503111 by doing
kzalloc_node(..., node_online(j) ? j : NUMA_NO_NODE)?
