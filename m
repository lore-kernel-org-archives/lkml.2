Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753109Ab2APBVS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 20:21:18 -0500
Received: from mga02.intel.com ([134.134.136.20]:23990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488Ab2APBVR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 20:21:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="96792133"
Message-ID: <1326676875.8294.30.camel@yhuang-dev>
Subject: Re: x86, mce, Use user return notifier in mce
From: Huang Ying <ying.huang@intel.com>
To: Tony Luck <tony.luck@intel.com>, Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Mon, 16 Jan 2012 09:21:15 +0800
In-Reply-To: <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	 <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
	 <1326436352.8294.22.camel@yhuang-dev>
	 <CA+8MBb+oqJZDYvmh8E6RB2MRp5fDj298Qjc4zs-rmyGkA4F3cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 23:41 -0800, Tony Luck wrote:
> On Thu, Jan 12, 2012 at 10:32 PM, Huang Ying <ying.huang@intel.com> wrote:
> > You are right.  User return notifier can not be used for SRAR.  I think
> > that may be useful for SRAO.  Where we need a way to do notify earlier
> > in case of the corresponding work_queue item is not executed in time.
> 
> OK - I've been so focused on SRAR that I didn't think of the SRAO case.
> But even there it seems odd to use user return notifier. We'd like the
> SRAO work item to be executed promptly - but we don't care where it
> is executed. So the "execute on this cpu" part of user return notifiers
> doesn't quite fit.
> 
> Is there a concept of "high priority work queue"?

"high priority work queue" sounds like a good idea.

Hi, Tejun,

Do you think the concept of "high priority work queue" is possible?
This is the requirement from our RAS guys.  To make some hardware
recovery function to be executed ASAP in process context.

Best Regards,
Huang Ying


