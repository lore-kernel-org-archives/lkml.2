Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab2EWMKN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 08:10:13 -0400
Received: from mx2.parallels.com ([64.131.90.16]:46532 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753023Ab2EWMKL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 08:10:11 -0400
Message-ID: <4FBCD328.6060406@parallels.com>
Date: Wed, 23 May 2012 16:08:08 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        <linux-kernel@vger.kernel.org>, <cgroups@vger.kernel.org>,
        <linux-mm@kvack.org>, Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
References: <1337613539-29108-1-git-send-email-glommer@parallels.com>  <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>  <alpine.DEB.2.00.1205220855470.17600@router.home>  <4FBBAE95.6080608@parallels.com>  <alpine.DEB.2.00.1205221216050.17721@router.home>  <alpine.DEB.2.00.1205221529340.18325@chino.kir.corp.google.com> <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
In-Reply-To: <1337773595.3013.15.camel@dabdike.int.hansenpartnership.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 03:46 PM, James Bottomley wrote:
>> We can't predict how slab will be extended in the future and this affects
>> >  anything created before g_cpucache_cpu<= EARLY.  This would introduce the
>> >  first problem with destroying such caches and is unnecessary if a
>> >  workaround exists.
> These problems seem to indicate that the slab behaviour: expecting the
> string to exist for the lifetime of the cache so there's no need to copy
> it might be better.
>
> This must be the behaviour all users of kmem_cache_create() expect
> anyway, since all enterprise distributions use slab and they're not
> getting bugs reported in this area.
>
> So, why not simply patch slab to rely on the string lifetime being the
> cache lifetime (or beyond) and therefore not having it take a copy?
>
You mean patch slub? slub is the one that takes a copy currently.

