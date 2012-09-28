Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759110Ab2I1UgW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:36:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42421 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758969Ab2I1UgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:36:18 -0400
Date: Fri, 28 Sep 2012 13:36:16 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <0000013a0d314c3f-e5b12d01-7a99-4368-82a0-f5de4d46f804-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209281332460.21335@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com> <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com> <5062C029.308@parallels.com>
 <alpine.DEB.2.00.1209261813300.7072@chino.kir.corp.google.com> <0000013a08020b4d-ecc22fc9-75e4-4f1d-8a76-5496a98d1df9-000000@email.amazonses.com> <alpine.DEB.2.00.1209271546460.13360@chino.kir.corp.google.com>
 <0000013a0d314c3f-e5b12d01-7a99-4368-82a0-f5de4d46f804-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Sep 2012, Christoph Lameter wrote:

> > > This means touching another field from critical paths of the allocators.
> > > It would increase the cache footprint and therefore reduce performance.
> > >
> >
> > To clarify your statement, you're referring to the mm/slab.c allocation of
> > new slab pages and when debugging is enabled as "critical paths", correct?
> > We would disagree on that point.
> 
> This is not debugging specific. Flags are also consulted to do RCU
> processing and other things.
> 

There is no "critical path" in mm/slab.c that tests CFLGS_OFF_SLAB; the 
flag itself is used to determine where slab management is done and you 
certainly wouldn't want to find this for any path that is critical.

If you'd like to disagree with that, please show the code and why you 
consider increasing the cache footprint in that case to be critical to 
performance.
