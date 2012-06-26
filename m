Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2FZUNp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 16:13:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34252 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751590Ab2FZUNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 16:13:44 -0400
Date: Tue, 26 Jun 2012 13:13:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Stefan Bader <stefan.bader@canonical.com>, mingo@kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Andrew Vagin <avagin@openvz.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH] sched: Fix race in task_group()
Message-ID: <20120626201339.GU3869@google.com>
References: <1340364965.18025.71.camel@twins>
 <4FE48A09.7050305@canonical.com>
 <1340718515.21991.83.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340718515.21991.83.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 03:48:35PM +0200, Peter Zijlstra wrote:
> Here's one that's actually compile tested (with the right CONFIG_foo
> enabled) and I fixed the autogroup lockdep splat.
> 
> ---
> Subject: sched: Fix race in task_group()
> From: Peter Zijlstra <peterz@infradead.org>
> Date: Fri, 22 Jun 2012 13:36:05 +0200
> 
> Stefan reported a crash on a kernel before a3e5d1091c1 ("sched: Don't
> call task_group() too many times in set_task_rq()"), he found the reason
> to be that the multiple task_group() invocations in set_task_rq()
> returned different values.

Hmm... short of intertwining locking further I don't think we can
solve this in prettier way.  So, yeah, looks good to me from cgroup
POV.

> Looking at all that I found a lack of serialization and plain wrong
> comments.
> 
> The below tries to fix it using an extra pointer which is updated under
> the appropriate scheduler locks. Its not pretty, but I can't really see
> another way given how all the cgroup stuff works.

BTW your patch is whitespace broken.  Seems like QP encoded.

Thanks.

-- 
tejun
