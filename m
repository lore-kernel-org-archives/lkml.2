Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab2F0TqN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 15:46:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56275 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab2F0TqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 15:46:11 -0400
Date: Wed, 27 Jun 2012 12:46:08 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: cgroups@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        devel@openvz.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH 06/11] memcg: kmem controller infrastructure
In-Reply-To: <4FEAD351.2030203@parallels.com>
Message-ID: <alpine.DEB.2.00.1206271239340.22162@chino.kir.corp.google.com>
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-7-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1206260210200.16020@chino.kir.corp.google.com> <4FE97E31.3010201@parallels.com>
 <alpine.DEB.2.00.1206262100320.24245@chino.kir.corp.google.com> <4FEAD351.2030203@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2012, Glauber Costa wrote:

> > > Nothing, but I also don't see how to prevent that.
> > 
> > You can test for current->flags & PF_KTHREAD following the check for
> > in_interrupt() and return true, it's what you were trying to do with the
> > check for !current->mm.
> > 
> 
> am I right to believe that if not in interrupt context - already ruled out -
> and !(current->flags & PF_KTHREAD), I am guaranteed to have a mm context, and
> thus, don't need to test against it ?
> 

No, because an mm may have been detached in the exit path by running 
exit_mm().  We'd certainly hope that there are no slab allocations 
following that point, though, but you'd still need to test current->mm.
