Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab1HISXJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:23:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54586 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751149Ab1HISXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:23:05 -0400
Date: Tue, 9 Aug 2011 20:19:47 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809181947.GB28442@redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-8-git-send-email-fweisbec@gmail.com> <20110809151155.GA15311@redhat.com> <20110809172746.GA31645@somewhere.redhat.com> <20110809175708.GA27866@redhat.com> <20110809180942.GC31645@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809180942.GC31645@somewhere.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Frederic Weisbecker wrote:
>
> On Tue, Aug 09, 2011 at 07:57:08PM +0200, Oleg Nesterov wrote:
> > > > cgroup_attach_proc() is different, it calls cgroup_task_migrate()
> > > > after ->attach_task(). Cough.
> > >
> > > That's bad. I need to fix that.
> > >
> > > So if it returns -ESRCH, I shall not call attach_task() on it
> > > but cancel_attach_task().
> >
> > Afaics this can't help, or I misunderstood. probably attach_task()
> > can check PF_EXITING...
>
> But cgroup_task_migrate() checks that already before migrating
> cgroups (checks PF_EXITING under task_lock() so that it's
> synchronized against cgroup_exit())

Yes, but how this can help?

->attach_task() is called before cgroup_task_migrate(). Suppose
that it exits before ->attach_task(). In this case we shouldn't
uncharge the old cgroup, it was already uncharged by cgroup_exit.

Oleg.

