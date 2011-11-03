Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934123Ab1KCQt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 12:49:28 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:45288 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933891Ab1KCQt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 12:49:27 -0400
Date: Thu, 3 Nov 2011 17:49:21 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Glauber Costa <glommer@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Glauber Costa <glommer@parallels.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111103164917.GF8198@somewhere.redhat.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com>
 <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
 <20111028163021.1ce61f8a.akpm@linux-foundation.org>
 <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA6-i6o0SPfZJDx4SRR1hY-He0L6zHuv0saH6EaE7Mrc2HF6PA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 29, 2011 at 11:38:25AM +0200, Glauber Costa wrote:
> On Sat, Oct 29, 2011 at 1:30 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> > On Tue, 25 Oct 2011 13:06:35 -0700
> > Tim Hockin <thockin@hockin.org> wrote:
> >
> >> On Tue, Oct 4, 2011 at 3:01 PM, Andrew Morton <akpm00@gmail.com> wrote:
> >> > On Mon, __3 Oct 2011 21:07:02 +0200
> >> > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> >> >
> >> >> Hi Andrew,
> >> >>
> >> >> This contains minor changes, mostly documentation and changelog
> >> >> updates, off-case build fix, and a code optimization in
> >> >> res_counter_common_ancestor().
> >> >
> >> > I'd normally duck a patch series like this when we're at -rc8 and ask
> >> > for it to be resent late in -rc1. __But I was feeling frisky so I
> >> > grabbed this lot for a bit of testing and will sit on it until -rc1.
> >> >
> >> > I'm still not convinced that the kernel has a burning need for a "task
> >> > counter subsystem". __Someone convince me that we should merge this!
> >>
> >> We have real (accidental) DoS situations which happen because we don't
> >> have this.  It usually takes the form of some library no re-joining
> >> threads.  We end up deploying a few apps linked against this library,
> >> and suddenly we're in trouble on a machine.  Except, this being
> >> Google, we're in trouble on a lot of machines.
> >
> > This is a bit foggy.  I think you mean that machines are experiencing
> > accidental forkbombs?
> >
> >> There may be other ways to cobble this sort of safety together, but
> >> they are less appealing for various reasons.  cgroups are how we
> >> control groups of related pids.
> >>
> 
> In the end of the day, all cgroups are just a group of tasks. So I don't really
> get the need to have a cgroup to control the number of tasks in the system.
> 
> Why don't we just allow all cgroups to have a limit on the number of
> tasks it can hold?

Not sure what you mean. You would prefer to have this as a core feature in
cgroups rather than a subsystem?
