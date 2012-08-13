Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752033Ab2HMNVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:21:39 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:51188 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2HMNVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:21:38 -0400
Date: Mon, 13 Aug 2012 18:50:42 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7] uprobes: kill dup_mmap()->uprobe_mmap(), simplify
 uprobe_mmap/munmap
Message-ID: <20120813132042.GG31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173739.GA13259@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173739.GA13259@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081313-2000-0000-0000-000008B1A680
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:39]:

> 1. Kill dup_mmap()->uprobe_mmap(), it was only needed to calculate
>    new_mm->uprobes_state.count removed by the previous patch.
> 
>    If the forking process has a pending uprobe (int3) in vma, it will
>    be copied by copy_page_range(), note that it checks vma->anon_vma
>    so "Don't copy ptes" is not possible after install_breakpoint()
>    which does anon_vma_prepare().
> 
> 2. Remove is_swbp_at_addr() and "int count" in uprobe_mmap(). Again,
>    this was needed for uprobes_state.count.
> 
>    As a side effect this fixes the bug pointed out by Srikar,
>    this code lacked the necessary put_uprobe().
> 
> 3. uprobe_munmap() becomes a nop after the previous patch. Remove the
>    meaningless code but do not remove the helper, we will need it.

We could have removed uprobe_munmap() for now and reintroduced it. But
its fine to keep it this way for now.

> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>

Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

