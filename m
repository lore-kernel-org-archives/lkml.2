Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761639Ab2EJVol (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 17:44:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54570 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761528Ab2EJVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 17:44:40 -0400
Date: Thu, 10 May 2012 14:44:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Gavin Shan <shangw@linux.vnet.ibm.com>, David Miller <davem@davemloft.net>,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 10/10] mm: remove sparsemem allocation details from the
 bootmem allocator
Message-Id: <20120510144439.eba9c486.akpm@linux-foundation.org>
In-Reply-To: <1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
References: <1336390672-14421-1-git-send-email-hannes@cmpxchg.org>
	<1336390672-14421-11-git-send-email-hannes@cmpxchg.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon,  7 May 2012 13:37:52 +0200
Johannes Weiner <hannes@cmpxchg.org> wrote:

> alloc_bootmem_section() derives allocation area constraints from the
> specified sparsemem section.  This is a bit specific for a generic
> memory allocator like bootmem, though, so move it over to sparsemem.
> 
> As __alloc_bootmem_node_nopanic() already retries failed allocations
> with relaxed area constraints, the fallback code in sparsemem.c can be
> removed and the code becomes a bit more compact overall.
> 
> ...
>
> @@ -332,9 +334,9 @@ static void __init check_usemap_section_nr(int nid, unsigned long *usemap)
>  #else
>  static unsigned long * __init
>  sparse_early_usemaps_alloc_pgdat_section(struct pglist_data *pgdat,
> -					 unsigned long count)
> +					 unsigned long size)
>  {
> -	return NULL;
> +	return alloc_bootmem_node_nopanic(pgdat, size)

You've been bad.   Your penance is to runtime test this code with
CONFIG_MEMORY_HOTREMOVE=n!
