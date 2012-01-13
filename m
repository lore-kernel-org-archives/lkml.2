Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2AMGch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 01:32:37 -0500
Received: from mga14.intel.com ([143.182.124.37]:57161 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753066Ab2AMGcf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 01:32:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="56052782"
Message-ID: <1326436352.8294.22.camel@yhuang-dev>
Subject: Re: x86, mce, Use user return notifier in mce
From: Huang Ying <ying.huang@intel.com>
To: Tony Luck <tony.luck@intel.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Date: Fri, 13 Jan 2012 14:32:32 +0800
In-Reply-To: <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
References: <1326415001-2145-1-git-send-email-ying.huang@intel.com>
	 <CA+8MBbJHsOHb-COG_y36VYDA9EeTs3KpLc86kw1OhVF9Z_p7Jw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 17:46 -0800, Tony Luck wrote:
> On Thu, Jan 12, 2012 at 4:36 PM, Huang Ying <ying.huang@intel.com> wrote:
> > Replace the home-made TIF_MCE_NOTIFY based code in MCE with user
> > return notifier.
> 
> When I looked at this before, I found that the existing user return notifier had
> the meaning "call a function before THIS CPU returns to user space". Use in KVM
> was to update some MSR that needed adjustment before a cpu ran another user
> process.
> 
> The MCE code wanted something slightly different: "call a function before THIS
> PROCESS returns to user space". So my prototype code from last year made a
> whole new set of interfaces - similar in style to the user return
> notifier, but with
> the MCE semantics.
> 
> At first glance it looks like you are just using the user return
> notifier code (perhaps
> I'm mis-reading the diff?). This won't work - it's possible for a
> context switch, and
> then the process that hit the MCE may get moved to another cpu, when it will
> be run. Meanwhile we'll execute our function in the context of some
> other process.

You are right.  User return notifier can not be used for SRAR.  I think
that may be useful for SRAO.  Where we need a way to do notify earlier
in case of the corresponding work_queue item is not executed in time.

Best Regards,
Huang Ying


