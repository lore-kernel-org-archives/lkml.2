Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933317Ab2HPUAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 16:00:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40004 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab2HPUAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 16:00:11 -0400
Date: Thu, 16 Aug 2012 13:00:06 -0700
From: Tejun Heo <tj@kernel.org>
To: aris@redhat.com
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        Li Zefan <lizefan@huawei.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>,
        Lennart Poettering <lpoetter@redhat.com>
Subject: Re: [PATCH v6 3/4] cgroup: add xattr support
Message-ID: <20120816200006.GG24861@google.com>
References: <20120816174453.154143248@napanee.usersys.redhat.com>
 <20120816174454.087507415@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816174454.087507415@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:44:56PM -0400, aris@redhat.com wrote:
> From: Li Zefan <lizefan@huawei.com>
> 
> This is one of the items in the plumber's wish list.
> 
> For use cases:
> 
> >> What would the use case be for this?
> >
> > Attaching meta information to services, in an easily discoverable
> > way. For example, in systemd we create one cgroup for each service, and
> > could then store data like the main pid of the specific service as an
> > xattr on the cgroup itself. That way we'd have almost all service state
> > in the cgroupfs, which would make it possible to terminate systemd and
> > later restart it without losing any state information. But there's more:
> > for example, some very peculiar services cannot be terminated on
> > shutdown (i.e. fakeraid DM stuff) and it would be really nice if the
> > services in question could just mark that on their cgroup, by setting an
> > xattr. On the more desktopy side of things there are other
> > possibilities: for example there are plans defining what an application
> > is along the lines of a cgroup (i.e. an app being a collection of
> > processes). With xattrs one could then attach an icon or human readable
> > program name on the cgroup.
> >
> > The key idea is that this would allow attaching runtime meta information
> > to cgroups and everything they model (services, apps, vms), that doesn't
> > need any complex userspace infrastructure, has good access control
> > (i.e. because the file system enforces that anyway, and there's the
> > "trusted." xattr namespace), notifications (inotify), and can easily be
> > shared among applications.
> >
> > Lennart
> 
> v6:
> - remove user xattr namespace, only allow trusted and security
> v5:
> - check for capabilities before setting/removing xattrs
> v4:
> - no changes
> v3:
> - instead of config option, use mount option to enable xattr support
> 
> Cc: Li Zefan <lizefan@huawei.com>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Hillf Danton <dhillf@gmail.com>
> Cc: Lennart Poettering <lpoetter@redhat.com>
> Signed-off-by: Li Zefan <lizefan@huawei.com>
> Signed-off-by: Aristeu Rozanski <aris@redhat.com>

I'm not against this but unsure whether using kmem is enough for the
suggested use case.  Lennart, would this suit systemd?  How much
metadata are we talking about?

Thanks.

-- 
tejun
