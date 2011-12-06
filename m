Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1LFRw2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 12:52:28 -0500
Received: from mga09.intel.com ([134.134.136.24]:11155 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751798Ab1LFRw1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 12:52:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="83521146"
From: "Yu, Fenghua" <fenghua.yu@intel.com>
To: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>
CC: H Peter Anvin <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        "Brown, Len" <len.brown@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>, x86 <x86@kernel.org>
Date: Tue, 6 Dec 2011 09:48:41 -0800
Subject: RE: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Topic: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit and
 package level thermal throttle event in mce log
Thread-Index: Acy0LBeLfvNQNRUBSF2FNUNrcBeOHAAEfF8w
Message-ID: <43F901BD926A4E43B106BF17856F075501A22B5365@orsmsx508.amr.corp.intel.com>
References: <1321305082-31310-1-git-send-email-fenghua.yu@intel.com>
 <20111205131825.GA31275@gere.osrc.amd.com>
 <0207C53569FE594381A4F2EB66570B2A018EE61884@orsmsx508.amr.corp.intel.com>
 <20111206153108.GD28735@gere.osrc.amd.com>
In-Reply-To: <20111206153108.GD28735@gere.osrc.amd.com>
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
> Sent: Tuesday, December 06, 2011 7:31 AM
> To: Luck, Tony
> Cc: Yu, Fenghua; H Peter Anvin; Thomas Gleixner; Ingo Molnar; Andrew
> Morton; Brown, Len; linux-kernel; x86
> Subject: Re: [PATCH] x86/mcheck/therm_throt.c: Don't log power limit
> and package level thermal throttle event in mce log
> 
> On Mon, Dec 05, 2011 at 02:18:26PM -0800, Luck, Tony wrote:
> > This looks like a sane improvement, Tony I'm assuming you're handling
> this?
> >
> > I can push this - but it would be nice to have some other comments
> from
> > outside of Intel (we've been beaten up written-by Intel, acked-by:
> Intel
> > too many times).
> >
> > Can I count that as an "Acked-by:"?
> 
> Well, from looking at Udo's feedback here
> 
> http://marc.info/?l=linux-kernel&m=132206108724885
> 
> this patch looks like it helps in his case partially. I'm still not
> sure
> about all the printks in therm_throt_process(), do you guys feel the
> need to notify the user that the CPU clock was throttled/power limits
> were applied, or rather have something more subtle...?

The printk is one way to notify users about the power limit and thermal throttle. The printk only dumps the events in an interval (300*HZ).

Another way is to count the events in /sys/devices/system/cpu/cpu#/thermal_throttle. In this way, kernel logs every interrupt on any cpu into respective counters. User application can poll the counters and get more accurate and timely information for the events.

As explained in this patch, core level thermal throttle is still logged in mcelog for legacy reason after this patch is applied.

Thanks.

-Fenghua
