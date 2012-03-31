Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab2CaWZi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 18:25:38 -0400
Received: from gate.crashing.org ([63.228.1.57]:55301 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753204Ab2CaWZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 18:25:36 -0400
Message-ID: <1333232714.30734.6.camel@pasglop>
Subject: Re: [PATCH 2/7] mm: introduce vma flag VM_ARCH_1
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 01 Apr 2012 08:25:14 +1000
In-Reply-To: <20120331092910.19920.29396.stgit@zurg>
References: <20120331091049.19373.28994.stgit@zurg>
	 <20120331092910.19920.29396.stgit@zurg>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-03-31 at 13:29 +0400, Konstantin Khlebnikov wrote:
> This patch shuffles some bits in vma->vm_flags
> 
> before patch:
> 
>         0x00000200      0x01000000      0x20000000      0x40000000
> x86     VM_NOHUGEPAGE   VM_HUGEPAGE     -               VM_PAT
> powerpc -               -               VM_SAO          -
> parisc  VM_GROWSUP      -               -               -
> ia64    VM_GROWSUP      -               -               -
> nommu   -               VM_MAPPED_COPY  -               -
> others  -               -               -               -
> 
> after patch:
> 
>         0x00000200      0x01000000      0x20000000      0x40000000
> x86     -               VM_PAT          VM_HUGEPAGE     VM_NOHUGEPAGE
> powerpc -               VM_SAO          -               -
> parisc  -               VM_GROWSUP      -               -
> ia64    -               VM_GROWSUP      -               -
> nommu   -               VM_MAPPED_COPY  -               -
> others  -               VM_ARCH_1       -               -
> 
> And voila! One completely free bit.

Great :-) Let me know when you free VM_ARCH_2 as well as I have good use
for it too :-)

Cheers,
Ben.


