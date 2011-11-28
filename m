Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab1K1Qb5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:31:57 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:44205 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab1K1Qb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:31:56 -0500
Date: Mon, 28 Nov 2011 20:31:51 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizf@cn.fujitsu.com>,
        Matt Helsley <matthltc@us.ibm.com>, Andrey Vagin <avagin@openvz.org>,
        Pavel Emelyanov <xemul@parallels.com>
Subject: Re: [RFC] cgroups: freezer -- Allow to attach a task to a frozen
 cgroup
Message-ID: <20111128163151.GN1775@moon>
References: <20111128120813.GK1775@moon>
 <20111128160844.GB18864@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111128160844.GB18864@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 28, 2011 at 08:08:44AM -0800, Tejun Heo wrote:
> On Mon, Nov 28, 2011 at 04:08:13PM +0400, Cyrill Gorcunov wrote:
> > In checkpoint/restore we need an ability to attach pids to
> > a frozen cgroup. Thus once pid reaches a frozen cgroup it is
> > not rejected, but the task get frozen immediately.
> > 
> > Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> > ---
> > 
> > I would really appreciate complains and comments.
> 
> First of all, both freezer and cgroup have non-trivial pending
> patchsets (e.g. ->can_attach_task() is scheduled for removal) and I
> have changes which basically try to achieve about the same thing, so
> let's slow down a bit.  I think the problem is a bit more complex.
> 
> Some thoughts I have on cgroup freezer ATM,
> 
...
> 
> * Another improvement that I want to have is allowing cgroup frozen
>   tasks to be killed.  I don't think this matters for system freezer
>   but for cgroup freezer both oom killer and systemd want it.
>

  * Run ptrace over frozen tasks ;)

> So, while I agree with the direction of this patch, I think this
> definitely needs a lot more work to go in.  I don't think we can do
> much until the freezer and cgroup changes are settled.  The freezer
> part is now in Rafael's tree, the cgroup part is going under Linus'
> review.  Once they're complete, I'll provide a merged branch that
> further cgroup works can be based on.
> 

Thanks a lot for comments, Tejun! For own needs I'll make a stub
in our user-space tool, once things are settled down we can move on.
