Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759150Ab2EVPVy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 11:21:54 -0400
Received: from mx2.parallels.com ([64.131.90.16]:39421 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754128Ab2EVPVw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 11:21:52 -0400
Message-ID: <4FBBAE95.6080608@parallels.com>
Date: Tue, 22 May 2012 19:19:49 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: David Rientjes <rientjes@google.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com> <alpine.DEB.2.00.1205220855470.17600@router.home>
In-Reply-To: <alpine.DEB.2.00.1205220855470.17600@router.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 05:56 PM, Christoph Lameter wrote:
> On Mon, 21 May 2012, David Rientjes wrote:
>
>> This doesn't work if you kmem_cache_destroy() a cache that was created
>> when g_cpucache_cpu<= EARLY, the kfree() will explode.  That never
>> happens for any existing cache created in kmem_cache_init(), but this
>> would introduce the first roadblock in doing so.  So you'll need some
>> magic to determine whether the cache was allocated statically and suppress
>> the kfree() in such a case.
>
> Nope. Only slab management caches will be created that early. The patch is
> fine as is.
>
>

I think that's precisely David's point: that we might want to destroy 
them eventually.
