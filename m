Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab0FCOGA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 10:06:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754309Ab0FCOF6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 10:05:58 -0400
Date: Thu, 3 Jun 2010 16:03:57 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Roland McGrath <roland@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-mm <linux-mm@kvack.org>,
       David Rientjes <rientjes@google.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Nick Piggin <npiggin@suse.de>
Subject: Re: [PATCH] oom: Make coredump interruptible
Message-ID: <20100603140357.GB3548@redhat.com>
References: <20100601093951.2430.A69D9226@jp.fujitsu.com> <20100601201843.GA20732@redhat.com> <20100602221805.F524.A69D9226@jp.fujitsu.com> <20100602154210.GA9622@redhat.com> <20100602172956.5A3E34A491@magilla.sf.frob.com> <20100602175325.GA16474@redhat.com> <20100602185812.4B5894A549@magilla.sf.frob.com> <20100602203827.GA29244@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100602203827.GA29244@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02, Oleg Nesterov wrote:
>
> On 06/02, Roland McGrath wrote:
> >
> > > when select_bad_process() finds the task P to kill it can participate
> > > in the core dump (sleep in exit_mm), but we should somehow inform the
> > > thread which actually dumps the core: P->mm->core_state->dumper.
> >
> > Perhaps it should simply do that: if you would choose P to oom-kill, and
> > P->mm->core_state!=NULL, then choose P->mm->core_state->dumper instead.
>
> ... to set TIF_MEMDIE which should be checked in elf_core_dump().
>
> Probably yes.

Well, nothing can protect mm->core_state, the dumper owns it. Of course
we can add the locking, but this is not nice.

And again, perhaps MMF_OOMKILLED can be useful anyway.

So, I think this would be the most quick/simple fix for now.

Oleg.

