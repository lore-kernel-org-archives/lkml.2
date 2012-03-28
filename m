Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758372Ab2C1QVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 12:21:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22965 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758118Ab2C1QVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 12:21:17 -0400
Date: Wed, 28 Mar 2012 12:21:08 -0400
From: Jason Baron <jbaron@redhat.com>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Hagen Paul Pfeifer <hagen@jauu.net>, torvalds@linux-foundation.org,
        LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120328162108.GB2381@redhat.com>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
 <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 28, 2012 at 04:09:24PM +0200, richard -rw- weinberger wrote:
> On Wed, Mar 28, 2012 at 3:57 PM, Hagen Paul Pfeifer <hagen@jauu.net> wrote:
> > High performance server sometimes create one listening socket (e.g. port
> > 80), create a epoll file descriptor and add the socket. Afterwards
> > create SC_NPROCESSORS_ONLN threads and wait for events. This often
> > result in a thundering herd problem because all CPUs are scheduled.
> >
> > This patch add an additional flag to epoll_ctl(2) called EPOLLEXCLUSIVE.
> > If a descriptor is added with this flag only one CPU is scheduled in.
> >
> > Signed-off-by: Hagen Paul Pfeifer <hagen@jauu.net>
> > ---
> > Dave rejected the patch and said not network specific. Because there
> > is no epoll maintainer this time directly.
> 
> CC'ing maintainers for you...
> Please use scripts/get_maintainer.pl.
> 

Hmmm...Looking at ep_poll() it does an '__add_wait_queue_exclusive()'.
So, I *think* epoll_wait() should do what you want, if you are waiting
on the same epfd in all the threads.

I think the case you are describing is where each thread does its own
ep_create(), and then a subsequent epoll_wait() on the fd from the
create?

So, I *think* you can get what you want without adding this flag.

Thanks,

-Jason
