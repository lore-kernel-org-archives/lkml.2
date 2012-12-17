Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753249Ab2LQQOK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:14:10 -0500
Received: from mga02.intel.com ([134.134.136.20]:54360 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752839Ab2LQQOI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:14:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,302,1355126400"; 
   d="scan'208";a="258402814"
Date: Tue, 18 Dec 2012 00:14:33 +0800
From: Feng Tang <feng.tang@intel.com>
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121217161433.GB4762@feng-snb>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
 <20121214013725.GA11276@feng-snb>
 <50CA8837.5010800@linaro.org>
 <20121214023826.GA31613@obsidianresearch.com>
 <20121214031330.GC11276@feng-snb>
 <20121214041024.GA1040@obsidianresearch.com>
 <50CB98AA.5090600@linaro.org>
 <20121214215651.GA31384@obsidianresearch.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121214215651.GA31384@obsidianresearch.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 02:56:51PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 14, 2012 at 01:22:50PM -0800, John Stultz wrote:
> 
> > Although from a timekeeping perspective, the read_persistent_clock()
> > interface is actually *much* preferred over the rtc HCTOSYS device.
> > 
> > Since read_persistent_clock() has the requirement that its safe to
> > call with IRQs disabled, we can use it in the timekeeping
> > suspend/resume code, which allows for better time accuracy.
> 
> Sure, but my view on this is that it has nothing to do with
> read_persistent_clock. If the RTC driver can run with IRQs off is a
> property of the RTC driver and RTC hardware - it has nothing to do
> with the platform. ARM platforms will vary on a machine by machine
> basis. The rtc-mv driver used on my ARM system is perfectly
> re-entrant, lots of rtc on SOC drivers will be the same.
> 
> If this is the only thing keeping you on read_persistent_clock, for
> real RTCs, then how about a RTC_DEV_SAFE_READ flag (or whatever) in
> rtc_device.flags?
> 
> Reserve read_persistent_clock for things like that very specialized
> non-RTC ARM counter.

Yes, these non-RTC device is one reason for keeping read_persistent_clock,
one other reason I can think of is the CONFIG_RTC_LIB is not always on by
default for all Archs, and some platforms may chose to disable it on purpose. 
When CONFIG_RTC_LIB is not set, we need the read_persistent_clock for
time init/suspend/resume.

Thanks,
Feng

