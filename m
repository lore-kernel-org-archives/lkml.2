Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933610Ab2C2Pxi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 11:53:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1441 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932608Ab2C2Pxa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 11:53:30 -0400
Date: Thu, 29 Mar 2012 11:53:24 -0400
From: Jason Baron <jbaron@redhat.com>
To: Hagen Paul Pfeifer <hagen@jauu.net>
Cc: richard -rw- weinberger <richard.weinberger@gmail.com>,
        torvalds@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH Resend] epoll: add EPOLLEXCLUSIVE support
Message-ID: <20120329155323.GB2424@redhat.com>
References: <1332943060-18374-1-git-send-email-hagen@jauu.net>
 <CAFLxGvx0m6iaDPTDkjzw6ohX6Wdmr+DgWEr_fMdyEux50JVFEw@mail.gmail.com>
 <20120328162108.GB2381@redhat.com>
 <20120328195848.GA5331@hell>
 <20120329141653.GA2424@redhat.com>
 <20120329150541.GB3173@hell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329150541.GB3173@hell>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 05:05:41PM +0200, Hagen Paul Pfeifer wrote:
> * Jason Baron | 2012-03-29 10:16:53 [-0400]:
> 
> >Right, for level triggered events, they all wait up. However, if you use
> >edge triggered, ie add 'EPOLLET', then the event gets 'consumed' by the
> >first thread that wakes up, and the subseqent waiters wouldn't get woken
> >up. IE you'll get one wakeup.
> 
> I addressed level triggered, right - it match the model. But I don't wanted to
> wake up every every thread anyway. I don't want to abandon level triggered
> functioning.
> 
> Any objective against this flag?
> 

I was trying to better understand the use-case, since at least for the
test case you posted, 'EPOLLET', already does what you want.

Also, the 'EPOLLEXCLUSIVE' flag in your patch addresses multiple threads
blocking on *different* epoll fds. However, if multiple threads are
blocked on a single epoll fd, they will all be woken even if 'EPOLLEXCLUSIVE'
is set. Shouldn't 'EPOLLEXCLUSIVE' affect that case too?

Thanks,

-Jason
