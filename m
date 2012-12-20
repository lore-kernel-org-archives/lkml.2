Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751113Ab2LTHCk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 02:02:40 -0500
Received: from mga02.intel.com ([134.134.136.20]:31320 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750776Ab2LTHCe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 02:02:34 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,322,1355126400"; 
   d="scan'208";a="236801198"
Date: Thu, 20 Dec 2012 15:02:55 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121220070255.GB16475@feng-snb>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
 <20121214023826.GA31613@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214023826.GA31613@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Thu, Dec 13, 2012 at 07:38:26PM -0700, Jason Gunthorpe wrote:
> 
> > make the HCTOSYS option be dependent on !HAS_PERSISTENT_CLOCK. This
> > way we avoid having configs where there are conflicting paths that
> > we chose from.
> 
> On ARM the read_presistent_clock is used to access a true monotonic
> counter that is divorced from the system RTC - look at
> arch/arm/plat-omap/counter_32k.c for instance.
> 
> This seems like a great use of that hardware resource, and no doubt
> those mach's also have a class RTC driver available talking to
> different hardware.
> 
> For mach's without that functionality ARM returns a fixed 0 value
> from read_persistent_clock, persumably the kernel detects this and
> falls back to using class rtc functions?

I read the counter_32k.c and the read_persistent_clock() magic for
ARM, and got a question: for the omap platforms using the
counter_32k.c's read_persistent_clock, why will they also calles
the time service from RTC device like the rtc_suspend/resume? I 
thought usually we just need to use the time source with the better
accuracy.

Thanks,
Feng

> 
> Maybe Feng would be better off adjusting read_persistent_clock to
> return ENODEV in such cases??
> 
> So, I think you have to keep your test as a run time test. To support
> the single image ARM boot you can't make the distinction with kconfig.
> 
> Regards,
> Jason
