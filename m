Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821Ab2B0JHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 04:07:01 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63302 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab2B0JG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 04:06:59 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yong.zhang0@gmail.com designates 10.224.194.195 as permitted sender) smtp.mail=yong.zhang0@gmail.com; dkim=pass header.i=yong.zhang0@gmail.com
Date: Mon, 27 Feb 2012 17:06:46 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Venki Pallipadi <venki@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v1
Message-ID: <20120227090646.GA1112@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <1329957415-15239-1-git-send-email-venki@google.com>
 <1329989454.24994.57.camel@twins>
 <CABeCy1a0U8Hk3Yfp54M-U80t2fbPrFQw=GnNQ_V082e9VxJQow@mail.gmail.com>
 <20120224054150.GA17543@zhy>
 <20120226013253.GN2393@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20120226013253.GN2393@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 05:32:53PM -0800, Paul E. McKenney wrote:
> On Fri, Feb 24, 2012 at 01:41:50PM +0800, Yong Zhang wrote:
> > On Thu, Feb 23, 2012 at 11:34:11AM -0800, Venki Pallipadi wrote:
> > > On Thu, Feb 23, 2012 at 1:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > > Why not scheduler_ipi()?
> > > 
> > > Was trying to avoid irq_enter/exit. As the work here is done in idle
> > > thread context, I though we could avoid enter/exit. 
> > 
> > It seems we could not.
> > At least RCU need it, see commit c5d753a55, otherwise we will get
> > warning like 'RCU used illegally from extended quiescent state!'
> 
> If the use is tracing, then Steven Rostedt's patchset plus use of his
> _rcuidle() tracing variants handles this:
> 
> 	https://lkml.org/lkml/2012/2/7/231
> 
> If this is instead algorithmic use of RCU, a set of patches I have queued
> up for 3.4 will be required.

scheduler_ipi() doing more than tracing. Will look at your patches :)

Thanks,
Yong
