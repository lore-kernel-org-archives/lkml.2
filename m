Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2GYST1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:19:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:38017 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752338Ab2GYSTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:19:25 -0400
Message-ID: <50103802.1070700@parallels.com>
Date: Wed, 25 Jul 2012 22:16:34 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@kernel.org>, Greg Thelen <gthelen@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.cz>,
        Frederic Weisbecker <fweisbec@gmail.com>, <devel@openvz.org>,
        <cgroups@vger.kernel.org>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Suleiman Souhlal <suleiman@google.com>
Subject: Re: [PATCH 10/10] memcg/sl[au]b: shrink dead caches
References: <1343227101-14217-1-git-send-email-glommer@parallels.com> <1343227101-14217-11-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1207251207180.3543@router.home>
In-Reply-To: <alpine.DEB.2.00.1207251207180.3543@router.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.1.99]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 09:13 PM, Christoph Lameter wrote:
> On Wed, 25 Jul 2012, Glauber Costa wrote:
> 
>> In the slub allocator, when the last object of a page goes away, we
>> don't necessarily free it - there is not necessarily a test for empty
>> page in any slab_free path.
> 
> That is true for the slab allocator as well. In either case calling
> kmem_cache_shrink() will make the objects go away by draining the cached
> objects and freeing the pages used for the objects back to the page
> allocator. You do not need this patch. Just call the proper functions to
> drop the objecgts in the caches in either allocator.
> 
>> The slab allocator has a time based reaper that would eventually get rid
>> of the objects, but we can also call it explicitly, since dead caches
>> are not a likely event.
> 
> So this is already for both allocators?
> 
Yes, I just didn't updated the whole changelog. my bad.

