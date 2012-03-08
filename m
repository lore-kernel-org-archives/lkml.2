Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758685Ab2CHUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 15:35:44 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50000 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753165Ab2CHUfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 15:35:40 -0500
Date: Thu, 8 Mar 2012 12:35:35 -0800
From: Tejun Heo <tj@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, axboe@kernel.dk,
        hughd@google.com, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, linux-kernel@vger.kernel.org,
        dpshah@google.com, ctalbott@google.com, rni@google.com
Subject: Re: [PATCHSET] mempool, percpu, blkcg: fix percpu stat allocation
 and remove stats_lock
Message-ID: <20120308203535.GE25508@google.com>
References: <20120306210954.GF32148@redhat.com>
 <20120306132034.ecaf8b20.akpm@linux-foundation.org>
 <20120306213437.GG32148@redhat.com>
 <20120306135531.828ca78e.akpm@linux-foundation.org>
 <20120307145556.GA11262@redhat.com>
 <20120307150549.955d6f9c.akpm@linux-foundation.org>
 <20120308175708.GB22922@redhat.com>
 <20120308180833.GA25508@google.com>
 <20120308201616.GD22922@redhat.com>
 <20120308203331.GE22922@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308203331.GE22922@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Vivek.

On Thu, Mar 08, 2012 at 03:33:31PM -0500, Vivek Goyal wrote:
> Ok, I can confirm that it is cfqq reference on blkg which is an issue. If
> I move my shell to a child cgroup and try to do some operations (in the
> context of shell, like autocompletion/reading an uncached dir), then IO
> is issued in the context of shell, I move out the shell out of cgroup and
> then try to delete it, it hangs. Once I exit out of shell, blkg reference
> is dropped and cgroup is deleted.
> 
> So we do need to cleanup the cic->cfqq upon cgroup change synchronously.

I see.  Thanks for confirming the problem.

> That will still not solve the issue of a process dumping tons of
> IO on device (large nr_requests) and then moving out of cgroup. Now
> cgroup deletion will still hang till all the IO in the cgroup
> completes.

I don't think the latter is too much of a problem.  I've been meaning
to decouple destruction from ref putting anyway, so let's see whether
that's possible.

Thanks.

-- 
tejun
