Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1JTFUC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 01:20:02 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23180 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1JTFUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 01:20:00 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=xRsLhKrPdyDHllNZW1av2gS0bItrKjUAbh8R19mD+mBVZlFgtv+GiFX2/bRAmBcRX
	IDWYGY3mosH5KjwlSzmyw==
Date: Wed, 19 Oct 2011 22:19:52 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: memory hotplug: Check if pages are correctly reserved
 on a per-section basis
In-Reply-To: <20111017143820.GA7626@suse.de>
Message-ID: <alpine.DEB.2.00.1110192219390.4618@chino.kir.corp.google.com>
References: <20111010071119.GE6418@suse.de> <20111010150038.ac161977.akpm@linux-foundation.org> <20111010232403.GA30513@kroah.com> <20111010162813.7a470ae4.akpm@linux-foundation.org> <20111011072406.GA2503@suse.de> <20111017143820.GA7626@suse.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Mel Gorman wrote:

> (Resending as I am not seeing it in -next so maybe it got lost)
> 
> mm: memory hotplug: Check if pages are correctly reserved on a per-section basis
> 
> It is expected that memory being brought online is PageReserved
> similar to what happens when the page allocator is being brought up.
> Memory is onlined in "memory blocks" which consist of one or more
> sections. Unfortunately, the code that verifies PageReserved is
> currently assuming that the memmap backing all these pages is virtually
> contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
> As a result, memory hot-add is failing on those configurations with
> the message;
> 
> kernel: section number XXX page number 256 not reserved, was it already online?
> 
> This patch updates the PageReserved check to lookup struct page once
> per section to guarantee the correct struct page is being checked.
> 
> [Check pages within sections properly: rientjes@google.com]
> [original patch by: nfont@linux.vnet.ibm.com]
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
