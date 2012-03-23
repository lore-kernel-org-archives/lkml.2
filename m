Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab2CWFwt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 01:52:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:53921 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000Ab2CWFwr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 01:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <4F6BEDC1.60006@linaro.org>
References: <CAB4K4y7ticNGWv1XWtqLatBG69yM2gv31ayt5DqWSSOUWTZrGg@mail.gmail.com>
	<20120319130445.GN15988@n2100.arm.linux.org.uk>
	<CAB4K4y4Sw4dyT7vX_YzgbYBK42LZuS96=6X3MtVdN-mBqOKr-Q@mail.gmail.com>
	<20120319132623.GO15988@n2100.arm.linux.org.uk>
	<4F696011.7080409@linaro.org>
	<CAB4K4y5ZkGY3pe3ty5fbaVTj626dAS3HuodX6HfDvym8g0qyZQ@mail.gmail.com>
	<CAB4K4y5phDP=4Ab1S2XwS+Oa25B5Pxe3p5D2ZO3G=2W=cMKm=w@mail.gmail.com>
	<20120322100236.GS15988@n2100.arm.linux.org.uk>
	<CAB4K4y5rOFbPm1XjeHxUFtc29tFAQ1besKLy5fz4MHq6UV0fdA@mail.gmail.com>
	<4F6BEDC1.60006@linaro.org>
Date: Fri, 23 Mar 2012 11:22:46 +0530
Message-ID: <CAB4K4y6u_59XLCBL2k5TrpAGv9C161wyqE_0_CEGbmgWeEwCyw@mail.gmail.com>
Subject: Re: Not able to use HIGH_RES_TIMERS on ARM
From: Ajeet Yadav <ajeet.yadav.77@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        stable@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CCing to stable@vger.kernel.org
On Fri, Mar 23, 2012 at 8:58 AM, John Stultz <john.stultz@linaro.org> wrote:
> On 03/22/2012 03:25 AM, Ajeet Yadav wrote:
>>
>> If I set  ARCH_USES_GETTIMEOFFSET=n to use this feature, my target
>> fail to boot. (reason I well understand from our past discussions)
>
> And this point I'm not sure I'm following. Why exactly does disabling
> ARCH_USES_GETTIMEOFFSET cause boot failures? Could you expand on the details
> here?
We did some dissection to narrow down the patch, our latest kernel is
stable 3.0.X , however we backported patch " ARM: 7321/1: cache-v7:
Disable preemption when reading CCSIDR" from 3.0.25 stable tree, this
patch causes kernel hang during boot (IRQSOFF_TRACER=y and
PREEMPT_TRACER=y) with 100% probability , if we remove this patch or
disable the given CONFIG's then boot is success.
>
> You should just end up using the jiffies clocksource, which would give you
> low-res HZ granular timestamps, but shouldn't get in the way of booting.
>
> thanks
> -john
>
