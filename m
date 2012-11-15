Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933319Ab2KODWX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 22:22:23 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:32954 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423543Ab2KODWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 22:22:21 -0500
Date: Wed, 14 Nov 2012 19:22:14 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121115032214.GM2548@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <20121113211602.GA30150@linux.vnet.ibm.com>
 <20121113133922.47144a50@chromoly>
 <20121113222350.GH2489@linux.vnet.ibm.com>
 <50A2CD77.7000403@linux.intel.com>
 <20121114000259.GK2489@linux.vnet.ibm.com>
 <50A2E116.8000400@linux.intel.com>
 <20121113171450.3657290c@chromoly>
 <20121114013459.GS2489@linux.vnet.ibm.com>
 <50A308FA.40001@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50A308FA.40001@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111503-2876-0000-0000-0000020A56CD
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 06:59:06PM -0800, Arjan van de Ven wrote:
> On 11/13/2012 5:34 PM, Paul E. McKenney wrote:
> > On Tue, Nov 13, 2012 at 05:14:50PM -0800, Jacob Pan wrote:
> >> On Tue, 13 Nov 2012 16:08:54 -0800
> >> Arjan van de Ven <arjan@linux.intel.com> wrote:
> >>
> >>>> I think I know, but I feel the need to ask anyway.  Why not tell
> >>>> RCU about the clamping?  
> >>>
> >>> I don't mind telling RCU, but what cannot happen is a bunch of CPU
> >>> time suddenly getting used (since that is the opposite of what is
> >>> needed at the specific point in time of going idle)
> > 
> > Another round of RCU_FAST_NO_HZ rework, you are asking for?  ;-)
> 
> well
> we can tell you we're about to mwait
> and we can tell you when we're done being idle.
> you could just do the actual work at that point, we don't care anymore ;-)
> just at the start of the mandated idle period we can't afford to have more
> jitter than we already have (which is more than I'd like, but it's manageable.
> More jitter means more performance hit, since during the time of the jitter, some cpus
> are forced idle, e.g. costing performance, without the actual big-step power savings
> kicking in yet....)

Fair enough -- but probably best to see what problems arise rather than
trying to guess too far ahead.  Who knows?  It might "just work".

> > If you are only having the system take 6-millisecond "vacations", probably
> 
> it's not all that different from running a while (1) loop for 6 msec inside
> a kernel thread.... other than the power level of course...

Well, a while (1) on all CPUs simultaneously, anyway.

							Thanx, Paul

