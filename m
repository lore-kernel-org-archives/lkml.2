Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2KGHEa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 02:04:30 -0500
Received: from mx2.parallels.com ([64.131.90.16]:49409 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141Ab2KGHE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 02:04:28 -0500
Message-ID: <509A07E3.5090700@parallels.com>
Date: Wed, 7 Nov 2012 08:04:03 +0100
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
        <kamezawa.hiroyu@jp.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.cz>,
        Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Suleiman Souhlal <suleiman@google.com>, JoonSoo Kim <js1304@gmail.com>
Subject: Re: [PATCH v6 19/29] memcg: infrastructure to match an allocation
 to the right cache
References: <1351771665-11076-1-git-send-email-glommer@parallels.com> <1351771665-11076-20-git-send-email-glommer@parallels.com> <20121105162837.5fdac20c.akpm@linux-foundation.org>
In-Reply-To: <20121105162837.5fdac20c.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [88.2.50.55]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/06/2012 01:28 AM, Andrew Morton wrote:
> On Thu,  1 Nov 2012 16:07:35 +0400
> Glauber Costa <glommer@parallels.com> wrote:
> 
>> +static __always_inline struct kmem_cache *
>> +memcg_kmem_get_cache(struct kmem_cache *cachep, gfp_t gfp)
> 
> I still don't understand why this code uses __always_inline so much.
> 
> I don't recall seeing the compiler producing out-of-line versions of
> "static inline" functions (and perhaps it has special treatment for
> functions which were defined in a header file?).
> 
> And if the compiler *does* decide to uninline the function, perhaps it
> knows best, and the function shouldn't have been declared inline in the
> first place.
> 
> 
> If it is indeed better to use __always_inline in this code then we have
> a heck of a lot of other "static inline" definitions whcih we need to
> convert!  So, what's going on here?
> 

The original motivation is indeed performance related. We want to make
sure it is inline so it will figure out quickly the "I am not a memcg
user" case and keep it going. The slub, for instance, is full of
__always_inline functions to make sure that the fast path contains
absolutely no function calls. So I was just following this here.

I can remove the marker without a problem and leave it to the compiler
if you think it is best

