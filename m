Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753320Ab1JPI2v (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 04:28:51 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:63751 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1JPI2t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 04:28:49 -0400
Date: Sun, 16 Oct 2011 01:31:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Michal Nazarewicz" <mina86@mina86.com>
Cc: "Marek Szyprowski" <m.szyprowski@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org,
        "Kyungmin Park" <kyungmin.park@samsung.com>,
        "Russell King" <linux@arm.linux.org.uk>,
        "KAMEZAWA Hiroyuki" <kamezawa.hiroyu@jp.fujitsu.com>,
        "Ankita Garg" <ankita@in.ibm.com>,
        "Daniel Walker" <dwalker@codeaurora.org>, "Mel Gorman" <mel@csn.ul.ie>,
        "Arnd Bergmann" <arnd@arndb.de>,
        "Jesse Barker" <jesse.barker@linaro.org>,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Shariq Hasnain" <shariq.hasnain@linaro.org>,
        "Chunsang Jeong" <chunsang.jeong@linaro.org>,
        "Dave Hansen" <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 2/9] mm: alloc_contig_freed_pages() added
Message-Id: <20111016013116.53032449.akpm@linux-foundation.org>
In-Reply-To: <op.v3fpwyxc3l0zgt@mpn-glaptop>
References: <1317909290-29832-1-git-send-email-m.szyprowski@samsung.com>
	<1317909290-29832-3-git-send-email-m.szyprowski@samsung.com>
	<20111014162933.d8fead58.akpm@linux-foundation.org>
	<op.v3fpwyxc3l0zgt@mpn-glaptop>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 16 Oct 2011 10:01:36 +0200 "Michal Nazarewicz" <mina86@mina86.com> wrote:

> Still, as I think of it now, maybe alloc_contig_free_range() would be
> better?

Nope.  Of *course* the pages were free.  Otherwise we couldn't
(re)allocate them.  I still think the "free" part is redundant.

What could be improved is the "alloc" part.  This really isn't an
allocation operation.  The pages are being removed from buddy then
moved into the free arena of a different memory manager from where they
will _later_ be "allocated".

So we should move away from the alloc/free naming altogether for this
operation and think up new terms.  How about "claim" and "release"? 
claim_contig_pages, claim_contig_range, release_contig_pages, etc?
Or we could use take/return.

Also, if we have no expectation that anything apart from CMA will use
these interfaces (?), the names could/should be prefixed with "cma_".

