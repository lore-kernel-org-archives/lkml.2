Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756092Ab1LVWVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 17:21:01 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44916 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751914Ab1LVWU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 17:20:59 -0500
Date: Thu, 22 Dec 2011 14:20:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: avi@redhat.com, nate@cpanel.net, cl@linux-foundation.org, oleg@redhat.com,
        axboe@kernel.dk, vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-Id: <20111222142058.41316ee0.akpm@linux-foundation.org>
In-Reply-To: <20111222220911.GK17084@google.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
	<20111222135925.de3221c8.akpm@linux-foundation.org>
	<20111222220911.GK17084@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Dec 2011 14:09:11 -0800
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Thu, Dec 22, 2011 at 01:59:25PM -0800, Andrew Morton wrote:
> > How about we just delete those statistics and then this patchset?
> > 
> > Or how about we change those statistics to not do percpu allocations,
> > then delete this patchset?
> 
> I'm not against above both

Don't just consider my suggestions - please try to come up with your own
alternatives too!  If all else fails then this patch is a last resort.

> but apparently those percpu stats reduced
> CPU overhead significantly.

Deleting them would save even more CPU.

Or make them runtime or compile-time configurable, so only the
developers see the impact.

Some specifics on which counters are causing the problems would help here.

> > Or how about we fix the percpu memory allocation code so that it
> > propagates the gfp flags, then delete this patchset?
> 
> Oh, no, this is gonna make things *way* more complex.  I tried.

But there's a difference between fixing a problem and working around it.

>  If
> we're gonna have many more NOIO percpu users, which I don't think we
> would or should, that might make sense but, for fringe cases,
> extending mempool to cover percpu is a much better sized solution.

I've long felt that we goofed with the gfp_flags thing and that it
should be a field in the task_struct.  Now *that* would be a large
patch!


