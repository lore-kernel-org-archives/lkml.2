Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756459Ab1K2XTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 18:19:30 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33775 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1K2XT3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 18:19:29 -0500
Date: Tue, 29 Nov 2011 15:19:22 -0800
From: Tejun Heo <tj@kernel.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111129231922.GA20313@google.com>
References: <20111128120813.GK1775@moon>
 <20111128160844.GB18864@google.com>
 <20111129225853.GA693@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111129225853.GA693@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Matt.

On Tue, Nov 29, 2011 at 02:58:53PM -0800, Matt Helsley wrote:
> >   transition notification too, at the very least, clarification of
> 
> Notification is a fine idea. However, not everything that's already
> written expects them so correct usage of the cgroup freezer should not
> require them -- IOW allowing the FROZEN -> FREEZING transition
> isn't made OK just by adding notifications.

The transition model doesn't have to be modified.  ie. we can try to
freeze the task/process on migration request and actually moves it
only when it actually reaches the target state.  Not entirely sure how
well that can be implemented with the current cgroup callbacks tho.
We can also make the new behavior selectable per-cgroup if all else
fail.

> > * There are some unclear corner cases and bugs the current cgroup
> >   freezer has.  e.g. behavior w.r.t. kthreads is outright buggy.  It
> >   would be great to figure out how to deal with them with or before
> >   this change (ie. what happens when you transfer unfreezable
> >   kthreads).
> 
> Huh? Shouldn't we just disable moving kthreads between cgroups? Allowing
> userspace to freeze kthreads via cgroups seems like a *very* bad idea
> (perhaps it's a thread critical for IO, or some driver, etc.).

That probably is the easiest solution.  Different cgroups can be
grouped together so we need to be a bit careful but if none of the
cgroups makes sense with kthread, we may just ban kthreads from any
cgroup.

Thanks.

-- 
tejun
