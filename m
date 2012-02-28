Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965838Ab2B1Rrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:47:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12744 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965345Ab2B1Rrw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:47:52 -0500
Date: Tue, 28 Feb 2012 18:40:50 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Siddhesh Poyarekar <siddhesh.poyarekar@gmail.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jamie Lokier <jamie@shareable.org>, Mike Frysinger <vapier@gentoo.org>,
        Alexey Dobriyan <adobriyan@gmail.com>, Matt Mackall <mpm@selenic.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + procfs-mark-thread-stack-correctly-in-proc-pid-maps.patch
	added to -mm tree
Message-ID: <20120228174049.GA11136@redhat.com>
References: <20120228170436.GA9698@redhat.com> <CAAHN_R1hmJt4zCxGAL7z2-9URmWUFwwV9pcqkdvQZodpunEJjQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAHN_R1hmJt4zCxGAL7z2-9URmWUFwwV9pcqkdvQZodpunEJjQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/28, Siddhesh Poyarekar wrote:
>
> On Tue, Feb 28, 2012 at 10:34 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> +int vm_is_stack(struct task_struct *task,
> >> +                           struct vm_area_struct *vma, int in_group)
> >> +{
> >> +     if (vm_is_stack_for_task(task, vma))
> >> +             return 1;
> >> +
> >> +     if (in_group) {
> >> +             struct task_struct *t = task;
> >> +             while_each_thread(task, t) {
> >> +                     if (vm_is_stack_for_task(t, vma))
> >> +                             return 1;
> >> +             }
> >> +     }
> >> +
> >> +     return 0;
> >> +}
> >
> > This is obviously wrong, while_each_thread() is not safe without
> > tasklist or siglock or rcu.
>
> I have fixed this in my git stash. I'll submit

OK, please CC me ;)

Oleg.

