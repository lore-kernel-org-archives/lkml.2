Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0CZMzH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 08:55:07 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:35330 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab0CZMzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 08:55:03 -0400
Date: Fri, 26 Mar 2010 05:54:59 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Grzegorz Nosek <root@localdomain.pl>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
       Roland McGrath <roland@redhat.com>,
       Sukadev Bhattiprolu <sukadev@us.ibm.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: Testing lxc 0.6.5 in Fedora 13
Message-ID: <20100326125459.GD3345@count0.beaverton.ibm.com>
References: <20100321195044.GA23757@megiteam.pl>
 <20100323212834.GH20796@count0.beaverton.ibm.com>
 <20100325213356.GB20541@megiteam.pl>
 <20100326111131.GA8604@redhat.com>
 <20100326115357.GA3345@count0.beaverton.ibm.com>
 <20100326124522.GD17113@megiteam.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100326124522.GD17113@megiteam.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 26, 2010 at 01:45:22PM +0100, Grzegorz Nosek wrote:
> On Fri, Mar 26, 2010 at 04:53:57AM -0700, Matt Helsley wrote:
> > Yup. strace would need to be modified to use that. I tried that and it still
> > won't work -- I seem to recall it didn't work because strace uses pid values
> > obtained from the wait syscall too. To make it work we'd need to be able to
> > translate those pids in userspace. That's do-able from userspace if you trace
> > all forks descending from the pidns init task. But it's not do-able for
> > simple attaches. That's why I was thinking Eric's setns() might be able to
> > help if strace used it to enter the tracee's pid namespace whenever we need to.
> > 
> > gdb often doesn't use the same methods but has similar problems with pid
> > namespaces.
> 
> Hmm, is there a good reason why strace does not use the data explicitly
> provided by the kernel but instead second-guesses it from syscall return
> values? I don't know anything about ptrace, really, but I'd expect the

strace isn't linux-only. Checking the syscall return values may be seen
as being more portable. At least that's my guess. That said there are
plenty of #ifdefs in strace and patching it to use GETEVENTMSG is quite
a small patch.

However, as I said, that still doesn't "fix" strace so that it can
be used to trace tasks in child pid namespaces. Especially when the
traced tasks are more than one namepace deeper. :(

> kernel to provide the tracer with out-of-band information otherwise
> taken from clone/waitpid/other syscalls?

I don't think the kernel provides special out-of-band methods for fetching
pids related to traced tasks except during fork and clone. Not wait*(). The
rest of ptrace tends to be focused on reading/writing registers/memory and
managing signal delivery.

Cheers,
	-Matt Helsley
