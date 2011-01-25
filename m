Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1AYVIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 16:08:48 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:46292 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1AYVIr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 16:08:47 -0500
Subject: Re: [PATCH 00/25] mm: Preemptibility -v7
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Andi Kleen <ak@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, benh <benh@kernel.crashing.org>
In-Reply-To: <4D3F36CB.6060505@linux.intel.com>
References: <20110125173111.720927511@chello.nl>
	 <m2ipxcsr6v.fsf@linux.intel.com> <1295987985.28776.1118.camel@laptop>
	 <4D3F36CB.6060505@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 25 Jan 2011 22:09:30 +0100
Message-ID: <1295989770.28776.1127.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-25 at 12:47 -0800, Andi Kleen wrote:
> 
> I thought the reason for the preempt off inside the mmu gather region was
> to stay on the same CPU for local/remote flushes. How would it change that? 

afaik its been preempt-off solely because it was always inside a number
of spinlocks, I know both Hugh and BenH worked on making it preemptible
far before I started this.

I remember Hugh and Nick talking about this at OLS'06 or 07, can't
really remember.

As to local/remote flushes, there is no real saying where the pages came
from due to on-demand paging and the scheduler never having had a notion
of home-node. Therefore freeing them wouldn't be more of less local if
that is exposed to the same migration as allocation was.


