Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab0ENXQ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 19:16:59 -0400
Received: from mga02.intel.com ([134.134.136.20]:37560 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab0ENXQ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 19:16:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,234,1272870000"; 
   d="scan'208";a="518086539"
Subject: Re: TSC unstable due to TSC halts in idle?
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: john stultz <johnstul@us.ibm.com>
Cc: Jesper Dangaard Brouer <hawk@diku.dk>,
       Thomas Gleixner <tglx@linutronix.de>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       netdev <netdev@vger.kernel.org>, "Brown, Len" <len.brown@intel.com>,
       "Li, Shaohua" <shaohua.li@intel.com>, "hawk@comx.dk" <hawk@comx.dk>
In-Reply-To: <AANLkTimeXEaUnzSBuilbQLHj_oho3ia9EgyPGpB7vJRI@mail.gmail.com>
References: <Pine.LNX.4.64.1005142208290.6220@ask.diku.dk>
	 <AANLkTimeXEaUnzSBuilbQLHj_oho3ia9EgyPGpB7vJRI@mail.gmail.com>
Content-Type: text/plain
Organization: Intel Corp
Date: Fri, 14 May 2010 16:15:57 -0700
Message-Id: <1273878957.2825.175.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 15:28 -0700, john stultz wrote:
> On Fri, May 14, 2010 at 1:13 PM, Jesper Dangaard Brouer <hawk@diku.dk> wrote:
> > I want to know, if its safe to enable the TSC clocksource, when the
> > kernel reports:
> >  "Marking TSC unstable due to TSC halts in idle"
> >
> > The system selects HPET (in current_clocksource), but I can still see
> > TSC as an available clocksource (in
> > /sys/devices/system/clocksource/clocksource0/available_clocksource).
> >
> > Is it safe to enable TSC manually (by changing current_clocksource)?
> > (my workload is 10Git/s routing, cannot survive with a slow clock)
> >
> >
> > Any trick to avoid this? (e.g. kernel config setting, or a /sys/ setting
> > which changes the minimum P-state?)
> 
> Might try booting with the max-cstate=1 option.

Jesper mentioned that it is xeon 5550. TSC's for that processor doesn't
stop in idle. Perhaps he is using an older kernel which doesn't detect
this fact. Jesper, more recent kernels should be able to use TSC as the
clocksource.

thanks,
suresh

