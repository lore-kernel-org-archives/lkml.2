Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2JVIlF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 04:41:05 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51224 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751883Ab2JVIlD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 04:41:03 -0400
Message-ID: <5085068E.5080304@parallels.com>
Date: Mon, 22 Oct 2012 12:40:46 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, Mel Gorman <mgorman@suse.de>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>, Johannes Weiner <hannes@cmpxchg.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, David Rientjes <rientjes@google.com>,
        "Pekka Enberg" <penberg@kernel.org>, <devel@openvz.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH v5 04/18] slab: don't preemptively remove element from
 list in cache destroy
References: <1350656442-1523-1-git-send-email-glommer@parallels.com> <1350656442-1523-5-git-send-email-glommer@parallels.com> <0000013a7a84cb28-334eab12-33c4-4a92-bd9c-e5ad938f83d0-000000@email.amazonses.com>
In-Reply-To: <0000013a7a84cb28-334eab12-33c4-4a92-bd9c-e5ad938f83d0-000000@email.amazonses.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 11:34 PM, Christoph Lameter wrote:
> On Fri, 19 Oct 2012, Glauber Costa wrote:
> 
>> I, however, see no reason why we need to do so, since we are now locked
>> during the whole deletion (which wasn't necessarily true before).  I
>> propose a simplification in which we delete it only when there is no
>> more going back, so we don't need to add it again.
> 
> Ok lets hope that holding the lock does not cause issues.
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 
BTW: One of the good things about this set, is that we are naturally
exercising cache destruction a lot more than we did before. So if there
is any problem, either with this or anything related to cache
destruction, it should at least show up a lot more frequently. So far,
this does not seem to cause any problems.

