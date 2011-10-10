Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753227Ab1JJWAn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 18:00:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43680 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752546Ab1JJWAm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 18:00:42 -0400
Date: Mon, 10 Oct 2011 15:00:38 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        nfont@linux.vnet.ibm.com,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH] mm: memory hotplug: Check if pages are correctly
 reserved on a per-section basis
Message-Id: <20111010150038.ac161977.akpm@linux-foundation.org>
In-Reply-To: <20111010071119.GE6418@suse.de>
References: <20111010071119.GE6418@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011 08:11:19 +0100
Mel Gorman <mgorman@suse.de> wrote:

> It is expected that memory being brought online is PageReserved
> similar to what happens when the page allocator is being brought up.
> Memory is onlined in "memory blocks" which consist of one or more
> sections. Unfortunately, the code that verifies PageReserved is
> currently assuming that the memmap backing all these pages is virtually
> contiguous which is only the case when CONFIG_SPARSEMEM_VMEMMAP is set.
> As a result, memory hot-add is failing on !VMEMMAP configurations
> with the message;
> 
> kernel: section number XXX page number 256 not reserved, was it already online?
> 
> This patch updates the PageReserved check to lookup struct page once
> per section to guarantee the correct struct page is being checked.
> 

Nathan's earlier version of this patch is already in linux-next, via
Greg.  We should drop the old version and get the new one merged
instead.

