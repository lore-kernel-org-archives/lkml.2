Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab1JSEAr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 00:00:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44996 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750870Ab1JSEAq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 00:00:46 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18O/JleO8sOUDQg7u8HXz8000VBDBas8hziGPaHbf
	xYc4TrNEb2SyXd
Subject: Re: patch] cpusets, cgroups: disallow attaching kthreadd
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>, Tejun Heo <htejun@gmail.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
	 <1318224892.6161.45.camel@marge.simson.net>
	 <1318233815.6527.5.camel@marge.simson.net>
	 <1318925436.9641.23.camel@marge.simson.net>
	 <1318927355.21167.3.camel@twins>
	 <1318927629.9641.27.camel@marge.simson.net>
	 <1318928763.21167.5.camel@twins>
	 <1318929825.9641.32.camel@marge.simson.net>
	 <1318932693.6748.5.camel@marge.simson.net>
	 <alpine.DEB.2.00.1110181336150.2639@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 19 Oct 2011 06:00:39 +0200
Message-ID: <1318996839.6222.20.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 13:38 -0700, David Rientjes wrote:
> On Tue, 18 Oct 2011, Mike Galbraith wrote:
> 
> > From: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > 
> > cgroups: disallow attaching kthreadd
> > 
> > Allowing kthreadd to be moved to a non-root group makes no sense, it being
> > a global resource, and needlessly leads unsuspecting users toward trouble.
> > 
> > 1. An RT workqueue worker thread spawned in a task group with no rt_runtime
> > allocated is not schedulable.  Simple user error, but harmful to the box.
> > 
> > 2. A worker thread which acquires PF_THREAD_BOUND can never leave a cpuset,
> > rendering the cpuset immortal.
> > 
> 
> Eek, this seems like complete overkill, there may be cgroups now or in the 
> future that it would be perfectly acceptable to move kthreadd into without 
> any negative effects.  There's no reason to restrict it this broadly, 
> that's why I thought your change to cpusets was fine and acked it.  It's 
> the perfect candidate for what the ->can_attach() pointer for a cgroup can 
> identify is problematic for _that_ cgroup.

Oh my, I can't win.

Either of the two patchlets will do the trick, so maintainer's choice.

> > Save the user some unexpected trouble, just say no.
> > 
> > Signed-off-by: Mike Galbraith <efault@gmx.de>
> > 
> 
> A patch from Peter that only has your sign-off?

The only thing in it from me was a comment, figured I should post a from
line as a matter of propriety.  Guess not.  If this variant is the one
that flies, the from line can be dropped.  I doubt Peter counts his
credits, and even if he did, he wouldn't notice _this one_ missing :)

	-Mike

