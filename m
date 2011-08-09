Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1HISlx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 14:41:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab1HISlv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 14:41:51 -0400
Date: Tue, 9 Aug 2011 20:39:00 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>
Subject: Re: [PATCH 7/8] cgroups: Add a task counter subsystem
Message-ID: <20110809183900.GA29472@redhat.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com> <1311956010-32076-8-git-send-email-fweisbec@gmail.com> <20110809151155.GA15311@redhat.com> <20110809172746.GA31645@somewhere.redhat.com> <20110809175708.GA27866@redhat.com> <20110809180942.GC31645@somewhere.redhat.com> <20110809181947.GB28442@redhat.com> <20110809183402.GD31645@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110809183402.GD31645@somewhere.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09, Frederic Weisbecker wrote:
>
> On Tue, Aug 09, 2011 at 08:19:47PM +0200, Oleg Nesterov wrote:
> >
> > Yes, but how this can help?
> >
> > ->attach_task() is called before cgroup_task_migrate(). Suppose
> > that it exits before ->attach_task(). In this case we shouldn't
> > uncharge the old cgroup, it was already uncharged by cgroup_exit.
>
> Yeah that's why in cgroup_attach_proc() we need to call cgroup_task_migrate()
> before ->attach_task(), as it's done in cgroup_attach_task().

Agreed. I do not undertand why attach task/proc should differ. This
doesn't look good even if (currently) correct.

> And also call
> cancel_attach_task() if it fails there with -ESRCH without cancelling
> the whole group attachment.

Probably... and attach_task() should do the same.

Oleg.

