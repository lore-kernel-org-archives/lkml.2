Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1LFT1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 14:27:39 -0500
Received: from mga14.intel.com ([143.182.124.37]:6310 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176Ab1LFT1i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 14:27:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,308,1320652800"; 
   d="scan'208";a="44482980"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@amd64.org>
CC: "Luck, Tony" <tony.luck@intel.com>, H Peter Anvin <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Date: Tue, 6 Dec 2011 11:27:34 -0800
Subject: RE: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Topic: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Index: Acy0Sj2qZTsRejGnTjasABj6lxz8iAAAMYOQ
Message-ID: <43F901BD926A4E43B106BF17856F075501A22B5563@orsmsx508.amr.corp.intel.com>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
 <20111206153108.GD28735@gere.osrc.amd.com>
 <43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
 <20111206190648.GB20445@aftab>
In-Reply-To: <20111206190648.GB20445@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Borislav Petkov [mailto:bp@amd64.org]
> Sent: Tuesday, December 06, 2011 11:07 AM
> To: Yu, Fenghua
> Cc: Luck, Tony; H Peter Anvin; Thomas Gleixner; Ingo Molnar; Andrew
> Morton; Brown, Len; linux-kernel; x86
> Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit
> and package level thermal throttle event in mce log
> 
> On Tue, Dec 06, 2011 at 09:48:41AM -0800, Yu, Fenghua wrote:
> 
> > The printk is one way to notify users about the power limit and
> > thermal throttle. The printk only dumps the events in an interval
> > (300*HZ).
> >
> > Another way is to count the events in
> > /sys/devices/system/cpu/cpu#/thermal_throttle. In this way, kernel
> > logs every interrupt on any cpu into respective counters. User
> > application can poll the counters and get more accurate and timely
> > information for the events.
> >
> > As explained in this patch, core level thermal throttle is still
> > logged in mcelog for legacy reason after this patch is applied.
> 
> I can see all that. Still, I'm questioning the need for those printks.
> A
> user application polling the counters is a much better solution, IMHO,
> than spamming the logs. IOW, is there a strong reason to have this -
> even ratelimited - information in the logs and unnerve users, or, would
> it be better to collect this info somewhere queitly and present it only
> when something requests it?

The printks are legacy code. People may have expect that info already. Removing them may cause
Others' complain.

Plus thermal throttle and power limit shouldn't happen too offen and/or for too long time. So the printks shouldn't print a lot of times in normal case and should spam dmesg. If the printks
do print a lot of times for a long period, user does need to pay attention to the events. One
concrete example is like what happened on x220. Please note the information printed by the
printks were noticed and referred, i.e. the info is useful in this case. From that perspective, the printks are necessary.

Having said that, the purpose of THIS patch is to remove thermal throttle and power limit events from mcelog to avoid people thinking scary hardware errors. If the printks are thought unnecessary, that should be in another patch.

Thanks.

-Fenghua



