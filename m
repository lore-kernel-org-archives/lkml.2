Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757432Ab2BWXZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 18:25:06 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64074 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756566Ab2BWXZD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 18:25:03 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.225.73 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Thu, 23 Feb 2012 15:24:58 -0800
From: Tejun Heo <tj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: vgoyal@redhat.com, axboe@kernel.dk, hughd@google.com, avi@redhat.com,
        nate@cpanel.net, cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120223232458.GN22536@google.com>
References: <1330036246-21633-1-git-send-email-tj@kernel.org>
 <20120223144336.58742e1b.akpm@linux-foundation.org>
 <20120223230123.GL22536@google.com>
 <20120223231204.GM22536@google.com>
 <20120223152223.43c72ccb.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120223152223.43c72ccb.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew.

On Thu, Feb 23, 2012 at 03:22:23PM -0800, Andrew Morton wrote:
> I forget how those patches work, but they might be vulnerable to the
> same issue.  If the block layer can handle the failed allocation
> attempt and retry at the next I/O event then I guess that would be
> acceptable; we'd lose a bit of statistical info occasionally, but who
> cares.
>
> But ISTR that we can't handle allocation failures here?

It's just gonna skip percpu stats.  The problem with percpu mempool is
more about what __GFP_WAIT means in the interface.  Handling alloc
failure isn't difficult at all.

Thanks.

-- 
tejun
