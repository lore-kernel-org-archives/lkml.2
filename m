Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2DBQ1k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 12:27:40 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:55471 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752096Ab2DBQ1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 12:27:39 -0400
Date: Mon, 2 Apr 2012 20:27:33 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Oleg Nesterov <oleg@redhat.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Eric Paris <eparis@redhat.com>
Subject: Re: [PATCH 6/7] mm: kill vma flag VM_EXECUTABLE
Message-ID: <20120402162733.GI7607@moon>
References: <20120331091049.19373.28994.stgit@zurg>
 <20120331092929.19920.54540.stgit@zurg>
 <20120331201324.GA17565@redhat.com>
 <20120331203912.GB687@moon>
 <4F79755B.3030703@openvz.org>
 <20120402144821.GA3334@redhat.com>
 <4F79D1AF.7080100@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F79D1AF.7080100@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 08:19:59PM +0400, Konstantin Khlebnikov wrote:
> Oleg Nesterov wrote:
> >On 04/02, Konstantin Khlebnikov wrote:
> >>
> >>In this patch I leave mm->exe_file lockless.
> >>After exec/fork we can change it only for current task and only if mm->mm_users == 1.
> >>
> >>something like this:
> >>
> >>task_lock(current);
> >
> >OK, this protects against the race with get_task_mm()
> >
> >>if (atomic_read(&current->mm->mm_users) == 1)
> >
> >this means PR_SET_MM_EXE_FILE can fail simply because someone did
> >get_task_mm(). Or the caller is multithreaded.
> 
> This is sad, seems like we should keep mm->exe_file protection by mm->mmap_sem.
> So, I'll rework this patch...

Ah, it's about locking. I misundertand it at first.
Oleg, forget about my email then.

	Cyrill
