Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932610Ab2LNXXH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 18:23:07 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:55841 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753848Ab2LNXXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 18:23:05 -0500
Message-ID: <50CBB4D5.6080504@linaro.org>
Date: Fri, 14 Dec 2012 15:23:01 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
CC: Feng Tang <feng.tang@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>, linux-kernel@vger.kernel.org,
        alek.du@intel.com
Subject: Re: [PATCH 1/3] timekeeping: Add persistent_clock_exist flag
References: <1355364328-19550-1-git-send-email-feng.tang@intel.com> <50CA7EE4.3000306@linaro.org> <20121214013725.GA11276@feng-snb> <50CA8837.5010800@linaro.org> <20121214023826.GA31613@obsidianresearch.com> <20121214031330.GC11276@feng-snb> <20121214041024.GA1040@obsidianresearch.com> <50CB98AA.5090600@linaro.org> <20121214215651.GA31384@obsidianresearch.com>
In-Reply-To: <20121214215651.GA31384@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 01:56 PM, Jason Gunthorpe wrote:
> On Fri, Dec 14, 2012 at 01:22:50PM -0800, John Stultz wrote:
>
>> Although from a timekeeping perspective, the read_persistent_clock()
>> interface is actually *much* preferred over the rtc HCTOSYS device.
>>
>> Since read_persistent_clock() has the requirement that its safe to
>> call with IRQs disabled, we can use it in the timekeeping
>> suspend/resume code, which allows for better time accuracy.
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
Something like this could work, although I worry it only causes even 
more code paths:
1) read_persistent_clock for non-RTC counters, called from 
timekeeping_suspend/resume
2) IRQ safe RTC called from timekeeping_suspend/resume
3) Non-IRQ safe RTC suspend/resume logic


>> While we're suggesting cleanups, the RTC Kconfig choices probably
>> need a cleanup too, as  the list of all possible drivers can be
>> confusing, when usually each architecture has only a few that they
> That is a general pain with the new 'everything is a driver'..
True, and maybe something I just have to live with.  But I can still 
make holiday wish lists :)

thanks
-john
