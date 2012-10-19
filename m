Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758125Ab2JSJKs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 05:10:48 -0400
Received: from mx2.parallels.com ([64.131.90.16]:42946 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753881Ab2JSJKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 05:10:44 -0400
Message-ID: <50811903.9000105@parallels.com>
Date: Fri, 19 Oct 2012 13:10:27 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121009 Thunderbird/16.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-mm@kvack.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        <devel@openvz.org>, <linux-kernel@vger.kernel.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v5 06/14] memcg: kmem controller infrastructure
References: <1350382611-20579-1-git-send-email-glommer@parallels.com> <1350382611-20579-7-git-send-email-glommer@parallels.com> <20121017151214.e3d2aa3b.akpm@linux-foundation.org> <507FC8E3.8020006@parallels.com> <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1210181502270.30894@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 02:06 AM, David Rientjes wrote:
> On Thu, 18 Oct 2012, Glauber Costa wrote:
> 
>>> Do we actually need to test PF_KTHREAD when current->mm == NULL? 
>>> Perhaps because of aio threads whcih temporarily adopt a userspace mm?
>>
>> I believe so. I remember I discussed this in the past with David
>> Rientjes and he advised me to test for both.
>>
> 
> PF_KTHREAD can do use_mm() to assume an ->mm but hopefully they aren't 
> allocating slab while doing so.  Have you considered actually charging 
> current->mm->owner for that memory, though, since the kthread will have 
> freed the memory before unuse_mm() or otherwise have charged it on behalf 
> of a user process, i.e. only exempting PF_KTHREAD?
> 
I always charge current->mm->owner.

