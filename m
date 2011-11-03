Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934208Ab1KCRAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:00:50 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57223 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934085Ab1KCRAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:00:49 -0400
Date: Thu, 3 Nov 2011 18:00:42 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>, Tim Hockin <thockin@hockin.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111103170038.GG8198@somewhere.redhat.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111004150111.e9337268.akpm00@gmail.com>
 <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
 <20111028163021.1ce61f8a.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111028163021.1ce61f8a.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 04:30:21PM -0700, Andrew Morton wrote:
> On Tue, 25 Oct 2011 13:06:35 -0700
> Tim Hockin <thockin@hockin.org> wrote:
> 
> > On Tue, Oct 4, 2011 at 3:01 PM, Andrew Morton <akpm00@gmail.com> wrote:
> > > On Mon, __3 Oct 2011 21:07:02 +0200
> > > Frederic Weisbecker <fweisbec@gmail.com> wrote:
> > >
> > >> Hi Andrew,
> > >>
> > >> This contains minor changes, mostly documentation and changelog
> > >> updates, off-case build fix, and a code optimization in
> > >> res_counter_common_ancestor().
> > >
> > > I'd normally duck a patch series like this when we're at -rc8 and ask
> > > for it to be resent late in -rc1. __But I was feeling frisky so I
> > > grabbed this lot for a bit of testing and will sit on it until -rc1.
> > >
> > > I'm still not convinced that the kernel has a burning need for a "task
> > > counter subsystem". __Someone convince me that we should merge this!
> > 
> > We have real (accidental) DoS situations which happen because we don't
> > have this.  It usually takes the form of some library no re-joining
> > threads.  We end up deploying a few apps linked against this library,
> > and suddenly we're in trouble on a machine.  Except, this being
> > Google, we're in trouble on a lot of machines.
> 
> This is a bit foggy.  I think you mean that machines are experiencing
> accidental forkbombs?

I'd like to hear about more details as well.

> 
> > There may be other ways to cobble this sort of safety together, but
> > they are less appealing for various reasons.  cgroups are how we
> > control groups of related pids.
> > 
> > I'd really love to be able to use this.
> 
> Has it been confirmed that this implementation actually solves the
> problem?  ie: tested a bit?
> 
> btw, Frederic told me that this version of the patchset had some
> serious problem so it's on hold pending an upgrade, regardless of other
> matters.

Yep. The particular issue is https://lkml.org/lkml/2011/10/13/532

Li Zefan proposed a fix (https://lkml.org/lkml/2011/10/17/26) which I'm
currently reworking.

But then I'd love it if you can test this subsystem to see if it really matches
your needs, Tim.

Thanks!
