Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755745Ab2LNBhe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 20:37:34 -0500
Received: from mga11.intel.com ([192.55.52.93]:18342 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab2LNBhd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 20:37:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,276,1355126400"; 
   d="scan'208";a="263794338"
Date: Fri, 14 Dec 2012 09:37:25 +0800
From: Feng Tang <feng.tang@intel.com>
To: John Stultz <john.stultz@linaro.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
Message-ID: <20121214013725.GA11276@feng-snb>
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com>
 <50CA7EE4.3000306@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50CA7EE4.3000306@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

Thanks for the review.

On Thu, Dec 13, 2012 at 05:20:36PM -0800, John Stultz wrote:
> On 12/12/2012 06:05 PM, Feng Tang wrote:
> >In current kernel, there are several places which need to check
> >whether there is a persistent clock for the platform. Current check
> >is done by calling the read_persistent_clock() and validating the
> >return value.
> >
> >Add such a flag to make code more readable and call read_persistent_clock()
> >only once for all the checks.
> Sorry.. What  the actual benefit of this patch set?   (Usually with
> changelogs its better to explain why you're doing something, rather
> then just what you're doing.)

The main benefits is not bother to do the rtc_resume and rtc_suspend work
if persistent clock exists. Current RTC suspend/resume code will do many
time calculation and compensation work at first, and then call
timekeeping_inject_sleeptime() which will just return for platform with
persistent clock, what I did in this patchset is to put the check at
the start, also I save the persistent_clock_exist flag for all possible
check after timekeeping_init().

> 
> Maybe I'm missing something, but it seems this doesn't change the
> resulting logic of the code, does it?  As I thought we already check
> read_persistent_clocks() output (and make sure its null) before
> using the rtc HCTOSYS_DEVICE.

No, it doesn't change the code logic. 

Thanks,
Feng

