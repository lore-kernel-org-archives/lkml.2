Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758881Ab1DYTJ3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 15:09:29 -0400
Received: from smtp105.prem.mail.ac4.yahoo.com ([76.13.13.44]:47265 "HELO
	smtp105.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758203Ab1DYTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 15:09:28 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: UamNmaIVM1nlqLRu5XLFC_rAoRYUmhAAWIvJQnvZzE6g64F
 FQbJVTcB6O_aKpRAPSBXfZmMmcXYxDtfJH50FBqEMKCr0krSN4Rv3LhQDK8J
 qdQtx.pAT0cMjyLRP4LDGqPX.isPPpJ8fe5qtP7eETSBvmh5ILMhd42MQIGL
 GhDGDN6nei_vz5sdNImsOGuzarTVh_by23ullmr98bnK4.On7C.4XXGMi_.M
 BjZJxUicw0DBsFP10cvAk5mdW0wx21a1wLjdBuTg9Z4Pa8L8e10MUQqEJNK6
 uCSuUITb.V0QTFFCr0gVOhyYoac_kDn8DEnm5YsDoBn6qeyKh3EWxgA7N4IP
 Mfb7G8T3AMEywa0dAHCwyb4.p
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 25 Apr 2011 14:09:26 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Pekka Enberg <penberg@kernel.org>
cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC/PATCH 2/2] slub: Don't share struct kmem_cache for shared
 caches
In-Reply-To: <1303753608-19248-2-git-send-email-penberg@kernel.org>
Message-ID: <alpine.DEB.2.00.1104251407090.9646@router.home>
References: <1303753608-19248-1-git-send-email-penberg@kernel.org> <1303753608-19248-2-git-send-email-penberg@kernel.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Apr 2011, Pekka Enberg wrote:

> This patch changes the slab cache sharing in SLUB to only share 'struct
> kmem_cpu_cache' which contains the actual list of slabs and object freelists.
> We no longer share 'struct kmem_cache' between merged caches so /proc/slabinfo
> statistics work as expected:

I am a bit confused. Struct kmem_cache contains per slab
allocation information and all pages have pointers to struct kmem_cache.

So we have pages now on the kmem_cache_cpu list with varying kmem_cache
pointers? How do we figure out which cache a page belongs to? It seems
that a page from one cache can be freed to the freelists of another.

Does this even run right with the debugging enabled?


