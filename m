Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab2LLUPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 15:15:35 -0500
Received: from one.firstfloor.org ([213.235.205.2]:45705 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754645Ab2LLUPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 15:15:34 -0500
Date: Wed, 12 Dec 2012 21:15:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Lameter <cl@linux.com>
Cc: Joonsoo Kim <js1304@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, andi@firstfloor.org,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Subject: Re: [PATCH] mm: introduce numa_zero_pfn
Message-ID: <20121212201529.GD16230@one.firstfloor.org>
References: <1355331819-8728-1-git-send-email-js1304@gmail.com> <0000013b90beeb93-87f65a09-0cc3-419f-be26-5271148cb947-000000@email.amazonses.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0000013b90beeb93-87f65a09-0cc3-419f-be26-5271148cb947-000000@email.amazonses.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I would expect a processor to fetch the zero page cachelines from the l3
> cache from other sockets avoiding memory transactions altogether. The zero
> page is likely in use somewhere so no typically no memory accesses should
> occur in a system.

It depends on how effectively the workload uses the caches. If something
is a cache pig of the L3 cache, then even shareable cache lines may need
to be refetched regularly.

But if your workloads spends a significant part of its time reading
from zero page read only data there is something wrong with the workload.

I would do some data profiling first to really prove that is the case.

-Andi
