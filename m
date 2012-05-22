Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756478Ab2EVN4w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 09:56:52 -0400
Received: from smtp104.prem.mail.ac4.yahoo.com ([76.13.13.43]:20174 "HELO
	smtp104.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753047Ab2EVN4u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 09:56:50 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: 4wUCOxgVM1nko0U1gZA5ZpibRjQ9SzMuO9ysPyo91HkJXeB
 90lvlV.9qsg5tNaKmfzZnIL1OrGZv6HLMyW0O4Zs_TwJiujLUDpUkixxKjqL
 vXkuFrjPu3n8_C6xXLB1w9Y7lsFFopiw1Ue88.zgIPcLQ58tGwH3btiNIpKf
 IBgXEncJRpknnQ3vcuz52nzWy9RpbGvo8jYWWURvX1AYg3htCZro7_0rOdk8
 lOt6s.j4WJdTWODtLetdtkMDuHHqT9QBzPvYxj6OHkwiuGJoZgE5fgrFzsm0
 RiLaQZUTzERKs.6p5.Srld_DxLghMyVitytLQFCS6EQZwpjvT2ZLBfadY.b8
 oWaoeF4dMKoPfYFxVghygC3pea5_Vl9ZfKlNYWiVdcnaBcroS2D4yG4zmZJH
 56ciCqvKibAYSOb0HURYrqZVwstaIgiOqOW8E
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Tue, 22 May 2012 08:56:47 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: David Rientjes <rientjes@google.com>
cc: Glauber Costa <glommer@parallels.com>, linux-kernel@vger.kernel.org,
        cgroups@vger.kernel.org, linux-mm@kvack.org,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab+slob: dup name string
In-Reply-To: <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1205220855470.17600@router.home>
References: <1337613539-29108-1-git-send-email-glommer@parallels.com> <alpine.DEB.2.00.1205212018230.13522@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 May 2012, David Rientjes wrote:

> This doesn't work if you kmem_cache_destroy() a cache that was created
> when g_cpucache_cpu <= EARLY, the kfree() will explode.  That never
> happens for any existing cache created in kmem_cache_init(), but this
> would introduce the first roadblock in doing so.  So you'll need some
> magic to determine whether the cache was allocated statically and suppress
> the kfree() in such a case.

Nope. Only slab management caches will be created that early. The patch is
fine as is.


