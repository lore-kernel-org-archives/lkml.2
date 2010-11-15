Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371Ab0KOJ7X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 04:59:23 -0500
Received: from smtp-out.google.com ([216.239.44.51]:52964 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755290Ab0KOJ7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Nov 2010 04:59:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=IUc6/9qKwtOvJO/yQ3CB/96otyGVBKpCkF80nWy1MFBIn0HZvMPW3pWMOVR0gNyguV
         mCphF94OwNXNEmbCKWYQ==
Date: Mon, 15 Nov 2010 01:59:12 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>
Subject: Re: [resend][PATCH 2/4] Revert "oom: deprecate oom_adj tunable"
In-Reply-To: <20101115092238.BEEE.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1011150152490.2986@chino.kir.corp.google.com>
References: <20101109105801.BC30.A69D9226@jp.fujitsu.com> <20101109122817.BC5A.A69D9226@jp.fujitsu.com> <20101115092238.BEEE.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 15 Nov 2010, KOSAKI Motohiro wrote:

> At v2.6.36-rc1, oom-killer doesn't work at all because YOU BROKE.
> And I was working on fixing it.
> 
> 2010-08-19
> http://marc.info/?t=128223176900001&r=1&w=2

This existed before my oom killer rewrite, it was only noticed because the 
rewrite enabled oom_dump_tasks by default.

> http://marc.info/?t=128221532700003&r=1&w=2

Yes, tasklist_lock was dropped in a mismerge of my patches when posting 
them.  Thanks for finding it and posting a patch, I appreciate it.

> http://marc.info/?t=128221532500008&r=1&w=2
> 

Yes, if a task was racing between oom_kill_process() and oom_kill_task() 
and all threads had dropped its mm between calls then there was a NULL 
pointer dereference, thanks for fixing that as well.

> However, You submitted new crap before the fixing. 
> 
> 2010-08-15
> http://marc.info/?t=128184669600001&r=1&w=2
> 

This isn't "crap", this is a necessary bit to ensure that tasks that share 
an ->mm with a task immune from kill aren't killed themselves since we 
can't free the memory.  We came to the consensus that it would be better 
to count the tasks that are OOM_DISABLE in the mm_struct to avoid the 
O(2*n) tasklist scan.

> If you tested mainline a bit, you could find the problem quickly.
> You should have fixed mainline kernel at first.
> 

Thanks for finding a couple fixes during the 2.6.36-rc1 when the rewrite 
was first merged, it's much appreciated!
