Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760298Ab2EJRd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 13:33:57 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34764 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760152Ab2EJRdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 13:33:47 -0400
Subject: Re: [PATCH] sched_groups are expected to be circular linked list,
 make it so right after allocation
From: Peter Zijlstra <peterz@infradead.org>
To: Igor Mammedov <imammedo@redhat.com>
Cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        mingo@kernel.org, pjt@google.com, tglx@linutronix.de,
        seto hidetoshi <seto.hidetoshi@jp.fujitsu.com>
In-Reply-To: <9d71ee11-b6c0-41e6-b4fb-75a72c27600e@zmail16.collab.prod.int.phx2.redhat.com>
References: <9d71ee11-b6c0-41e6-b4fb-75a72c27600e@zmail16.collab.prod.int.phx2.redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 19:33:30 +0200
Message-ID: <1336671210.27020.124.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 13:01 -0400, Igor Mammedov wrote:
> However cpu that has been blissfully forgotten, continues to boot and sets
> cpu_active_mask. So causing all sorts of havoc in places that use this mask.
> Then when next cpu is being onlined/offlined it eventually calls 
> CPU_[ONLINE|DOWN]->cpuset_update_active_cpus()
> result is OOPS.
> 
> That is why I've posted https://lkml.org/lkml/2012/5/9/125
> that prevent all of this from happening by 'gracefully' aborting boot
> process on failed cpu with necessary cleanup.
> 
> Checked Ingo's git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git:master
> races, that patches 1, 2, 4 are fixing, are still there.
> If it is preferable for this patches to go into -tip, then I'll rebase them
> on top of it and repost. ??? 

Right, I'd hoped tglx would respond as he's got more stuff on his
harddrive. But he's been rather quiet the past few days. This either
means he's ignoring us all and working very hard to finish these patches
so he can post them and delight us all with a new hotplug
infrastructure. Or not and there's something else.. 

Anyway, I think you're right in that fixing that bringup fail is
important -- and you've done the work already, so yeah unless tglx shows
up soon your patches ought to go on.

I'll try and have a peek at them soon.

