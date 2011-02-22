Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753749Ab1BVVWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:22:14 -0500
Received: from smtp-out.google.com ([74.125.121.67]:34024 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867Ab1BVVWK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:22:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ER8cx3VyjikNLLcZTu6Y7BgcA70vSEEzX+x0U9VKjdpC7vvJAdbOREEr7O/pU/9aPO
         qB5ppX39afMUEG+X4AZQ==
Date: Tue, 22 Feb 2011 13:22:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 4/5] teach smaps_pte_range() about THP pmds
In-Reply-To: <20110222015343.41586948@kernel>
Message-ID: <alpine.DEB.2.00.1102221321000.5929@chino.kir.corp.google.com>
References: <20110222015338.309727CA@kernel> <20110222015343.41586948@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Dave Hansen wrote:

> 
> v2 - used mm->page_table_lock to fix up locking bug that
> 	Mel pointed out.  Also remove Acks since things
> 	got changed significantly.
> 
> This adds code to explicitly detect  and handle
> pmd_trans_huge() pmds.  It then passes HPAGE_SIZE units
> in to the smap_pte_entry() function instead of PAGE_SIZE.
> 
> This means that using /proc/$pid/smaps now will no longer
> cause THPs to be broken down in to small pages.
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>
