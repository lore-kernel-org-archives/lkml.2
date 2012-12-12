Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab2LLUMN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:12:13 -0500
Received: from a193-30.smtp-out.amazonses.com ([199.255.193.30]:63651 "EHLO
	a193-30.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754792Ab2LLUML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:12:11 -0500
Date: Wed, 12 Dec 2012 20:12:09 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <js1304@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, andi@firstfloor.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] mm: introduce numa_zero_pfn
In-Reply-To: <1355331819-8728-1-git-send-email-js1304@gmail.com>
Message-ID: <0000013b90beeb93-87f65a09-0cc3-419f-be26-5271148cb947-000000@email.amazonses.com>
References: <1355331819-8728-1-git-send-email-js1304@gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 199.255.193.30
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2012, Joonsoo Kim wrote:

> Currently, we use just *one* zero page regardless of user process' node.
> When user process read zero page, at first, cpu should load this
> to cpu cache. If node of cpu is not same as node of zero page, loading
> takes long time. If we make zero pages for each nodes and use them
> adequetly, we can reduce this overhead.

Are you sure about the loading taking a long time?

I would expect a processor to fetch the zero page cachelines from the l3
cache from other sockets avoiding memory transactions altogether. The zero
page is likely in use somewhere so no typically no memory accesses should
occur in a system.

Fetching from the l3 cache out of another socket is faster than
fetching from local memory.

