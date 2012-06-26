Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab2FZImn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:42:43 -0400
Received: from mx2.parallels.com ([64.131.90.16]:41141 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab2FZImj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:42:39 -0400
Message-ID: <4FE9755B.1040905@parallels.com>
Date: Tue, 26 Jun 2012 12:39:55 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Suleiman Souhlal <suleiman@google.com>
CC: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Johannes Weiner <hannes@cmpxchg.org>, Christoph Lameter <cl@linux.com>,
        <devel@openvz.org>, <kamezawa.hiroyu@jp.fujitsu.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 02/11] memcg: Reclaim when more than one page needed.
References: <1340633728-12785-1-git-send-email-glommer@parallels.com> <1340633728-12785-3-git-send-email-glommer@parallels.com> <CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
In-Reply-To: <CABCjUKD0h089StLF8BwVRU-St70Ai9PTw-cjis40_aLLG3MAQQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2012 03:33 AM, Suleiman Souhlal wrote:
> On Mon, Jun 25, 2012 at 7:15 AM, Glauber Costa <glommer@parallels.com> wrote:
>> From: Suleiman Souhlal <ssouhlal@FreeBSD.org>
>>
>> mem_cgroup_do_charge() was written before slab accounting, and expects
>> three cases: being called for 1 page, being called for a stock of 32 pages,
>> or being called for a hugepage.  If we call for 2 or 3 pages (and several
>> slabs used in process creation are such, at least with the debug options I
>> had), it assumed it's being called for stock and just retried without reclaiming.
>>
>> Fix that by passing down a minsize argument in addition to the csize.
>>
>> And what to do about that (csize == PAGE_SIZE && ret) retry?  If it's
>> needed at all (and presumably is since it's there, perhaps to handle
>> races), then it should be extended to more than PAGE_SIZE, yet how far?
>> And should there be a retry count limit, of what?  For now retry up to
>> COSTLY_ORDER (as page_alloc.c does), stay safe with a cond_resched(),
>> and make sure not to do it if __GFP_NORETRY.
>
> The commit description mentions COSTLY_ORDER, but it's not actually
> used in the patch.
>
> -- Suleiman
>
Yeah, forgot to update the changelog =(

But much more importantly, are you still happy with those changes?

