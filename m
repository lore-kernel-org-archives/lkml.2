Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760184Ab2HXWIK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 18:08:10 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54840 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758962Ab2HXWIG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 18:08:06 -0400
Date: Fri, 24 Aug 2012 15:08:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Glauber Costa <glommer@parallels.com>
Cc: <linux-kernel@vger.kernel.org>, <torvalds@linux-foundation.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>
Subject: Re: [PATCH v2] fork: fix oops after fork failure
Message-Id: <20120824150804.8e3c4b7e.akpm@linux-foundation.org>
In-Reply-To: <1345736168-1990-1-git-send-email-glommer@parallels.com>
References: <1345736168-1990-1-git-send-email-glommer@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Aug 2012 19:36:08 +0400
Glauber Costa <glommer@parallels.com> wrote:

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

I think ths was already fixed by f19b9f74b7ea3b ("fork: fix error
handling in dup_task()").  As you would have noticed if you were
preparing patches against up-to-date kernel versions!

