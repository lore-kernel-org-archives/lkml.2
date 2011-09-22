Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753877Ab1IVUnr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 16:43:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23051 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753823Ab1IVUnq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 16:43:46 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=SR7rLWtbtP1lA+90ZSiQcbQoeEMGZdXe5ku2q6Sc3/ej8AjHFF1XuCWmMBxEquK1b
	yZbLYLPhLbbeezix1t83g==
Date: Thu, 22 Sep 2011 13:43:37 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] show page size in /proc/$pid/numa_maps
In-Reply-To: <20110921221329.5B7EE5C5@kernel>
Message-ID: <alpine.DEB.2.00.1109221339520.31548@chino.kir.corp.google.com>
References: <20110921221329.5B7EE5C5@kernel>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Sep 2011, Dave Hansen wrote:

> 
> The output of /proc/$pid/numa_maps is in terms of number of pages
> like anon=22 or dirty=54.  Here's some output:
> 
> 7f4680000000 default file=/hugetlb/bigfile anon=50 dirty=50 N0=50
> 7f7659600000 default file=/anon_hugepage\040(deleted) anon=50 dirty=50 N0=50
> 7fff8d425000 default stack anon=50 dirty=50 N0=50
> 
> Looks like we have a stack and a couple of anonymous hugetlbfs
> areas page which both use the same amount of memory.  They don't.
> 
> The 'bigfile' uses 1GB pages and takes up ~50GB of space.  The
> anon_hugepage uses 2MB pages and takes up ~100MB of space while
> the stack uses normal 4k pages.  You can go over to smaps to
> figure out what the page size _really_ is with KernelPageSize
> or MMUPageSize.  But, I think this is a pretty nasty and
> counterintuitive interface as it stands.
> 
> The following patch adds a pagemult= field.  It is placed only
> in cases where the VMA's page size differs from the base kernel
> page size.  I'm calling it pagemult to emphasize that it is
> indended to modify the statistics output rather than _really_
> show the page size that the kernel or MMU is using.
> 

Why not just add a pagesize={4K,2M,1G,...} field for every output?
