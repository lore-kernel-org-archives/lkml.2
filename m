Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933540Ab2BBT6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 14:58:51 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36799 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933526Ab2BBT6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 14:58:50 -0500
Date: Thu, 2 Feb 2012 11:58:49 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Dave Young <hidave.darkstar@gmail.com>, Dave Young <dyoung@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] move vm tools from Documentation/vm/ to tools/
Message-Id: <20120202115849.478b8513.akpm@linux-foundation.org>
In-Reply-To: <4F2A3C27.5080504@gmail.com>
References: <20120201063420.GA10204@darkstar.nay.redhat.com>
	<20120201131746.07e2219e.akpm@linux-foundation.org>
	<CABqxG0fyH89YP+jpZ5nJoVfzOQ++J4EfGP42FtjxAv7OY9o+5w@mail.gmail.com>
	<4F2A3C27.5080504@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 02 Feb 2012 15:32:55 +0800
Cong Wang <xiyou.wangcong@gmail.com> wrote:

> On 02/02/2012 10:13 AM, Dave Young wrote:
> > On Thu, Feb 2, 2012 at 5:17 AM, Andrew Morton<akpm@linux-foundation.org>  wrote:
> >> On Wed, 1 Feb 2012 14:34:20 +0800
> >> Dave Young<dyoung@redhat.com>  wrote:
> >>
> >>> tools/ is the better place for vm tools which are used by many people.
> >>> Moving them to tools also make them open to more users instead of hide in
> >>> Documentation folder.
> >>>
> >>
> >> It would be nice to covert these into simple pass/fail tests and
> >> promote them to tools/testing/selftests/.
> >
> > Andrew, I'm not clear about this, do you means to selftest
> > hugepage-mmap.c,  hugepage-shm.c  and map_hugetlb.c? I think slabinfo
> > and page-types should stay in tools/vm/. Can you explain a bit?
> >
> 
> Hey,
> 
> Check the comments in these files:
> 
> /*
>   * hugepage-mmap:
>   *
>   * Example of using huge page memory in a user application using the mmap
>   * system call.
> 
> 
> /*
>   * hugepage-shm:
>   *
>   * Example of using huge page memory in a user application using Sys V 
> shared
>   * memory system calls.  In this example the app is requesting 256MB of
>   * memory that is backed by huge pages.  The application uses the flag
>   * SHM_HUGETLB in the shmget system call to inform the kernel that it is
>   * requesting huge pages.
> 
> 
> /*
>   * Example of using hugepage memory in a user application using the mmap
>   * system call with MAP_HUGETLB flag.
> 
> All of them are examples, not tests, not tools, thus Documentation/ is 
> the best place for them.

um, read the code?  All three programs are exactly pass/fail selftests.

They are very simplistic selftests and perhaps one day we'll write more
sophisticated selftest code.  If we were to do this then these files
over in tools/vm would become obsolete.  So we should put these into
tools/testing/selftests/ on day one.
