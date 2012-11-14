Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab2KNBgZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:36:25 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45143 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756063Ab2KNBgX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:36:23 -0500
Date: Tue, 13 Nov 2012 17:34:59 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
        Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121114013459.GS2489@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
 <1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
 <20121113211602.GA30150@linux.vnet.ibm.com>
 <20121113133922.47144a50@chromoly>
 <20121113222350.GH2489@linux.vnet.ibm.com>
 <50A2CD77.7000403@linux.intel.com>
 <20121114000259.GK2489@linux.vnet.ibm.com>
 <50A2E116.8000400@linux.intel.com>
 <20121113171450.3657290c@chromoly>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121113171450.3657290c@chromoly>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12111401-5806-0000-0000-00001BBE7BD5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 13, 2012 at 05:14:50PM -0800, Jacob Pan wrote:
> On Tue, 13 Nov 2012 16:08:54 -0800
> Arjan van de Ven <arjan@linux.intel.com> wrote:
> 
> > > I think I know, but I feel the need to ask anyway.  Why not tell
> > > RCU about the clamping?  
> > 
> > I don't mind telling RCU, but what cannot happen is a bunch of CPU
> > time suddenly getting used (since that is the opposite of what is
> > needed at the specific point in time of going idle)

Another round of RCU_FAST_NO_HZ rework, you are asking for?  ;-)

> Another reason is my observation that there are some assumptions/checks
> to make sure only idle thread can tell rcu it is idle. Is it ok to
> extend that to other kthreads?

If you are only having the system take 6-millisecond "vacations", probably
best to try it as it is and fix specific problems if/when they arise.

							Thanx, Paul

