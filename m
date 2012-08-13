Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab2HMNXY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:23:24 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:55317 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751736Ab2HMNXX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:23:23 -0400
Date: Mon, 13 Aug 2012 18:52:21 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/7] uprobes: introduce MMF_HAS_UPROBES
Message-ID: <20120813132221.GJ31805@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120808173659.GA13220@redhat.com>
 <20120808173747.GA13272@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20120808173747.GA13272@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 12081313-2674-0000-0000-0000059523A9
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Oleg Nesterov <oleg@redhat.com> [2012-08-08 19:37:47]:

> Add the new MMF_HAS_UPROBES flag. It is set by install_breakpoint()
> and it is copied by dup_mmap(), uprobe_pre_sstep_notifier() checks
> it to avoid the slow path if the task was never probed. Perhaps it
> makes sense to check it in valid_vma(is_register => false) as well.
> 
> This needs the new dup_mmap()->uprobe_dup_mmap() hook. We can't use
> uprobe_reset_state() or put MMF_HAS_UPROBES into MMF_INIT_MASK, we
> need oldmm->mmap_sem to avoid the race with uprobe_register() or
> mmap() from another thread.
> 
> Currently we never clear this bit, it can be false-positive after
> uprobe_unregister() or uprobe_munmap() or if dup_mmap() hits the
> probed VM_DONTCOPY vma. But this is fine correctness-wise and has
> no effect unless the task hits the non-uprobe breakpoint.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Srikar Dronamraju <srikar@linux.vnet.ibm.com>

