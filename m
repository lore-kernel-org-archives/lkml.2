Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2KMVja (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 16:39:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:25177 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751353Ab2KMVj3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 16:39:29 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,768,1352102400"; 
   d="scan'208";a="167988873"
Date: Tue, 13 Nov 2012 13:39:22 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: paulmck@linux.vnet.ibm.com
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121113133922.47144a50@chromoly>
In-Reply-To: <20121113211602.GA30150@linux.vnet.ibm.com>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<20121113211602.GA30150@linux.vnet.ibm.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 13:16:02 -0800
"Paul E. McKenney" <paulmck@linux.vnet.ibm.com> wrote:

> > Please refer to Documentation/thermal/intel_powerclamp.txt for more
> > details.  
> 
> If I read this correctly, this forces a group of CPUs into idle for
> about 600 milliseconds at a time.  This would indeed delay grace
> periods, which could easily result in user complaints.  Also, given
> the default RCU_BOOST_DELAY of 500 milliseconds in kernels enabling
> RCU_BOOST, you would see needless RCU priority boosting.
> 
the default idle injection duration is 6ms. we adjust the sleep
interval to ensure idle ratio. So the idle duration stays the same once
set. So would it be safe to delay grace period for this small amount in
exchange for less over head in each injection period?
> Of course, if the idle period extended for longer, you would see RCU
> CPU stall warnings.  And if the idle period extended indefinitely, you
> could hang the system -- the RCU callbacks on the idled CPU could not
> be invoked, and if one of those RCU callbacks was waking someone up,
> that someone would not be woken up.
> 
for the same algorithm, idle duration is not extended. the injected
idle loop also yield to pending softirqs, i guess that is what rcu
callbacks are using?
> It looks like you could end up with part of the system powerclamped
> in some situations, and with all of it powerclamped in other
> situations. Is that the case, or am I confused?
> 
could you explain the part that is partially powerclamped?

> 							Thanx, Paul
[Jacob Pan]

-- 
Thanks,

Jacob
