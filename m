Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab2BHTJW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 14:09:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56739 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753362Ab2BHTJV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 14:09:21 -0500
Date: Wed, 8 Feb 2012 20:02:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pedro Alves <palves@redhat.com>
Cc: Cyrill Gorcunov <gorcunov@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120208190250.GA23163@redhat.com>
References: <20120203162519.GB805@google.com> <4F2C0F13.70709@parallels.com> <20120203165132.GA5636@redhat.com> <4F31848A.9070406@redhat.com> <20120207205639.GJ27437@moon> <4F31945B.5000304@redhat.com> <20120207215121.GB29773@moon> <4F326AF7.3060203@redhat.com> <20120208173103.GA20853@redhat.com> <4F32B924.8080407@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F32B924.8080407@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/08, Pedro Alves wrote:
>
> On 02/08/2012 05:31 PM, Oleg Nesterov wrote:
> > On 02/08, Pedro Alves wrote:
> >>
> >> I just tried it.  This is &pthread->tid in glibc/libpthread, so with debug
> >> info it's easy to figure out where to set the watchpoint manually with gdb
> >> without asking the kernel.  Doesn't work.  ptrace doesn't show any trap
> >> for the kernel writes.
> >
> > The tracee simply can't report this trap. it is already dead ;) and
> > hw breakpoint (used by ptrace) is "pinned" to the thread.
>
> Right, as I said.  :-)  I saw that a watchpoint trap isn't reported either
> for the CLONE_CHILD_SETTID case (that is, within clone, when the kernel
> writes the tid to the memory address passed in to the clone syscall).

Yes. But in this case the new thread has no bps even if it is auto-
attached.

IOW, I think that hw bp can detect the write from the kernel space,
but I didn't check.

> I wouldn't have been surprised to see the trap in userspace in either
> the parent

It would be just wrong. Please note that it is child, not parent, who
does the write.




If only I understood why do we need CLONE_CHILD_SETTID... at least
I certainly do not understand why glibc translates fork() into
clone(CLONE_CHILD_SETTID) on my system. The child write into its
memory, the parent can't see this change. IIRC, initially
CLONE_CHILD_SETTID wrote child->pid into the parent's memory, and
even before the child was actually created.

Oleg.

