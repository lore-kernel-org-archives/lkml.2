Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030653Ab2HWQEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 12:04:23 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43789 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934124Ab2HWQEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 12:04:21 -0400
Date: Thu, 23 Aug 2012 18:04:14 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2] fork: fix oops after fork failure
Message-ID: <20120823160411.GA19305@somewhere.redhat.com>
References: <1345736168-1990-1-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345736168-1990-1-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 23, 2012 at 07:36:08PM +0400, Glauber Costa wrote:
> When we want to duplicate a new process, dup_task_struct() will undergo
> a series of allocations. If alloc_thread_info_node() fails, we call
> free_task_struct() and return.
> 
> This seems right, but it is not. free_task_struct() will not only free
> the task struct from the kmem_cache, but will also call
> arch_release_task_struct(). The problem is that this function is
> supposed to undo whatever arch-specific work done by
> arch_dup_task_struct(), that is not yet called at this point.  The
> particular problem I ran accross was that in x86, we will arrive at
> fpu_free() without having ever allocated it.
> 
> Signed-off-by: Glauber Costa <glommer@parallels.com>
> Reported-by: Frederic Weisbecker <fweisbec@redhat.com>

Tested-by: Frederic Weisbecker <fweisbec@redhat.com>
