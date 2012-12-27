Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab2L0XER (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 18:04:17 -0500
Received: from mail-pa0-f42.google.com ([209.85.220.42]:45670 "EHLO
	mail-pa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab2L0XEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 18:04:14 -0500
Date: Thu, 27 Dec 2012 15:04:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Sasha Levin <sasha.levin@oracle.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        "David S. Miller" <davem@davemloft.net>, Tejun Heo <tj@kernel.org>,
        Joonsoo Kim <js1304@gmail.com>, Yinghai Lu <yinghai@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm, bootmem: panic in bootmem alloc functions even
 if slab is available
In-Reply-To: <50DCCE5A.4000805@oracle.com>
Message-ID: <alpine.DEB.2.00.1212271502070.23127@chino.kir.corp.google.com>
References: <1356293711-23864-1-git-send-email-sasha.levin@oracle.com> <1356293711-23864-2-git-send-email-sasha.levin@oracle.com> <alpine.DEB.2.00.1212271423210.18214@chino.kir.corp.google.com> <50DCCE5A.4000805@oracle.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Dec 2012, Sasha Levin wrote:

> That's exactly what happens with the patch. Note that in the current upstream
> version there are several slab checks scattered all over.
> 
> In this case for example, I'm removing it from __alloc_bootmem_node(), but the
> first code line of__alloc_bootmem_node_nopanic() is:
> 
>         if (WARN_ON_ONCE(slab_is_available()))
>                 return kzalloc(size, GFP_NOWAIT);
> 

You're only talking about mm/bootmem.c and not mm/nobootmem.c, and notice 
that __alloc_bootmem_node() does not call __alloc_bootmem_node_nopanic(), 
it calls ___alloc_bootmem_node_nopanic().
