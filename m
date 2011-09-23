Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752120Ab1IWUEW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 16:04:22 -0400
Received: from smtp-out.google.com ([74.125.121.67]:62611 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937Ab1IWUEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 16:04:21 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=MM0ZX079wmvWaPAptw9WbYVi5izDSkoCu6nAsJS6ClinoKt7ZTFI2Lj52J62IgX15
	AN4oR9mazYx5e7tsksjqg==
Date: Fri, 23 Sep 2011 13:04:12 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@linux.vnet.ibm.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] show page size in /proc/$pid/numa_maps
In-Reply-To: <1316793268.16137.481.camel@nimitz>
Message-ID: <alpine.DEB.2.00.1109231256540.11347@chino.kir.corp.google.com>
References: <20110921221329.5B7EE5C5@kernel> <alpine.DEB.2.00.1109221339520.31548@chino.kir.corp.google.com> <1316793268.16137.481.camel@nimitz>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Sep 2011, Dave Hansen wrote:

> > Why not just add a pagesize={4K,2M,1G,...} field for every output? 
> 
> I think it's a bit misleading.  With THP at least we have 2M pages in
> the MMU, but we're reporting in 4k units.
> 
> I certainly considered doing just what you're suggesting, though.  It's
> definitely not a bad idea.  Certainly much more clear.
> 

Een though the code is in task_mmu.c, I think that /proc/pid/numa_maps 
should be more representative of the state of vmas where any 
pagesize={4K,2M,1G,...} would be true rather than whether or not the mmu 
sees tham as large or small pages.  I actually don't see much difference 
between anon=50 pagemult=512 and anon=50 pagesize=2M, but I'd definitely 
recommend printing the field for every vma.
