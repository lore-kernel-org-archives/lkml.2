Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab1LWOri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 09:47:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48036 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab1LWOrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 09:47:37 -0500
Date: Fri, 23 Dec 2011 09:46:47 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tejun Heo <tj@kernel.org>, avi@redhat.com, nate@cpanel.net,
        cl@linux-foundation.org, oleg@redhat.com, axboe@kernel.dk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET] block, mempool, percpu: implement percpu mempool and
 fix blkcg percpu alloc deadlock
Message-ID: <20111223144647.GA16818@redhat.com>
References: <1324590326-10135-1-git-send-email-tj@kernel.org>
 <20111222135925.de3221c8.akpm@linux-foundation.org>
 <20111222220911.GK17084@google.com>
 <20111222142058.41316ee0.akpm@linux-foundation.org>
 <20111223014043.GC12738@redhat.com>
 <20111222175834.66559c8b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111222175834.66559c8b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 22, 2011 at 05:58:34PM -0800, Andrew Morton wrote:
> On Thu, 22 Dec 2011 20:40:43 -0500 Vivek Goyal <vgoyal@redhat.com> wrote:
> 
> > That's why the need of per cpu data structures to make stat collection
> > lockless.
> 
> btw, (and this is a common refrain): was there any reason for avoiding
> using percpu_counters here?

IIUC, per cpu counters also call alloc_percpu() during initialization.

int __percpu_counter_init(struct percpu_counter *fbc, s64 amount,
                          struct lock_class_key *key)
{
        raw_spin_lock_init(&fbc->lock);
        lockdep_set_class(&fbc->lock, key);
        fbc->count = amount;
        fbc->counters = alloc_percpu(s32);
....
....
}

So they are no good either for allocation and initialization in IO path.

Thanks
Vivek
