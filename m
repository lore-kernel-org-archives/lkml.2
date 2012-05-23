Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758236Ab2EWJ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 05:27:27 -0400
Received: from mx2.parallels.com ([64.131.90.16]:51740 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2EWJ10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 05:27:26 -0400
Message-ID: <4FBCAD03.5010106@parallels.com>
Date: Wed, 23 May 2012 13:25:23 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Christoph Lameter <cl@linux.com>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH v2] slab+slob: dup name string
References: <1337680298-11929-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205220857380.17600@router.home> <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1205222048380.28165@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2012 07:55 AM, David Rientjes wrote:
> I hate consistency patches like this because it could potentially fail a
> kmem_cache_create() from a sufficiently long cache name when it wouldn't
> have before, but I'm not really concerned since kmem_cache_create() will
> naturally be followed by kmem_cache_alloc() which is more likely to cause
> the oom anyway.  But it's just another waste of memory for consistency
> sake.
>
> This is much easier to do, just statically allocate the const char *'s
> needed for the boot caches and then set their ->name's manually in
> kmem_cache_init() and then avoid the kfree() in kmem_cache_destroy() if
> the name is between&boot_cache_name[0] and&boot_cache_name[n].

That can be done.

I'll also revisit my memcg patches to see if I can rework it so it 
doesn't care about this particular behavior. We're having a surprisingly 
difficult time reaching consensus on this, so maybe it would be better 
left untouched (if there is a way that makes sense to)
