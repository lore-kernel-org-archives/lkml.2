Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757152Ab2BCQ6B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 11:58:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756875Ab2BCQ6A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 11:58:00 -0500
Date: Fri, 3 Feb 2012 17:51:32 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        Pedro Alves <pedro@codesourcery.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Roland McGrath <roland@redhat.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120203165132.GA5636@redhat.com>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org> <20120203162519.GB805@google.com> <4F2C0F13.70709@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F2C0F13.70709@parallels.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03, Pavel Emelyanov wrote:
>
> On 02/03/2012 08:25 PM, Tejun Heo wrote:
> > On Fri, Feb 03, 2012 at 02:11:23PM +0300, Andrew Vagin wrote:
> >> Zero is written at clear_tid_address, when the process exits.
> >> This functionality is used by pthread_join().
> >>
> >> sys_set_tid_address() changes this address for current task.
> >>
> >> Before this patch clear_tid_address could not be got from user space.
> >> I want to dump a full state of a task, so I need this address.
> >> Also I think it may be useful for debugging a multithreading program.
> >>
> >> I am not sure that ptrace is suitable place. It may be added in prctl,
> >> but I think it's a bit useless and strange. I can't image a real
> >> situation (avoid checkpointing) when a thread will want to get own
> >> clear_tid_address from itself, this address is used by parent ussually.
> >>
> >> Signed-off-by: Andrew Vagin <avagin@openvz.org>
> >
> > Ummm... this really doesn't fit in ptrace.  Cyrill, why not put it
> > together with other params you're exporting?
>
> Because there's no need for current to get this value of himself, but can
> be useful for e.g. gdb.

OK, perhaps this makes sense, I do not know.

Jan, Pedro, do you think gdb can use PTRACE_GET_TID_ADDRESS (returns
tracee->clear_child_tid) ?

Oleg.

