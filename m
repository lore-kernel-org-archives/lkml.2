Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755266Ab2AUCoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:44:09 -0500
Received: from mga01.intel.com ([192.55.52.88]:22561 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753279Ab2AUCoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:44:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="109302287"
Message-ID: <1327113843.7922.27.camel@yhuang-dev>
Subject: Re: x86, mce, Use user return notifier in mce
From: Huang Ying <ying.huang@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Sat, 21 Jan 2012 10:44:03 +0800
In-Reply-To: <20120120173427.GC3336@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	 <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
	 <1326436352.8294.22.camel@yhuang-dev>
	 <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
	 <1326676875.8294.30.camel@yhuang-dev>
	 <20120120173427.GC3336@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-20 at 09:34 -0800, Tejun Heo wrote:
> Hello,
> 
> On Mon, Jan 16, 2012 at 09:21:15AM +0800, Huang Ying wrote:
> > "high priority work queue" sounds like a good idea.
> > 
> > Hi, Tejun,
> > 
> > Do you think the concept of "high priority work queue" is possible?
> > This is the requirement from our RAS guys.  To make some hardware
> > recovery function to be executed ASAP in process context.
> 
> Take a look at Documentation/workqueue.txt.  It already has
> WQ_HIGHPRI.

Thanks for reminding!

It appears that WQ_HIGHPRI only provides priority between work queue,
not between the work queue backing kthread and other tasks.  Is there
any mechanism for that?

If my understanding was correct, WQ_MEM_RECLAIM has some side-effect for
that.  Because hardware errors occurs seldom, the reserved kthread for
WQ_MEME_RECLAIM just sleeps most of the time.  When first hardware error
occurs and the work item is queued, the reserved kthread is waked up.
Because the reserved kthread sleeps for long time, it is highly possible
for it to be scheduled at the next schedule point.

Because hardware error usually has no locality, WQ_UNBOUND can be used
for it so that the work item can be put on relative low-load CPU.  From
the document, it is said WQ_UNBOUND work items will be executed ASAP
too.  Compared with WQ_HIGHPRI, how about the priority of WQ_UNBOUND?

Best Regards,
Huang Ying


