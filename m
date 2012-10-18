Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2JRWHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 18:07:07 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64484 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752085Ab2JRWHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 18:07:04 -0400
Date: Thu, 18 Oct 2012 15:06:54 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Glauber Costa <glommer@parallels.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, kamezawa.hiroyu@jp.fujitsu.com,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        devel@openvz.org, linux-kernel@vger.kernel.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
In-Reply-To: <507FC8E3.8020006@parallels.com>
Message-ID: <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <20121017151214.e3d2aa3b.akpm@linux-foundation.org> <507FC8E3.8020006@parallels.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Oct 2012, Glauber Costa wrote:

> > Do we actually need to test PF_KTHREAD when current->mm == NULL? 
> > Perhaps because of aio threads whcih temporarily adopt a userspace mm?
> 
> I believe so. I remember I discussed this in the past with David
> Rientjes and he advised me to test for both.
> 

PF_KTHREAD can do use_mm() to assume an ->mm but hopefully they aren't 
allocating slab while doing so.  Have you considered actually charging 
current->mm->owner for that memory, though, since the kthread will have 
freed the memory before unuse_mm() or otherwise have charged it on behalf 
of a user process, i.e. only exempting PF_KTHREAD?
