Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965049Ab2FAPzf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 11:55:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14624 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964994Ab2FAPza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 11:55:30 -0400
Date: Fri, 1 Jun 2012 17:53:12 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] uprobes: install_breakpoint() should fail if
	is_swbp_insn() == T
Message-ID: <20120601155312.GA20265@redhat.com>
References: <20120530165757.GA8077@redhat.com> <20120530165816.GA8085@redhat.com> <1338398931.28384.7.camel@twins> <20120530173717.GM15587@linux.vnet.ibm.com> <1338400142.28384.12.camel@twins> <1338400450.28384.16.camel@twins> <20120531185339.GA28057@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531185339.GA28057@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31, Oleg Nesterov wrote:
>
> __find_next_vma_info() checks tmpvi->mm == vma->vm_mm to detect the
> already visited mm/vma. However, afaics this can be false positive?

Yes, but I guess this is harmless, we can rely on uprobe_mmap.



But. Doesn't this mean we can greatly simplify register_for_each_vma()
and make it O(n) ?

Unless I missed something, we can simply create the list of
mm/vaddr structures under ->i_mmap_mutex (vma_prio_tree_foreach), then
register_for_each_vma() can process the list and that is all.

If another mapping comes after we drop i_mmap_mutex, uprobe_mmap()
should be called and it should install the bp.


Srikar, Peter, what do you think?

Oleg.

