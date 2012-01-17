Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753070Ab2AQRxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 12:53:30 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:58004 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750752Ab2AQRx3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 12:53:29 -0500
Date: Tue, 17 Jan 2012 09:53:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Cgroups <cgroups@vger.kernel.org>,
        Lennart Poettering <mzxreary@0pointer.de>,
        Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 2/2] cgroup: add xattr support
Message-ID: <20120117175322.GC6762@google.com>
References: <4F13DA90.2000603@cn.fujitsu.com>
 <4F13DAA9.4070703@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F13DAA9.4070703@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Jan 16, 2012 at 04:07:05PM +0800, Li Zefan wrote:
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
> Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>

Ummm... I don't feel too good about this.  Why can't those extra
information be kept somewhere else?  Overloading cgroupfs as storage
for essentially opaque userland information doesn't seem like a good
idea to me.

Thanks.

-- 
tejun
