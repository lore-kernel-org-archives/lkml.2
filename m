Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab2IZArB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 20:47:01 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48405 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753946Ab2IZAq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 20:46:59 -0400
Date: Tue, 25 Sep 2012 17:46:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Glauber Costa <glommer@parallels.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Michal Hocko <mhocko@suse.cz>,
        Pekka Enberg <penberg@cs.helsinki.fi>
Subject: Re: [PATCH] slab: Ignore internal flags in cache creation
In-Reply-To: <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com>
Message-ID: <alpine.DEB.2.00.1209251744580.22521@chino.kir.corp.google.com>
References: <1348571866-31738-1-git-send-email-glommer@parallels.com> <00000139fe408877-40bc98e3-322c-4ba2-be72-e298ff28e694-000000@email.amazonses.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012, Christoph Lameter wrote:

> > No cache should ever pass those as a creation flags. We can just ignore
> > this bit if it happens to be passed (such as when duplicating a cache in
> > the kmem memcg patches)
> 
> Acked-by: Christoph Lameter <cl@linux.com>
> 

Nack, this is already handled by CREATE_MASK in the mm/slab.c allocator; 
the flag extensions beyond those defined in the generic slab.h header are 
implementation defined.  It may be true that SLAB uses a bit only 
internally (and already protects it with a BUG_ON() in 
__kmem_cache_create()) but that doesn't mean other implementations can't 
use such a flag that would be a no-op on another allocator.
