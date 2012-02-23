Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757237Ab2BWXB2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:01:28 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54252 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756508Ab2BWXB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:01:27 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.208.136 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Thu, 23 Feb 2012 15:01:23 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: axboe@kernel.dk, vgoyal@redhat.com, hughd@google.com, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120223230123.GL22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223144336.58742e1b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 23, 2012 at 02:43:36PM -0800, Andrew Morton wrote:
> On Thu, 23 Feb 2012 14:30:38 -0800
> Tejun Heo <tj@kernel.org> wrote:
> 
> > This patchset is combination of the patchset "block, mempool, percpu:
> > implement percpu mempool and fix blkcg percpu alloc deadlock" [1] and
> > patches to remove blkg->stats_lock.
> 
> What's changed since last time?  I scanned the changelogs to see how
> earlier issues were addressed and saw no mention of any of it.  eg, is
> the code still deadlockable if the allocator is called with __GFP_WAIT?

Hmmm... going through the thread again, ah, okay, I forgot about that
completely.  Yeah, that is an actual problem.  Both __GFP_WAIT which
isn't GFP_KERNEL and GFP_KERNEL are valid use cases.  I guess we'll be
building async percpu pool in blkcg then.  Great.  :(

-- 
tejun
