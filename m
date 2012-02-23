Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757436Ab2BWXW1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:22:27 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:45834 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884Ab2BWXWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:22:25 -0500
Date: Thu, 23 Feb 2012 15:22:23 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: vgoyal@redhat.com, axboe@kernel.dk, hughd@google.com, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-Id: <20120223152223.43c72ccb.akpm@linux-foundation.org>
In-Reply-To: <20120223231204.GM22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
	<20120223144336.58742e1b.akpm@linux-foundation.org>
	<20120223230123.GL22536@google.com>
	<20120223231204.GM22536@google.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Feb 2012 15:12:04 -0800
Tejun Heo <tj@kernel.org> wrote:

> On Thu, Feb 23, 2012 at 03:01:23PM -0800, Tejun Heo wrote:
> > Hmmm... going through the thread again, ah, okay, I forgot about that
> > completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
> > isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
> > building async percpu pool in blkcg then.  Great.  :(
> 
> Vivek, you win. :) Can you please refresh the async alloc patch on top
> of blkcg-stacking branch?  I'll rool that into this series and drop
> the mempool stuff.

I forget how those patches work, but they might be vulnerable to the
same issue.  If the block layer can handle the failed allocation
attempt and retry at the next I/O event then I guess that would be
acceptable; we'd lose a bit of statistical info occasionally, but who
cares.

But ISTR that we can't handle allocation failures here?
