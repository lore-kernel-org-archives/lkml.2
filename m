Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755943Ab2F0BIS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 21:08:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59421 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755430Ab2F0BIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 21:08:16 -0400
Date: Tue, 26 Jun 2012 18:08:13 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Glauber Costa <glommer@parallels.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, kamezawa.hiroyu@jp.fujitsu.com,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 00/11] kmem controller for memcg: stripped down version
In-Reply-To: <20120626145539.eeeab909.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1206261804160.11287@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <20120625162745.eabe4f03.akpm@linux-foundation.org> <4FE9621D.2050002@parallels.com> <20120626145539.eeeab909.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 26 Jun 2012, Andrew Morton wrote:

> mm, maybe.  Kernel developers tend to look at code from the point of
> view "does it work as designed", "is it clean", "is it efficient", "do
> I understand it", etc.  We often forget to step back and really
> consider whether or not it should be merged at all.
> 

It's appropriate for true memory isolation so that applications cannot 
cause an excess of slab to be consumed.  This allows other applications to 
have higher reservations without the risk of incurring a global oom 
condition as the result of the usage of other memcgs.

I'm not sure whether it would ever be appropriate to limit the amount of 
slab for an individual slab cache, however, instead of limiting the sum of 
all slab for a set of processes.  With cache merging in slub this would 
seem to be difficult to do correctly.
