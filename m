Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753460Ab2AKHEW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 02:04:22 -0500
Received: from mail4.comsite.net ([205.238.176.238]:11570 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752691Ab2AKHEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 02:04:20 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.21.127.101;
From: Milton Miller <miltonm@bga.com>
Subject: Re: [PATCH v6 2/8] arm: move arm over to generic on_each_cpu_mask
In-Reply-To: <1326040026-7285-3-git-send-email-gilad@benyossef.com>
References: <1326040026-7285-3-git-send-email-gilad@benyossef.com>
To: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>
Cc: Christoph Lameter <cl@linux.com>, Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, <linux-mm@kvack.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Rik van Riel <riel@redhat.com>, Andi Kleen <andi@firstfloor.org>,
        Sasha Levin <levinsasha928@gmail.com>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        <linux-fsdevel@vger.kernel.org>, Avi Kivity <avi@redhat.com>,
        Michal Nazarewicz <mina86@mina86.org>,
        Kosaki Motohiro <kosaki.motohiro@gmail.com>
Date: Wed, 11 Jan 2012 01:04:11 -0600
X-Originating-IP: 71.21.127.101
Message-ID: <1326265451_1659@mail4.comsite.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun Jan 08 2012 about 11:28:02 EST, Gilad Ben-Yossef wrote:
> Note that the generic version is a little different then the Arm one:
> 
> 1. It has the mask as first parameter
> 2. It calls the function on the calling CPU with interrupts disabled,
> but this should be OK since the function is called on the other CPUs
> with interrupts disabled anyway.

While the split is good for review, since this function uses the same
name we will need to combine 1-3 to avoid a bisection build error.



-		on_each_cpu_mask(ipi_flush_tlb_page, &ta, 1, mm_cpumask(vma->vm_mm));
+		on_each_cpu_mask(mm_cpumask(vma->vm_mm), ipi_flush_tlb_page,
+			&ta, 1);

Since you are only rearranging the arguments and not adding any
characters, my first thought would be just leave the line long.
However, looking at the 80 column wrap I see how "mm));" is more
clearly wrapped text vs ", 1);".

My suggestion is to create a local var to shorten the line, probably 
struct mm_struct *mm, but a cpumask_var_t would also work.

Overall a minor point, I'm ok if this doesn't happen.

milton
