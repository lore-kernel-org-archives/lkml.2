Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755876Ab1LMUtZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 15:49:25 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59686 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753692Ab1LMUtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 15:49:24 -0500
Date: Tue, 13 Dec 2011 12:49:18 -0800
From: Tejun Heo <tj@kernel.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tim Hockin <thockin@hockin.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
Message-ID: <20111213204918.GK25802@google.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com>
 <20111213155848.GI25802@google.com>
 <20111213190642.GB2421@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111213190642.GB2421@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 13, 2011 at 08:06:46PM +0100, Frederic Weisbecker wrote:
> On Tue, Dec 13, 2011 at 07:58:48AM -0800, Tejun Heo wrote:
> > Can you please rebase the patchset on top of cgroup/for-3.3?
> 
> Sure. But please note its fate is still under discussion. Whether
> we want it upstream is still a running debate. But I certainly
> need to rebase against your tree.

I see.

> > I primarily like the idea of being able to track process usage w/ cgroup
> > and enforce limits on it but hope that it could somehow integrate w/
> > cgroup freezer.  ie. trigger freezer if it goes over limit and let the
> > userland tool / administrator deal with the frozen cgroup.  I'm
> > planning on extending cgroup freezer such that it supports recursive
> > freezing and killing of frozen tasks.  If we can fit task counters
> > into that, we'll have general method of handling problematic cgroups -
> > freeze, notify userland and let it deal with it.
> 
> Hmm, so you suggest a kernel trigger that freeze the cgroup when the
> task limit is reached?

Yeah, something like that.  I'm not really sure about how it would
actually work tho.

> What about rather implementing register_event() for the tasks.usage such
> that the user can be notified using eventfd when the limit is reached.
> Then it would be up to the user to decide to freeze or any other thing.
> Sounds like a more generic solution.

Maybe, the problem would be how to ensure that the userland manager
can respond fast enough (whatever that means...).

Thanks.

-- 
tejun
