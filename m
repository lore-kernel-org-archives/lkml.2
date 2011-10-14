Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932272Ab1JNQTz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 12:19:55 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56844 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab1JNQTy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 12:19:54 -0400
Date: Fri, 14 Oct 2011 18:19:50 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        lennart@poettering.net, harald@redhat.com, david@fubar.dk,
        greg@kroah.com, "Kirill A. Shutemov" <kirill@shutemov.name>,
        Oleg Nesterov <oleg@redhat.com>, Paul Menage <paul@paulmenage.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111014161946.GR14968@somewhere>
References: <1317943022.1095.25.camel@mop>
 <20111011161600.6145aa6b.akpm@linux-foundation.org>
 <20111012005935.GD14968@somewhere>
 <20111012174014.GE6281@google.com>
 <20111012181641.GZ15413@moon>
 <20111014153844.GP14968@somewhere>
 <20111014160110.GS14464@moon>
 <20111014160809.GT14464@moon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111014160809.GT14464@moon>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 08:08:09PM +0400, Cyrill Gorcunov wrote:
> On Fri, Oct 14, 2011 at 08:01:10PM +0400, Cyrill Gorcunov wrote:
> ...
> > > Well, wouldn't it be better to pull that complexity to userspace?
> > > After all, moving tasks from a cgroup to another is not a performance
> > > critical operation so that probably doesn't need to be all handled by
> > > the kernel.
> > > 
> > > If one worries about concurrent clone/fork while moving tasks, then
> > > freezing the cgroup and moving its tasks away from userspace could
> > > be enough?
> > 
> > Well, it's not that problem to make it task-by-task, still I think
> > it's just a convenient shortcut :)
> > 
> 
> Frederic, don't get me wrong, but when I've tried cgroups and freezer for
> first time (and I did it not by any script but by hands rather) it makes
> me scream out that once I've moved a number of tasks to some freezer cgroup
> now I need to move them back again. Of course there is a way to write some
> script of whatever but I thought we had some echo -1 shortcut. Anyway,
> I can live with it ;)

Using a script would be a much better shortcut.
The script may be a few dozen lines. Push that in the kernel and it may
be much more.

Have a close overall look at kernel/cgroup.c and ask yourself if you would
like to add 100 more lines to it, to avoid to make it in userspace ;)
