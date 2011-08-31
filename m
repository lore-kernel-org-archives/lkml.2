Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1HaVyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 17:54:36 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64159 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755795Ab1HaVya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 17:54:30 -0400
Date: Wed, 31 Aug 2011 23:54:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Paul Menage <paul@paulmenage.org>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Tim Hockin <thockin@hockin.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [RFD] Task counter: cgroup core feature or cgroup subsystem?
 (was Re: [PATCH 0/8 v3] cgroups: Task counter subsystem)
Message-ID: <20110831215423.GF20598@somewhere>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org>
 <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
 <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
 <20110818143319.GC10441@somewhere>
 <CALdu-PA3+u-v1fj-DQuC-zyJ4Ud0Xi0sq0zcB0DLNcR_TMT6XQ@mail.gmail.com>
 <20110824175431.GA26417@somewhere.redhat.com>
 <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALdu-PAiRgjFaERETAZVH=+Ky-0ekjBWn6aDK5Hzam1AQ7sC4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 26, 2011 at 08:16:32AM -0700, Paul Menage wrote:
> On Wed, Aug 24, 2011 at 10:54 AM, Frederic Weisbecker
> <fweisbec@gmail.com> wrote:
> >
> > It seems your patch doesn't handle the ->fork() and ->exit() calls.
> > We probably need a quick access to states of multi-subsystems from
> > the task, some lists available from task->cgroups, I don't know yet.
> >
> 
> That state is available, but currently only while holding cgroup_mutex
> - at least, that's what task_cgroup_from_root() requires.
> 
> It might be the case that we could achieve the same effect by just
> locking the task, so the pre-condition for task_cgroup_from_root()
> would be either that cgroup_mutex is held or the task lock is held.

Now I realize, is it necessary if we only want to access a subsys state
through task->cgroups->subsys[i] from the ->fork() callback?

The task is not yet added to the thread_group, its pid is not yet
hashed so I guess it can not concurrently be moved to another
cgroup.

We need a special flavour of task->cgroups->subsys for multi bindable
subsystem but that's the same.
