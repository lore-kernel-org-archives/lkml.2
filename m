Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab1BVVV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 16:21:58 -0500
Received: from smtp-out.google.com ([74.125.121.67]:33898 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753749Ab1BVVV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 16:21:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=LY/9YT+g9rGAvlQgNnwQ+wCtsle2Aq82QJBx3+bD+VYu1L5/xnO9YHH2d2sTnnQT1O
         gIevnNJT3OTZlfAqYK/g==
Date: Tue, 22 Feb 2011 13:21:48 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Michael J Wolf <mjwolf@us.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH 1/5] pagewalk: only split huge pages when necessary
In-Reply-To: <20110222015339.0C9A2212@kernel>
Message-ID: <alpine.DEB.2.00.1102221316400.5929@chino.kir.corp.google.com>
References: <20110222015338.309727CA@kernel> <20110222015339.0C9A2212@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Feb 2011, Dave Hansen wrote:

> 
> v2 - rework if() block, and remove  now redundant split_huge_page()
> 
> Right now, if a mm_walk has either ->pte_entry or ->pmd_entry
> set, it will unconditionally split any transparent huge pages
> it runs in to.  In practice, that means that anyone doing a
> 
> 	cat /proc/$pid/smaps
> 
> will unconditionally break down every huge page in the process
> and depend on khugepaged to re-collapse it later.  This is
> fairly suboptimal.
> 
> This patch changes that behavior.  It teaches each ->pmd_entry
> handler (there are five) that they must break down the THPs
> themselves.  Also, the _generic_ code will never break down
> a THP unless a ->pte_entry handler is actually set.
> 
> This means that the ->pmd_entry handlers can now choose to
> deal with THPs without breaking them down.
> 
> Acked-by: Mel Gorman <mel@csn.ul.ie>
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>

Acked-by: David Rientjes <rientjes@google.com>

Thanks for adding the comment about ->pmd_entry() being required to split 
the pages in include/linux/mm.h!
